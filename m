Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010AE5EC884
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiI0PtS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 11:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbiI0Psh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:48:37 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E919FC8890
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 08:46:19 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-QKlQUpVGN4O12cQB9usrwA-1; Tue, 27 Sep 2022 11:46:14 -0400
X-MC-Unique: QKlQUpVGN4O12cQB9usrwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56AEA101A52A;
        Tue, 27 Sep 2022 15:46:14 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8834F2166B26;
        Tue, 27 Sep 2022 15:46:13 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 6/6] xfrm: mip6: add extack to mip6_destopt_init_state, mip6_rthdr_init_state
Date:   Tue, 27 Sep 2022 17:45:34 +0200
Message-Id: <3b0054025ef7e683a40f64fcda660ac8e5965987.1664287440.git.sd@queasysnail.net>
In-Reply-To: <cover.1664287440.git.sd@queasysnail.net>
References: <cover.1664287440.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
 net/ipv6/mip6.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 3d87ae88ebfd..83d2a8be263f 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -250,12 +250,11 @@ static int mip6_destopt_reject(struct xfrm_state *x, struct sk_buff *skb,
 static int mip6_destopt_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->id.spi) {
-		pr_info("%s: spi is not 0: %u\n", __func__, x->id.spi);
+		NL_SET_ERR_MSG(extack, "SPI must be 0");
 		return -EINVAL;
 	}
 	if (x->props.mode != XFRM_MODE_ROUTEOPTIMIZATION) {
-		pr_info("%s: state's mode is not %u: %u\n",
-			__func__, XFRM_MODE_ROUTEOPTIMIZATION, x->props.mode);
+		NL_SET_ERR_MSG(extack, "XFRM mode must be XFRM_MODE_ROUTEOPTIMIZATION");
 		return -EINVAL;
 	}
 
@@ -336,12 +335,11 @@ static int mip6_rthdr_output(struct xfrm_state *x, struct sk_buff *skb)
 static int mip6_rthdr_init_state(struct xfrm_state *x, struct netlink_ext_ack *extack)
 {
 	if (x->id.spi) {
-		pr_info("%s: spi is not 0: %u\n", __func__, x->id.spi);
+		NL_SET_ERR_MSG(extack, "SPI must be 0");
 		return -EINVAL;
 	}
 	if (x->props.mode != XFRM_MODE_ROUTEOPTIMIZATION) {
-		pr_info("%s: state's mode is not %u: %u\n",
-			__func__, XFRM_MODE_ROUTEOPTIMIZATION, x->props.mode);
+		NL_SET_ERR_MSG(extack, "XFRM mode must be XFRM_MODE_ROUTEOPTIMIZATION");
 		return -EINVAL;
 	}
 
-- 
2.37.3

