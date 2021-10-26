Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF7143B0C4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhJZLJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:09:55 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29938 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhJZLJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:09:54 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hdpnk2nmFzbnPy;
        Tue, 26 Oct 2021 19:02:50 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 19:07:27 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 26 Oct
 2021 19:07:27 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <oneukum@suse.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <johan@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] usbnet: fix error return code in usbnet_probe()
Date:   Tue, 26 Oct 2021 19:25:26 +0800
Message-ID: <20211026112526.2878177-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return error code if usb_maxpacket() returns 0 in usbnet_probe().

Fixes: 397430b50a36 ("usbnet: sanity check for maxpacket")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/usb/usbnet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 80432ee0ce69..fb5bf7d36d50 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1790,6 +1790,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
 	if (dev->maxpacket == 0) {
 		/* that is a broken device */
+		status = -EINVAL;
 		goto out4;
 	}
 
-- 
2.25.1

