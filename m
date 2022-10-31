Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8B9613114
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 08:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJaHJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 03:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaHJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 03:09:35 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0837BF48
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 00:09:32 -0700 (PDT)
X-QQ-mid: bizesmtp69t1667200100t50hphgx
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 31 Oct 2022 15:08:18 +0800 (CST)
X-QQ-SSF: 01400000000000M0L000000A0000000
X-QQ-FEAT: D6RqbDSxuq67nhRvZ6Hd7suN3OX2xsBKEjP0DztJ7FiQi02hTgYvmF2UxayM1
        14wK89eLuvL82FTcN9P1mU1qSEurVVKl23MSpj5Q1E1dlBQA98PHZ8FUvLJgbVzu9t+TjhA
        tdbA5huglbOkmNETXl8qY2on0PjhkuNkzkaYhNfHn6wgKi969G2ZQjGzG8y84DMuutz/eIN
        qJOIora1clf/UMRQd3rtgCav8N2Ngy1yc77igqiAPDllPhYqMof2dcFtc9FGkR+sYxvJVIb
        NiELCevGLIlZFNKQq2YYXjVVtGKrgTenYSIm6iYZHkHYq6lQklzgiTyTaARPjv9Q8THRAMU
        sZ9JVHjGpyADK3B0Q9DdtXBSlElqcVOEqbsMJSyGP96r/rtI3mB3oR5m6Z5otRyRJkkhBCr
        yeNNPJcvvCJXAHmxKr6J7A==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: [PATCH net-next 1/3] net: libwx: Implement interaction with firmware
Date:   Mon, 31 Oct 2022 15:07:55 +0800
Message-Id: <20221031070757.982-2-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031070757.982-1-mengyuanlou@net-swift.com>
References: <20221031070757.982-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiawen Wu <jiawenwu@trustnetic.com>

Add mailbox commands to interact with firmware.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   | 427 +++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_hw.h   |   7 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h | 109 +++++
 3 files changed, 543 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 8dbbac862f27..eafc1791f859 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -73,6 +73,433 @@ int wx_check_flash_load(struct wx_hw *hw, u32 check_bit)
 }
 EXPORT_SYMBOL(wx_check_flash_load);
 
+void wx_control_hw(struct wx_hw *wxhw, bool drv)
+{
+	if (drv) {
+		/* Let firmware know the driver has taken over */
+		wr32m(wxhw, WX_CFG_PORT_CTL,
+		      WX_CFG_PORT_CTL_DRV_LOAD, WX_CFG_PORT_CTL_DRV_LOAD);
+	} else {
+		/* Let firmware take over control of hw */
+		wr32m(wxhw, WX_CFG_PORT_CTL,
+		      WX_CFG_PORT_CTL_DRV_LOAD, 0);
+	}
+}
+EXPORT_SYMBOL(wx_control_hw);
+
+/**
+ * wx_mng_present - returns 0 when management capability is present
+ * @wxhw: pointer to hardware structure
+ */
+int wx_mng_present(struct wx_hw *wxhw)
+{
+	u32 fwsm;
+
+	fwsm = rd32(wxhw, WX_MIS_ST);
+	if (fwsm & WX_MIS_ST_MNG_INIT_DN)
+		return 0;
+	else
+		return -EACCES;
+}
+EXPORT_SYMBOL(wx_mng_present);
+
+/* Software lock to be held while software semaphore is being accessed. */
+static DEFINE_MUTEX(wx_sw_sync_lock);
+
+/**
+ *  wx_release_sw_sync - Release SW semaphore
+ *  @wxhw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to release
+ *
+ *  Releases the SW semaphore for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+static void wx_release_sw_sync(struct wx_hw *wxhw, u32 mask)
+{
+	mutex_lock(&wx_sw_sync_lock);
+	wr32m(wxhw, WX_MNG_SWFW_SYNC, mask, 0);
+	mutex_unlock(&wx_sw_sync_lock);
+}
+
+/**
+ *  wx_acquire_sw_sync - Acquire SW semaphore
+ *  @wxhw: pointer to hardware structure
+ *  @mask: Mask to specify which semaphore to acquire
+ *
+ *  Acquires the SW semaphore for the specified
+ *  function (CSR, PHY0, PHY1, EEPROM, Flash)
+ **/
+static int wx_acquire_sw_sync(struct wx_hw *wxhw, u32 mask)
+{
+	u32 sem = 0;
+	int ret = 0;
+
+	mutex_lock(&wx_sw_sync_lock);
+	ret = read_poll_timeout(rd32, sem, !(sem & mask),
+				5000, 2000000, false, wxhw, WX_MNG_SWFW_SYNC);
+	if (!ret) {
+		sem |= mask;
+		wr32(wxhw, WX_MNG_SWFW_SYNC, sem);
+	} else {
+		wx_err(wxhw, "SW Semaphore not granted: 0x%x.\n", sem);
+	}
+	mutex_unlock(&wx_sw_sync_lock);
+
+	return ret;
+}
+
+/**
+ *  wx_host_interface_command - Issue command to manageability block
+ *  @wxhw: pointer to the HW structure
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
+static int wx_host_interface_command(struct wx_hw *wxhw, u32 *buffer,
+				     u32 length, u32 timeout, bool return_data)
+{
+	u32 hdr_size = sizeof(struct wx_hic_hdr);
+	u32 hicr, i, bi, buf[64] = {};
+	int status = 0;
+	u32 dword_len;
+	u16 buf_len;
+
+	if (length == 0 || length > WX_HI_MAX_BLOCK_BYTE_LENGTH) {
+		wx_err(wxhw, "Buffer length failure buffersize=%d.\n", length);
+		return -EINVAL;
+	}
+
+	status = wx_acquire_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_MB);
+	if (status != 0)
+		return status;
+
+	/* Calculate length in DWORDs. We must be DWORD aligned */
+	if ((length % (sizeof(u32))) != 0) {
+		wx_err(wxhw, "Buffer length failure, not aligned to dword");
+		status = -EINVAL;
+		goto rel_out;
+	}
+
+	dword_len = length >> 2;
+
+	/* The device driver writes the relevant command block
+	 * into the ram area.
+	 */
+	for (i = 0; i < dword_len; i++) {
+		wr32a(wxhw, WX_MNG_MBOX, i, (__force u32)cpu_to_le32(buffer[i]));
+		/* write flush */
+		buf[i] = rd32a(wxhw, WX_MNG_MBOX, i);
+	}
+	/* Setting this bit tells the ARC that a new command is pending. */
+	wr32m(wxhw, WX_MNG_MBOX_CTL,
+	      WX_MNG_MBOX_CTL_SWRDY, WX_MNG_MBOX_CTL_SWRDY);
+
+	status = read_poll_timeout(rd32, hicr, hicr & WX_MNG_MBOX_CTL_FWRDY, 1000,
+				   timeout * 1000, false, wxhw, WX_MNG_MBOX_CTL);
+	if (status)
+		goto rel_out;
+
+	/* Check command completion */
+	if (status) {
+		wx_dbg(wxhw, "Command has failed with no status valid.\n");
+
+		buf[0] = rd32(wxhw, WX_MNG_MBOX);
+		if ((buffer[0] & 0xff) != (~buf[0] >> 24)) {
+			status = -EINVAL;
+			goto rel_out;
+		}
+		if ((buf[0] & 0xff0000) >> 16 == 0x80) {
+			wx_dbg(wxhw, "It's unknown cmd.\n");
+			status = -EINVAL;
+			goto rel_out;
+		}
+
+		wx_dbg(wxhw, "write value:\n");
+		for (i = 0; i < dword_len; i++)
+			wx_dbg(wxhw, "%x ", buffer[i]);
+		wx_dbg(wxhw, "read value:\n");
+		for (i = 0; i < dword_len; i++)
+			wx_dbg(wxhw, "%x ", buf[i]);
+	}
+
+	if (!return_data)
+		goto rel_out;
+
+	/* Calculate length in DWORDs */
+	dword_len = hdr_size >> 2;
+
+	/* first pull in the header so we know the buffer length */
+	for (bi = 0; bi < dword_len; bi++) {
+		buffer[bi] = rd32a(wxhw, WX_MNG_MBOX, bi);
+		le32_to_cpus(&buffer[bi]);
+	}
+
+	/* If there is any thing in data position pull it in */
+	buf_len = ((struct wx_hic_hdr *)buffer)->buf_len;
+	if (buf_len == 0)
+		goto rel_out;
+
+	if (length < buf_len + hdr_size) {
+		wx_err(wxhw, "Buffer not large enough for reply message.\n");
+		status = -EFAULT;
+		goto rel_out;
+	}
+
+	/* Calculate length in DWORDs, add 3 for odd lengths */
+	dword_len = (buf_len + 3) >> 2;
+
+	/* Pull in the rest of the buffer (bi is where we left off) */
+	for (; bi <= dword_len; bi++) {
+		buffer[bi] = rd32a(wxhw, WX_MNG_MBOX, bi);
+		le32_to_cpus(&buffer[bi]);
+	}
+
+rel_out:
+	wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_MB);
+	return status;
+}
+
+/**
+ *  wx_read_ee_hostif_data - Read EEPROM word using a host interface cmd
+ *  assuming that the semaphore is already obtained.
+ *  @wxhw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @data: word read from the EEPROM
+ *
+ *  Reads a 16 bit word from the EEPROM using the hostif.
+ **/
+static int wx_read_ee_hostif_data(struct wx_hw *wxhw, u16 offset, u16 *data)
+{
+	struct wx_hic_read_shadow_ram buffer;
+	int status;
+
+	buffer.hdr.req.cmd = FW_READ_SHADOW_RAM_CMD;
+	buffer.hdr.req.buf_lenh = 0;
+	buffer.hdr.req.buf_lenl = FW_READ_SHADOW_RAM_LEN;
+	buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+	/* convert offset from words to bytes */
+	buffer.address = (__force u32)cpu_to_be32(offset * 2);
+	/* one word */
+	buffer.length = (__force u16)cpu_to_be16(sizeof(u16));
+
+	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),
+					   WX_HI_COMMAND_TIMEOUT, false);
+
+	if (status != 0)
+		return status;
+
+	*data = (u16)rd32a(wxhw, WX_MNG_MBOX, FW_NVM_DATA_OFFSET);
+
+	return status;
+}
+
+/**
+ *  wx_read_ee_hostif - Read EEPROM word using a host interface cmd
+ *  @wxhw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @data: word read from the EEPROM
+ *
+ *  Reads a 16 bit word from the EEPROM using the hostif.
+ **/
+int wx_read_ee_hostif(struct wx_hw *wxhw, u16 offset, u16 *data)
+{
+	int status = 0;
+
+	status = wx_acquire_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	if (status == 0) {
+		status = wx_read_ee_hostif_data(wxhw, offset, data);
+		wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	}
+
+	return status;
+}
+EXPORT_SYMBOL(wx_read_ee_hostif);
+
+/**
+ *  wx_read_ee_hostif_buffer- Read EEPROM word(s) using hostif
+ *  @wxhw: pointer to hardware structure
+ *  @offset: offset of  word in the EEPROM to read
+ *  @words: number of words
+ *  @data: word(s) read from the EEPROM
+ *
+ *  Reads a 16 bit word(s) from the EEPROM using the hostif.
+ **/
+int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
+			     u16 offset, u16 words, u16 *data)
+{
+	struct wx_hic_read_shadow_ram buffer;
+	u32 current_word = 0;
+	u16 words_to_read;
+	u32 value = 0;
+	int status;
+	u32 i;
+
+	/* Take semaphore for the entire operation. */
+	status = wx_acquire_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	if (status != 0)
+		return status;
+
+	while (words) {
+		if (words > FW_MAX_READ_BUFFER_SIZE / 2)
+			words_to_read = FW_MAX_READ_BUFFER_SIZE / 2;
+		else
+			words_to_read = words;
+
+		buffer.hdr.req.cmd = FW_READ_SHADOW_RAM_CMD;
+		buffer.hdr.req.buf_lenh = 0;
+		buffer.hdr.req.buf_lenl = FW_READ_SHADOW_RAM_LEN;
+		buffer.hdr.req.checksum = FW_DEFAULT_CHECKSUM;
+
+		/* convert offset from words to bytes */
+		buffer.address = (__force u32)cpu_to_be32((offset + current_word) * 2);
+		buffer.length = (__force u16)cpu_to_be16(words_to_read * 2);
+
+		status = wx_host_interface_command(wxhw, (u32 *)&buffer,
+						   sizeof(buffer),
+						   WX_HI_COMMAND_TIMEOUT,
+						   false);
+
+		if (status != 0) {
+			wx_err(wxhw, "Host interface command failed\n");
+			goto out;
+		}
+
+		for (i = 0; i < words_to_read; i++) {
+			u32 reg = WX_MNG_MBOX + (FW_NVM_DATA_OFFSET << 2) + 2 * i;
+
+			value = rd32(wxhw, reg);
+			data[current_word] = (u16)(value & 0xffff);
+			current_word++;
+			i++;
+			if (i < words_to_read) {
+				value >>= 16;
+				data[current_word] = (u16)(value & 0xffff);
+				current_word++;
+			}
+		}
+		words -= words_to_read;
+	}
+
+out:
+	wx_release_sw_sync(wxhw, WX_MNG_SWFW_SYNC_SW_FLASH);
+	return status;
+}
+EXPORT_SYMBOL(wx_read_ee_hostif_buffer);
+
+/**
+ *  wx_calculate_checksum - Calculate checksum for buffer
+ *  @buffer: pointer to EEPROM
+ *  @length: size of EEPROM to calculate a checksum for
+ *  Calculates the checksum for some buffer on a specified length.  The
+ *  checksum calculated is returned.
+ **/
+static u8 wx_calculate_checksum(u8 *buffer, u32 length)
+{
+	u8 sum = 0;
+	u32 i;
+
+	if (!buffer)
+		return 0;
+
+	for (i = 0; i < length; i++)
+		sum += buffer[i];
+
+	return (u8)(0 - sum);
+}
+
+/**
+ *  wx_reset_hostif - send reset cmd to fw
+ *  @wxhw: pointer to hardware structure
+ *
+ *  Sends reset cmd to firmware through the manageability
+ *  block.
+ **/
+int wx_reset_hostif(struct wx_hw *wxhw)
+{
+	struct wx_hic_reset reset_cmd;
+	int ret_val = 0;
+	int i;
+
+	reset_cmd.hdr.cmd = FW_RESET_CMD;
+	reset_cmd.hdr.buf_len = FW_RESET_LEN;
+	reset_cmd.hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
+	reset_cmd.lan_id = wxhw->bus.func;
+	reset_cmd.reset_type = (u16)wxhw->reset_type;
+	reset_cmd.hdr.checksum = 0;
+	reset_cmd.hdr.checksum = wx_calculate_checksum((u8 *)&reset_cmd,
+						       (FW_CEM_HDR_LEN +
+							reset_cmd.hdr.buf_len));
+
+	for (i = 0; i <= FW_CEM_MAX_RETRIES; i++) {
+		ret_val = wx_host_interface_command(wxhw, (u32 *)&reset_cmd,
+						    sizeof(reset_cmd),
+						    WX_HI_COMMAND_TIMEOUT,
+						    true);
+		if (ret_val != 0)
+			continue;
+
+		if (reset_cmd.hdr.cmd_or_resp.ret_status ==
+		    FW_CEM_RESP_STATUS_SUCCESS)
+			ret_val = 0;
+		else
+			ret_val = -EFAULT;
+
+		break;
+	}
+
+	return ret_val;
+}
+EXPORT_SYMBOL(wx_reset_hostif);
+
+/**
+ *  wx_init_eeprom_params - Initialize EEPROM params
+ *  @wxhw: pointer to hardware structure
+ *
+ *  Initializes the EEPROM parameters wx_eeprom_info within the
+ *  wx_hw struct in order to set up EEPROM access.
+ **/
+void wx_init_eeprom_params(struct wx_hw *wxhw)
+{
+	struct wx_eeprom_info *eeprom = &wxhw->eeprom;
+	u16 eeprom_size;
+	u16 data = 0x80;
+
+	if (eeprom->type == wx_eeprom_uninitialized) {
+		eeprom->semaphore_delay = 10;
+		eeprom->type = wx_eeprom_none;
+
+		if (!(rd32(wxhw, WX_SPI_STATUS) &
+		      WX_SPI_STATUS_FLASH_BYPASS)) {
+			eeprom->type = wx_flash;
+
+			eeprom_size = 4096;
+			eeprom->word_size = eeprom_size >> 1;
+
+			wx_dbg(wxhw, "Eeprom params: type = %d, size = %d\n",
+			       eeprom->type, eeprom->word_size);
+		}
+	}
+
+	if (wxhw->mac.type == wx_mac_sp) {
+		if (wx_read_ee_hostif(wxhw, WX_SW_REGION_PTR, &data)) {
+			wx_err(wxhw, "NVM Read Error\n");
+			return;
+		}
+		data = data >> 1;
+	}
+
+	eeprom->sw_region_offset = data;
+}
+EXPORT_SYMBOL(wx_init_eeprom_params);
+
 /**
  *  wx_get_mac_addr - Generic get MAC address
  *  @wxhw: pointer to hardware structure
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 58a943dc76c1..163777d5ed96 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -5,6 +5,13 @@
 #define _WX_HW_H_
 
 int wx_check_flash_load(struct wx_hw *hw, u32 check_bit);
+void wx_control_hw(struct wx_hw *wxhw, bool drv);
+int wx_mng_present(struct wx_hw *wxhw);
+int wx_read_ee_hostif(struct wx_hw *wxhw, u16 offset, u16 *data);
+int wx_read_ee_hostif_buffer(struct wx_hw *wxhw,
+			     u16 offset, u16 words, u16 *data);
+int wx_reset_hostif(struct wx_hw *wxhw);
+void wx_init_eeprom_params(struct wx_hw *wxhw);
 void wx_get_mac_addr(struct wx_hw *wxhw, u8 *mac_addr);
 int wx_set_rar(struct wx_hw *wxhw, u32 index, u8 *addr, u64 pools, u32 enable_addr);
 int wx_clear_rar(struct wx_hw *wxhw, u32 index);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 790497cec603..3b2c4586e0c3 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -19,6 +19,11 @@
 #define WX_MIS_PWR                   0x10000
 #define WX_MIS_RST                   0x1000C
 #define WX_MIS_RST_LAN_RST(_i)       BIT((_i) + 1)
+#define WX_MIS_RST_SW_RST            BIT(0)
+#define WX_MIS_ST                    0x10028
+#define WX_MIS_ST_MNG_INIT_DN        BIT(0)
+#define WX_MIS_SWSM                  0x1002C
+#define WX_MIS_SWSM_SMBI             BIT(0)
 #define WX_MIS_RST_ST                0x10030
 #define WX_MIS_RST_ST_RST_INI_SHIFT  8
 #define WX_MIS_RST_ST_RST_INIT       (0xFF << WX_MIS_RST_ST_RST_INI_SHIFT)
@@ -51,6 +56,11 @@
 #define WX_TS_ALARM_ST_DALARM        BIT(1)
 #define WX_TS_ALARM_ST_ALARM         BIT(0)
 
+/************************* Port Registers ************************************/
+/* port cfg Registers */
+#define WX_CFG_PORT_CTL              0x14400
+#define WX_CFG_PORT_CTL_DRV_LOAD     BIT(3)
+
 /*********************** Transmit DMA registers **************************/
 /* transmit global control */
 #define WX_TDM_CTL                   0x18000
@@ -107,6 +117,15 @@
 #define WX_PSR_MAC_SWC_IDX           0x16210
 #define WX_CLEAR_VMDQ_ALL            0xFFFFFFFFU
 
+/************************************** MNG ********************************/
+#define WX_MNG_SWFW_SYNC             0x1E008
+#define WX_MNG_SWFW_SYNC_SW_MB       BIT(2)
+#define WX_MNG_SWFW_SYNC_SW_FLASH    BIT(3)
+#define WX_MNG_MBOX                  0x1E100
+#define WX_MNG_MBOX_CTL              0x1E044
+#define WX_MNG_MBOX_CTL_SWRDY        BIT(0)
+#define WX_MNG_MBOX_CTL_FWRDY        BIT(2)
+
 /************************************* ETH MAC *****************************/
 #define WX_MAC_TX_CFG                0x11000
 #define WX_MAC_TX_CFG_TE             BIT(0)
@@ -144,6 +163,70 @@
 /* Number of 80 microseconds we wait for PCI Express master disable */
 #define WX_PCI_MASTER_DISABLE_TIMEOUT        80000
 
+/****************** Manageablility Host Interface defines ********************/
+#define WX_HI_MAX_BLOCK_BYTE_LENGTH  256 /* Num of bytes in range */
+#define WX_HI_COMMAND_TIMEOUT        1000 /* Process HI command limit */
+
+#define FW_READ_SHADOW_RAM_CMD       0x31
+#define FW_READ_SHADOW_RAM_LEN       0x6
+#define FW_DEFAULT_CHECKSUM          0xFF /* checksum always 0xFF */
+#define FW_NVM_DATA_OFFSET           3
+#define FW_MAX_READ_BUFFER_SIZE      244
+#define FW_RESET_CMD                 0xDF
+#define FW_RESET_LEN                 0x2
+#define FW_CEM_HDR_LEN               0x4
+#define FW_CEM_CMD_RESERVED          0X0
+#define FW_CEM_MAX_RETRIES           3
+#define FW_CEM_RESP_STATUS_SUCCESS   0x1
+
+#define WX_SW_REGION_PTR             0x1C
+
+/* Host Interface Command Structures */
+struct wx_hic_hdr {
+	u8 cmd;
+	u8 buf_len;
+	union {
+		u8 cmd_resv;
+		u8 ret_status;
+	} cmd_or_resp;
+	u8 checksum;
+};
+
+struct wx_hic_hdr2_req {
+	u8 cmd;
+	u8 buf_lenh;
+	u8 buf_lenl;
+	u8 checksum;
+};
+
+struct wx_hic_hdr2_rsp {
+	u8 cmd;
+	u8 buf_lenl;
+	u8 buf_lenh_status;     /* 7-5: high bits of buf_len, 4-0: status */
+	u8 checksum;
+};
+
+union wx_hic_hdr2 {
+	struct wx_hic_hdr2_req req;
+	struct wx_hic_hdr2_rsp rsp;
+};
+
+/* These need to be dword aligned */
+struct wx_hic_read_shadow_ram {
+	union wx_hic_hdr2 hdr;
+	u32 address;
+	u16 length;
+	u16 pad2;
+	u16 data;
+	u16 pad3;
+};
+
+struct wx_hic_reset {
+	struct wx_hic_hdr hdr;
+	u16 lan_id;
+	u16 reset_type;
+};
+
 /* Bus parameters */
 struct wx_bus_info {
 	u8 func;
@@ -175,17 +258,38 @@ struct wx_mac_info {
 	struct wx_thermal_sensor_data sensor;
 };
 
+enum wx_eeprom_type {
+	wx_eeprom_uninitialized = 0,
+	wx_eeprom_spi,
+	wx_flash,
+	wx_eeprom_none /* No NVM support */
+};
+
+struct wx_eeprom_info {
+	enum wx_eeprom_type type;
+	u32 semaphore_delay;
+	u16 word_size;
+	u16 sw_region_offset;
+};
+
 struct wx_addr_filter_info {
 	u32 num_mc_addrs;
 	u32 mta_in_use;
 	bool user_set_promisc;
 };
 
+enum wx_reset_type {
+	WX_LAN_RESET = 0,
+	WX_SW_RESET,
+	WX_GLOBAL_RESET
+};
+
 struct wx_hw {
 	u8 __iomem *hw_addr;
 	struct pci_dev *pdev;
 	struct wx_bus_info bus;
 	struct wx_mac_info mac;
+	struct wx_eeprom_info eeprom;
 	struct wx_addr_filter_info addr_ctrl;
 	u16 device_id;
 	u16 vendor_id;
@@ -195,6 +299,7 @@ struct wx_hw {
 	u16 oem_ssid;
 	u16 oem_svid;
 	bool adapter_stopped;
+	enum wx_reset_type reset_type;
 };
 
 #define WX_INTR_ALL (~0ULL)
@@ -202,6 +307,10 @@ struct wx_hw {
 /* register operations */
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
+#define rd32a(a, reg, offset) ( \
+	rd32((a), (reg) + ((offset) << 2)))
+#define wr32a(a, reg, off, val) \
+	wr32((a), (reg) + ((off) << 2), (val))
 
 static inline u32
 rd32m(struct wx_hw *wxhw, u32 reg, u32 mask)
-- 
2.38.1

