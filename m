Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F7457DDAF
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbiGVJ1N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 05:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbiGVJ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:26:46 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4306CA761
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:16:55 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-AvskmAWYMYCVD6gk9LYOcA-1; Fri, 22 Jul 2022 05:16:51 -0400
X-MC-Unique: AvskmAWYMYCVD6gk9LYOcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EF3A3C0D843;
        Fri, 22 Jul 2022 09:16:51 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 500B92166B26;
        Fri, 22 Jul 2022 09:16:50 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Era Mayflower <mayflowerera@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 4/4] macsec: always read MACSEC_SA_ATTR_PN as a u64
Date:   Fri, 22 Jul 2022 11:16:30 +0200
Message-Id: <152aba728ba9580ee9815315070b812a918dd819.1656519221.git.sd@queasysnail.net>
In-Reply-To: <cover.1656519221.git.sd@queasysnail.net>
References: <cover.1656519221.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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

Currently, MACSEC_SA_ATTR_PN is handled inconsistently, sometimes as a
u32, sometimes forced into a u64 without checking the actual length of
the attribute. Instead, we can use nla_get_u64 everywhere, which will
read up to 64 bits into a u64, capped by the actual length of the
attribute coming from userspace.

This fixes several issues:
 - the check in validate_add_rxsa doesn't work with 32-bit attributes
 - the checks in validate_add_txsa and validate_upd_sa incorrectly
   reject X << 32 (with X != 0)

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b3834e353c22..95578f04f212 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1698,7 +1698,7 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_PN] &&
-	    *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1941,7 +1941,7 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -2295,7 +2295,7 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
-- 
2.36.1

