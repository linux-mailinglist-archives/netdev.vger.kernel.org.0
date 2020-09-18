Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E71426FBA8
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgIRLi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 07:38:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13302 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbgIRLi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 07:38:58 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AAED4BEDE1250E39538D;
        Fri, 18 Sep 2020 19:38:56 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 19:38:54 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: brcmfmac: check return value of driver_for_each_device()
Date:   Fri, 18 Sep 2020 19:37:48 +0800
Message-ID: <1600429068-28003-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1576:6: warning:
 variable 'ret' set but not used [-Wunused-but-set-variable]
  1576 |  int ret;
       |      ^~~

driver_for_each_device() has been declared with __must_check, so the
return value should be checked.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index ac54638..6f67fef 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1578,6 +1578,9 @@ void brcmf_usb_exit(void)
 	brcmf_dbg(USB, "Enter\n");
 	ret = driver_for_each_device(drv, NULL, NULL,
 				     brcmf_usb_reset_device);
+	if (ret)
+		brcmf_err("failed to reset all usb devices %d\n", ret);
+
 	usb_deregister(&brcmf_usbdrvr);
 }
 
-- 
2.9.5

