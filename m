Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9450932598F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhBYWUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:20:52 -0500
Received: from antares.kleine-koenig.org ([94.130.110.236]:40596 "EHLO
        antares.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhBYWT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 17:19:27 -0500
Received: by antares.kleine-koenig.org (Postfix, from userid 1000)
        id 7EA30B147A1; Thu, 25 Feb 2021 23:18:36 +0100 (CET)
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Haren Myneni <haren@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Steven Royer <seroyer@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2] vio: make remove callback return void
Date:   Thu, 25 Feb 2021 23:18:34 +0100
Message-Id: <20210225221834.160083-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver core ignores the return value of struct bus_type::remove()
because there is only little that can be done. To simplify the quest to
make this function return void, let struct vio_driver::remove() return
void, too. All users already unconditionally return 0, this commit makes
it obvious that returning an error code is a bad idea.

Note there are two nominally different implementations for a vio bus:
one in arch/sparc/kernel/vio.c and the other in
arch/powerpc/platforms/pseries/vio.c. This patch only adapts the powerpc
one.

Before this patch for a device that was bound to a driver without a
remove callback vio_cmo_bus_remove(viodev) wasn't called. As the device
core still considers the device unbound after vio_bus_remove() returns
calling this unconditionally is the consistent behaviour which is
implemented here.

Reviewed-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Acked-by: Lijun Pan <ljp@linux.ibm.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
Hello,

I dropped the sparc specific files (i.e. all that Michael Ellerman
didn't characterize as powerpc specific and verified that they are
indeed sparc-only).

The commit log is adapted accordingly.

Best regards
Uwe

 arch/powerpc/include/asm/vio.h           | 2 +-
 arch/powerpc/platforms/pseries/vio.c     | 7 +++----
 drivers/char/hw_random/pseries-rng.c     | 3 +--
 drivers/char/tpm/tpm_ibmvtpm.c           | 4 +---
 drivers/crypto/nx/nx-842-pseries.c       | 4 +---
 drivers/crypto/nx/nx.c                   | 4 +---
 drivers/misc/ibmvmc.c                    | 4 +---
 drivers/net/ethernet/ibm/ibmveth.c       | 4 +---
 drivers/net/ethernet/ibm/ibmvnic.c       | 4 +---
 drivers/scsi/ibmvscsi/ibmvfc.c           | 3 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c         | 4 +---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 4 +---
 drivers/tty/hvc/hvcs.c                   | 3 +--
 13 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/arch/powerpc/include/asm/vio.h b/arch/powerpc/include/asm/vio.h
index 0cf52746531b..721c0d6715ac 100644
--- a/arch/powerpc/include/asm/vio.h
+++ b/arch/powerpc/include/asm/vio.h
@@ -113,7 +113,7 @@ struct vio_driver {
 	const char *name;
 	const struct vio_device_id *id_table;
 	int (*probe)(struct vio_dev *dev, const struct vio_device_id *id);
-	int (*remove)(struct vio_dev *dev);
+	void (*remove)(struct vio_dev *dev);
 	/* A driver must have a get_desired_dma() function to
 	 * be loaded in a CMO environment if it uses DMA.
 	 */
diff --git a/arch/powerpc/platforms/pseries/vio.c b/arch/powerpc/platforms/pseries/vio.c
index b2797cfe4e2b..9cb4fc839fd5 100644
--- a/arch/powerpc/platforms/pseries/vio.c
+++ b/arch/powerpc/platforms/pseries/vio.c
@@ -1261,7 +1261,6 @@ static int vio_bus_remove(struct device *dev)
 	struct vio_dev *viodev = to_vio_dev(dev);
 	struct vio_driver *viodrv = to_vio_driver(dev->driver);
 	struct device *devptr;
-	int ret = 1;
 
 	/*
 	 * Hold a reference to the device after the remove function is called
@@ -1270,13 +1269,13 @@ static int vio_bus_remove(struct device *dev)
 	devptr = get_device(dev);
 
 	if (viodrv->remove)
-		ret = viodrv->remove(viodev);
+		viodrv->remove(viodev);
 
-	if (!ret && firmware_has_feature(FW_FEATURE_CMO))
+	if (firmware_has_feature(FW_FEATURE_CMO))
 		vio_cmo_bus_remove(viodev);
 
 	put_device(devptr);
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/drivers/char/hw_random/pseries-rng.c b/drivers/char/hw_random/pseries-rng.c
index 8038a8a9fb58..f4949b689bd5 100644
--- a/drivers/char/hw_random/pseries-rng.c
+++ b/drivers/char/hw_random/pseries-rng.c
@@ -54,10 +54,9 @@ static int pseries_rng_probe(struct vio_dev *dev,
 	return hwrng_register(&pseries_rng);
 }
 
-static int pseries_rng_remove(struct vio_dev *dev)
+static void pseries_rng_remove(struct vio_dev *dev)
 {
 	hwrng_unregister(&pseries_rng);
-	return 0;
 }
 
 static const struct vio_device_id pseries_rng_driver_ids[] = {
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 994385bf37c0..903604769de9 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -343,7 +343,7 @@ static int ibmvtpm_crq_send_init_complete(struct ibmvtpm_dev *ibmvtpm)
  *
  * Return: Always 0.
  */
-static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
+static void tpm_ibmvtpm_remove(struct vio_dev *vdev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&vdev->dev);
 	struct ibmvtpm_dev *ibmvtpm = dev_get_drvdata(&chip->dev);
@@ -372,8 +372,6 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
 	kfree(ibmvtpm);
 	/* For tpm_ibmvtpm_get_desired_dma */
 	dev_set_drvdata(&vdev->dev, NULL);
-
-	return 0;
 }
 
 /**
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 2de5e3672e42..cc8dd3072b8b 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -1042,7 +1042,7 @@ static int nx842_probe(struct vio_dev *viodev,
 	return ret;
 }
 
-static int nx842_remove(struct vio_dev *viodev)
+static void nx842_remove(struct vio_dev *viodev)
 {
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
@@ -1063,8 +1063,6 @@ static int nx842_remove(struct vio_dev *viodev)
 	if (old_devdata)
 		kfree(old_devdata->counters);
 	kfree(old_devdata);
-
-	return 0;
 }
 
 static const struct vio_device_id nx842_vio_driver_ids[] = {
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 0d2dc5be7f19..1d0e8a1ba160 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -783,7 +783,7 @@ static int nx_probe(struct vio_dev *viodev, const struct vio_device_id *id)
 	return nx_register_algs();
 }
 
-static int nx_remove(struct vio_dev *viodev)
+static void nx_remove(struct vio_dev *viodev)
 {
 	dev_dbg(&viodev->dev, "entering nx_remove for UA 0x%x\n",
 		viodev->unit_address);
@@ -811,8 +811,6 @@ static int nx_remove(struct vio_dev *viodev)
 		nx_unregister_skcipher(&nx_ecb_aes_alg, NX_FC_AES,
 				       NX_MODE_AES_ECB);
 	}
-
-	return 0;
 }
 
 
diff --git a/drivers/misc/ibmvmc.c b/drivers/misc/ibmvmc.c
index 2d778d0f011e..c0fe3295c330 100644
--- a/drivers/misc/ibmvmc.c
+++ b/drivers/misc/ibmvmc.c
@@ -2288,15 +2288,13 @@ static int ibmvmc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return -EPERM;
 }
 
-static int ibmvmc_remove(struct vio_dev *vdev)
+static void ibmvmc_remove(struct vio_dev *vdev)
 {
 	struct crq_server_adapter *adapter = dev_get_drvdata(&vdev->dev);
 
 	dev_info(adapter->dev, "Entering remove for UA 0x%x\n",
 		 vdev->unit_address);
 	ibmvmc_release_crq_queue(adapter);
-
-	return 0;
 }
 
 static struct vio_device_id ibmvmc_device_table[] = {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index c3ec9ceed833..7fea9ae60f13 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1758,7 +1758,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	return 0;
 }
 
-static int ibmveth_remove(struct vio_dev *dev)
+static void ibmveth_remove(struct vio_dev *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(&dev->dev);
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
@@ -1771,8 +1771,6 @@ static int ibmveth_remove(struct vio_dev *dev)
 
 	free_netdev(netdev);
 	dev_set_drvdata(&dev->dev, NULL);
-
-	return 0;
 }
 
 static struct attribute veth_active_attr;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 118a4bd3f877..eb39318766f6 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5396,7 +5396,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	return rc;
 }
 
-static int ibmvnic_remove(struct vio_dev *dev)
+static void ibmvnic_remove(struct vio_dev *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(&dev->dev);
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
@@ -5437,8 +5437,6 @@ static int ibmvnic_remove(struct vio_dev *dev)
 	device_remove_file(&dev->dev, &dev_attr_failover);
 	free_netdev(netdev);
 	dev_set_drvdata(&dev->dev, NULL);
-
-	return 0;
 }
 
 static ssize_t failover_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 755313b766b9..e663085a8944 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -6038,7 +6038,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
  * Return value:
  * 	0
  **/
-static int ibmvfc_remove(struct vio_dev *vdev)
+static void ibmvfc_remove(struct vio_dev *vdev)
 {
 	struct ibmvfc_host *vhost = dev_get_drvdata(&vdev->dev);
 	LIST_HEAD(purge);
@@ -6070,7 +6070,6 @@ static int ibmvfc_remove(struct vio_dev *vdev)
 	spin_unlock(&ibmvfc_driver_lock);
 	scsi_host_put(vhost->host);
 	LEAVE;
-	return 0;
 }
 
 /**
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 29fcc44be2d5..77fafb1bc173 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2335,7 +2335,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	return -1;
 }
 
-static int ibmvscsi_remove(struct vio_dev *vdev)
+static void ibmvscsi_remove(struct vio_dev *vdev)
 {
 	struct ibmvscsi_host_data *hostdata = dev_get_drvdata(&vdev->dev);
 
@@ -2356,8 +2356,6 @@ static int ibmvscsi_remove(struct vio_dev *vdev)
 	spin_unlock(&ibmvscsi_driver_lock);
 
 	scsi_host_put(hostdata->host);
-
-	return 0;
 }
 
 /**
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index cc3908c2d2f9..9abd9e253af6 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3595,7 +3595,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	return rc;
 }
 
-static int ibmvscsis_remove(struct vio_dev *vdev)
+static void ibmvscsis_remove(struct vio_dev *vdev)
 {
 	struct scsi_info *vscsi = dev_get_drvdata(&vdev->dev);
 
@@ -3622,8 +3622,6 @@ static int ibmvscsis_remove(struct vio_dev *vdev)
 	list_del(&vscsi->list);
 	spin_unlock_bh(&ibmvscsis_dev_lock);
 	kfree(vscsi);
-
-	return 0;
 }
 
 static ssize_t system_id_show(struct device *dev,
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index c90848919644..01fc97e3c5c8 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -819,7 +819,7 @@ static int hvcs_probe(
 	return 0;
 }
 
-static int hvcs_remove(struct vio_dev *dev)
+static void hvcs_remove(struct vio_dev *dev)
 {
 	struct hvcs_struct *hvcsd = dev_get_drvdata(&dev->dev);
 	unsigned long flags;
@@ -849,7 +849,6 @@ static int hvcs_remove(struct vio_dev *dev)
 
 	printk(KERN_INFO "HVCS: vty-server@%X removed from the"
 			" vio bus.\n", dev->unit_address);
-	return 0;
 };
 
 static struct vio_driver hvcs_vio_driver = {

base-commit: 2c87f7a38f930ef6f6a7bdd04aeb82ce3971b54b
-- 
2.30.0

