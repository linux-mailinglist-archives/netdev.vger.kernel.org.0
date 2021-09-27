Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F5241A065
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 22:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbhI0UqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 16:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbhI0UqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 16:46:21 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0DFC061765
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 13:44:43 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mUxTe-0001jp-DD; Mon, 27 Sep 2021 22:43:54 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mUxTY-0001YX-J8; Mon, 27 Sep 2021 22:43:48 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mUxTY-0001NN-Gx; Mon, 27 Sep 2021 22:43:48 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-pci@vger.kernel.org,
        kernel@pengutronix.de, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Michael Buesch <m@bues.ch>,
        "Oliver O'Halloran" <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the driver name
Date:   Mon, 27 Sep 2021 22:43:22 +0200
Message-Id: <20210927204326.612555-5-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927204326.612555-1-uwe@kleine-koenig.org>
References: <20210927204326.612555-1-uwe@kleine-koenig.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=a2O0HTv4aJywRdn8Xll+BiOFc5OY645rbrBOo3iG86g=; m=uiYraG79NtpzJXVYTkT2krJ2oKsGebV/4PDlvGFyew0=; p=AUabNdK3Oc6hLf1u5raYHAjiFBP1NcdSOD8qDOCVVeY=; g=9fc159a3b3d1c22b121315875a3324b706ea97b2
X-Patch-Sig: m=pgp; i=uwe@kleine-koenig.org; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFSLNEACgkQwfwUeK3K7Ak0WAf+LIC 8H0Ni3FH7fEhqAxEC6O6fGPMdf/2Uz3OTec5bTRdY7DvxodsBp63bi7OJ13K5jPa7ij4bJOOWh7iX pJU4IYM7ydRfA3q19o6WWuYtjfZosjDi6HAEfun5hNZVm8IkhodehHyfaIHhiMNizGFJedWzcZcfY Aw529YNY7kWJ5QjJXMDNkwzTIQDFPVWiwpdvamB+NMXPd/DjyXJZVXhLX0DfW3eWzbCfO1cw55dfb VSPPw0hnLPcjdx9BAevJ4yqd3ufOJmkp6oRrzBa7cyKnECkyCF4NPhfht2lE5njNfVlAfhAlwK6Yj NnYPLRRXlhPvURkRF1X6bQKfT5KbHKQ==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

struct pci_dev::driver holds (apart from a constant offset) the same
data as struct pci_dev::dev->driver. With the goal to remove struct
pci_dev::driver to get rid of data duplication replace getting the
driver name by dev_driver_string() which implicitly makes use of struct
pci_dev::dev->driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/powerpc/include/asm/ppc-pci.h                   | 9 ++++++++-
 drivers/bcma/host_pci.c                              | 7 ++++---
 drivers/crypto/hisilicon/qm.c                        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c   | 2 +-
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c            | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
 drivers/ssb/pcihost_wrapper.c                        | 8 +++++---
 8 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-pci.h b/arch/powerpc/include/asm/ppc-pci.h
index 2b9edbf6e929..e8f1795a2acf 100644
--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@ -57,7 +57,14 @@ void eeh_sysfs_remove_device(struct pci_dev *pdev);
 
 static inline const char *eeh_driver_name(struct pci_dev *pdev)
 {
-	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
+	if (pdev) {
+		const char *drvstr = dev_driver_string(&pdev->dev);
+
+		if (strcmp(drvstr, ""))
+			return drvstr;
+	}
+
+	return "<null>";
 }
 
 #endif /* CONFIG_EEH */
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 69c10a7b7c61..0973022d4b13 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -175,9 +175,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 	if (err)
 		goto err_kfree_bus;
 
-	name = dev_name(&dev->dev);
-	if (dev->driver && dev->driver->name)
-		name = dev->driver->name;
+	name = dev_driver_string(&dev->dev);
+	if (!strcmp(name, ""))
+		name = dev_name(&dev->dev);
+
 	err = pci_request_regions(dev, name);
 	if (err)
 		goto err_pci_disable;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 369562d34d66..8f361e54e524 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3085,7 +3085,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	};
 	int ret;
 
-	ret = strscpy(interface.name, pdev->driver->name,
+	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
 		      sizeof(interface.name));
 	if (ret < 0)
 		return -ENAMETOOLONG;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 7ea511d59e91..f279edfce3f1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -606,7 +606,7 @@ static void hns3_get_drvinfo(struct net_device *netdev,
 		return;
 	}
 
-	strncpy(drvinfo->driver, h->pdev->driver->name,
+	strncpy(drvinfo->driver, dev_driver_string(&h->pdev->dev),
 		sizeof(drvinfo->driver));
 	drvinfo->driver[sizeof(drvinfo->driver) - 1] = '\0';
 
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index a250d394da38..a8f007f6dad2 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -720,7 +720,7 @@ static int prestera_fw_load(struct prestera_fw *fw)
 static int prestera_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
-	const char *driver_name = pdev->driver->name;
+	const char *driver_name = dev_driver_string(&pdev->dev);
 	struct prestera_fw *fw;
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 13b0259f7ea6..8f306364f7bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1876,7 +1876,7 @@ static void mlxsw_pci_cmd_fini(struct mlxsw_pci *mlxsw_pci)
 
 static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	const char *driver_name = pdev->driver->name;
+	const char *driver_name = dev_driver_string(&pdev->dev);
 	struct mlxsw_pci *mlxsw_pci;
 	int err;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 0685ece1f155..23dfb599c828 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
 {
 	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
 
-	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
+	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvinfo->driver));
 	nfp_net_get_nspinfo(app, nsp_version);
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%s %s %s %s", vnic_version, nsp_version,
diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
index 410215c16920..4938ed5cfae5 100644
--- a/drivers/ssb/pcihost_wrapper.c
+++ b/drivers/ssb/pcihost_wrapper.c
@@ -78,9 +78,11 @@ static int ssb_pcihost_probe(struct pci_dev *dev,
 	err = pci_enable_device(dev);
 	if (err)
 		goto err_kfree_ssb;
-	name = dev_name(&dev->dev);
-	if (dev->driver && dev->driver->name)
-		name = dev->driver->name;
+
+	name = dev_driver_string(&dev->dev);
+	if (*name == '\0')
+		name = dev_name(&dev->dev);
+
 	err = pci_request_regions(dev, name);
 	if (err)
 		goto err_pci_disable;
-- 
2.30.2

