Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC6257DDA7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiGVJ1M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 05:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbiGVJ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:26:46 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E092CA759
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:16:52 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-404-n0wR4nbkNhuNezPtSEst9A-1; Fri, 22 Jul 2022 05:16:49 -0400
X-MC-Unique: n0wR4nbkNhuNezPtSEst9A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B90012999B2E;
        Fri, 22 Jul 2022 09:16:48 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B25B22166B2A;
        Fri, 22 Jul 2022 09:16:47 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Era Mayflower <mayflowerera@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 2/4] macsec: fix error message in macsec_add_rxsa and _txsa
Date:   Fri, 22 Jul 2022 11:16:28 +0200
Message-Id: <494928eb18c832dc04ffe6a6811234db86b0de7b.1656519221.git.sd@queasysnail.net>
In-Reply-To: <cover.1656519221.git.sd@queasysnail.net>
References: <cover.1656519221.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
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

The expected length is MACSEC_SALT_LEN, not MACSEC_SA_ATTR_SALT.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 769a1eca6bd8..634452d3ecc5 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1770,7 +1770,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_rxsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
@@ -2012,7 +2012,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 		if (nla_len(tb_sa[MACSEC_SA_ATTR_SALT]) != MACSEC_SALT_LEN) {
 			pr_notice("macsec: nl: add_txsa: bad salt length: %d != %d\n",
 				  nla_len(tb_sa[MACSEC_SA_ATTR_SALT]),
-				  MACSEC_SA_ATTR_SALT);
+				  MACSEC_SALT_LEN);
 			rtnl_unlock();
 			return -EINVAL;
 		}
-- 
2.36.1

