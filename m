Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A125EE1A2
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiI1QTA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiI1QSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:17 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFA536868
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:14 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-XNbE44o8MByOnCGlhPZWtg-1; Wed, 28 Sep 2022 12:18:03 -0400
X-MC-Unique: XNbE44o8MByOnCGlhPZWtg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E21CC10115EB;
        Wed, 28 Sep 2022 16:17:43 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2ECF99D469;
        Wed, 28 Sep 2022 16:17:42 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 04/12] macsec: replace custom checks on MACSEC_SA_ATTR_KEYID with NLA_POLICY_EXACT_LEN
Date:   Wed, 28 Sep 2022 18:17:17 +0200
Message-Id: <ecc100752f64e577cb654abde722b9705a0108b2.1664379352.git.sd@queasysnail.net>
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

The existing checks already specify that MACSEC_SA_ATTR_KEYID must
have length MACSEC_KEYID_LEN.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index a9fb7946a2a6..76ff09b16013 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1633,8 +1633,7 @@ static const struct nla_policy macsec_genl_sa_policy[NUM_MACSEC_SA_ATTR] = {
 	[MACSEC_SA_ATTR_AN] = NLA_POLICY_MAX(NLA_U8, MACSEC_NUM_AN - 1),
 	[MACSEC_SA_ATTR_ACTIVE] = NLA_POLICY_MAX(NLA_U8, 1),
 	[MACSEC_SA_ATTR_PN] = NLA_POLICY_MIN_LEN(4),
-	[MACSEC_SA_ATTR_KEYID] = { .type = NLA_BINARY,
-				   .len = MACSEC_KEYID_LEN, },
+	[MACSEC_SA_ATTR_KEYID] = NLA_POLICY_EXACT_LEN(MACSEC_KEYID_LEN),
 	[MACSEC_SA_ATTR_KEY] = { .type = NLA_BINARY,
 				 .len = MACSEC_MAX_KEY_LEN, },
 	[MACSEC_SA_ATTR_SSCI] = { .type = NLA_U32 },
@@ -1698,9 +1697,6 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
-	if (nla_len(attrs[MACSEC_SA_ATTR_KEYID]) != MACSEC_KEYID_LEN)
-		return false;
-
 	return true;
 }
 
@@ -1920,9 +1916,6 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
-	if (nla_len(attrs[MACSEC_SA_ATTR_KEYID]) != MACSEC_KEYID_LEN)
-		return false;
-
 	return true;
 }
 
-- 
2.37.3

