Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3125F5994
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJESNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 14:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiJESNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:13:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A166CF63
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 11:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A14BFB81DE0
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 18:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC2FC433C1;
        Wed,  5 Oct 2022 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664993583;
        bh=wCOFdRmuPv+gTIzkVhG7hFXGvU+4HVnQ5hHs2mcIlRA=;
        h=From:To:Cc:Subject:Date:From;
        b=pYySkwJkmbk7+LLjsxCTwmPfTqLaSm017NMJm57uaBVQjtEMjRxmF4FC0JFtaJWfy
         08UFqTnEIfD2BAVaZhbtnip4vpQjRcUxlI/TIyhANquCK5FBmYM9M0QbglMXdjrTNW
         6bK19/exUVc/vrTOIjBcMJshFV0Fi8bWAWwJu3FxEF5aeIhMRZ8mJlg04BuuJ39hk6
         ubk/1M7jmIKmiJt0QXSV6MS8ojUuOdm05ly5DdvFTUYTZat/lw3oyI+Qk8zyP+/xAW
         GgpWp40scS36rPswcXxn3RnT04ELBPodw6SAeq3AUyAPfZBYow75yex/epk9Z/9ypk
         PQ/VWenh3eOpQ==
From:   David Ahern <dsahern@kernel.org>
To:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        David Ahern <dsahern@kernel.org>,
        Gwangun Jung <exsociety@gmail.com>
Subject: [PATCH net] ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference
Date:   Wed,  5 Oct 2022 12:12:57 -0600
Message-Id: <20221005181257.8897-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
    fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
    fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
    inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874

Separate nexthop objects are mutually exclusive with the legacy
multipath spec. Fix fib_nh_match to return if the config for the
to be deleted route contains a multipath spec while the fib_info
is using a nexthop object.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv4/fib_semantics.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 2dc97583d279..17caa73f57e6 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -926,6 +926,10 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 	if (!cfg->fc_mp)
 		return 0;
 
+	/* multipath spec and nexthop id are mutually exclusive */
+	if (fi->nh)
+		return 1;
+
 	rtnh = cfg->fc_mp;
 	remaining = cfg->fc_mp_len;
 
-- 
2.25.1

