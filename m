Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEC01FC631
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFQG3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:29:38 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:61545 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFQG3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:29:37 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05H6TOkO026703;
        Tue, 16 Jun 2020 23:29:34 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 3/5] cxgb4: add support to flash boot image
Date:   Wed, 17 Jun 2020 11:59:05 +0530
Message-Id: <20200617062907.26121-4-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200617062907.26121-1-vishal@chelsio.com>
References: <20200617062907.26121-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update set_flash to flash boot image to flash region

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  48 +++++
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  56 ++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 187 ++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h  |   6 +
 4 files changed, 297 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index cc76983130cc..b0e06644da76 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -142,6 +142,52 @@ enum cc_fec {
 enum {
 	CXGB4_ETHTOOL_FLASH_FW = 1,
 	CXGB4_ETHTOOL_FLASH_PHY = 2,
+	CXGB4_ETHTOOL_FLASH_BOOT = 3,
+};
+
+struct cxgb4_pcir_data {
+	__le32 signature;	/* Signature. The string "PCIR" */
+	__le16 vendor_id;	/* Vendor Identification */
+	__le16 device_id;	/* Device Identification */
+	__u8 vital_product[2];	/* Pointer to Vital Product Data */
+	__u8 length[2];		/* PCIR Data Structure Length */
+	__u8 revision;		/* PCIR Data Structure Revision */
+	__u8 class_code[3];	/* Class Code */
+	__u8 image_length[2];	/* Image Length. Multiple of 512B */
+	__u8 code_revision[2];	/* Revision Level of Code/Data */
+	__u8 code_type;
+	__u8 indicator;
+	__u8 reserved[2];
+};
+
+/* BIOS boot headers */
+struct cxgb4_pci_exp_rom_header {
+	__le16 signature;	/* ROM Signature. Should be 0xaa55 */
+	__u8 reserved[22];	/* Reserved per processor Architecture data */
+	__le16 pcir_offset;	/* Offset to PCI Data Structure */
+};
+
+/* Legacy PCI Expansion ROM Header */
+struct legacy_pci_rom_hdr {
+	__u8 signature[2];	/* ROM Signature. Should be 0xaa55 */
+	__u8 size512;		/* Current Image Size in units of 512 bytes */
+	__u8 initentry_point[4];
+	__u8 cksum;		/* Checksum computed on the entire Image */
+	__u8 reserved[16];	/* Reserved */
+	__le16 pcir_offset;	/* Offset to PCI Data Struture */
+};
+
+#define CXGB4_HDR_CODE1 0x00
+#define CXGB4_HDR_CODE2 0x03
+#define CXGB4_HDR_INDI 0x80
+
+/* BOOT constants */
+enum {
+	BOOT_SIZE_INC = 512,
+	BOOT_SIGNATURE = 0xaa55,
+	BOOT_MIN_SIZE = sizeof(struct cxgb4_pci_exp_rom_header),
+	BOOT_MAX_SIZE = 1024 * BOOT_SIZE_INC,
+	PCIR_SIGNATURE = 0x52494350
 };
 
 struct port_stats {
@@ -2013,6 +2059,8 @@ void t4_register_netevent_notifier(void);
 int t4_i2c_rd(struct adapter *adap, unsigned int mbox, int port,
 	      unsigned int devid, unsigned int offset,
 	      unsigned int len, u8 *buf);
+int t4_load_boot(struct adapter *adap, u8 *boot_data,
+		 unsigned int boot_addr, unsigned int size);
 void free_rspq_fl(struct adapter *adap, struct sge_rspq *rq, struct sge_fl *fl);
 void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 		  unsigned int n, bool unmap);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 4a72f481c4c0..d1fd01b2cc2a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -29,6 +29,7 @@ static const char * const flash_region_strings[] = {
 	"All",
 	"Firmware",
 	"PHY Firmware",
+	"Boot",
 };
 
 static const char stats_strings[][ETH_GSTRING_LEN] = {
@@ -1243,6 +1244,28 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	return err;
 }
 
+static int cxgb4_ethtool_flash_boot(struct net_device *netdev,
+				    const u8 *bdata, u32 size)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	unsigned int offset;
+	u8 *data;
+	int ret;
+
+	data = kmemdup(bdata, size, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	offset = OFFSET_G(t4_read_reg(adap, PF_REG(0, PCIE_PF_EXPROM_OFST_A)));
+
+	ret = t4_load_boot(adap, data, offset, size);
+	if (ret)
+		dev_err(adap->pdev_dev, "Failed to load boot image\n");
+
+	kfree(data);
+	return ret;
+}
+
 #define CXGB4_PHY_SIG 0x130000ea
 
 static int cxgb4_validate_phy_image(const u8 *data, u32 *size)
@@ -1312,6 +1335,9 @@ static int cxgb4_ethtool_flash_region(struct net_device *netdev,
 	case CXGB4_ETHTOOL_FLASH_PHY:
 		ret = cxgb4_ethtool_flash_phy(netdev, data, size);
 		break;
+	case CXGB4_ETHTOOL_FLASH_BOOT:
+		ret = cxgb4_ethtool_flash_boot(netdev, data, size);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1341,10 +1367,40 @@ static int cxgb4_validate_fw_image(const u8 *data, u32 *size)
 	return 0;
 }
 
+static int cxgb4_validate_boot_image(const u8 *data, u32 *size)
+{
+	struct cxgb4_pci_exp_rom_header *exp_header;
+	struct cxgb4_pcir_data *pcir_header;
+	struct legacy_pci_rom_hdr *header;
+	const u8 *cur_header = data;
+	u16 pcir_offset;
+
+	exp_header = (struct cxgb4_pci_exp_rom_header *)data;
+
+	if (le16_to_cpu(exp_header->signature) != BOOT_SIGNATURE)
+		return -EINVAL;
+
+	if (size) {
+		do {
+			header = (struct legacy_pci_rom_hdr *)cur_header;
+			pcir_offset = le16_to_cpu(header->pcir_offset);
+			pcir_header = (struct cxgb4_pcir_data *)(cur_header +
+				      pcir_offset);
+
+			*size += header->size512 * 512;
+			cur_header += header->size512 * 512;
+		} while (!(pcir_header->indicator & CXGB4_HDR_INDI));
+	}
+
+	return 0;
+}
+
 static int cxgb4_ethtool_get_flash_region(const u8 *data, u32 *size)
 {
 	if (!cxgb4_validate_fw_image(data, size))
 		return CXGB4_ETHTOOL_FLASH_FW;
+	if (!cxgb4_validate_boot_image(data, size))
+		return CXGB4_ETHTOOL_FLASH_BOOT;
 	if (!cxgb4_validate_phy_image(data, size))
 		return CXGB4_ETHTOOL_FLASH_PHY;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 1c8068c02728..f1d345845d19 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -10481,3 +10481,190 @@ int t4_set_vlan_acl(struct adapter *adap, unsigned int mbox, unsigned int vf,
 
 	return t4_wr_mbox(adap, adap->mbox, &vlan_cmd, sizeof(vlan_cmd), NULL);
 }
+
+/**
+ *	modify_device_id - Modifies the device ID of the Boot BIOS image
+ *	@adatper: the device ID to write.
+ *	@boot_data: the boot image to modify.
+ *
+ *	Write the supplied device ID to the boot BIOS image.
+ */
+static void modify_device_id(int device_id, u8 *boot_data)
+{
+	struct cxgb4_pcir_data *pcir_header;
+	struct legacy_pci_rom_hdr *header;
+	u8 *cur_header = boot_data;
+	u16 pcir_offset;
+
+	 /* Loop through all chained images and change the device ID's */
+	do {
+		header = (struct legacy_pci_rom_hdr *)cur_header;
+		pcir_offset = le16_to_cpu(header->pcir_offset);
+		pcir_header = (struct cxgb4_pcir_data *)(cur_header +
+			      pcir_offset);
+
+		/**
+		 * Only modify the Device ID if code type is Legacy or HP.
+		 * 0x00: Okay to modify
+		 * 0x01: FCODE. Do not modify
+		 * 0x03: Okay to modify
+		 * 0x04-0xFF: Do not modify
+		 */
+		if (pcir_header->code_type == CXGB4_HDR_CODE1) {
+			u8 csum = 0;
+			int i;
+
+			/**
+			 * Modify Device ID to match current adatper
+			 */
+			pcir_header->device_id = cpu_to_le16(device_id);
+
+			/**
+			 * Set checksum temporarily to 0.
+			 * We will recalculate it later.
+			 */
+			header->cksum = 0x0;
+
+			/**
+			 * Calculate and update checksum
+			 */
+			for (i = 0; i < (header->size512 * 512); i++)
+				csum += cur_header[i];
+
+			/**
+			 * Invert summed value to create the checksum
+			 * Writing new checksum value directly to the boot data
+			 */
+			cur_header[7] = -csum;
+
+		} else if (pcir_header->code_type == CXGB4_HDR_CODE2) {
+			/**
+			 * Modify Device ID to match current adatper
+			 */
+			pcir_header->device_id = cpu_to_le16(device_id);
+		}
+
+		/**
+		 * Move header pointer up to the next image in the ROM.
+		 */
+		cur_header += header->size512 * 512;
+	} while (!(pcir_header->indicator & CXGB4_HDR_INDI));
+}
+
+/**
+ *	t4_load_boot - download boot flash
+ *	@adapter: the adapter
+ *	@boot_data: the boot image to write
+ *	@boot_addr: offset in flash to write boot_data
+ *	@size: image size
+ *
+ *	Write the supplied boot image to the card's serial flash.
+ *	The boot image has the following sections: a 28-byte header and the
+ *	boot image.
+ */
+int t4_load_boot(struct adapter *adap, u8 *boot_data,
+		 unsigned int boot_addr, unsigned int size)
+{
+	unsigned int sf_sec_size = adap->params.sf_size / adap->params.sf_nsec;
+	unsigned int boot_sector = (boot_addr * 1024);
+	struct cxgb4_pci_exp_rom_header *header;
+	struct cxgb4_pcir_data *pcir_header;
+	int pcir_offset;
+	unsigned int i;
+	u16 device_id;
+	int ret, addr;
+
+	/**
+	 * Make sure the boot image does not encroach on the firmware region
+	 */
+	if ((boot_sector + size) >> 16 > FLASH_FW_START_SEC) {
+		dev_err(adap->pdev_dev, "boot image encroaching on firmware region\n");
+		return -EFBIG;
+	}
+
+	/* Get boot header */
+	header = (struct cxgb4_pci_exp_rom_header *)boot_data;
+	pcir_offset = le16_to_cpu(header->pcir_offset);
+	/* PCIR Data Structure */
+	pcir_header = (struct cxgb4_pcir_data *)&boot_data[pcir_offset];
+
+	/**
+	 * Perform some primitive sanity testing to avoid accidentally
+	 * writing garbage over the boot sectors.  We ought to check for
+	 * more but it's not worth it for now ...
+	 */
+	if (size < BOOT_MIN_SIZE || size > BOOT_MAX_SIZE) {
+		dev_err(adap->pdev_dev, "boot image too small/large\n");
+		return -EFBIG;
+	}
+
+	if (le16_to_cpu(header->signature) != BOOT_SIGNATURE) {
+		dev_err(adap->pdev_dev, "Boot image missing signature\n");
+		return -EINVAL;
+	}
+
+	/* Check PCI header signature */
+	if (le32_to_cpu(pcir_header->signature) != PCIR_SIGNATURE) {
+		dev_err(adap->pdev_dev, "PCI header missing signature\n");
+		return -EINVAL;
+	}
+
+	/* Check Vendor ID matches Chelsio ID*/
+	if (le16_to_cpu(pcir_header->vendor_id) != PCI_VENDOR_ID_CHELSIO) {
+		dev_err(adap->pdev_dev, "Vendor ID missing signature\n");
+		return -EINVAL;
+	}
+
+	/**
+	 * The boot sector is comprised of the Expansion-ROM boot, iSCSI boot,
+	 * and Boot configuration data sections. These 3 boot sections span
+	 * sectors 0 to 7 in flash and live right before the FW image location.
+	 */
+	i = DIV_ROUND_UP(size ? size : FLASH_FW_START,  sf_sec_size);
+	ret = t4_flash_erase_sectors(adap, boot_sector >> 16,
+				     (boot_sector >> 16) + i - 1);
+
+	/**
+	 * If size == 0 then we're simply erasing the FLASH sectors associated
+	 * with the on-adapter option ROM file
+	 */
+	if (ret || size == 0)
+		goto out;
+	/* Retrieve adapter's device ID */
+	pci_read_config_word(adap->pdev, PCI_DEVICE_ID, &device_id);
+       /* Want to deal with PF 0 so I strip off PF 4 indicator */
+	device_id = device_id & 0xf0ff;
+
+	 /* Check PCIE Device ID */
+	if (le16_to_cpu(pcir_header->device_id) != device_id) {
+		/**
+		 * Change the device ID in the Boot BIOS image to match
+		 * the Device ID of the current adapter.
+		 */
+		modify_device_id(device_id, boot_data);
+	}
+
+	/**
+	 * Skip over the first SF_PAGE_SIZE worth of data and write it after
+	 * we finish copying the rest of the boot image. This will ensure
+	 * that the BIOS boot header will only be written if the boot image
+	 * was written in full.
+	 */
+	addr = boot_sector;
+	for (size -= SF_PAGE_SIZE; size; size -= SF_PAGE_SIZE) {
+		addr += SF_PAGE_SIZE;
+		boot_data += SF_PAGE_SIZE;
+		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, boot_data);
+		if (ret)
+			goto out;
+	}
+
+	ret = t4_write_flash(adap, boot_sector, SF_PAGE_SIZE,
+			     (const u8 *)header);
+
+out:
+	if (ret)
+		dev_err(adap->pdev_dev, "boot image load failed, error %d\n",
+			ret);
+	return ret;
+}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index bb89d3be360b..065c01c654ff 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -563,6 +563,12 @@
 #define AIVEC_V(x) ((x) << AIVEC_S)
 
 #define PCIE_PF_CLI_A	0x44
+
+#define PCIE_PF_EXPROM_OFST_A 0x4c
+#define OFFSET_S    10
+#define OFFSET_M    0x3fffU
+#define OFFSET_G(x) (((x) >> OFFSET_S) & OFFSET_M)
+
 #define PCIE_INT_CAUSE_A	0x3004
 
 #define UNXSPLCPLERR_S    29
-- 
2.18.2

