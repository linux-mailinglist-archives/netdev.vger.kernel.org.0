Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A996D5AD34E
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiIEM4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiIEM4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:56:15 -0400
X-Greylist: delayed 212 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 05 Sep 2022 05:56:07 PDT
Received: from smtpbg.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417742018B
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 05:56:06 -0700 (PDT)
X-QQ-mid: bizesmtp81t1662382371tplowacw
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 05 Sep 2022 20:52:50 +0800 (CST)
X-QQ-SSF: 01400000002000L0L000B00A0000000
X-QQ-FEAT: xo0edGM1fUis+1hPQJk0yuap4FBrQmvW/s7nVGDE5jc9r9hh/VWjsFlOoHHjj
        h23VRxTLzgVzH9plRkTgZWTmzO+zGpbRoNi82kt07yEETqtzW1KSD+ik6i7fdiHptKOq+Ga
        YHp5l7L2zztPln1PZxYfKNbl1rjEEUn3/BVl4mSJ/UNXAKxxKacv4c+uBe+zbA1yY7PWOJq
        IW5WQWloPR5HYxvy7LLAuCR/4WTt+WGjprV5T/Ddas6xzmuu/eorQgPodVhayQNJCVPWYOa
        0sRZfp7QBfqgf9rMWdvtm41nqyfDlwvDJHDMnzCrdQANkt5vMLsfRrpzTkJSRGa/bveNgRg
        z63xy5fPYpisP2rmBrxrgi9jB+3zHvRWrerKG3gWfsmuOduOtTSeujlGlwcVzXl93aJhB3I
        vtiS7idk8fM=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@net-swift.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 02/02] net: ngbe: Check some hardware functions
Date:   Mon,  5 Sep 2022 20:52:48 +0800
Message-Id: <20220905125248.2361-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check eeprom ready.
Check whether WOL is enabled.
Check whether the MAC is available.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   | 311 ++++++++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   8 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  54 +++
 3 files changed, 373 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index 20c21f99e308..f38dc47b8f32 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -381,3 +381,314 @@ int ngbe_reset_hw(struct ngbe_hw *hw)
 
 	return 0;
 }
+
+/**
+ *  ngbe_release_eeprom_semaphore - Release hardware semaphore
+ *  @hw: pointer to hardware structure
+ *
+ *  This function clears hardware semaphore bits.
+ **/
+static void ngbe_release_eeprom_semaphore(struct ngbe_hw *hw)
+{
+	wr32m(hw, NGBE_MIS_SWSM, NGBE_MIS_SWSM_SMBI, 0);
+	ngbe_flush(hw);
+}
+
+/**
+ *  ngbe_get_eeprom_semaphore - Get hardware semaphore
+ *  @hw: pointer to hardware structure
+ *  Sets the hardware semaphores so EEPROM access can occur for bit-bang method
+ **/
+static int ngbe_get_eeprom_semaphore(struct ngbe_hw *hw)
+{
+	int status = 0;
+	u32 times = 10;
+	u32 i;
+	u32 swsm;
+
+	/* Get SMBI software semaphore between device drivers first */
+	for (i = 0; i < times; i++) {
+		/* If the SMBI bit is 0 when we read it, then the bit will be
+		 * set and we have the semaphore
+		 */
+		status = read_poll_timeout(rd32, swsm, !(swsm & NGBE_MIS_SWSM_SMBI), 50,
+					   20000, false, hw, NGBE_MIS_SWSM);
+		if (!status)
+			return 0;
+	}
+
+	if (i == times) {
+		dev_err(ngbe_hw_to_dev(hw),
+			"Driver can't access the Eeprom - SMBI Semaphore not granted.\n");
+		/* this release is particularly important because our attempts
+		 * above to get the semaphore may have succeeded, and if there
+		 * was a timeout, we should unconditionally clear the semaphore
+		 * bits to free the driver to make progress
+		 */
+		ngbe_release_eeprom_semaphore(hw);
+		status = -EBUSY;
+	}
+	/* one last try
+	 * If the SMBI bit is 0 when we read it, then the bit will be
+	 * set and we have the semaphore
+	 */
+	swsm = rd32(hw, NGBE_MIS_SWSM);
+	if (!(swsm & NGBE_MIS_SWSM_SMBI))
+		status = 0;
+	return status;
+}
+
+/**
+ *  ngbe_acquire_swfw_sync - Acquire SWFW semaphore
+ *  @hw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to acquire
+ *
+ *  Acquires the SWFW semaphore through the GSSR register for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+static int ngbe_acquire_swfw_sync(struct ngbe_hw *hw, u32 mask)
+{
+	u32 gssr = 0;
+	u32 swmask = mask;
+	u32 fwmask = mask << 16;
+	u32 times = 2000;
+	u32 i;
+
+	for (i = 0; i < times; i++) {
+		/* SW NVM semaphore bit is used for access to all
+		 * SW_FW_SYNC bits (not just NVM)
+		 */
+		if (ngbe_get_eeprom_semaphore(hw))
+			return -EBUSY;
+
+		gssr = rd32(hw, NGBE_MNG_SWFW_SYNC);
+		if (!(gssr & (fwmask | swmask))) {
+			gssr |= swmask;
+			wr32(hw, NGBE_MNG_SWFW_SYNC, gssr);
+			ngbe_release_eeprom_semaphore(hw);
+			return 0;
+		}
+		/* Resource is currently in use by FW or SW */
+		ngbe_release_eeprom_semaphore(hw);
+	}
+
+	/* If time expired clear the bits holding the lock and retry */
+	if (gssr & (fwmask | swmask))
+		ngbe_release_swfw_sync(hw, gssr & (fwmask | swmask));
+
+	return -EBUSY;
+}
+
+/**
+ *  ngbe_release_swfw_sync - Release SWFW semaphore
+ *  @hw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to release
+ *
+ *  Releases the SWFW semaphore through the GSSR register for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+void ngbe_release_swfw_sync(struct ngbe_hw *hw, u32 mask)
+{
+	ngbe_get_eeprom_semaphore(hw);
+	wr32m(hw, NGBE_MNG_SWFW_SYNC, mask, 0);
+	ngbe_release_eeprom_semaphore(hw);
+}
+
+/**
+ *  ngbe_host_interface_command - Issue command to manageability block
+ *  @hw: pointer to the HW structure
+ *  @buffer: contains the command to write and where the return status will
+ *   be placed
+ *  @length: length of buffer, must be multiple of 4 bytes
+ *  @timeout: time in ms to wait for command completion
+ *  @return_data: read and return data from the buffer (true) or not (false)
+ *   Needed because FW structures are big endian and decoding of
+ *   these fields can be 8 bit or 16 bit based on command. Decoding
+ *   is not easily understood without making a table of commands.
+ *   So we will leave this up to the caller to read back the data
+ *   in these cases.
+ **/
+int ngbe_host_interface_command(struct ngbe_hw *hw, u32 *buffer,
+				u32 length, u32 timeout, bool return_data)
+{
+	u32 hicr, i, bi;
+	u32 hdr_size = sizeof(struct ngbe_hic_hdr);
+	u16 buf_len;
+	u32 dword_len;
+	int err = 0;
+	u32 buf[64] = {};
+
+	if (length == 0 || length > NGBE_HI_MAX_BLOCK_BYTE_LENGTH) {
+		dev_err(ngbe_hw_to_dev(hw),
+			"Buffer length failure buffersize=%d.\n", length);
+		return -EINVAL;
+	}
+
+	if (ngbe_acquire_swfw_sync(hw, NGBE_MNG_SWFW_SYNC_SW_MB) != 0)
+		return -EBUSY;
+
+	/* Calculate length in DWORDs. We must be DWORD aligned */
+	if ((length % (sizeof(u32))) != 0) {
+		dev_err(ngbe_hw_to_dev(hw),
+			"Buffer length failure, not aligned to dword");
+		err = -EINVAL;
+		goto rel_out;
+	}
+
+	/*read to clean all status*/
+	hicr = rd32(hw, NGBE_MNG_MBOX_CTL);
+	if ((hicr & NGBE_MNG_MBOX_CTL_FWRDY))
+		dev_err(ngbe_hw_to_dev(hw),
+			"fwrdy is set before command.\n");
+	dword_len = length >> 2;
+	/* The device driver writes the relevant command block
+	 * into the ram area.
+	 */
+	for (i = 0; i < dword_len; i++)
+		wr32a(hw, NGBE_MNG_MBOX, i, buffer[i]);
+
+	/* Setting this bit tells the ARC that a new command is pending. */
+	wr32m(hw, NGBE_MNG_MBOX_CTL,
+	      NGBE_MNG_MBOX_CTL_SWRDY, NGBE_MNG_MBOX_CTL_SWRDY);
+
+	for (i = 0; i < timeout; i++) {
+		err = read_poll_timeout(rd32, hicr, hicr & NGBE_MNG_MBOX_CTL_FWRDY, 1000,
+					20000, false, hw, NGBE_MNG_MBOX_CTL);
+		if (!err)
+			break;
+	}
+
+	buf[0] = rd32(hw, NGBE_MNG_MBOX);
+	/* Check command completion */
+	if (timeout != 0 && i == timeout) {
+		dev_err(ngbe_hw_to_dev(hw),
+			"Command has failed with no status valid.\n");
+		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
+			err = -EINVAL;
+			goto rel_out;
+		}
+	}
+
+	if (!return_data)
+		goto rel_out;
+
+	/* Calculate length in DWORDs */
+	dword_len = hdr_size >> 2;
+
+	/* first pull in the header so we know the buffer length */
+	for (bi = 0; bi < dword_len; bi++)
+		buffer[bi] = rd32a(hw, NGBE_MNG_MBOX, bi);
+
+	/* If there is any thing in data position pull it in */
+	buf_len = ((struct ngbe_hic_hdr *)buffer)->buf_len;
+	if (buf_len == 0)
+		goto rel_out;
+
+	if (length < buf_len + hdr_size) {
+		dev_err(ngbe_hw_to_dev(hw),
+			"Buffer not large enough for reply message.\n");
+		err = -ENOMEM;
+		goto rel_out;
+	}
+
+	/* Calculate length in DWORDs, add 3 for odd lengths */
+	dword_len = (buf_len + 3) >> 2;
+
+	/* Pull in the rest of the buffer (bi is where we left off) */
+	for (; bi <= dword_len; bi++)
+		buffer[bi] = rd32a(hw, NGBE_MNG_MBOX, bi);
+
+rel_out:
+	ngbe_release_swfw_sync(hw, NGBE_MNG_SWFW_SYNC_SW_MB);
+	return err;
+}
+
+/**
+ *  ngbe_init_eeprom_params - Initialize EEPROM params
+ *  @hw: pointer to hardware structure
+ *
+ *  Initializes the EEPROM parameters ngbe_eeprom_info within the
+ *  ngbe_hw struct in order to set up EEPROM access.
+ **/
+void ngbe_init_eeprom_params(struct ngbe_hw *hw)
+{
+	struct ngbe_eeprom_info *eeprom = &hw->eeprom;
+
+	eeprom->semaphore_delay = 10;
+	eeprom->word_size = 1024 >> 1;
+	eeprom->sw_region_offset = 0x80;
+}
+
+int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw)
+{
+	int tmp;
+	int status;
+	struct ngbe_hic_read_shadow_ram buffer;
+
+	buffer.hdr.req.cmd = NGBE_FW_EEPROM_CHECKSUM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = 0;
+	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
+	/* convert offset from words to bytes */
+	buffer.address = 0;
+	/* one word */
+	buffer.length = 0;
+
+	status = ngbe_host_interface_command(hw, (u32 *)&buffer,
+					     sizeof(buffer),
+					     NGBE_HI_COMMAND_TIMEOUT, false);
+
+	if (status < 0)
+		return status;
+	tmp = (u32)rd32a(hw, NGBE_MNG_MBOX, 1);
+	if (tmp == 0x80658383)
+		status = 0;
+	else
+		return -EIO;
+
+	return status;
+}
+
+static int ngbe_read_ee_hostif_data32(struct ngbe_hw *hw, u16 offset, u32 *data)
+{
+	int status;
+	struct ngbe_hic_read_shadow_ram buffer;
+
+	buffer.hdr.req.cmd = NGBE_FW_READ_SHADOW_RAM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = NGBE_FW_READ_SHADOW_RAM_LEN;
+	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
+	/* convert offset from words to bytes */
+	buffer.address = (__force u32)cpu_to_be32(offset * 2);
+	/* one word */
+	buffer.length = (__force u16)cpu_to_be16(sizeof(u32));
+
+	status = ngbe_host_interface_command(hw, (u32 *)&buffer,
+					     sizeof(buffer),
+					     NGBE_HI_COMMAND_TIMEOUT, false);
+	if (status)
+		return status;
+	*data = (u32)rd32a(hw, NGBE_MNG_MBOX, NGBE_FW_NVM_DATA_OFFSET);
+
+	return 0;
+}
+
+/**
+ *  ngbe_read_ee_hostif32 - Read EEPROM word using a host interface cmd
+ *  @hw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @data: dword read from the EEPROM
+ *
+ *  Reads a dword from the EEPROM using the hostif.
+ **/
+int ngbe_read_ee_hostif32(struct ngbe_hw *hw, u16 offset, u32 *data)
+{
+	int status = 0;
+
+	if (ngbe_acquire_swfw_sync(hw, NGBE_MNG_SWFW_SYNC_SW_FLASH) < 0)
+		return -EBUSY;
+	status = ngbe_read_ee_hostif_data32(hw, offset, data);
+	ngbe_release_swfw_sync(hw, NGBE_MNG_SWFW_SYNC_SW_FLASH);
+
+	return status;
+}
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
index c2c9dc186ad4..8b0ada1dac6c 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
@@ -12,7 +12,15 @@ void wr32m(struct ngbe_hw *hw, u32 reg, u32 mask, u32 field);
 struct device *ngbe_hw_to_dev(struct ngbe_hw *hw);
 int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data);
 int ngbe_check_flash_load(struct ngbe_hw *hw, u32 check_bit);
+/* eeprom ops */
+void ngbe_init_eeprom_params(struct ngbe_hw *hw);
+int ngbe_eeprom_chksum_hostif(struct ngbe_hw *hw);
+int ngbe_read_ee_hostif32(struct ngbe_hw *hw, u16 offset, u32 *data);
+
 int ngbe_get_pcie_msix_counts(struct ngbe_hw *hw, u16 *msix_count);
 /* mac ops */
+void ngbe_release_swfw_sync(struct ngbe_hw *hw, u32 mask);
+int ngbe_host_interface_command(struct ngbe_hw *hw, u32 *buffer,
+				u32 length, u32 timeout, bool return_data);
 int ngbe_reset_hw(struct ngbe_hw *hw);
 #endif /* _NGBE_HW_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 6ea06d6032c6..3885161ddcfd 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -234,7 +234,11 @@ static int ngbe_probe(struct pci_dev *pdev,
 	struct ngbe_adapter *adapter = NULL;
 	struct net_device *netdev;
 	struct ngbe_hw *hw = NULL;
+	u32 e2rom_cksum_cap = 0;
 	static int cards_found;
+	u32 e2rom_verl = 0;
+	u32 etrack_id = 0;
+	u32 saved_ver = 0;
 	int err;
 
 	err = pci_enable_device_mem(pdev);
@@ -314,6 +318,56 @@ static int ngbe_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 	}
 
+	if (hw->bus.func == 0) {
+		wr32(hw, NGBE_CALSUM_CAP_STATUS, 0x0);
+		wr32(hw, NGBE_EEPROM_VERSION_STORE_REG, 0x0);
+	} else {
+		e2rom_cksum_cap = rd32(hw, NGBE_CALSUM_CAP_STATUS);
+		saved_ver = rd32(hw, NGBE_EEPROM_VERSION_STORE_REG);
+	}
+
+	ngbe_init_eeprom_params(hw);
+	if (hw->bus.func == 0 || e2rom_cksum_cap == 0) {
+		/* make sure the EEPROM is ready */
+		err = ngbe_eeprom_chksum_hostif(hw);
+		if (err) {
+			dev_err(&pdev->dev, "The EEPROM Checksum Is Not Valid\n");
+			err = -EIO;
+			goto err_sw_init;
+		}
+	}
+
+	adapter->wol = 0;
+	if (hw->wol_enabled)
+		adapter->wol = NGBE_PSR_WKUP_CTL_MAG;
+
+	hw->wol_enabled = !!(adapter->wol);
+	wr32(hw, NGBE_PSR_WKUP_CTL, adapter->wol);
+
+	device_set_wakeup_enable(&pdev->dev, adapter->wol);
+
+	/* Save off EEPROM version number and Option Rom version which
+	 * together make a unique identify for the eeprom
+	 */
+	if (saved_ver) {
+		etrack_id = saved_ver;
+	} else {
+		ngbe_read_ee_hostif32(hw,
+				      hw->eeprom.sw_region_offset + NGBE_EEPROM_VERSION_L,
+				      &e2rom_verl);
+		etrack_id = e2rom_verl;
+		wr32(hw, NGBE_EEPROM_VERSION_STORE_REG, etrack_id);
+	}
+	snprintf(adapter->eeprom_id, sizeof(adapter->eeprom_id), "0x%08x", etrack_id);
+
+	eth_hw_addr_set(netdev, hw->mac.perm_addr);
+
+	if (!is_valid_ether_addr(netdev->dev_addr)) {
+		dev_err(&pdev->dev, "invalid MAC address\n");
+		err = -EIO;
+		goto err_sw_init;
+	}
+
 	pci_set_drvdata(pdev, adapter);
 
 	return 0;
-- 
2.37.1

