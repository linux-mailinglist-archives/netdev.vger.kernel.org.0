Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5652B4CAA64
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242638AbiCBQgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbiCBQgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:36:11 -0500
Received: from simonwunderlich.de (simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154F7CE907
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:35:27 -0800 (PST)
Received: from kero.packetmixer.de (p200300C597470fC0D439FBe5c3508408.dip0.t-ipconnect.de [IPv6:2003:c5:9747:fc0:d439:fbe5:c350:8408])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 25D48FA750;
        Wed,  2 Mar 2022 17:35:26 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Leonardo=20M=C3=B6rlein?= <freifunk@irrelefant.net>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/4] batman-adv: Demote batadv-on-batadv skip error message
Date:   Wed,  2 Mar 2022 17:35:22 +0100
Message-Id: <20220302163522.102842-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302163522.102842-1-sw@simonwunderlich.de>
References: <20220302163522.102842-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The error message "Cannot find parent device" was shown for users of
macvtap (on batadv devices) whenever the macvtap was moved to a different
netns. This happens because macvtap doesn't provide an implementation for
rtnl_link_ops->get_link_net.

The situation for which this message is printed is actually not an error
but just a warning that the optional sanity check was skipped. So demote
the message from error to warning and adjust the text to better explain
what happened.

Reported-by: Leonardo Mörlein <freifunk@irrelefant.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 59d19097a54c..b25afc7ff59c 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -165,9 +165,9 @@ static bool batadv_is_on_batman_iface(const struct net_device *net_dev)
 	/* recurse over the parent device */
 	parent_dev = __dev_get_by_index((struct net *)parent_net,
 					dev_get_iflink(net_dev));
-	/* if we got a NULL parent_dev there is something broken.. */
 	if (!parent_dev) {
-		pr_err("Cannot find parent device\n");
+		pr_warn("Cannot find parent device. Skipping batadv-on-batadv check for %s\n",
+			net_dev->name);
 		return false;
 	}
 
-- 
2.30.2

