Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950BA5EE1A6
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiI1QSz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiI1QSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:12 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DD537F8F
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:09 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-O134Q-RVOs23AX3HzaZnzA-1; Wed, 28 Sep 2022 12:18:07 -0400
X-MC-Unique: O134Q-RVOs23AX3HzaZnzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8A3C3814662;
        Wed, 28 Sep 2022 16:17:42 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28B259459C;
        Wed, 28 Sep 2022 16:17:41 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 03/12] macsec: replace custom checks on MACSEC_SA_ATTR_SALT with NLA_POLICY_EXACT_LEN
Date:   Wed, 28 Sep 2022 18:17:16 +0200
Message-Id: <1ceb481d4a55a176ac8b57aacb72d4094d1d6cb1.1664379352.git.sd@queasysnail.net>
In-Reply-To: <cover.1664379352.git.sd@queasysnail.net>
References: <cover.1664379352.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing checks already specify that MACSEC_SA_ATTR_SALT must have
length MACSEC_SALT_LEN.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index be438147e0db..a9fb7946a2a6 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1638,8 +1638,7 @@ static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 	[MACSEC_SA_ATTR_KEY] = { .type = NLA_BINARY,
 				 .len = MACSEC_MAX_KEY_LEN, },
 	[MACSEC_SA_ATTR_SSCI] = { .type = NLA_U32 },
-	[MACSEC_SA_ATTR_SALT] = { .type = NLA_BINARY,
-				  .len = MACSEC_SALT_LEN, },
+	[MACSEC_SA_ATTR_SALT] = NLA_POLICY_EXACT_LEN(MACSEC_SALT_LEN),
 };
 
 static const struct nla_policy macsec_genl_offload_policy[NUM_MACSEC_OFFLOAD_ATTR] = {
@@ -1760,14 +1759,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 			rtnl_unlock();
 			return -EINVAL;
 		}
-
-		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
-			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
-				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SALT_LEN);
-			rtnl_unlock();
-			return -EINVAL;
-		}
 	}
 
 	rx_sa = rtnl_dereference(rx_sc->sa[assoc_num]);
@@ -1989,14 +1980,6 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 			rtnl_unlock();
 			return -EINVAL;
 		}
-
-		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
-			pr_notice("macsec: nl: add_txsa: bad salt length: %d != %d\n",
-				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SALT_LEN);
-			rtnl_unlock();
-			return -EINVAL;
-		}
 	}
 
 	tx_sa = rtnl_dereference(tx_sc->sa[assoc_num]);
-- 
2.37.3

