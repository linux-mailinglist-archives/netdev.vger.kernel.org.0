Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CEE5EE1D2
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbiI1Q3T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiI1Q3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:29:17 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE5D4DB69
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:29:17 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-dkkzACktOL-lMwUjm7CixQ-1; Wed, 28 Sep 2022 12:29:12 -0400
X-MC-Unique: dkkzACktOL-lMwUjm7CixQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF17A89F5F2;
        Wed, 28 Sep 2022 16:29:11 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0799A145D84F;
        Wed, 28 Sep 2022 16:29:10 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 11/12] macsec: replace custom check on IFLA_MACSEC_ENCODING_SA with NLA_POLICY_MAX
Date:   Wed, 28 Sep 2022 18:28:58 +0200
Message-Id: <57f0c81a407a93dcd6d6221ba5b0904b3ba4d63f.1664379352.git.sd@queasysnail.net>
In-Reply-To: <cover.1664379352.git.sd@queasysnail.net>
References: <cover.1664379352.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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
 drivers/net/macsec.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 81027941bc5b..863e5ae6e75e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3653,7 +3653,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_ICV_LEN] = NLA_POLICY_RANGE(NLA_U8, MACSEC_MIN_ICV_LEN, MACSEC_STD_ICV_LEN),
 	[IFLA_MACSEC_CIPHER_SUITE] = NLA_POLICY_VALIDATE_FN(NLA_U64, validate_cipher_suite),
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
-	[IFLA_MACSEC_ENCODING_SA] = { .type = NLA_U8 },
+	[IFLA_MACSEC_ENCODING_SA] = NLA_POLICY_MAX(NLA_U8, MACSEC_NUM_AN - 1),
 	[IFLA_MACSEC_ENCRYPT] = NLA_POLICY_MAX(NLA_U8, 1),
 	[IFLA_MACSEC_PROTECT] = NLA_POLICY_MAX(NLA_U8, 1),
 	[IFLA_MACSEC_INC_SCI] = NLA_POLICY_MAX(NLA_U8, 1),
@@ -4144,11 +4144,6 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 		}
 	}
 
-	if (data[IFLA_MACSEC_ENCODING_SA]) {
-		if (nla_get_u8(data[IFLA_MACSEC_ENCODING_SA]) >= MACSEC_NUM_AN)
-			return -EINVAL;
-	}
-
 	es  = data[IFLA_MACSEC_ES] ? nla_get_u8(data[IFLA_MACSEC_ES]) : false;
 	sci = data[IFLA_MACSEC_INC_SCI] ? nla_get_u8(data[IFLA_MACSEC_INC_SCI]) : false;
 	scb = data[IFLA_MACSEC_SCB] ? nla_get_u8(data[IFLA_MACSEC_SCB]) : false;
-- 
2.37.3

