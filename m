Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB775EE1A0
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiI1QS7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234059AbiI1QSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:03 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FA095A3
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:01 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-jB9TBfOhNtOHVbapT2_4mw-1; Wed, 28 Sep 2022 12:17:58 -0400
X-MC-Unique: jB9TBfOhNtOHVbapT2_4mw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D23E829DD9B4;
        Wed, 28 Sep 2022 16:17:40 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D26D9D464;
        Wed, 28 Sep 2022 16:17:39 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 01/12] macsec: replace custom checks on MACSEC_SA_ATTR_AN with NLA_POLICY_MAX
Date:   Wed, 28 Sep 2022 18:17:14 +0200
Message-Id: <2e61465ba19fad605f8c3e51600c56ca66d53448.1664379352.git.sd@queasysnail.net>
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

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c891b60937a7..061ed437daa5 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1544,9 +1544,6 @@ static struct macsec_tx_sa *get_txsa_from_nl(struct net *net,
 	if (IS_ERR(dev))
 		return ERR_CAST(dev);
 
-	if (*assoc_num >= MACSEC_NUM_AN)
-		return ERR_PTR(-EINVAL);
-
 	secy = &macsec_priv(dev)->secy;
 	tx_sc = &secy->tx_sc;
 
@@ -1607,8 +1604,6 @@ static struct macsec_rx_sa *get_rxsa_from_nl(struct net *net,
 		return ERR_PTR(-EINVAL);
 
 	*assoc_num = nla_get_u8(tb_sa[MACSEC_SA_ATTR_AN]);
-	if (*assoc_num >= MACSEC_NUM_AN)
-		return ERR_PTR(-EINVAL);
 
 	rx_sc = get_rxsc_from_nl(net, attrs, tb_rxsc, devp, secyp);
 	if (IS_ERR(rx_sc))
@@ -1635,7 +1630,7 @@ static const struct nla_policy macsec_genl_rxsc_policy[NUM_MACSEC_RXSC_ATTR] = {
 };
 
 static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
-	[MACSEC_SA_ATTR_AN] = { .type = NLA_U8 },
+	[MACSEC_SA_ATTR_AN] = NLA_POLICY_MAX(NLA_U8, MACSEC_NUM_AN - 1),
 	[MACSEC_SA_ATTR_ACTIVE] = { .type = NLA_U8 },
 	[MACSEC_SA_ATTR_PN] = NLA_POLICY_MIN_LEN(4),
 	[MACSEC_SA_ATTR_KEYID] = { .type = NLA_BINARY,
@@ -1700,8 +1695,6 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	    !attrs[MACSEC_SA_ATTR_KEYID])
 		return false;
 
-	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
-		return false;
 
 	if (attrs[MACSEC_SA_ATTR_PN] &&
 	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
@@ -1944,9 +1937,6 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	    !attrs[MACSEC_SA_ATTR_KEYID])
 		return false;
 
-	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
-		return false;
-
 	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
@@ -2298,9 +2288,6 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	    attrs[MACSEC_SA_ATTR_SALT])
 		return false;
 
-	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
-		return false;
-
 	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
-- 
2.37.3

