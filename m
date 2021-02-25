Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B31324FCF
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 13:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhBYMUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 07:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhBYMUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 07:20:16 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2ECC06178A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:19:00 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mm21so8230296ejb.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 04:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VwRPKCVOmxGv/SdbYtNhUZCc3KlJ7t0EavxKRIEpKzo=;
        b=BiK57PumYK/uMTCraAh2SHlekrLEFVNAh6Awac89qyqBBuU94o8brRJBt792zoE54A
         6RJ0VfczJ77pfsbCVyCO99VU4SygD88DEDQ1Dl/VGJVW3IBPq+OzWkd/36uKcFxk9wol
         /dkov6FE6fndLbpywUpNCugGS0T91raDbrjjyjOV7VV5lQjlqBPs5JczgGlcJ9cBU4K1
         9uzT4y42fVhEYb2eL8iy6DzKMT3PYbZ4LF8TpTqwQbtYDZ47BfHI2r/ymERp4rtNxMjR
         fvDIDCPTtsg3UXD9vOrAUzkD+SC9lYsbKxRKX/PJkq1bIvziPYHUQwD8+MeMaGRnbwqQ
         uDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VwRPKCVOmxGv/SdbYtNhUZCc3KlJ7t0EavxKRIEpKzo=;
        b=mI5vT/xzVNUkL2Zpq1r8W0jHIuUrRJazcNK5wE1Ja4/hbQFJZ76BogBQWsXiAruyfD
         ZfqcANnM7eqaKBtXmaeRJtVEp4eJgY2yT3UbJZoY2jar4UTEgX1/xpJa3PZsBoNaDks5
         VAzKKtlozlg6SanTDNnNJgRyQXWTuyyuQ/Od/nO8o+YzVDQyUqjiYcl3ZH7WqjDPgzhX
         liwizw8odaNDvDHLEHjel8M6x0VJFq//x5KdNcizZUmeTI5fBD6G9/qjBRUzebQvDXbK
         ohVZCJR4ed6UXwySNGTNL1DS5RMY2h8vFfmF9VfII3yXvjtK66r4KUyU9wLJyd4fZOOg
         sM7Q==
X-Gm-Message-State: AOAM531kG7xl0Y50MGzzqQuof7/Hzp+FvoWN7EeJDqtAiOqTW70NGN6u
        ZU/H//qCkeHfysCwGZpmqw0=
X-Google-Smtp-Source: ABdhPJymTwSKl8LGW3lw1snqZHsJziD+4gagwjgWJXp9CXEn/adD5YW6rfQfnmn35SKGzy7pfM9FAg==
X-Received: by 2002:a17:906:4e91:: with SMTP id v17mr2357086eju.331.1614255539431;
        Thu, 25 Feb 2021 04:18:59 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id x25sm3420925edv.65.2021.02.25.04.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 04:18:59 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Markus=20Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
Subject: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in IFF_PROMISC mode
Date:   Thu, 25 Feb 2021 14:18:34 +0200
Message-Id: <20210225121835.3864036-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225121835.3864036-1-olteanv@gmail.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
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
Changes in v2:
None.

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

