Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2DC324F25
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhBYL1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235649AbhBYLZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 06:25:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD46BC06178A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:19 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id l12so6371874edt.3
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 03:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3gMn1B5n+kEUxmDCzxuLwqjw53ImoVESHGUvoMUB0uY=;
        b=XVpccipdBkLfqoGCprpq+/yA+wz031x7mtfu6DPGLHNNK98tK3zZbVxU7r6749aBHc
         0evY5LEOCEbjHRZB3lR3903M+2mJtH3lFazhTZCZZn1sthcrkc5m9d6dKfu/pzupZ66x
         aT5nRdxxh0BMcNRF6XKDSLjVuCd8bzSqxkC0pWNeFQgoAJplZ/L3PP0TICcJq+/hDhiV
         d2mBq3+K5bFiaoN/v2cecbxSzowt73NdGjQ5F6JPnrXWrL7Sul3yVSeTGdfvXXdeTmQ9
         0Zyn0Zk6xlAl/5RdbWWHI5SU3TGk1qe4l6UWRLvFxwooiNp7dmOVcRi5LTRDAboXYtj0
         6F/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3gMn1B5n+kEUxmDCzxuLwqjw53ImoVESHGUvoMUB0uY=;
        b=gvw3w+qWGceWTD4QrTRdejvpMrNJpCsEFnL/zqfRnmeBya+5kmRVDGrQPeVONIiZdz
         WsF44M1C3D1mbeAnzt4vrytVBCIu1L5siBodyQi/itEMFKQtx3iK39sqBcHl8luCaXVj
         7Gjs7ifQeKKWsLtcT5m0FPBYwZypoBQsa+wTsQSE0XTKOFj5uVvntexAbBmAnh7hxw0M
         FLcl6TofUHBfoYivIkr4Nb16OO9hSPDnxiwNQEMJfw6FVWZTtzc34rEi1hEebmfP+mnH
         1CNm6hXJ4AnMCGAatF1uI0B6s0Oy5PUAI3NxSfUHNJtvQxXyvSlgNBu9ozG26VceuMPy
         1ORQ==
X-Gm-Message-State: AOAM530j5iUbFPGYIRqp00h+YIHAG6E9nq8YPBFCHZDRpI41uqlmrB8Q
        tsi1zc5LkEs9Y7sbMQNuiqiMRiFYxf4=
X-Google-Smtp-Source: ABdhPJx8O0NSWHpch0j9NCuc++JctsN1outn7Vh2qebz19FkRdexU/cUh3gM1C8axuPWpVw78vUelA==
X-Received: by 2002:aa7:c243:: with SMTP id y3mr2368099edo.122.1614252258537;
        Thu, 25 Feb 2021 03:24:18 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id v12sm2977156ejh.94.2021.02.25.03.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 03:24:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Markus=20Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: [PATCH net 5/6] net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
Date:   Thu, 25 Feb 2021 13:23:56 +0200
Message-Id: <20210225112357.3785911-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225112357.3785911-1-olteanv@gmail.com>
References: <20210225112357.3785911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Quoting from the blamed commit:

    In promiscuous mode, it is more intuitive that all traffic is received,
    including VLAN tagged traffic. It appears that it is necessary to set
    the flag in PSIPVMR for that to be the case, so VLAN promiscuous mode is
    also temporarily enabled. On exit from promiscuous mode, the setting
    made by ethtool is restored.

Intuitive or not, there isn't any definition issued by a standards body
which says that promiscuity has anything to do with VLAN filtering - it
only has to do with accepting packets regardless of destination MAC address.

In fact people are already trying to use this misunderstanding/bug of
the enetc driver as a justification to transform promiscuity into
something it never was about: accepting every packet (maybe that would
be the "rx-all" netdev feature?):
https://lore.kernel.org/netdev/20201110153958.ci5ekor3o2ekg3ky@ipetronik.com/

So we should avoid that and delete the bogus logic in enetc.

Fixes: 7070eea5e95a ("enetc: permit configuration of rx-vlan-filter with ethtool")
Cc: Markus Blöchl <Markus.Bloechl@ipetronik.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 62ba4bf56f0d..49681a0566ed 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -190,7 +190,6 @@ static void enetc_pf_set_rx_mode(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	char vlan_promisc_simap = pf->vlan_promisc_simap;
 	struct enetc_hw *hw = &priv->si->hw;
 	bool uprom = false, mprom = false;
 	struct enetc_mac_filter *filter;
@@ -203,16 +202,12 @@ static void enetc_pf_set_rx_mode(struct net_device *ndev)
 		psipmr = ENETC_PSIPMR_SET_UP(0) | ENETC_PSIPMR_SET_MP(0);
 		uprom = true;
 		mprom = true;
-		/* Enable VLAN promiscuous mode for SI0 (PF) */
-		vlan_promisc_simap |= BIT(0);
 	} else if (ndev->flags & IFF_ALLMULTI) {
 		/* enable multi cast promisc mode for SI0 (PF) */
 		psipmr = ENETC_PSIPMR_SET_MP(0);
 		mprom = true;
 	}
 
-	enetc_set_vlan_promisc(&pf->si->hw, vlan_promisc_simap);
-
 	/* first 2 filter entries belong to PF */
 	if (!uprom) {
 		/* Update unicast filters */
-- 
2.25.1

