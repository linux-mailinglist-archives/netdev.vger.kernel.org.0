Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545AC60EB06
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiJZV5U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Oct 2022 17:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbiJZV5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:57:18 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C4B96203
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 14:57:17 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-CEYi92hBMUiS_C2dnbNMEg-1; Wed, 26 Oct 2022 17:57:12 -0400
X-MC-Unique: CEYi92hBMUiS_C2dnbNMEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F34EE29AA2E7;
        Wed, 26 Oct 2022 21:57:11 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA14A111F3B6;
        Wed, 26 Oct 2022 21:57:10 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leon@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net v2 2/5] macsec: delete new rxsc when offload fails
Date:   Wed, 26 Oct 2022 23:56:24 +0200
Message-Id: <54e5c16b2ffb7db1fac0c1f2360e7a332c115364.1666793468.git.sd@queasysnail.net>
In-Reply-To: <cover.1666793468.git.sd@queasysnail.net>
References: <cover.1666793468.git.sd@queasysnail.net>
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

