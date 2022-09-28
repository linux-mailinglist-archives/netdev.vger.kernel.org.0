Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAA95EE1A5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiI1QTD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiI1QSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:30 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1001BE11FA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:27 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-u4503PDSOfC0JkUc3M_zvw-1; Wed, 28 Sep 2022 12:18:18 -0400
X-MC-Unique: u4503PDSOfC0JkUc3M_zvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0A5338035D9;
        Wed, 28 Sep 2022 16:17:46 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E99D194573;
        Wed, 28 Sep 2022 16:17:45 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 07/12] macsec: replace custom checks on IFLA_MACSEC_ICV_LEN with NLA_POLICY_RANGE
Date:   Wed, 28 Sep 2022 18:17:20 +0200
Message-Id: <56da4c0178a38d68ad515f9340e09db3d9f2f156.1664379352.git.sd@queasysnail.net>
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

The existing checks already force this range.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 84e67f8c9bad..c70dd40e9d8d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3648,7 +3648,7 @@ static const struct device_type macsec_type = {
 static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCI] = { .type = NLA_U64 },
 	[IFLA_MACSEC_PORT] = { .type = NLA_U16 },
-	[IFLA_MACSEC_ICV_LEN] = { .type = NLA_U8 },
+	[IFLA_MACSEC_ICV_LEN] = NLA_POLICY_RANGE(NLA_U8, MACSEC_MIN_ICV_LEN, MACSEC_STD_ICV_LEN),
 	[IFLA_MACSEC_CIPHER_SUITE] = { .type = NLA_U64 },
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
 	[IFLA_MACSEC_ENCODING_SA] = { .type = NLA_U8 },
@@ -4134,9 +4134,6 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 	case MACSEC_CIPHER_ID_GCM_AES_XPN_128:
 	case MACSEC_CIPHER_ID_GCM_AES_XPN_256:
 	case MACSEC_DEFAULT_CIPHER_ID:
-		if (icv_len < MACSEC_MIN_ICV_LEN ||
-		    icv_len > MACSEC_STD_ICV_LEN)
-			return -EINVAL;
 		break;
 	default:
 		return -EINVAL;
-- 
2.37.3

