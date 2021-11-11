Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963D144CF56
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhKKB7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:59:07 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:48538 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbhKKB7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:59:07 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 468B320271; Thu, 11 Nov 2021 09:56:17 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     Zev Weiss <zev@bewilderbeest.net>, Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/6] i2c: core: Allow 255 byte transfers for SMBus 3.x
Date:   Thu, 11 Nov 2021 09:55:43 +0800
Message-Id: <20211111015548.2892849-2-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211111015548.2892849-1-matt@codeconstruct.com.au>
References: <20211111015548.2892849-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMBus 3.0 increased the maximum block transfer size from 32 bytes to
255 bytes. We increase the size of struct i2c_smbus_data's block[]
member.

i2c_smbus_xfer() and i2c_smbus_xfer_emulated() now support 255 byte
block operations, other block functions remain limited to 32 bytes for
compatibility with existing callers.

We allow adapters to indicate support for the larger size with
I2C_FUNC_SMBUS_V3_BLOCK. Most emulated drivers should be able to use 255
byte blocks by replacing I2C_SMBUS_BLOCK_MAX with I2C_SMBUS_V3_BLOCK_MAX
though some will have hardware limitations that need testing.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 drivers/i2c/i2c-core-smbus.c | 20 +++++++++++++-------
 include/linux/i2c.h          | 13 +++++++++++++
 include/uapi/linux/i2c.h     |  5 ++++-
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/i2c-core-smbus.c b/drivers/i2c/i2c-core-smbus.c
index e5b2d1465e7e..743415584aba 100644
--- a/drivers/i2c/i2c-core-smbus.c
+++ b/drivers/i2c/i2c-core-smbus.c
@@ -303,7 +303,8 @@ static void i2c_smbus_try_get_dmabuf(struct i2c_msg *msg, u8 init_val)
 	bool is_read = msg->flags & I2C_M_RD;
 	unsigned char *dma_buf;
 
-	dma_buf = kzalloc(I2C_SMBUS_BLOCK_MAX + (is_read ? 2 : 3), GFP_KERNEL);
+	dma_buf = kzalloc(I2C_SMBUS_V3_BLOCK_MAX + (is_read ? 2 : 3),
+		GFP_KERNEL);
 	if (!dma_buf)
 		return;
 
@@ -329,9 +330,10 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 	 * initialize most things with sane defaults, to keep the code below
 	 * somewhat simpler.
 	 */
-	unsigned char msgbuf0[I2C_SMBUS_BLOCK_MAX+3];
-	unsigned char msgbuf1[I2C_SMBUS_BLOCK_MAX+2];
+	unsigned char msgbuf0[I2C_SMBUS_V3_BLOCK_MAX+3];
+	unsigned char msgbuf1[I2C_SMBUS_V3_BLOCK_MAX+2];
 	int nmsgs = read_write == I2C_SMBUS_READ ? 2 : 1;
+	u16 block_max;
 	u8 partial_pec = 0;
 	int status;
 	struct i2c_msg msg[2] = {
@@ -350,6 +352,10 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 	bool wants_pec = ((flags & I2C_CLIENT_PEC) && size != I2C_SMBUS_QUICK
 			  && size != I2C_SMBUS_I2C_BLOCK_DATA);
 
+	/* Drivers must opt in to 255 byte max block size */
+	block_max = i2c_check_functionality(adapter, I2C_FUNC_SMBUS_V3_BLOCK)
+			? I2C_SMBUS_V3_BLOCK_MAX : I2C_SMBUS_BLOCK_MAX;
+
 	msgbuf0[0] = command;
 	switch (size) {
 	case I2C_SMBUS_QUICK:
@@ -399,7 +405,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 			i2c_smbus_try_get_dmabuf(&msg[1], 0);
 		} else {
 			msg[0].len = data->block[0] + 2;
-			if (msg[0].len > I2C_SMBUS_BLOCK_MAX + 2) {
+			if (msg[0].len > block_max + 2) {
 				dev_err(&adapter->dev,
 					"Invalid block write size %d\n",
 					data->block[0]);
@@ -413,7 +419,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 	case I2C_SMBUS_BLOCK_PROC_CALL:
 		nmsgs = 2; /* Another special case */
 		read_write = I2C_SMBUS_READ;
-		if (data->block[0] > I2C_SMBUS_BLOCK_MAX) {
+		if (data->block[0] > block_max) {
 			dev_err(&adapter->dev,
 				"Invalid block write size %d\n",
 				data->block[0]);
@@ -430,7 +436,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 		i2c_smbus_try_get_dmabuf(&msg[1], 0);
 		break;
 	case I2C_SMBUS_I2C_BLOCK_DATA:
-		if (data->block[0] > I2C_SMBUS_BLOCK_MAX) {
+		if (data->block[0] > block_max) {
 			dev_err(&adapter->dev, "Invalid block %s size %d\n",
 				read_write == I2C_SMBUS_READ ? "read" : "write",
 				data->block[0]);
@@ -498,7 +504,7 @@ static s32 i2c_smbus_xfer_emulated(struct i2c_adapter *adapter, u16 addr,
 			break;
 		case I2C_SMBUS_BLOCK_DATA:
 		case I2C_SMBUS_BLOCK_PROC_CALL:
-			if (msg[1].buf[0] > I2C_SMBUS_BLOCK_MAX) {
+			if (msg[1].buf[0] > block_max) {
 				dev_err(&adapter->dev,
 					"Invalid block size returned: %d\n",
 					msg[1].buf[0]);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 2ce3efbe9198..086a09895243 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -51,6 +51,19 @@ typedef int (*i2c_slave_cb_t)(struct i2c_client *client,
 struct module;
 struct property_entry;
 
+/* SMBus 3.0 extends the maximum block read/write size to 255 (from 32).
+ * The larger size is only supported by some drivers, indicated by
+ * the I2C_FUNC_SMBUS_V3_BLOCK functionality bit.
+ */
+#define I2C_SMBUS_V3_BLOCK_MAX	255	/* As specified in SMBus 3.0 standard */
+
+/* Note compatibility definition in uapi header with 32 byte block */
+union i2c_smbus_data {
+	__u8 byte;
+	__u16 word;
+	__u8 block[I2C_SMBUS_V3_BLOCK_MAX + 1]; /* block[0] is used for length */
+};
+
 #if IS_ENABLED(CONFIG_I2C)
 /* Return the Frequency mode string based on the bus frequency */
 const char *i2c_freq_mode_string(u32 bus_freq_hz);
diff --git a/include/uapi/linux/i2c.h b/include/uapi/linux/i2c.h
index 92326ebde350..7b7d90b50cf0 100644
--- a/include/uapi/linux/i2c.h
+++ b/include/uapi/linux/i2c.h
@@ -108,6 +108,7 @@ struct i2c_msg {
 #define I2C_FUNC_SMBUS_READ_I2C_BLOCK	0x04000000 /* I2C-like block xfer  */
 #define I2C_FUNC_SMBUS_WRITE_I2C_BLOCK	0x08000000 /* w/ 1-byte reg. addr. */
 #define I2C_FUNC_SMBUS_HOST_NOTIFY	0x10000000 /* SMBus 2.0 or later */
+#define I2C_FUNC_SMBUS_V3_BLOCK		0x20000000 /* Device supports 255 byte block */
 
 #define I2C_FUNC_SMBUS_BYTE		(I2C_FUNC_SMBUS_READ_BYTE | \
 					 I2C_FUNC_SMBUS_WRITE_BYTE)
@@ -137,13 +138,15 @@ struct i2c_msg {
 /*
  * Data for SMBus Messages
  */
-#define I2C_SMBUS_BLOCK_MAX	32	/* As specified in SMBus standard */
+#define I2C_SMBUS_BLOCK_MAX	32	/* As specified in SMBus 2.0 standard */
+#ifndef __KERNEL__
 union i2c_smbus_data {
 	__u8 byte;
 	__u16 word;
 	__u8 block[I2C_SMBUS_BLOCK_MAX + 2]; /* block[0] is used for length */
 			       /* and one more for user-space compatibility */
 };
+#endif
 
 /* i2c_smbus_xfer read or write markers */
 #define I2C_SMBUS_READ	1
-- 
2.32.0

