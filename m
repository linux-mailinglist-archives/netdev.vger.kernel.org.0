Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FFD64BFA4
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiLMWwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236643AbiLMWwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:52:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE3B2315F
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 14:52:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC842B81603
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8795DC433F0;
        Tue, 13 Dec 2022 22:52:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="H9E7mir2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1670971941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6aoeCGWfJWhYrNceNOQ8Mw0lNPbbWMBJOuMKQF1Fk8=;
        b=H9E7mir29Kz/qcpQTEus2pe/yWQi+LpeT3UAvyEXtiLEtV+IvfvAYeKKz84LDZ++NEERYc
        TtAy6g6JDdISdDsEqw7Dy2uO/yw4Afxjo5qEgVQX2381h7sTN/EFVJ/+NLulxMYNlsOLyn
        rhG1rmtck6+Gnc66h5FN+2b3iXpwMNo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 68c162aa (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 13 Dec 2022 22:52:21 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/1] wireguard: timers: cast enum limits members to int in prints
Date:   Tue, 13 Dec 2022 15:52:08 -0700
Message-Id: <20221213225208.3343692-2-Jason@zx2c4.com>
In-Reply-To: <20221213225208.3343692-1-Jason@zx2c4.com>
References: <20221213225208.3343692-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>

Since gcc13, each member of an enum has the same type as the enum. And
that is inherited from its members. Provided "REKEY_AFTER_MESSAGES =
1ULL << 60", the named type is unsigned long.

This generates warnings with gcc-13:
  error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'

Cast those particular enum members to int when printing them.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113
Cc: Martin Liska <mliska@suse.cz>
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/timers.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/timers.c b/drivers/net/wireguard/timers.c
index d54d32ac9bc4..91f5d6d2d4e2 100644
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
@@ -94,7 +94,7 @@ static void wg_expired_new_handshake(struct timer_list *timer)
 
 	pr_debug("%s: Retrying handshake with peer %llu (%pISpfsc) because we stopped hearing back after %d seconds\n",
 		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, KEEPALIVE_TIMEOUT + REKEY_TIMEOUT);
+		 &peer->endpoint.addr, (int)(KEEPALIVE_TIMEOUT + REKEY_TIMEOUT));
 	/* We clear the endpoint address src address, in case this is the cause
 	 * of trouble.
 	 */
@@ -126,7 +126,7 @@ static void wg_queued_expired_zero_key_material(struct work_struct *work)
 
 	pr_debug("%s: Zeroing out all keys for peer %llu (%pISpfsc), since we haven't received a new one in %d seconds\n",
 		 peer->device->dev->name, peer->internal_id,
-		 &peer->endpoint.addr, REJECT_AFTER_TIME * 3);
+		 &peer->endpoint.addr, (int)REJECT_AFTER_TIME * 3);
 	wg_noise_handshake_clear(&peer->handshake);
 	wg_noise_keypairs_clear(&peer->keypairs);
 	wg_peer_put(peer);
-- 
2.39.0

