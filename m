Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458183EC2FF
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 15:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238519AbhHNNzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 09:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbhHNNzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 09:55:51 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36A2C061764;
        Sat, 14 Aug 2021 06:55:22 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id z20so25522425lfd.2;
        Sat, 14 Aug 2021 06:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/9pT7bkBVTNDK1ijiiTlwQXalEnUrKo+aspgV56b6Jw=;
        b=FsLPuxb27KLkDPr4k7bQZxrdTouVAn8KOUiH/TMBcbsSU2LczQLcLR5JQAP5kRPJUN
         PD7kEo90p65eY0ZeBl7fLIDPfMLUu8G17CqzXvAQjcOENxFfNSS4gDUeS3yeXbTAiYt3
         yHRt/8LgYSNd++n+T5wtRUJg3dN9dsU6t7ilI58mee7wKKeKOWobN3svOVDpaqm9EvRD
         bObOYygvt80yZMv1kf06IPTsEKutSNi0EwVfoJs3tdzwHJcdr8zTv8Nl0Vw54//d02OG
         g1w8HEdrW3wHrWMHTZknD6heP9iQOKYf029f17084XWIWEx420mhVfdbMdKBW3dYQVA1
         s0/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/9pT7bkBVTNDK1ijiiTlwQXalEnUrKo+aspgV56b6Jw=;
        b=Zbbt6lI45FcnR59AJp4WmTBCb3xW56AvcLtglDYZ3px3pUD9PyKNE5VfTyKk+Apkqz
         hS78/ucEhU/nW6lArRJFL6xkkj1esJq5AJlJifTJqXgI4herZFo6ut/PV9YF+DxLSfLl
         tja9hntdnjO0y/rRIBrVwKgvBxxzeFc/Zrh4aBzCHGN9QOeIIgYoEZ8CXTrzpdqZH2M7
         eEuq7sMuwLtLzOwAEDkbDYRclxHgRHnVtCS+8g/h0+EYAB6RiLcFmOQyyF0MVIYXjWoa
         c4vbBvkbfW4eQHyDO5knJW7BZ7OBg11HRPMAt0fQH9I1mpF+HpaJWZsKuZ2wjYus7vjM
         u1Ng==
X-Gm-Message-State: AOAM532Y8daftDQ+vnaHWX8w2rqrVLP1Yo5I0OZkpyHRdEbiPcIlf+Jy
        yobA6SHVvTHICZq7vX3feX0=
X-Google-Smtp-Source: ABdhPJzAhFCPZLjoIVpxxWrYG8RTVlzcU69Sp9DQgkysAOJ7VGz5Ln9/FytE/w+z4I5O5Hu5gGZh4Q==
X-Received: by 2002:a05:6512:ad2:: with SMTP id n18mr5076300lfu.334.1628949320806;
        Sat, 14 Aug 2021 06:55:20 -0700 (PDT)
Received: from localhost.localdomain ([185.215.60.122])
        by smtp.gmail.com with ESMTPSA id y32sm422962lfa.171.2021.08.14.06.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 06:55:20 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch
Cc:     robert.foss@collabora.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: [PATCH v3] net: asix: fix uninit value bugs
Date:   Sat, 14 Aug 2021 16:55:05 +0300
Message-Id: <20210814135505.11920-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813155226.651c74f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210813155226.651c74f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

Also, same loop was used in 3 other functions. Fixed uninit value bug
in them too.

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

---
 drivers/net/usb/asix_common.c | 51 ++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index ac92bc52a85e..f0ee35edb746 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -468,18 +468,25 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
 	u8 smsr;
-	int i = 0;
 	int ret;
+	int i;
 
 	mutex_lock(&dev->phy_mutex);
-	do {
+	for (i = 0; i < 30; ++i) {
 		ret = asix_set_sw_mii(dev, 0);
 		if (ret == -ENODEV || ret == -ETIMEDOUT)
 			break;
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 0);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+		if (ret == -ENODEV)
+			break;
+		else if (ret < 0)
+			continue;
+		else if (smsr & AX_HOST_EN)
+			break;
+	}
+
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
@@ -506,21 +513,27 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
 	u8 smsr;
-	int i = 0;
 	int ret;
+	int i;
 
 	netdev_dbg(dev->net, "asix_mdio_write() phy_id=0x%02x, loc=0x%02x, val=0x%04x\n",
 			phy_id, loc, val);
 
 	mutex_lock(&dev->phy_mutex);
-	do {
+	for (i = 0; i < 30; ++i) {
 		ret = asix_set_sw_mii(dev, 0);
 		if (ret == -ENODEV)
 			break;
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 0);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+		if (ret == -ENODEV)
+			break;
+		else if (ret < 0)
+			continue;
+		else if (smsr & AX_HOST_EN)
+			break;
+	}
 
 	if (ret == -ENODEV)
 		goto out;
@@ -562,18 +575,25 @@ int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
 	u8 smsr;
-	int i = 0;
 	int ret;
+	int i;
 
 	mutex_lock(&dev->phy_mutex);
-	do {
+	for (i = 0; i < 30; ++i) {
 		ret = asix_set_sw_mii(dev, 1);
 		if (ret == -ENODEV || ret == -ETIMEDOUT)
 			break;
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 1);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+		if (ret == -ENODEV)
+			break;
+		else if (ret < 0)
+			continue;
+		else if (smsr & AX_HOST_EN)
+			break;
+	}
+
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
@@ -596,21 +616,28 @@ asix_mdio_write_nopm(struct net_device *netdev, int phy_id, int loc, int val)
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res = cpu_to_le16(val);
 	u8 smsr;
-	int i = 0;
 	int ret;
+	int i;
 
 	netdev_dbg(dev->net, "asix_mdio_write() phy_id=0x%02x, loc=0x%02x, val=0x%04x\n",
 			phy_id, loc, val);
 
 	mutex_lock(&dev->phy_mutex);
-	do {
+	for (i = 0; i < 30; ++i) {
 		ret = asix_set_sw_mii(dev, 1);
 		if (ret == -ENODEV)
 			break;
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 1);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+		if (ret == -ENODEV)
+			break;
+		else if (ret < 0)
+			continue;
+		else if (smsr & AX_HOST_EN)
+			break;
+	}
+
 	if (ret == -ENODEV) {
 		mutex_unlock(&dev->phy_mutex);
 		return;
-- 
2.32.0

