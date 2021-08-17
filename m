Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329C33EF047
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhHQQiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhHQQiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 12:38:02 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F47AC061764;
        Tue, 17 Aug 2021 09:37:29 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id t9so42540325lfc.6;
        Tue, 17 Aug 2021 09:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YXS2wDrNmRySEhsIbVUMKvb+Ici86y1kGrWc6irGTdI=;
        b=Y5hr7uJGS6odntPRfVaTWLcpzoeH263nrltEvmqFinf6ceo9aZlDCiHDsAr9GmrupU
         IRNg6FoDEviyUm7NpnYSEV25dvz4apQiNUL7cwUeGZypnGtOAmo4cCb9OTV2d8dISB9B
         KoDLzDWnsTuygAvGuViTxIx+gaP0sxUY8WBU2GJzb83RLT0jNdEwmZ6Sc074HPfdh3Qa
         P5FLMkj130JSNqgYvgAMB1sJxe5c42BzcDLNCAztau3LgUblSgqPBTx7Tfpzyccg+n+8
         lgevVSZ0ixMIVmeiLQ8Q1Pne1j8WM2LmBkbfx9QprZmHXptXfg737vYNKQHSkzE0B4Ex
         BVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YXS2wDrNmRySEhsIbVUMKvb+Ici86y1kGrWc6irGTdI=;
        b=arCKEKrjwmAmWMoyiu8y/nej5sQBI+dYZHK29hwu8kH/pm4qt2wa/cJIecMKC46FM0
         +BRgt4REncLZrIo1GAHtcjC6m9vzhTtfn/WQxAirKeeYPUTEwf+Qsw9PvSD9A2WHmtnm
         Mu6K7svpr8cpa9QIeNg2GpmuVNnlKARM1/gAVWZg6GBS0hlw+2GlKJ50ycTwgD0gfjqK
         jxIWVY4aJYOI4AC0QFbT1Tm3z6Ogx/iTX2EdC+M/GzPGb+3qzld0Ov3qZ/SMtONBE7Gu
         C2n6yIRjT/TsEYVaMd0JjI4cH+NcIvSOffvJhbIIY3pkIMNVwh/bHjwqY/g41SgQyVh+
         4plw==
X-Gm-Message-State: AOAM532tsBJY1Ia9atkrcCQbetp7tHGpkDCiU9fHqtGuReV2qc3bS6BX
        tQAyJoXh7NlJy4nwXnbpw6k=
X-Google-Smtp-Source: ABdhPJzpbGmHrwh8UAjjsCRvYXj+APQyDZxQPQSAbma10H9Mf3UHV2kID3HT1nzwpSYt9itchv3pjw==
X-Received: by 2002:a05:6512:3f16:: with SMTP id y22mr2966368lfa.356.1629218247319;
        Tue, 17 Aug 2021 09:37:27 -0700 (PDT)
Received: from localhost.localdomain ([46.235.67.232])
        by smtp.gmail.com with ESMTPSA id u22sm255382lff.270.2021.08.17.09.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 09:37:26 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, himadrispandya@gmail.com
Cc:     robert.foss@collabora.com, freddy@asix.com.tw,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: [PATCH v4] net: asix: fix uninit value bugs
Date:   Tue, 17 Aug 2021 19:37:23 +0300
Message-Id: <20210817163723.19040-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YRfjFr9GbcoJrycc@lunn.ch>
References: <YRfjFr9GbcoJrycc@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported uninit-value in asix_mdio_read(). The problem was in
missing error handling. asix_read_cmd() should initialize passed stack
variable smsr, but it can fail in some cases. Then while condidition
checks possibly uninit smsr variable.

Since smsr is uninitialized stack variable, driver can misbehave,
because smsr will be random in case of asix_read_cmd() failure.
Fix it by adding error handling and just continue the loop instead of
checking uninit value.

Added helper function for checking Host_En bit, since wrong loop was used
in 4 functions and there is no need in copy-pasting code parts.

Cc: Robert Foss <robert.foss@collabora.com>
Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
Reported-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	1. Fixed previous wrong approach and changed while loop to for loop
	2. Reported-and-tested-by: tag removed, since KMSAN tests can be
	   false positive. Used Reported-by instead.

Changes in v3:
	1. Addressed uninit value bugs in asix_mdio_write(), asix_mdio_read_nopm()
	and asix_mdio_write_nopm()
	2. Moved i after ret to reverse xmas tree style
	3. Fixed Fixes: tag

Changes in v4:
	1. Added helper for checking Host_En bit, since wrong loop was
	   used in 4 functions. (Suggested by Andrew Lunn)

---
 drivers/net/usb/asix_common.c | 70 +++++++++++++++--------------------
 1 file changed, 30 insertions(+), 40 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index ac92bc52a85e..38cda590895c 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -63,6 +63,29 @@ void asix_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 			       value, index, data, size);
 }
 
+static int asix_check_host_enable(struct usbnet *dev, int in_pm)
+{
+	int i, ret;
+	u8 smsr;
+
+	for (i = 0; i < 30; ++i) {
+		ret = asix_set_sw_mii(dev, in_pm);
+		if (ret == -ENODEV || ret == -ETIMEDOUT)
+			break;
+		usleep_range(1000, 1100);
+		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
+				    0, 0, 1, &smsr, in_pm);
+		if (ret == -ENODEV)
+			break;
+		else if (ret < 0)
+			continue;
+		else if (smsr & AX_HOST_EN)
+			break;
+	}
+
+	return ret;
+}
+
 static void reset_asix_rx_fixup_info(struct asix_rx_fixup_info *rx)
 {
 	/* Reset the variables that have a lifetime outside of
@@ -467,19 +490,11 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
-	u8 smsr;
-	int i = 0;
 	int ret;
 
 	mutex_lock(&dev->phy_mutex);
-	do {
-		ret = asix_set_sw_mii(dev, 0);
-		if (ret == -ENODEV || ret == -ETIMEDOUT)
-			break;
-		usleep_range(1000, 1100);
-		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
-				    0, 0, 1, &smsr, 0);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+
+	ret = asix_check_host_enable(dev, 0);
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
@@ -505,23 +520,14 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
-	u8 smsr;
-	int i = 0;
 	int ret;
 
 	netdev_dbg(dev->net, "asix_mdio_write() phy_id=0x%02x, loc=0x%02x, val=0x%04x\n",
 			phy_id, loc, val);
 
 	mutex_lock(&dev->phy_mutex);
-	do {
-		ret = asix_set_sw_mii(dev, 0);
-		if (ret == -ENODEV)
-			break;
-		usleep_range(1000, 1100);
-		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
-				    0, 0, 1, &smsr, 0);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
 
+	ret = asix_check_host_enable(dev, 0);
 	if (ret == -ENODEV)
 		goto out;
 
@@ -561,19 +567,11 @@ int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
-	u8 smsr;
-	int i = 0;
 	int ret;
 
 	mutex_lock(&dev->phy_mutex);
-	do {
-		ret = asix_set_sw_mii(dev, 1);
-		if (ret == -ENODEV || ret == -ETIMEDOUT)
-			break;
-		usleep_range(1000, 1100);
-		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
-				    0, 0, 1, &smsr, 1);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+
+	ret = asix_check_host_enable(dev, 1);
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
@@ -595,22 +593,14 @@ asix_mdio_write_nopm(struct net_device *netdev, int phy_id, int loc, int val)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
-	u8 smsr;
-	int i = 0;
 	int ret;
 
 	netdev_dbg(dev->net, "asix_mdio_write() phy_id=0x%02x, loc=0x%02x, val=0x%04x\n",
 			phy_id, loc, val);
 
 	mutex_lock(&dev->phy_mutex);
-	do {
-		ret = asix_set_sw_mii(dev, 1);
-		if (ret == -ENODEV)
-			break;
-		usleep_range(1000, 1100);
-		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
-				    0, 0, 1, &smsr, 1);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+
+	ret = asix_check_host_enable(dev, 1);
 	if (ret == -ENODEV) {
 		mutex_unlock(&dev->phy_mutex);
 		return;
-- 
2.32.0

