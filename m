Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864684415C7
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 10:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhKAJHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 05:07:08 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:44088 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhKAJHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 05:07:07 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 495A12029C; Mon,  1 Nov 2021 17:04:33 +0800 (AWST)
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
Subject: [PATCH net-next 2/6] i2c: dev: Handle 255 byte blocks for i2c ioctl
Date:   Mon,  1 Nov 2021 17:04:01 +0800
Message-Id: <20211101090405.1405987-3-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211101090405.1405987-1-matt@codeconstruct.com.au>
References: <20211101090405.1405987-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I2C_SMBUS is limited to 32 bytes due to compatibility with the
32 byte i2c_smbus_data.block

I2C_RDWR allows larger transfers if sufficient sized buffers are passed.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 drivers/i2c/i2c-dev.c        | 93 ++++++++++++++++++++++++++++++------
 include/uapi/linux/i2c-dev.h |  2 +
 include/uapi/linux/i2c.h     |  2 +
 3 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index bce0e8bb7852..5ee9118c0407 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -46,6 +46,24 @@ struct i2c_dev {
 	struct cdev cdev;
 };
 
+/* The userspace union i2c_smbus_data for I2C_SMBUS ioctl is limited
+ * to 32 bytes (I2C_SMBUS_BLOCK_MAX) for compatibility.
+ */
+union compat_i2c_smbus_data {
+	__u8 byte;
+	__u16 word;
+	__u8 block[I2C_SMBUS_BLOCK_MAX + 2]; /* block[0] is used for length */
+			       /* and one more for user-space compatibility */
+};
+
+/* Must match i2c-dev.h definition with compat .data member */
+struct i2c_smbus_ioctl_data {
+	__u8 read_write;
+	__u8 command;
+	__u32 size;
+	union compat_i2c_smbus_data __user *data;
+};
+
 #define I2C_MINORS	(MINORMASK + 1)
 static LIST_HEAD(i2c_dev_list);
 static DEFINE_SPINLOCK(i2c_dev_list_lock);
@@ -235,14 +253,17 @@ static int i2cdev_check_addr(struct i2c_adapter *adapter, unsigned int addr)
 static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		unsigned nmsgs, struct i2c_msg *msgs)
 {
-	u8 __user **data_ptrs;
+	u8 __user **data_ptrs = NULL;
+	u16 *orig_lens = NULL;
 	int i, res;
 
+	res = -ENOMEM;
 	data_ptrs = kmalloc_array(nmsgs, sizeof(u8 __user *), GFP_KERNEL);
-	if (data_ptrs == NULL) {
-		kfree(msgs);
-		return -ENOMEM;
-	}
+	if (data_ptrs == NULL)
+		goto out;
+	orig_lens = kmalloc_array(nmsgs, sizeof(u16), GFP_KERNEL);
+	if (orig_lens == NULL)
+		goto out;
 
 	res = 0;
 	for (i = 0; i < nmsgs; i++) {
@@ -253,12 +274,30 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		}
 
 		data_ptrs[i] = (u8 __user *)msgs[i].buf;
-		msgs[i].buf = memdup_user(data_ptrs[i], msgs[i].len);
+		msgs[i].buf = NULL;
+		if (msgs[i].len < 1) {
+			/* Sanity check */
+			res = -EINVAL;
+			break;
+
+		}
+		/* Allocate a larger buffer to accommodate possible 255 byte
+		 * blocks. Read results will be dropped later
+		 * if they are too large for the original length.
+		 */
+		orig_lens[i] = msgs[i].len;
+		msgs[i].buf = kmalloc(msgs[i].len + I2C_SMBUS_V3_BLOCK_MAX,
+			GFP_USER | __GFP_NOWARN);
 		if (IS_ERR(msgs[i].buf)) {
 			res = PTR_ERR(msgs[i].buf);
 			break;
 		}
-		/* memdup_user allocates with GFP_KERNEL, so DMA is ok */
+		if (copy_from_user(msgs[i].buf, data_ptrs[i], msgs[i].len)) {
+			kfree(msgs[i].buf);
+			res = -EFAULT;
+			break;
+		}
+		/* Buffer from kmalloc, so DMA is ok */
 		msgs[i].flags |= I2C_M_DMA_SAFE;
 
 		/*
@@ -274,7 +313,7 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 		 */
 		if (msgs[i].flags & I2C_M_RECV_LEN) {
 			if (!(msgs[i].flags & I2C_M_RD) ||
-			    msgs[i].len < 1 || msgs[i].buf[0] < 1 ||
+			    msgs[i].buf[0] < 1 ||
 			    msgs[i].len < msgs[i].buf[0] +
 					     I2C_SMBUS_BLOCK_MAX) {
 				i++;
@@ -297,12 +336,16 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 	res = i2c_transfer(client->adapter, msgs, nmsgs);
 	while (i-- > 0) {
 		if (res >= 0 && (msgs[i].flags & I2C_M_RD)) {
-			if (copy_to_user(data_ptrs[i], msgs[i].buf,
-					 msgs[i].len))
+			if (orig_lens[i] < msgs[i].len)
+				res = -EINVAL;
+			else if (copy_to_user(data_ptrs[i], msgs[i].buf,
+						 msgs[i].len))
 				res = -EFAULT;
 		}
 		kfree(msgs[i].buf);
 	}
+out:
+	kfree(orig_lens);
 	kfree(data_ptrs);
 	kfree(msgs);
 	return res;
@@ -310,7 +353,7 @@ static noinline int i2cdev_ioctl_rdwr(struct i2c_client *client,
 
 static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
 		u8 read_write, u8 command, u32 size,
-		union i2c_smbus_data __user *data)
+		union compat_i2c_smbus_data __user *data)
 {
 	union i2c_smbus_data temp = {};
 	int datasize, res;
@@ -371,6 +414,16 @@ static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
 		if (copy_from_user(&temp, data, datasize))
 			return -EFAULT;
 	}
+	if ((size == I2C_SMBUS_BLOCK_PROC_CALL ||
+	    size == I2C_SMBUS_I2C_BLOCK_DATA ||
+	    size == I2C_SMBUS_BLOCK_DATA) &&
+	    read_write == I2C_SMBUS_WRITE &&
+	    temp.block[0] > I2C_SMBUS_BLOCK_MAX) {
+		/* Don't accept writes larger than the buffer size */
+		dev_dbg(&client->adapter->dev, "block write is too large");
+		return -EINVAL;
+
+	}
 	if (size == I2C_SMBUS_I2C_BLOCK_BROKEN) {
 		/* Convert old I2C block commands to the new
 		   convention. This preserves binary compatibility. */
@@ -380,9 +433,21 @@ static noinline int i2cdev_ioctl_smbus(struct i2c_client *client,
 	}
 	res = i2c_smbus_xfer(client->adapter, client->addr, client->flags,
 	      read_write, command, size, &temp);
-	if (!res && ((size == I2C_SMBUS_PROC_CALL) ||
-		     (size == I2C_SMBUS_BLOCK_PROC_CALL) ||
-		     (read_write == I2C_SMBUS_READ))) {
+	if (res)
+		return res;
+	if ((size == I2C_SMBUS_BLOCK_PROC_CALL ||
+	    size == I2C_SMBUS_I2C_BLOCK_DATA ||
+	    size == I2C_SMBUS_BLOCK_DATA) &&
+	    read_write == I2C_SMBUS_READ &&
+	    temp.block[0] > I2C_SMBUS_BLOCK_MAX) {
+		/* Don't accept reads larger than the buffer size */
+		dev_dbg(&client->adapter->dev, "block read is too large");
+		return -EINVAL;
+
+	}
+	if ((size == I2C_SMBUS_PROC_CALL) ||
+	    (size == I2C_SMBUS_BLOCK_PROC_CALL) ||
+	    (read_write == I2C_SMBUS_READ)) {
 		if (copy_to_user(data, &temp, datasize))
 			return -EFAULT;
 	}
diff --git a/include/uapi/linux/i2c-dev.h b/include/uapi/linux/i2c-dev.h
index 1c4cec4ddd84..46ce31d42f7d 100644
--- a/include/uapi/linux/i2c-dev.h
+++ b/include/uapi/linux/i2c-dev.h
@@ -39,12 +39,14 @@
 
 
 /* This is the structure as used in the I2C_SMBUS ioctl call */
+#ifndef __KERNEL__
 struct i2c_smbus_ioctl_data {
 	__u8 read_write;
 	__u8 command;
 	__u32 size;
 	union i2c_smbus_data __user *data;
 };
+#endif
 
 /* This is the structure as used in the I2C_RDWR ioctl call */
 struct i2c_rdwr_ioctl_data {
diff --git a/include/uapi/linux/i2c.h b/include/uapi/linux/i2c.h
index 7b7d90b50cf0..c3534ab1ae53 100644
--- a/include/uapi/linux/i2c.h
+++ b/include/uapi/linux/i2c.h
@@ -109,6 +109,8 @@ struct i2c_msg {
 #define I2C_FUNC_SMBUS_WRITE_I2C_BLOCK	0x08000000 /* w/ 1-byte reg. addr. */
 #define I2C_FUNC_SMBUS_HOST_NOTIFY	0x10000000 /* SMBus 2.0 or later */
 #define I2C_FUNC_SMBUS_V3_BLOCK		0x20000000 /* Device supports 255 byte block */
+						   /* Note that I2C_SMBUS ioctl only */
+						   /* supports a 32 byte block */
 
 #define I2C_FUNC_SMBUS_BYTE		(I2C_FUNC_SMBUS_READ_BYTE | \
 					 I2C_FUNC_SMBUS_WRITE_BYTE)
-- 
2.32.0

