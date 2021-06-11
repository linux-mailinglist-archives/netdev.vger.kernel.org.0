Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3143A3E4C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhFKIuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:50:55 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:53982 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhFKIuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 04:50:54 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 15B8mrFP022144;
        Fri, 11 Jun 2021 01:48:53 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net 1/3] cxgb4: fix endianness when flashing boot image
Date:   Fri, 11 Jun 2021 12:17:45 +0530
Message-Id: <d676f0c760e52b9746ae13f7079d8d717ae42f80.1623400558.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
References: <cover.1623400558.git.rahul.lakkireddy@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Boot images are copied to memory and updated with current underlying
device ID before flashing them to adapter. Ensure the updated images
are always flashed in Big Endian to allow the firmware to read the
new images during boot properly.

Fixes: 550883558f17 ("cxgb4: add support to flash boot image")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 44 +++++++++++++---------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 9428ef1f04a8..1293505025c1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3060,16 +3060,19 @@ int t4_read_flash(struct adapter *adapter, unsigned int addr,
  *	@addr: the start address to write
  *	@n: length of data to write in bytes
  *	@data: the data to write
+ *	@byte_oriented: whether to store data as bytes or as words
  *
  *	Writes up to a page of data (256 bytes) to the serial flash starting
  *	at the given address.  All the data must be written to the same page.
+ *	If @byte_oriented is set the write data is stored as byte stream
+ *	(i.e. matches what on disk), otherwise in big-endian.
  */
 static int t4_write_flash(struct adapter *adapter, unsigned int addr,
-			  unsigned int n, const u8 *data)
+			  unsigned int n, const u8 *data, bool byte_oriented)
 {
-	int ret;
-	u32 buf[64];
 	unsigned int i, c, left, val, offset = addr & 0xff;
+	u32 buf[64];
+	int ret;
 
 	if (addr >= adapter->params.sf_size || offset + n > SF_PAGE_SIZE)
 		return -EINVAL;
@@ -3080,10 +3083,14 @@ static int t4_write_flash(struct adapter *adapter, unsigned int addr,
 	    (ret = sf1_write(adapter, 4, 1, 1, val)) != 0)
 		goto unlock;
 
-	for (left = n; left; left -= c) {
+	for (left = n; left; left -= c, data += c) {
 		c = min(left, 4U);
-		for (val = 0, i = 0; i < c; ++i)
-			val = (val << 8) + *data++;
+		for (val = 0, i = 0; i < c; ++i) {
+			if (byte_oriented)
+				val = (val << 8) + data[i];
+			else
+				val = (val << 8) + data[c - i - 1];
+		}
 
 		ret = sf1_write(adapter, c, c != left, 1, val);
 		if (ret)
@@ -3096,7 +3103,8 @@ static int t4_write_flash(struct adapter *adapter, unsigned int addr,
 	t4_write_reg(adapter, SF_OP_A, 0);    /* unlock SF */
 
 	/* Read the page to verify the write succeeded */
-	ret = t4_read_flash(adapter, addr & ~0xff, ARRAY_SIZE(buf), buf, 1);
+	ret = t4_read_flash(adapter, addr & ~0xff, ARRAY_SIZE(buf), buf,
+			    byte_oriented);
 	if (ret)
 		return ret;
 
@@ -3692,7 +3700,7 @@ int t4_load_fw(struct adapter *adap, const u8 *fw_data, unsigned int size)
 	 */
 	memcpy(first_page, fw_data, SF_PAGE_SIZE);
 	((struct fw_hdr *)first_page)->fw_ver = cpu_to_be32(0xffffffff);
-	ret = t4_write_flash(adap, fw_start, SF_PAGE_SIZE, first_page);
+	ret = t4_write_flash(adap, fw_start, SF_PAGE_SIZE, first_page, true);
 	if (ret)
 		goto out;
 
@@ -3700,14 +3708,14 @@ int t4_load_fw(struct adapter *adap, const u8 *fw_data, unsigned int size)
 	for (size -= SF_PAGE_SIZE; size; size -= SF_PAGE_SIZE) {
 		addr += SF_PAGE_SIZE;
 		fw_data += SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, fw_data);
+		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, fw_data, true);
 		if (ret)
 			goto out;
 	}
 
-	ret = t4_write_flash(adap,
-			     fw_start + offsetof(struct fw_hdr, fw_ver),
-			     sizeof(hdr->fw_ver), (const u8 *)&hdr->fw_ver);
+	ret = t4_write_flash(adap, fw_start + offsetof(struct fw_hdr, fw_ver),
+			     sizeof(hdr->fw_ver), (const u8 *)&hdr->fw_ver,
+			     true);
 out:
 	if (ret)
 		dev_err(adap->pdev_dev, "firmware download failed, error %d\n",
@@ -10208,7 +10216,7 @@ int t4_load_cfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 			n = size - i;
 		else
 			n = SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+		ret = t4_write_flash(adap, addr, n, cfg_data, true);
 		if (ret)
 			goto out;
 
@@ -10677,13 +10685,14 @@ int t4_load_boot(struct adapter *adap, u8 *boot_data,
 	for (size -= SF_PAGE_SIZE; size; size -= SF_PAGE_SIZE) {
 		addr += SF_PAGE_SIZE;
 		boot_data += SF_PAGE_SIZE;
-		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, boot_data);
+		ret = t4_write_flash(adap, addr, SF_PAGE_SIZE, boot_data,
+				     false);
 		if (ret)
 			goto out;
 	}
 
 	ret = t4_write_flash(adap, boot_sector, SF_PAGE_SIZE,
-			     (const u8 *)header);
+			     (const u8 *)header, false);
 
 out:
 	if (ret)
@@ -10758,7 +10767,7 @@ int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 	for (i = 0; i < size; i += SF_PAGE_SIZE) {
 		n = min_t(u32, size - i, SF_PAGE_SIZE);
 
-		ret = t4_write_flash(adap, addr, n, cfg_data);
+		ret = t4_write_flash(adap, addr, n, cfg_data, false);
 		if (ret)
 			goto out;
 
@@ -10770,7 +10779,8 @@ int t4_load_bootcfg(struct adapter *adap, const u8 *cfg_data, unsigned int size)
 	for (i = 0; i < npad; i++) {
 		u8 data = 0;
 
-		ret = t4_write_flash(adap, cfg_addr + size + i, 1, &data);
+		ret = t4_write_flash(adap, cfg_addr + size + i, 1, &data,
+				     false);
 		if (ret)
 			goto out;
 	}
-- 
2.27.0

