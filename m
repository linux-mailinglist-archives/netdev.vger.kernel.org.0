Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE995EE19D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiI1QSs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbiI1QS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:26 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF4C85FA9
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:20 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-MhOxfM3EPO-ZrAnW-Ys-KQ-1; Wed, 28 Sep 2022 12:18:13 -0400
X-MC-Unique: MhOxfM3EPO-ZrAnW-Ys-KQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E07E11C05B03;
        Wed, 28 Sep 2022 16:17:47 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 160A494573;
        Wed, 28 Sep 2022 16:17:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 08/12] macsec: use NLA_POLICY_VALIDATE_FN to validate IFLA_MACSEC_CIPHER_SUITE
Date:   Wed, 28 Sep 2022 18:17:21 +0200
Message-Id: <5d4541915e5229c0329ff8e6618439ca21767b18.1664379352.git.sd@queasysnail.net>
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

Unfortunately, since the value of MACSEC_DEFAULT_CIPHER_ID doesn't fit
near the others, we can't use a simple range in the policy.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c70dd40e9d8d..3863f41c9106 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3645,11 +3645,13 @@ static const struct device_type macsec_type = {
 	.name = "macsec",
 };
 
+static int validate_cipher_suite(const struct nlattr *attr,
+				 struct netlink_ext_ack *extack);
 static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCI] = { .type = NLA_U64 },
 	[IFLA_MACSEC_PORT] = { .type = NLA_U16 },
 	[IFLA_MACSEC_ICV_LEN] = NLA_POLICY_RANGE(NLA_U8, MACSEC_MIN_ICV_LEN, MACSEC_STD_ICV_LEN),
-	[IFLA_MACSEC_CIPHER_SUITE] = { .type = NLA_U64 },
+	[IFLA_MACSEC_CIPHER_SUITE] = NLA_POLICY_VALIDATE_FN(NLA_U64, validate_cipher_suite),
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
 	[IFLA_MACSEC_ENCODING_SA] = { .type = NLA_U8 },
 	[IFLA_MACSEC_ENCRYPT] = { .type = NLA_U8 },
@@ -4099,6 +4101,21 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 	return err;
 }
 
+static int validate_cipher_suite(const struct nlattr *attr,
+				 struct netlink_ext_ack *extack)
+{
+	switch (nla_get_u64(attr)) {
+	case MACSEC_CIPHER_ID_GCM_AES_128:
+	case MACSEC_CIPHER_ID_GCM_AES_256:
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
+	case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
+	case MACSEC_DEFAULT_CIPHER_ID:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
@@ -4128,17 +4145,6 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 		}
 	}
 
-	switch (csid) {
-	case MACSEC_CIPHER_ID_GCM_AES_128:
-	case MACSEC_CIPHER_ID_GCM_AES_256:
-	case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
-	case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
-	case MACSEC_DEFAULT_CIPHER_ID:
-		break;
-	default:
-		return -EINVAL;
-	}
-
 	if (data[IFLA_MACSEC_ENCODING_SA]) {
 		if (nla_get_u8(data[IFLA_MACSEC_ENCODING_SA]) >= MACSEC_NUM_AN)
 			return -EINVAL;
-- 
2.37.3

