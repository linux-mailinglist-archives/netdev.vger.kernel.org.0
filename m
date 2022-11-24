Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D76637BA7
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKXOoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiKXOot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:49 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C45FED5C3
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:47 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id C3031C0009;
        Thu, 24 Nov 2022 14:44:45 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 7/7] xfrm: add extack to xfrm_set_spdinfo
Date:   Thu, 24 Nov 2022 15:43:44 +0100
Message-Id: <b7f8434356f4292be3cd3eec36c24ee7368be85d.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_user.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5c280e04e02c..0eb4696661c8 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1367,20 +1367,28 @@ static int xfrm_set_spdinfo(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_SPD_IPV4_HTHRESH]) {
 		struct nlattr *rta = attrs[XFRMA_SPD_IPV4_HTHRESH];
 
-		if (nla_len(rta) < sizeof(*thresh4))
+		if (nla_len(rta) < sizeof(*thresh4)) {
+			NL_SET_ERR_MSG(extack, "Invalid SPD_IPV4_HTHRESH attribute length");
 			return -EINVAL;
+		}
 		thresh4 = nla_data(rta);
-		if (thresh4->lbits > 32 || thresh4->rbits > 32)
+		if (thresh4->lbits > 32 || thresh4->rbits > 32) {
+			NL_SET_ERR_MSG(extack, "Invalid hash threshold (must be <= 32 for IPv4)");
 			return -EINVAL;
+		}
 	}
 	if (attrs[XFRMA_SPD_IPV6_HTHRESH]) {
 		struct nlattr *rta = attrs[XFRMA_SPD_IPV6_HTHRESH];
 
-		if (nla_len(rta) < sizeof(*thresh6))
+		if (nla_len(rta) < sizeof(*thresh6)) {
+			NL_SET_ERR_MSG(extack, "Invalid SPD_IPV6_HTHRESH attribute length");
 			return -EINVAL;
+		}
 		thresh6 = nla_data(rta);
-		if (thresh6->lbits > 128 || thresh6->rbits > 128)
+		if (thresh6->lbits > 128 || thresh6->rbits > 128) {
+			NL_SET_ERR_MSG(extack, "Invalid hash threshold (must be <= 128 for IPv6)");
 			return -EINVAL;
+		}
 	}
 
 	if (thresh4 || thresh6) {
-- 
2.38.0

