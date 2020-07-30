Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42527233518
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 17:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgG3PMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 11:12:09 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13347 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729696AbgG3PMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 11:12:08 -0400
Received: from localhost (fedora32ganji.blr.asicdesigners.com [10.193.80.135])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 06UFC3RC013794;
        Thu, 30 Jul 2020 08:12:04 -0700
From:   Ganji Aravind <ganji.aravind@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: [PATCH net-next] cxgb4: Add support to flash firmware config image
Date:   Thu, 30 Jul 2020 20:41:38 +0530
Message-Id: <20200730151138.394115-1-ganji.aravind@chelsio.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update set_flash to flash firmware configuration image
to flash region.

Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  3 +-
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 93 +++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 13 ++-
 3 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index adbc0d088070..081f94c539a9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -143,7 +143,8 @@ enum {
 	CXGB4_ETHTOOL_FLASH_FW = 1,
 	CXGB4_ETHTOOL_FLASH_PHY = 2,
 	CXGB4_ETHTOOL_FLASH_BOOT = 3,
-	CXGB4_ETHTOOL_FLASH_BOOTCFG = 4
+	CXGB4_ETHTOOL_FLASH_BOOTCFG = 4,
+	CXGB4_ETHTOOL_FLASH_FWCFG = 5
 };
 
 struct cxgb4_bootcfg_data {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 12ef9ddd1e54..42e2cf5c33f3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -40,6 +40,7 @@ static const char * const flash_region_strings[] = {
 	"PHY Firmware",
 	"Boot",
 	"Boot CFG",
+	"Firmware CFG",
 };
 
 static const char stats_strings[][ETH_GSTRING_LEN] = {
@@ -1351,6 +1352,93 @@ static int cxgb4_ethtool_flash_fw(struct net_device *netdev,
 	return ret;
 }
 
+static const u8 *cxgb4_token_match(const u8 *input, const u8 *token)
+{
+	const u8 *token_match;
+
+	token_match = strstr(input, token);
+	if (token_match)
+		return (token_match + strlen(token));
+
+	return NULL;
+}
+
+static u32 cxgb4_compute_fwcfg_csum(const u8 *data, size_t st_size)
+{
+	unsigned int n, rem;
+	const __be32 *uip;
+	u32 csum;
+
+	uip = (const __be32 *)data;
+	for (csum = 0, n = st_size >> 2; n; n--)
+		csum += be32_to_cpu(*uip++);
+
+	rem = st_size & 0x3;
+	if (rem) {
+		union {
+			char buf[4];
+			__be32 u;
+		} last;
+		char *cp;
+
+		last.u = *uip;
+		for (cp = &last.buf[rem], n = 4 - rem; n; n--)
+			*cp++ = 0;
+		csum += be32_to_cpu(last.u);
+	}
+
+	return csum;
+}
+
+static int cxgb4_validate_fwcfg_image(const u8 *data)
+{
+	const u8 *fwcfg_fini, *version, *checksum;
+	u32 calculated_csum = 0;
+	u8 fw_csum[16] = { 0 };
+	u8 fw_ver[8] = { 0 };
+	size_t st_size;
+
+	fwcfg_fini = cxgb4_token_match(data, "[fini]\n");
+	if (!fwcfg_fini)
+		return -EINVAL;
+
+	version = cxgb4_token_match(fwcfg_fini, "version = ");
+	if (!version)
+		return -EINVAL;
+
+	checksum = cxgb4_token_match(fwcfg_fini, "checksum = ");
+	if (!checksum)
+		return -EINVAL;
+
+	st_size = fwcfg_fini - data;
+	calculated_csum = cxgb4_compute_fwcfg_csum(data, st_size);
+
+	snprintf(fw_csum, sizeof(fw_csum), "0x%x", calculated_csum);
+	snprintf(fw_ver, sizeof(fw_ver), "0x%x", PCI_VENDOR_ID_CHELSIO);
+
+	if (strncmp(fw_csum, checksum, strlen(fw_csum)) &&
+	    strncmp(fw_ver, version, strlen(fw_ver)))
+		return -EPERM;
+
+	return 0;
+}
+
+static int cxgb4_ethtool_flash_fwcfg(struct net_device *netdev,
+				     const u8 *data, u32 size)
+{
+	struct adapter *adap = netdev2adap(netdev);
+	int ret;
+
+	ret = cxgb4_validate_fwcfg_image(data);
+	if (ret) {
+		dev_err(adap->pdev_dev,
+			"Firmware config validation error: %d\n", ret);
+		return ret;
+	}
+
+	return t4_load_cfg(adap, data, size);
+}
+
 static int cxgb4_ethtool_flash_region(struct net_device *netdev,
 				      const u8 *data, u32 size, u32 region)
 {
@@ -1370,6 +1458,9 @@ static int cxgb4_ethtool_flash_region(struct net_device *netdev,
 	case CXGB4_ETHTOOL_FLASH_BOOTCFG:
 		ret = cxgb4_ethtool_flash_bootcfg(netdev, data, size);
 		break;
+	case CXGB4_ETHTOOL_FLASH_FWCFG:
+		ret = cxgb4_ethtool_flash_fwcfg(netdev, data, size);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
@@ -1448,6 +1539,8 @@ static int cxgb4_ethtool_get_flash_region(const u8 *data, u32 *size)
 		return CXGB4_ETHTOOL_FLASH_PHY;
 	if (!cxgb4_validate_bootcfg_image(data, size))
 		return CXGB4_ETHTOOL_FLASH_BOOTCFG;
+	if (!cxgb4_validate_fwcfg_image(data))
+		return CXGB4_ETHTOOL_FLASH_FWCFG;
 
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 8a56491bb034..bf3eea91a2cc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -10208,11 +10208,18 @@ int t4_load_cfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 
 	/* this will write to the flash up to SF_PAGE_SIZE at a time */
 	for (i = 0; i < size; i += SF_PAGE_SIZE) {
-		if ((size - i) <  SF_PAGE_SIZE)
+		if ((size - i) <  SF_PAGE_SIZE) {
+			u8 buf[SF_PAGE_SIZE] = { 0 };
+			u8 npad;
+
 			n = size - i;
-		else
+			npad = ((n + 4 - 1) & ~3) - n;
+			memcpy(buf, cfg_data, n);
+			ret = t4_write_flash(adap, addr, n + npad, buf);
+		} else {
 			n = SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+			ret = t4_write_flash(adap, addr, n, cfg_data);
+		}
 		if (ret)
 			goto out;
 
-- 
2.26.2

