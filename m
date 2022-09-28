Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35BA5EE1A3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiI1QSy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiI1QSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:23 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C516E52DF1
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:15 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-oyebVxLSNSmQj6jRhqhoqA-1; Wed, 28 Sep 2022 12:18:10 -0400
X-MC-Unique: oyebVxLSNSmQj6jRhqhoqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED691886C98;
        Wed, 28 Sep 2022 16:17:44 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D9A49D469;
        Wed, 28 Sep 2022 16:17:44 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 05/12] macsec: use NLA_POLICY_VALIDATE_FN to validate MACSEC_SA_ATTR_PN
Date:   Wed, 28 Sep 2022 18:17:18 +0200
Message-Id: <de1bb532ba13f0d56626ba3979f930657a3efc61.1664379352.git.sd@queasysnail.net>
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

We need to keep the length checks done in macsec_{add,upd}_{rx,tx}sa
based on whether the device is set up for XPN (with 64b PNs instead of
32b), but we can at least check early and that the length is not
completely bogus and whether the PN is 0.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 76ff09b16013..3f8069f758c7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1617,6 +1617,19 @@ static struct macsec_rx_sa *get_rxsa_from_nl(struct net *net,
 	return rx_sa;
 }
 
+static int validate_pn(const struct nlattr *attr,
+		       struct netlink_ext_ack *extack)
+{
+	if (nla_len(attr) == MACSEC_DEFAULT_PN_LEN ||
+	    nla_len(attr) == MACSEC_XPN_PN_LEN) {
+		if (nla_get_u64(attr) == 0)
+			return -EINVAL;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 static const struct nla_policy macsec_genl_policy[NUM_MACSEC_ATTR] = {
 	[MACSEC_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[MACSEC_ATTR_RXSC_CONFIG] = { .type = NLA_NESTED },
@@ -1632,7 +1645,7 @@ static const struct nla_policy macsec_genl_rxsc_policy[NUM_MACSEC_RXSC_ATTR] = {
 static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 	[MACSEC_SA_ATTR_AN] = NLA_POLICY_MAX(NLA_U8, MACSEC_NUM_AN - 1),
 	[MACSEC_SA_ATTR_ACTIVE] = NLA_POLICY_MAX(NLA_U8, 1),
-	[MACSEC_SA_ATTR_PN] = NLA_POLICY_MIN_LEN(4),
+	[MACSEC_SA_ATTR_PN] = NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_pn, 8),
 	[MACSEC_SA_ATTR_KEYID] = NLA_POLICY_EXACT_LEN(MACSEC_KEYID_LEN),
 	[MACSEC_SA_ATTR_KEY] = { .type = NLA_BINARY,
 				 .len = MACSEC_MAX_KEY_LEN, },
@@ -1693,10 +1706,6 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	    !attrs[MACSEC_SA_ATTR_KEYID])
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] &&
-	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
-		return false;
-
 	return true;
 }
 
@@ -1913,9 +1922,6 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	    !attrs[MACSEC_SA_ATTR_KEYID])
 		return false;
 
-	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
-		return false;
-
 	return true;
 }
 
@@ -2248,9 +2254,6 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	    attrs[MACSEC_SA_ATTR_SALT])
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
-		return false;
-
 	return true;
 }
 
-- 
2.37.3

