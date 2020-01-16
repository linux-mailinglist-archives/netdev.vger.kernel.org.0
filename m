Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE2F13F6B2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388125AbgAPRBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:01:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388117AbgAPRBf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:01:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A2382077B;
        Thu, 16 Jan 2020 17:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194094;
        bh=ZEbNqm5OKHalr2x/W9yOCq/dnXWqutXvTbFLrr0skKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB3pVmaARmWNZbdo9YC3+jvTLUULT/aujcUzux4DQQhN3CdTQrxq412MXy6Hht+c/
         C2fK23abJVbwkG6etcL8iHYdNV9Yz2Nu0Hoxga57pm4rQQ+UAhZGCC12lr9DvPumTQ
         3HHxOI6iJqBSzgM86HZLNqL0aPenziQpAG69eiQ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Russel King <linux@armlinux.org.uk>,
        Franky Lin <franky.lin@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 196/671] brcmfmac: create debugfs files for bus-specific layer
Date:   Thu, 16 Jan 2020 11:51:45 -0500
Message-Id: <20200116165940.10720-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit aaf6a5e86e36766abbeedf220462bde8031f9a72 ]

Since we moved the drivers debugfs directory under ieee80211 debugfs the
debugfs entries need to be added after wiphy_register() has been called.
For most part that has been done accordingly, but for the debugfs entries
added by SDIO it was not and failed silently. This patch fixes that by
adding a bus-layer callback for it.

Fixes: 856d5a011c86 ("brcmfmac: allocate struct brcmf_pub instance using wiphy_new()")
Reported-by: Russel King <linux@armlinux.org.uk>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h   | 10 ++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c  |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c  | 12 +++++++-----
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index c4965184cdf3..3d441c5c745c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -90,6 +90,7 @@ struct brcmf_bus_ops {
 	int (*get_memdump)(struct device *dev, void *data, size_t len);
 	int (*get_fwname)(struct device *dev, const char *ext,
 			  unsigned char *fw_name);
+	void (*debugfs_create)(struct device *dev);
 };
 
 
@@ -235,6 +236,15 @@ int brcmf_bus_get_fwname(struct brcmf_bus *bus, const char *ext,
 	return bus->ops->get_fwname(bus->dev, ext, fw_name);
 }
 
+static inline
+void brcmf_bus_debugfs_create(struct brcmf_bus *bus)
+{
+	if (!bus->ops->debugfs_create)
+		return;
+
+	return bus->ops->debugfs_create(bus->dev);
+}
+
 /*
  * interface functions from common layer
  */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 584e05fdca6a..9d7b8834b854 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1105,6 +1105,7 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	brcmf_feat_debugfs_create(drvr);
 	brcmf_proto_debugfs_create(drvr);
+	brcmf_bus_debugfs_create(bus_if);
 
 	return 0;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index abaed2fa2def..5c3b62e61980 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3131,9 +3131,12 @@ static int brcmf_debugfs_sdio_count_read(struct seq_file *seq, void *data)
 	return 0;
 }
 
-static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+static void brcmf_sdio_debugfs_create(struct device *dev)
 {
-	struct brcmf_pub *drvr = bus->sdiodev->bus_if->drvr;
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
+	struct brcmf_sdio *bus = sdiodev->bus;
 	struct dentry *dentry = brcmf_debugfs_get_devdir(drvr);
 
 	if (IS_ERR_OR_NULL(dentry))
@@ -3153,7 +3156,7 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 	return 0;
 }
 
-static void brcmf_sdio_debugfs_create(struct brcmf_sdio *bus)
+static void brcmf_sdio_debugfs_create(struct device *dev)
 {
 }
 #endif /* DEBUG */
@@ -3438,8 +3441,6 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	if (bus->rxbuf)
 		bus->rxblen = value;
 
-	brcmf_sdio_debugfs_create(bus);
-
 	/* the commands below use the terms tx and rx from
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
@@ -4050,6 +4051,7 @@ static const struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.get_ramsize = brcmf_sdio_bus_get_ramsize,
 	.get_memdump = brcmf_sdio_bus_get_memdump,
 	.get_fwname = brcmf_sdio_get_fwname,
+	.debugfs_create = brcmf_sdio_debugfs_create
 };
 
 #define BRCMF_SDIO_FW_CODE	0
-- 
2.20.1

