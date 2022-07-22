Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E34A57DD8B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiGVJ3s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 05:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbiGVJ2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:28:46 -0400
X-Greylist: delayed 69 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Jul 2022 02:18:01 PDT
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B4779CE509
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:18:01 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-_Ws3Bni8PseijyxxH8Ztew-1; Fri, 22 Jul 2022 05:16:47 -0400
X-MC-Unique: _Ws3Bni8PseijyxxH8Ztew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 470243804509;
        Fri, 22 Jul 2022 09:16:47 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D34C2166B26;
        Fri, 22 Jul 2022 09:16:46 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Era Mayflower <mayflowerera@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Frantisek Sumsal <fsumsal@redhat.com>
Subject: [PATCH net 1/4] macsec: fix NULL deref in macsec_add_rxsa
Date:   Fri, 22 Jul 2022 11:16:27 +0200
Message-Id: <7b3fd03e1a46047e5ffe2a389fe74501f0a93206.1656519221.git.sd@queasysnail.net>
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

Commit 48ef50fa866a added a test on tb_sa[MACSEC_SA_ATTR_PN], but
nothing guarantees that it's not NULL at this point. The same code was
added to macsec_add_txsa, but there it's not a problem because
validate_add_txsa checks that the MACSEC_SA_ATTR_PN attribute is
present.

Note: it's not possible to reproduce with iproute, because iproute
doesn't allow creating an SA without specifying the PN.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208315
Reported-by: Frantisek Sumsal <fsumsal@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 817577e713d7..769a1eca6bd8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1753,7 +1753,8 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	pn_len = secy->xpn ? MACSEC_XPN_PN_LEN : MACSEC_DEFAULT_PN_LEN;
-	if (nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
+	if (tb_sa[MACSEC_SA_ATTR_PN] &&
+	    nla_len(tb_sa[MACSEC_SA_ATTR_PN]) != pn_len) {
 		pr_notice("macsec: nl: add_rxsa: bad pn length: %d != %d\n",
 			  nla_len(tb_sa[MACSEC_SA_ATTR_PN]), pn_len);
 		rtnl_unlock();
-- 
2.36.1

