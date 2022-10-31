Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356A66134C7
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiJaLos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJaLof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:44:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEB6F02C;
        Mon, 31 Oct 2022 04:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03E6CB815F0;
        Mon, 31 Oct 2022 11:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7877CC433D6;
        Mon, 31 Oct 2022 11:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667216668;
        bh=nToB1GC3IZYvNqBjpUGx00XoAWJDS1KYM7LwXh0TTXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=XHOKN6EiXg24tI+YL5fNUQoIwWC8ToQ9v5XYBhYzBFQ5dXVhDq7TedJ+jpHoKInF1
         hu+XjGGHhJqDa7DBprj1D+AkyhtMrccFKhSLEQdt9WHlOb5NlNvYD+bJzuIGFeJmDC
         TBiuEha58nxC2+9v3RmYIlzY84i7N1IHV0XVw/NvUTS3+9pDpTFtDmoKokY5bDBGIi
         ANsVKljgQMZPEniEIw+BzBkMhWbUb824VrBHjga5LWskEW22rK+TZaZ++cCDkTfyPg
         wxGMYx2Dld/7znmv+uTqrbYdIsIGQvjmzyMSvVwPeRjEER0GFJ1eBb9Du7blIB5PhG
         fEChIgrGSLo0Q==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     Jason@zx2c4.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Subject: [PATCH] wireguard (gcc13): cast enum limits members to int in prints
Date:   Mon, 31 Oct 2022 12:44:24 +0100
Message-Id: <20221031114424.10438-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided "REKEY_AFTER_MESSAGES = 1ULL
<< 60", the named type is unsigned long.

This generates warnings with gcc-13:
  error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'

Cast the enum members to int when printing them.

Alternatively, we can cast it to ulong (to silence gcc < 12) and use %lu.
Alternatively, we can move REKEY_AFTER_MESSAGES away from the enum.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska@suse.cz>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: wireguard@lists.zx2c4.com
Cc: netdev@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
 drivers/net/wireguard/timers.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/timers.c b/drivers/net/wireguard/timers.c
index b5706b6718b1..51081ba93609 100644
--- a/drivers/net/wireguard/timers.c
+++ b/drivers/net/wireguard/timers.c
@@ -46,7 +46,7 @@ static void wg_expired_retransmit_handshake(struct timer_list *timer)
 	if (peer->timer_handshake_attempts > MAX_TIMER_HANDSHAKES) {
 		pr_debug("%s: Handshake for peer %llu (%pISpfsc) did not complete after %d attempts, giving up\n",
 			 peer->device->dev->name, peer->internal_id,
-			 &peer->endpoint.addr, MAX_TIMER_HANDSHAKES + 2);
+			 &peer->endpoint.addr, (int)MAX_TIMER_HANDSHAKES + 2);
 
 		del_timer(&peer->timer_send_keepalive);
 		/* We drop all packets without a keypair and don't try again,
@@ -64,7 +64,7 @@ static void wg_expired_retransmit_handshake(struct timer_list *timer)
 		++peer->timer_handshake_attempts;
 		pr_debug("%s: Handshake for peer %llu (%pISpfsc) did not complete after %d seconds, retrying (try %d)\n",
 			 peer->device->dev->name, peer->internal_id,
-			 &peer->endpoint.addr, REKEY_TIMEOUT,
+			 &peer->endpoint.addr, (int)REKEY_TIMEOUT,
 			 peer->timer_handshake_attempts + 1);
 
 		/* We clear the endpoint address src address, in case this is
@@ -94,7 +94,8 @@ static void wg_expired_new_handshake(struct timer_list *timer)
 
 	pr_debug("%s: Retrying handshake with peer %llu (%pISpfsc) because we stopped hearing back after %d seconds\n",
 		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, KEEPALIVE_TIMEOUT + REKEY_TIMEOUT);
+		 &peer->endpoint.addr,
+		 (int)(KEEPALIVE_TIMEOUT + REKEY_TIMEOUT));
 	/* We clear the endpoint address src address, in case this is the cause
 	 * of trouble.
 	 */
@@ -126,7 +127,7 @@ static void wg_queued_expired_zero_key_material(struct work_struct *work)
 
 	pr_debug("%s: Zeroing out all keys for peer %llu (%pISpfsc), since we haven't received a new one in %d seconds\n",
 		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, REJECT_AFTER_TIME * 3);
+		 &peer->endpoint.addr, (int)REJECT_AFTER_TIME * 3);
 	wg_noise_handshake_clear(&peer->handshake);
 	wg_noise_keypairs_clear(&peer->keypairs);
 	wg_peer_put(peer);
-- 
2.38.1

