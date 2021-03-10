Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2839A333C2A
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbhCJMF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbhCJMEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:04:49 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4F4C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:48 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l12so27706118edt.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPKhDvpNanMg66h5KIXhooZXRDUExMMWXCLmke7I9Dw=;
        b=sFaLMgelmZrYovDwLApFBFhftVMZ71ZDCyHQRRDdA0eJ1ogi4BNCVjL3Ews1t1mhr/
         /bM29hmX+xte9B7UkAsAiryCZuusm4yaaMdWjS8TIZA3Yikp8biq932ac+ygoXQ4Nuqs
         sO+56BpjDXGiKkHDbK0312Xw++7Cp7vzQuIFmqdkd02xaFkTYbLn94BWhz46zdSAhbL2
         WHx4HYKQyFpYFsVqp+6duLPZKQ0hJrQO2P5YHhbCIpM9m4pTri2mpYma0af9/3tOK+zp
         h97pMexgQnHL+VZkWgyO9CYeww4FMh4CsGz2nK/7ZJSwPeyfHTtsOsXGYY4vUeqa8uFp
         K3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPKhDvpNanMg66h5KIXhooZXRDUExMMWXCLmke7I9Dw=;
        b=NRsa0p6cbQETdH14BrrU24jcF++oIrbZBvmi2nkkkMqoh/2+Evnt62qQhUSRI+eNL2
         O0KbbQcBjzzQ09p1yYgTZJFV7QqgY/Glyg5Fbj12a7aWM5mpeQSnwFIgVAtOTJl9JPlb
         PbHKv6s40TWAi6oolcBlTlvuZ58kUXzWMBFTu8FKOv4nGOWagczGMunpk1xhmoTaF7Z4
         8suPwapWsCsx5XdXD1qMZYQL8/cIBKQ1qSyqRmaDj1z3lMxwQnwOxuYjJ0RehSFVdaxD
         848D5Rq2VU9Z00N9qs/OaKHUzpckW/by2+VknM6J6Z4yJsLxKyW4tNfrKAMPZgwJ8G4M
         4JqQ==
X-Gm-Message-State: AOAM5319eMEndzavh3+9mrTO+ITTMYnqpqkiRlB7TZAUdJGGu5h3aTC/
        mi/JmlohfY0+SKQRk2inFBA=
X-Google-Smtp-Source: ABdhPJxd9QHO9gcu9iwkedjzv41jyqUTGjG2On7nrw2C9ffJ/l4iWDdU6sSthM7WOgtq6/j2wd26zA==
X-Received: by 2002:aa7:c98f:: with SMTP id c15mr2878798edt.231.1615377887547;
        Wed, 10 Mar 2021 04:04:47 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id q20sm9913239ejs.41.2021.03.10.04.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:04:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net-next 07/12] net: enetc: don't initialize unused ports from a separate code path
Date:   Wed, 10 Mar 2021 14:03:46 +0200
Message-Id: <20210310120351.542292-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210310120351.542292-1-vladimir.oltean@nxp.com>
References: <20210310120351.542292-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 3222b5b613db ("net: enetc: initialize RFS/RSS memories for
unused ports too") there is a requirement to initialize the memories of
unused PFs too, which has left the probe path in a bit of a rough shape,
because we basically have a minimal initialization path for unused PFs
which is separate from the main initialization path.

Now that initializing a control BD ring is as simple as calling
enetc_setup_cbdr, let's move that outside of enetc_alloc_si_resources
(unused PFs don't need classification rules, so no point in allocating
them just to free them later).

But enetc_alloc_si_resources is called both for PFs and for VFs, so now
that enetc_setup_cbdr is no longer called from this common function, it
means that the VF probe path needs to explicitly call enetc_setup_cbdr
too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 21 +-------
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 52 ++++++++-----------
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  7 +++
 3 files changed, 30 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 06fcab53c471..f92d29b62bae 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1059,34 +1059,17 @@ void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 {
 	struct enetc_si *si = priv->si;
-	int err;
-
-	err = enetc_setup_cbdr(priv->dev, &si->hw, ENETC_CBDR_DEFAULT_SIZE,
-			       &si->cbd_ring);
-	if (err)
-		return err;
 
 	priv->cls_rules = kcalloc(si->num_fs_entries, sizeof(*priv->cls_rules),
 				  GFP_KERNEL);
-	if (!priv->cls_rules) {
-		err = -ENOMEM;
-		goto err_alloc_cls;
-	}
+	if (!priv->cls_rules)
+		return -ENOMEM;
 
 	return 0;
-
-err_alloc_cls:
-	enetc_teardown_cbdr(&si->cbd_ring);
-
-	return err;
 }
 
 void enetc_free_si_resources(struct enetc_ndev_priv *priv)
 {
-	struct enetc_si *si = priv->si;
-
-	enetc_teardown_cbdr(&si->cbd_ring);
-
 	kfree(priv->cls_rules);
 }
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bf70b8f9943f..c8b6110448d4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1081,22 +1081,6 @@ static int enetc_init_port_rss_memory(struct enetc_si *si)
 	return err;
 }
 
-static void enetc_init_unused_port(struct enetc_si *si)
-{
-	struct device *dev = &si->pdev->dev;
-	struct enetc_hw *hw = &si->hw;
-	int err;
-
-	err = enetc_setup_cbdr(dev, hw, ENETC_CBDR_DEFAULT_SIZE, &si->cbd_ring);
-	if (err)
-		return;
-
-	enetc_init_port_rfs_memory(si);
-	enetc_init_port_rss_memory(si);
-
-	enetc_teardown_cbdr(&si->cbd_ring);
-}
-
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
@@ -1120,8 +1104,24 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_map_pf_space;
 	}
 
+	err = enetc_setup_cbdr(&pdev->dev, &si->hw, ENETC_CBDR_DEFAULT_SIZE,
+			       &si->cbd_ring);
+	if (err)
+		goto err_setup_cbdr;
+
+	err = enetc_init_port_rfs_memory(si);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize RFS memory\n");
+		goto err_init_port_rfs;
+	}
+
+	err = enetc_init_port_rss_memory(si);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to initialize RSS memory\n");
+		goto err_init_port_rss;
+	}
+
 	if (node && !of_device_is_available(node)) {
-		enetc_init_unused_port(si);
 		dev_info(&pdev->dev, "device is disabled, skipping\n");
 		err = -ENODEV;
 		goto err_device_disabled;
@@ -1154,18 +1154,6 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_si_res;
 	}
 
-	err = enetc_init_port_rfs_memory(si);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to initialize RFS memory\n");
-		goto err_init_port_rfs;
-	}
-
-	err = enetc_init_port_rss_memory(si);
-	if (err) {
-		dev_err(&pdev->dev, "Failed to initialize RSS memory\n");
-		goto err_init_port_rss;
-	}
-
 	err = enetc_configure_si(priv);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to configure SI\n");
@@ -1201,15 +1189,17 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 err_mdiobus_create:
 	enetc_free_msix(priv);
 err_config_si:
-err_init_port_rss:
-err_init_port_rfs:
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
+err_init_port_rss:
+err_init_port_rfs:
 err_device_disabled:
+	enetc_teardown_cbdr(&si->cbd_ring);
+err_setup_cbdr:
 err_map_pf_space:
 	enetc_pci_remove(pdev);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 9b755a84c2d6..371a34d3c6b4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -165,6 +165,11 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 
 	enetc_init_si_rings_params(priv);
 
+	err = enetc_setup_cbdr(priv->dev, &si->hw, ENETC_CBDR_DEFAULT_SIZE,
+			       &si->cbd_ring);
+	if (err)
+		goto err_setup_cbdr;
+
 	err = enetc_alloc_si_resources(priv);
 	if (err) {
 		dev_err(&pdev->dev, "SI resource alloc failed\n");
@@ -197,6 +202,8 @@ static int enetc_vf_probe(struct pci_dev *pdev,
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:
+	enetc_teardown_cbdr(&si->cbd_ring);
+err_setup_cbdr:
 	si->ndev = NULL;
 	free_netdev(ndev);
 err_alloc_netdev:
-- 
2.25.1

