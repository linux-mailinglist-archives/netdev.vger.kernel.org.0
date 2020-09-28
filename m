Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED2327B29F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 18:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgI1Q5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 12:57:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34257 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgI1Q5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 12:57:18 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kMwQj-00068h-K9; Mon, 28 Sep 2020 16:55:14 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     briannorris@chromium.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] rtw88: pci: Power cycle device during shutdown
Date:   Tue, 29 Sep 2020 00:55:08 +0800
Message-Id: <20200928165508.20775-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200824093225.13689-1-kai.heng.feng@canonical.com>
References: <20200824093225.13689-1-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are reports that 8822CE fails to work rtw88 with "failed to read DBI
register" error. Also I have a system with 8723DE which freezes the whole
system when the rtw88 is probing the device.

According to [1], platform firmware may not properly power manage the
device during shutdown. I did some expirements and putting the device to
D3 can workaround the issue.

So let's power cycle the device by putting the device to D3 at shutdown
to prevent the issue from happening.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=206411#c9

BugLink: https://bugs.launchpad.net/bugs/1872984
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - Add more detail in commit log.

 drivers/net/wireless/realtek/rtw88/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 3413973bc475..7f1f5073b9f4 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1599,6 +1599,8 @@ void rtw_pci_shutdown(struct pci_dev *pdev)
 
 	if (chip->ops->shutdown)
 		chip->ops->shutdown(rtwdev);
+
+	pci_set_power_state(pdev, PCI_D3hot);
 }
 EXPORT_SYMBOL(rtw_pci_shutdown);
 
-- 
2.17.1

