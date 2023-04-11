Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B405A6DDBB5
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbjDKNFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjDKNFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:05:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9229D558A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681218241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PLHoOhImSgZgv5pnKGV2gG+UHyIYprSCALR+OOXUiGk=;
        b=YeBCL6LpOFWpbRXeR3O39Rt9pzt1bHxzmqL6MO5nAdNim1LKlDo4f6QqQIBuJXbIVbJpe7
        uZm9zI3U/8YHebStTNxII27+0M96PraJK1eHxSHZlmPWI2SOOLrd4ffuiyC7xUWuqw92XL
        /YwDaIq9fn9ojrhvyE+pn45tjJ3XnyE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-oymR3Zx9N2S8Xl27GDZghw-1; Tue, 11 Apr 2023 09:00:31 -0400
X-MC-Unique: oymR3Zx9N2S8Xl27GDZghw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52B2E3C10EC9;
        Tue, 11 Apr 2023 13:00:30 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C17EF1121320;
        Tue, 11 Apr 2023 13:00:29 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 4216DA80B9B; Tue, 11 Apr 2023 15:00:28 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        alexandre.torgue@foss.st.com, Jose Abreu <joabreu@synopsys.com>
Subject: [PATCH net-next] net: stmmac: propagate feature flags to vlan
Date:   Tue, 11 Apr 2023 15:00:28 +0200
Message-Id: <20230411130028.136250-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_dev_probe doesn't propagate feature flags to VLANs.  So features
like TX offloading don't correspond with the general features and it's
not possible to manipulate features via ethtool -K to affect VLANs.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e590b6fc4761..308d4ee12d41 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7216,6 +7216,8 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->dma_cap.rssen && priv->plat->rss_en)
 		ndev->features |= NETIF_F_RXHASH;
 
+	ndev->vlan_features |= ndev->features;
+
 	/* MTU range: 46 - hw-specific max */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
 	if (priv->plat->has_xgmac)
-- 
2.39.1

