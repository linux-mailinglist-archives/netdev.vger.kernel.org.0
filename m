Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240EF5EE1A1
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiI1QTF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Sep 2022 12:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234649AbiI1QSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:18:31 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899E1ABD6C
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 09:18:30 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-ZJ3-Kv4NPJKOB-siy_oTIw-1; Wed, 28 Sep 2022 12:18:25 -0400
X-MC-Unique: ZJ3-Kv4NPJKOB-siy_oTIw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1DC7849414;
        Wed, 28 Sep 2022 16:17:48 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C2AB9D47C;
        Wed, 28 Sep 2022 16:17:48 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net-next 09/12] macsec: validate IFLA_MACSEC_VALIDATION with NLA_POLICY_MAX
Date:   Wed, 28 Sep 2022 18:17:22 +0200
Message-Id: <fcc0f15fa62c785abe65bf658cd1dc98c6f5ea85.1664379352.git.sd@queasysnail.net>
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
 drivers/net/macsec.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3863f41c9106..3171a84e6900 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3660,7 +3660,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_ES] = { .type = NLA_U8 },
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
-	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_VALIDATION] = NLA_POLICY_MAX(NLA_U8, MACSEC_VALIDATE_MAX),
 	[IFLA_MACSEC_OFFLOAD] = NLA_POLICY_MAX(NLA_U8, MACSEC_OFFLOAD_MAX),
 };
 
@@ -4166,10 +4166,6 @@ static int macsec_validate_attr(struct nlattr *tb[], struct nlattr *data[],
 	if ((sci && (scb || es)) || (scb && es))
 		return -EINVAL;
 
-	if (data[IFLA_MACSEC_VALIDATION] &&
-	    nla_get_u8(data[IFLA_MACSEC_VALIDATION]) > MACSEC_VALIDATE_MAX)
-		return -EINVAL;
-
 	if ((data[IFLA_MACSEC_REPLAY_PROTECT] &&
 	     nla_get_u8(data[IFLA_MACSEC_REPLAY_PROTECT])) &&
 	    !data[IFLA_MACSEC_WINDOW])
-- 
2.37.3

