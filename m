Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6872C2D833
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfE2Irn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:47:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33785 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725914AbfE2Irm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:47:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3928921CFD;
        Wed, 29 May 2019 04:47:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 29 May 2019 04:47:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=YnOVfRaaLAwMCi1mAmBRDLj2FhYFV1o4bwVL+x0WR3s=; b=bjOt1JwC
        Ogy+MvxgXBT2e6GlxJqsn85/UbAx68DqPuV2DOuSJezOhOz4gLCEvrh7AviyVavC
        B9+0REiR4472AvD5Dw6u/X5uolxWN98ShXkqypiR0GwSKVVsmVllIwbHRANz/OB/
        CfKN2pU2Qc484hB+zp3a0Nz+3nvi532+RbYiZ3K/nJ9kcYiubcyzIW2J6A74zxLU
        CxhbRg2S7W5eQ4qXnkCboFE+/689OkFPh1vp7eWaJtr48ODWx2f6KVfLJ+Phm/W3
        lTQVx+b+kw1nqmLL9HQImYLjVP9GqEHfTR7CbdfZ7nviT1Pmmdig4IyB7W0EcJMr
        VVtDVrTdeGlOwA==
X-ME-Sender: <xms:LkfuXIlHgQh6abtRHRHA08d3QREO7AlVv09-8yBTQnPDPSLI1O6CYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:LkfuXAyATmvHqU9oJpUr2XAvSSQfBTp6Q69JxK51CALYDgT47I-OUA>
    <xmx:LkfuXPZyAxGUTJAxFWsmAIXT-GktZUsA7iresUHOW9BCUaUiZf-OuA>
    <xmx:LkfuXHsRE9HffqZERhfxnE6psfjmGJpIDe_243oUWw0vIvQ4Gzrk5A>
    <xmx:LkfuXL9oVFT8MPCnvG9_IELRLBsU0dqqP5k7315Osu9rbnY8-5Qnyg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id C88BD80065;
        Wed, 29 May 2019 04:47:40 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, vadimp@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/8] mlxsw: i2c: Allow flexible setting of I2C transactions size
Date:   Wed, 29 May 2019 11:47:16 +0300
Message-Id: <20190529084722.22719-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529084722.22719-1-idosch@idosch.org>
References: <20190529084722.22719-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Current implementation uses fixed size of I2C data transaction buffer.
Allow to set size of I2C transactions according to I2C physical adapter
capability. For that purpose adapter read and write size is obtained
from the I2C physical adapter and buffer size is set according to the
minimum of these two values. If adapter does not provide such info,
default buffer size is to be used.
It allows to improve performance of I2C access to silicon when long
size transactions are used.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 64 ++++++++++++++++-------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 803ce9623205..95f408d0e103 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -43,11 +43,10 @@
 #define MLXSW_I2C_PREP_SIZE		(MLXSW_I2C_ADDR_WIDTH + 28)
 #define MLXSW_I2C_MBOX_SIZE		20
 #define MLXSW_I2C_MBOX_OUT_PARAM_OFF	12
-#define MLXSW_I2C_MAX_BUFF_SIZE		32
 #define MLXSW_I2C_MBOX_OFFSET_BITS	20
 #define MLXSW_I2C_MBOX_SIZE_BITS	12
 #define MLXSW_I2C_ADDR_BUF_SIZE		4
-#define MLXSW_I2C_BLK_MAX		32
+#define MLXSW_I2C_BLK_DEF		32
 #define MLXSW_I2C_RETRY			5
 #define MLXSW_I2C_TIMEOUT_MSECS		5000
 #define MLXSW_I2C_MAX_DATA_SIZE		256
@@ -62,6 +61,7 @@
  * @dev: I2C device;
  * @core: switch core pointer;
  * @bus_info: bus info block;
+ * @block_size: maximum block size allowed to pass to under layer;
  */
 struct mlxsw_i2c {
 	struct {
@@ -74,6 +74,7 @@ struct mlxsw_i2c {
 	struct device *dev;
 	struct mlxsw_core *core;
 	struct mlxsw_bus_info bus_info;
+	u16 block_size;
 };
 
 #define MLXSW_I2C_READ_MSG(_client, _addr_buf, _buf, _len) {	\
@@ -315,20 +316,26 @@ mlxsw_i2c_write(struct device *dev, size_t in_mbox_size, u8 *in_mbox, int num,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct mlxsw_i2c *mlxsw_i2c = i2c_get_clientdata(client);
 	unsigned long timeout = msecs_to_jiffies(MLXSW_I2C_TIMEOUT_MSECS);
-	u8 tran_buf[MLXSW_I2C_MAX_BUFF_SIZE + MLXSW_I2C_ADDR_BUF_SIZE];
 	int off = mlxsw_i2c->cmd.mb_off_in, chunk_size, i, j;
 	unsigned long end;
+	u8 *tran_buf;
 	struct i2c_msg write_tran =
-		MLXSW_I2C_WRITE_MSG(client, tran_buf, MLXSW_I2C_PUSH_CMD_SIZE);
+		MLXSW_I2C_WRITE_MSG(client, NULL, MLXSW_I2C_PUSH_CMD_SIZE);
 	int err;
 
+	tran_buf = kmalloc(mlxsw_i2c->block_size + MLXSW_I2C_ADDR_BUF_SIZE,
+			   GFP_KERNEL);
+	if (!tran_buf)
+		return -ENOMEM;
+
+	write_tran.buf = tran_buf;
 	for (i = 0; i < num; i++) {
-		chunk_size = (in_mbox_size > MLXSW_I2C_BLK_MAX) ?
-			     MLXSW_I2C_BLK_MAX : in_mbox_size;
+		chunk_size = (in_mbox_size > mlxsw_i2c->block_size) ?
+			     mlxsw_i2c->block_size : in_mbox_size;
 		write_tran.len = MLXSW_I2C_ADDR_WIDTH + chunk_size;
 		mlxsw_i2c_set_slave_addr(tran_buf, off);
 		memcpy(&tran_buf[MLXSW_I2C_ADDR_BUF_SIZE], in_mbox +
-		       MLXSW_I2C_BLK_MAX * i, chunk_size);
+		       mlxsw_i2c->block_size * i, chunk_size);
 
 		j = 0;
 		end = jiffies + timeout;
@@ -342,9 +349,10 @@ mlxsw_i2c_write(struct device *dev, size_t in_mbox_size, u8 *in_mbox, int num,
 			 (j++ < MLXSW_I2C_RETRY));
 
 		if (err != 1) {
-			if (!err)
+			if (!err) {
 				err = -EIO;
-			return err;
+				goto mlxsw_i2c_write_exit;
+			}
 		}
 
 		off += chunk_size;
@@ -355,24 +363,27 @@ mlxsw_i2c_write(struct device *dev, size_t in_mbox_size, u8 *in_mbox, int num,
 	err = mlxsw_i2c_write_cmd(client, mlxsw_i2c, 0);
 	if (err) {
 		dev_err(&client->dev, "Could not start transaction");
-		return -EIO;
+		err = -EIO;
+		goto mlxsw_i2c_write_exit;
 	}
 
 	/* Wait until go bit is cleared. */
 	err = mlxsw_i2c_wait_go_bit(client, mlxsw_i2c, p_status);
 	if (err) {
 		dev_err(&client->dev, "HW semaphore is not released");
-		return err;
+		goto mlxsw_i2c_write_exit;
 	}
 
 	/* Validate transaction completion status. */
 	if (*p_status) {
 		dev_err(&client->dev, "Bad transaction completion status %x\n",
 			*p_status);
-		return -EIO;
+		err = -EIO;
 	}
 
-	return 0;
+mlxsw_i2c_write_exit:
+	kfree(tran_buf);
+	return err;
 }
 
 /* Routine executes I2C command. */
@@ -395,8 +406,8 @@ mlxsw_i2c_cmd(struct device *dev, u16 opcode, u32 in_mod, size_t in_mbox_size,
 
 	if (in_mbox) {
 		reg_size = mlxsw_i2c_get_reg_size(in_mbox);
-		num = reg_size / MLXSW_I2C_BLK_MAX;
-		if (reg_size % MLXSW_I2C_BLK_MAX)
+		num = reg_size / mlxsw_i2c->block_size;
+		if (reg_size % mlxsw_i2c->block_size)
 			num++;
 
 		if (mutex_lock_interruptible(&mlxsw_i2c->cmd.lock) < 0) {
@@ -416,7 +427,7 @@ mlxsw_i2c_cmd(struct device *dev, u16 opcode, u32 in_mod, size_t in_mbox_size,
 	} else {
 		/* No input mailbox is case of initialization query command. */
 		reg_size = MLXSW_I2C_MAX_DATA_SIZE;
-		num = reg_size / MLXSW_I2C_BLK_MAX;
+		num = reg_size / mlxsw_i2c->block_size;
 
 		if (mutex_lock_interruptible(&mlxsw_i2c->cmd.lock) < 0) {
 			dev_err(&client->dev, "Could not acquire lock");
@@ -432,8 +443,8 @@ mlxsw_i2c_cmd(struct device *dev, u16 opcode, u32 in_mod, size_t in_mbox_size,
 	/* Send read transaction to get output mailbox content. */
 	read_tran[1].buf = out_mbox;
 	for (i = 0; i < num; i++) {
-		chunk_size = (reg_size > MLXSW_I2C_BLK_MAX) ?
-			     MLXSW_I2C_BLK_MAX : reg_size;
+		chunk_size = (reg_size > mlxsw_i2c->block_size) ?
+			     mlxsw_i2c->block_size : reg_size;
 		read_tran[1].len = chunk_size;
 		mlxsw_i2c_set_slave_addr(tran_buf, off);
 
@@ -546,6 +557,7 @@ static const struct mlxsw_bus mlxsw_i2c_bus = {
 static int mlxsw_i2c_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
 {
+	const struct i2c_adapter_quirks *quirks = client->adapter->quirks;
 	struct mlxsw_i2c *mlxsw_i2c;
 	u8 status;
 	int err;
@@ -554,6 +566,22 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	if (!mlxsw_i2c)
 		return -ENOMEM;
 
+	if (quirks) {
+		if ((quirks->max_read_len &&
+		     quirks->max_read_len < MLXSW_I2C_BLK_DEF) ||
+		    (quirks->max_write_len &&
+		     quirks->max_write_len < MLXSW_I2C_BLK_DEF)) {
+			dev_err(&client->dev, "Insufficient transaction buffer length\n");
+			return -EOPNOTSUPP;
+		}
+
+		mlxsw_i2c->block_size = max_t(u16, MLXSW_I2C_BLK_DEF,
+					      min_t(u16, quirks->max_read_len,
+						    quirks->max_write_len));
+	} else {
+		mlxsw_i2c->block_size = MLXSW_I2C_BLK_DEF;
+	}
+
 	i2c_set_clientdata(client, mlxsw_i2c);
 	mutex_init(&mlxsw_i2c->cmd.lock);
 
-- 
2.20.1

