Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC03616FE8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiKBVeq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Nov 2022 17:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKBVe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:34:26 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE173E0ED
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:34:15 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-8HI8K9Y0NY2AAmzhYEwhug-1; Wed, 02 Nov 2022 17:34:12 -0400
X-MC-Unique: 8HI8K9Y0NY2AAmzhYEwhug-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96269811E75;
        Wed,  2 Nov 2022 21:34:11 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 609D1492B08;
        Wed,  2 Nov 2022 21:34:10 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net v3 3/5] macsec: fix secy->n_rx_sc accounting
Date:   Wed,  2 Nov 2022 22:33:14 +0100
Message-Id: <d30d6b52fc5787262ca170187134a0989e2d6f7d.1667204360.git.sd@queasysnail.net>
In-Reply-To: <cover.1667204360.git.sd@queasysnail.net>
References: <cover.1667204360.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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

secy->n_rx_sc is supposed to be the number of _active_ rxsc's within a
secy. This is then used by macsec_send_sci to help decide if we should
add the SCI to the header or not.

This logic is currently broken when we create a new RXSC and turn it
off at creation, as create_rx_sc always sets ->active to true (and
immediately uses that to increment n_rx_sc), and only later
macsec_add_rxsc sets rx_sc->active.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
v2: drop unnecessary !! (Leon Romanovsky)
v3: drop extra newline (Jakub Kicinski)

 drivers/net/macsec.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0d6fe34b91ae..1b4d856f4bd7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1413,7 +1413,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
+static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
+					 bool active)
 {
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_dev *macsec;
@@ -1437,7 +1438,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 	}
 
 	rx_sc->sci = sci;
-	rx_sc->active = true;
+	rx_sc->active = active;
 	refcount_set(&rx_sc->refcnt, 1);
 
 	secy = &macsec_priv(dev)->secy;
@@ -1876,6 +1877,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
+	bool active = true;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1897,15 +1899,15 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
-	rx_sc = create_rx_sc(dev, sci);
+	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
+		active = nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
+
+	rx_sc = create_rx_sc(dev, sci, active);
 	if (IS_ERR(rx_sc)) {
 		rtnl_unlock();
 		return PTR_ERR(rx_sc);
 	}
 
-	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
-		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
-
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-- 
2.38.0

