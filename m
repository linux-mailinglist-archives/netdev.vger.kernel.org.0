Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D881D41BEA1
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 07:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244220AbhI2FUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 01:20:24 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:44792 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S232553AbhI2FUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 01:20:21 -0400
X-UUID: 70daad25348b408cb336491b518638f4-20210929
X-UUID: 70daad25348b408cb336491b518638f4-20210929
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <jason-ch.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1840174725; Wed, 29 Sep 2021 13:18:36 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 29 Sep 2021 13:18:35 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 29 Sep 2021 13:18:35 +0800
From:   Jason-ch Chen <jason-ch.chen@mediatek.com>
To:     <matthias.bgg@gmail.com>, <hayeswang@realtek.com>
CC:     <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        <hsinyi@google.com>, Jason-ch Chen <jason-ch.chen@mediatek.com>
Subject: [PATCH] r8152: stop submitting rx for -EPROTO
Date:   Wed, 29 Sep 2021 13:18:12 +0800
Message-ID: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unplugging RTL8152 Fast Ethernet Adapter which is plugged
into an USB HUB, the driver would get -EPROTO for bulk transfer.
There is a high probability to get the soft/hard lockup
information if the driver continues to submit Rx before the HUB
completes the detection of all hub ports and issue the
disconnect event.

[  644.786219] net_ratelimit: 113887 callbacks suppressed
[  644.786239] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786335] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786369] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786431] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786493] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786555] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786617] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786678] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786740] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  644.786802] r8152 1-1.2.4:1.0 eth0: Rx status -71
[  645.041159] mtk-scp 10500000.scp: scp_ipi_send: IPI timeout!
[  645.041211] cros-ec-rpmsg 10500000.scp.cros-ec-rpmsg.13.-1: rpmsg send failed
[  649.183350] watchdog: BUG: soft lockup - CPU#0 stuck for 12s! [migration/0:14]

Signed-off-by: Jason-ch Chen <jason-ch.chen@mediatek.com>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 60ba9b734055..250718f0dcb7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1771,6 +1771,7 @@ static void read_bulk_callback(struct urb *urb)
 		netif_device_detach(tp->netdev);
 		return;
 	case -ENOENT:
+	case -EPROTO:
 		return;	/* the urb is in unlink state */
 	case -ETIME:
 		if (net_ratelimit())
-- 
2.18.0

