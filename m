Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27653E8B84
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbhHKIJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbhHKIH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:07:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBC3C06179C
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:07:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mDjGA-000106-3C; Wed, 11 Aug 2021 10:06:46 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mDjG5-0000OE-DS; Wed, 11 Aug 2021 10:06:41 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mDjG5-0002wt-Bn; Wed, 11 Aug 2021 10:06:41 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, kernel@pengutronix.de,
        Michael Ellerman <mpe@ellerman.id.au>,
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
Subject: [PATCH v3 4/8] PCI: replace pci_dev::driver usage that gets the driver name
Date:   Wed, 11 Aug 2021 10:06:33 +0200
Message-Id: <20210811080637.2596434-5-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811080637.2596434-1-u.kleine-koenig@pengutronix.de>
References: <20210811080637.2596434-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=a2O0HTv4aJywRdn8Xll+BiOFc5OY645rbrBOo3iG86g=; m=uiYraG79NtpzJXVYTkT2krJ2oKsGebV/4PDlvGFyew0=; p=xyRPXHOyvhpnJ99hDMY7ADUgwnpuj2HiXDqhBu9Yb1M=; g=b3e05e6dc28299e7c6641f7dd0a9213e54a17f13
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmEThOUACgkQwfwUeK3K7AkzTgf/faO QhHJzkpgD4RjAK6FRKTnAHgiisHkpBmxU1n5mMESIIgA0o553RuJVZ9t70Z6X54FJ7S6xm9Nyje0y 3IM1vRgOQzzCbXpONVYXQOWacqD3AlpbDU0W+X+v0jRC++ZVLwstYMhXTD8A2tESsaECCnL98JrL9 cMnAtuC2bhBOTnd0oFFbgIhP+uTHvVCvBIEnsAVPp8mddaEGne03leLhYZfEYJGZxK703Y2B6qiu+ 5uVndlfe6jqJ9WQ95olpZqA7ngE9JTRbc1f85iEY7ACM40+a5J3doEFceNuPZYBoL6Wt+e8NGK4EN +nR8ho7zAM4s3LsNjoqmQL3Abcmx5jQ==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct pci_dev::driver holds (apart from a constant offset) the same
data as struct pci_dev::dev->driver. With the goal to remove struct
pci_dev::driver to get rid of data duplication replace getting the
driver name by dev_driver_string() which implicitly makes use of struct
pci_dev::dev->driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/powerpc/include/asm/ppc-pci.h                   | 7 ++++++-
 drivers/bcma/host_pci.c                              | 7 ++++---
 drivers/crypto/hisilicon/qm.c                        | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c   | 2 +-
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c            | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
 drivers/ssb/pcihost_wrapper.c                        | 8 +++++---
 8 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/include/asm/ppc-pci.h b/arch/powerpc/include/asm/ppc-pci.h
index 2b9edbf6e929..3f89dda91e89 100644
--- a/arch/powerpc/include/asm/ppc-pci.h
+++ b/arch/powerpc/include/asm/ppc-pci.h
@@ -57,7 +57,12 @@ void eeh_sysfs_remove_device(struct pci_dev *pdev);
 
 static inline const char *eeh_driver_name(struct pci_dev *pdev)
 {
-	return (pdev && pdev->driver) ? pdev->driver->name : "<null>";
+	const char *drvstr = pdev ? dev_driver_string(&pdev->dev) : "";
+
+	if (*drvstr == '\0')
+		return "<null>";
+
+	return drvstr;
 }
 
 #endif /* CONFIG_EEH */
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 69c10a7b7c61..dc2ffa686964 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -175,9 +175,10 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 	if (err)
 		goto err_kfree_bus;
 
-	name = dev_name(&dev->dev);
-	if (dev->driver && dev->driver->name)
-		name = dev->driver->name;
+	name = dev_driver_string(&dev->dev);
+	if (*name == '\0')
+		name = dev_name(&dev->dev);
+
 	err = pci_request_regions(dev, name);
 	if (err)
 		goto err_pci_disable;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 1d67f94a1d56..ddf8d0ea6a75 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3003,7 +3003,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	};
 	int ret;
 
-	ret = strscpy(interface.name, pdev->driver->name,
+	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
 		      sizeof(interface.name));
 	if (ret < 0)
 		return -ENAMETOOLONG;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 82061ab6930f..e7a2c8d4558f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -593,7 +593,7 @@ static void hns3_get_drvinfo(struct net_device *netdev,
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
index 1b482446536d..1c0a9edcd005 100644
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

