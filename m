Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801AD5EE19F
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbiI1QSt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiI1QSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:09 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944382FFEB
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:07 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-BWgBBBZNMuWPK9q1Lv_I9w-1; Wed, 28 Sep 2022 12:18:03 -0400
X-MC-Unique: BWgBBBZNMuWPK9q1Lv_I9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD4293C138A3;
        Wed, 28 Sep 2022 16:17:41 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1466C9D464;
        Wed, 28 Sep 2022 16:17:40 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 02/12] macsec: replace custom checks on MACSEC_*_ATTR_ACTIVE with NLA_POLICY_MAX
Date:   Wed, 28 Sep 2022 18:17:15 +0200
Message-Id: <1a99cf014faedeeec44049b0af6b6dce9863b42d.1664379352.git.sd@queasysnail.net>
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
 drivers/net/macsec.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 061ed437daa5..be438147e0db 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1626,12 +1626,12 @@ static const struct nla_policy macsec_genl_policy[NUM_MACSEC_ATTR] = {
 
 static const struct nla_policy macsec_genl_rxsc_policy[NUM_MACSEC_RXSC_ATTR] = {
 	[MACSEC_RXSC_ATTR_SCI] = { .type = NLA_U64 },
-	[MACSEC_RXSC_ATTR_ACTIVE] = { .type = NLA_U8 },
+	[MACSEC_RXSC_ATTR_ACTIVE] = NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 	[MACSEC_SA_ATTR_AN] = NLA_POLICY_MAX(NLA_U8, MACSEC_NUM_AN - 1),
-	[MACSEC_SA_ATTR_ACTIVE] = { .type = NLA_U8 },
+	[MACSEC_SA_ATTR_ACTIVE] = NLA_POLICY_MAX(NLA_U8, 1),
 	[MACSEC_SA_ATTR_PN] = NLA_POLICY_MIN_LEN(4),
 	[MACSEC_SA_ATTR_KEYID] = { .type = NLA_BINARY,
 				   .len = MACSEC_KEYID_LEN, },
@@ -1695,16 +1695,10 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	    !attrs[MACSEC_SA_ATTR_KEYID])
 		return false;
 
-
 	if (attrs[MACSEC_SA_ATTR_PN] &&
 	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
-		if (nla_get_u8(attrs[MACSEC_SA_ATTR_ACTIVE]) > 1)
-			return false;
-	}
-
 	if (nla_len(attrs[MACSEC_SA_ATTR_KEYID]) != MACSEC_KEYID_LEN)
 		return false;
 
@@ -1853,11 +1847,6 @@ static bool validate_add_rxsc(struct nlattr **attrs)
 	if (!attrs[MACSEC_RXSC_ATTR_SCI])
 		return false;
 
-	if (attrs[MACSEC_RXSC_ATTR_ACTIVE]) {
-		if (nla_get_u8(attrs[MACSEC_RXSC_ATTR_ACTIVE]) > 1)
-			return false;
-	}
-
 	return true;
 }
 
@@ -1940,11 +1929,6 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
-		if (nla_get_u8(attrs[MACSEC_SA_ATTR_ACTIVE]) > 1)
-			return false;
-	}
-
 	if (nla_len(attrs[MACSEC_SA_ATTR_KEYID]) != MACSEC_KEYID_LEN)
 		return false;
 
@@ -2291,11 +2275,6 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
-		if (nla_get_u8(attrs[MACSEC_SA_ATTR_ACTIVE]) > 1)
-			return false;
-	}
-
 	return true;
 }
 
-- 
2.37.3

