Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD465FDC3F
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJMOR1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Oct 2022 10:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiJMORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:17:20 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20D212FFAD
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:17:18 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-kCYXkD4uMCWge4_iHRBlaA-1; Thu, 13 Oct 2022 10:17:16 -0400
X-MC-Unique: kCYXkD4uMCWge4_iHRBlaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ABCC38041B5;
        Thu, 13 Oct 2022 14:17:10 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 564EF1111C86;
        Thu, 13 Oct 2022 14:16:54 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 2/5] macsec: delete new rxsc when offload fails
Date:   Thu, 13 Oct 2022 16:15:40 +0200
Message-Id: <ef551fa7819a9ed3795941cca5a42f932a800d3a.1665416630.git.sd@queasysnail.net>
In-Reply-To: <cover.1665416630.git.sd@queasysnail.net>
References: <cover.1665416630.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

Currently we get an inconsistent state:
 - netlink returns the error to userspace
 - the RXSC is installed but not offloaded

Then the device could get confused when we try to add an RXSA, because
the RXSC isn't supposed to exist.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b3f76e8071f2..0d6fe34b91ae 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1876,7 +1876,6 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
-	bool was_active;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1904,7 +1903,6 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
-	was_active = rx_sc->active;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
 		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
@@ -1931,7 +1929,8 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	rx_sc->active = was_active;
+	del_rx_sc(secy, sci);
+	free_rx_sc(rx_sc);
 	rtnl_unlock();
 	return ret;
 }
-- 
2.38.0

