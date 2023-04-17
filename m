Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D1D6E50F2
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDQTaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 15:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjDQTaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 15:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADFF7AA4
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 12:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681759732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GbsTDSdEYWYb0Ug2wp+3Q3zdLxW1lWnMaS36fo47Lak=;
        b=i7RPqq+UbOiZ7+aZMiJFouHbdzeTw9yP2plVzgAg2p9s/vY4xR8XpTtjKQyx5X2NHMNI2s
        sW9Ij/4ILkoLwIFQxgmIfPSnu+BamMArbm+8tr9DQikfrPr9uI3Mo16pgW3qxSAgRjT5DX
        W16YQUn7iJRB6qDzypqHTqpVwb6XgVk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-9SOwtL2kO_-hs9n0NIaeMg-1; Mon, 17 Apr 2023 15:28:47 -0400
X-MC-Unique: 9SOwtL2kO_-hs9n0NIaeMg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 700C63815EE2;
        Mon, 17 Apr 2023 19:28:47 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.195.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 11BD740C83AC;
        Mon, 17 Apr 2023 19:28:47 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id AB0ACA808C0; Mon, 17 Apr 2023 21:28:45 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2 net-next] net: stmmac: propagate feature flags to vlan
Date:   Mon, 17 Apr 2023 21:28:45 +0200
Message-Id: <20230417192845.590034-1-vinschen@redhat.com>
In-Reply-To: <20230417121146.654b980d@kernel.org>
References: <20230417121146.654b980d@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
like offloading don't correspond with the general features and it's not
possible to manipulate features via ethtool -K to affect VLANs.

Propagate feature flags to vlan features.  Drop TSO feature because
it does not work on VLANs yet.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7fcab057032..8ab67c020a08 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7253,6 +7253,10 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->dma_cap.rssen && priv->plat->rss_en)
 		ndev->features |= NETIF_F_RXHASH;
 
+	ndev->vlan_features |= ndev->features;
+	/* TSO doesn't work on VLANs yet */
+	ndev->vlan_features &= ~NETIF_F_TSO;
+
 	/* MTU range: 46 - hw-specific max */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
 	if (priv->plat->has_xgmac)
-- 
2.31.1

