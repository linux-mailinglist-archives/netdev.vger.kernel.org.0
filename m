Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043421FC632
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgFQG3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:29:41 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:6111 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFQG3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:29:40 -0400
Received: from vishal.asicdesigners.com ([10.193.191.100])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05H6TOkP026703;
        Tue, 16 Jun 2020 23:29:36 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 4/5] cxgb4: add support to flash boot cfg image
Date:   Wed, 17 Jun 2020 11:59:06 +0530
Message-Id: <20200617062907.26121-5-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200617062907.26121-1-vishal@chelsio.com>
References: <20200617062907.26121-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update set_flash to flash boot cfg image to flash region

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  9 ++
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 30 +++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 90 +++++++++++++++++++
 3 files changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index b0e06644da76..e6aab51a93ac 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -143,6 +143,12 @@ enum {
 	CXGB4_ETHTOOL_FLASH_FW = 1,
 	CXGB4_ETHTOOL_FLASH_PHY = 2,
 	CXGB4_ETHTOOL_FLASH_BOOT = 3,
+	CXGB4_ETHTOOL_FLASH_BOOTCFG = 4
+};
+
+struct cxgb4_bootcfg_data {
+	__le16 signature;
+	__u8 reserved[2];
 };
 
 struct cxgb4_pcir_data {
@@ -183,6 +189,7 @@ struct legacy_pci_rom_hdr {
 
 /* BOOT constants */
 enum {
+	BOOT_CFG_SIG = 0x4243,
 	BOOT_SIZE_INC = 512,
 	BOOT_SIGNATURE = 0xaa55,
 	BOOT_MIN_SIZE = sizeof(struct cxgb4_pci_exp_rom_header),
@@ -2061,6 +2068,8 @@ int t4_i2c_rd(struct adapter *adap, unsigned int mbox, int port,
 	      unsigned int len, u8 *buf);
 int t4_load_boot(struct adapter *adap, u8 *boot_data,
 		 unsigned int boot_addr, unsigned int size);
+int t4_load_bootcfg(struct adapter *adap,
+		    const u8 *cfg_data, unsigned int size);
 void free_rspq_fl(struct adapter *adap, struct sge_rspq *rq, struct sge_fl *fl);
 void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 		  unsigned int n, bool unmap);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index d1fd01b2cc2a..6b48760a55cb 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -30,6 +30,7 @@ static const char * const flash_region_strings[] = {
 	"Firmware",
 	"PHY Firmware",
 	"Boot",
+	"Boot CFG",
 };
 
 static const char stats_strings[][ETH_GSTRING_LEN] = {
@@ -1244,6 +1245,19 @@ static int set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom,
 	return err;
 }
 
+static int cxgb4_ethtool_flash_bootcfg(struct net_device *netdev,
+				       const u8 *data, u32 size)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	int ret;
+
+	ret = t4_load_bootcfg(adap, data, size);
+	if (ret)
+		dev_err(adap->pdev_dev, "Failed to load boot cfg image\n");
+
+	return ret;
+}
+
 static int cxgb4_ethtool_flash_boot(struct net_device *netdev,
 				    const u8 *bdata, u32 size)
 {
@@ -1338,6 +1352,9 @@ static int cxgb4_ethtool_flash_region(struct net_device *netdev,
 	case CXGB4_ETHTOOL_FLASH_BOOT:
 		ret = cxgb4_ethtool_flash_boot(netdev, data, size);
 		break;
+	case CXGB4_ETHTOOL_FLASH_BOOTCFG:
+		ret = cxgb4_ethtool_flash_bootcfg(netdev, data, size);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1367,6 +1384,17 @@ static int cxgb4_validate_fw_image(const u8 *data, u32 *size)
 	return 0;
 }
 
+static int cxgb4_validate_bootcfg_image(const u8 *data, u32 *size)
+{
+	struct cxgb4_bootcfg_data *header;
+
+	header = (struct cxgb4_bootcfg_data *)data;
+	if (le16_to_cpu(header->signature) != BOOT_CFG_SIG)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int cxgb4_validate_boot_image(const u8 *data, u32 *size)
 {
 	struct cxgb4_pci_exp_rom_header *exp_header;
@@ -1403,6 +1431,8 @@ static int cxgb4_ethtool_get_flash_region(const u8 *data, u32 *size)
 		return CXGB4_ETHTOOL_FLASH_BOOT;
 	if (!cxgb4_validate_phy_image(data, size))
 		return CXGB4_ETHTOOL_FLASH_PHY;
+	if (!cxgb4_validate_bootcfg_image(data, size))
+		return CXGB4_ETHTOOL_FLASH_BOOTCFG;
 
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index f1d345845d19..0ebb5d4b023a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -10668,3 +10668,93 @@ int t4_load_boot(struct adapter *adap, u8 *boot_data,
 			ret);
 	return ret;
 }
+
+/**
+ *	t4_flash_bootcfg_addr - return the address of the flash
+ *	optionrom configuration
+ *	@adapter: the adapter
+ *
+ *	Return the address within the flash where the OptionROM Configuration
+ *	is stored, or an error if the device FLASH is too small to contain
+ *	a OptionROM Configuration.
+ */
+static int t4_flash_bootcfg_addr(struct adapter *adapter)
+{
+	/**
+	 * If the device FLASH isn't large enough to hold a Firmware
+	 * Configuration File, return an error.
+	 */
+	if (adapter->params.sf_size <
+	    FLASH_BOOTCFG_START + FLASH_BOOTCFG_MAX_SIZE)
+		return -ENOSPC;
+
+	return FLASH_BOOTCFG_START;
+}
+
+int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
+{
+	unsigned int sf_sec_size = adap->params.sf_size / adap->params.sf_nsec;
+	struct cxgb4_bootcfg_data *header;
+	unsigned int flash_cfg_start_sec;
+	unsigned int addr, npad;
+	int ret, i, n, cfg_addr;
+
+	cfg_addr = t4_flash_bootcfg_addr(adap);
+	if (cfg_addr < 0)
+		return cfg_addr;
+
+	addr = cfg_addr;
+	flash_cfg_start_sec = addr / SF_SEC_SIZE;
+
+	if (size > FLASH_BOOTCFG_MAX_SIZE) {
+		dev_err(adap->pdev_dev, "bootcfg file too large, max is %u bytes\n",
+			FLASH_BOOTCFG_MAX_SIZE);
+		return -EFBIG;
+	}
+
+	header = (struct cxgb4_bootcfg_data *)cfg_data;
+	if (le16_to_cpu(header->signature) != BOOT_CFG_SIG) {
+		dev_err(adap->pdev_dev, "Wrong bootcfg signature\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	i = DIV_ROUND_UP(FLASH_BOOTCFG_MAX_SIZE,
+			 sf_sec_size);
+	ret = t4_flash_erase_sectors(adap, flash_cfg_start_sec,
+				     flash_cfg_start_sec + i - 1);
+
+	/**
+	 * If size == 0 then we're simply erasing the FLASH sectors associated
+	 * with the on-adapter OptionROM Configuration File.
+	 */
+	if (ret || size == 0)
+		goto out;
+
+	/* this will write to the flash up to SF_PAGE_SIZE at a time */
+	for (i = 0; i < size; i += SF_PAGE_SIZE) {
+		n = min_t(u32, size - i, SF_PAGE_SIZE);
+
+		ret = t4_write_flash(adap, addr, n, cfg_data);
+		if (ret)
+			goto out;
+
+		addr += SF_PAGE_SIZE;
+		cfg_data += SF_PAGE_SIZE;
+	}
+
+	npad = ((size + 4 - 1) & ~3) - size;
+	for (i = 0; i < npad; i++) {
+		u8 data = 0;
+
+		ret = t4_write_flash(adap, cfg_addr + size + i, 1, &data);
+		if (ret)
+			goto out;
+	}
+
+out:
+	if (ret)
+		dev_err(adap->pdev_dev, "boot config data %s failed %d\n",
+			(size == 0 ? "clear" : "download"), ret);
+	return ret;
+}
-- 
2.18.2

