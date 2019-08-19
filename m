Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B2B91B68
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 05:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfHSDPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 23:15:45 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:38967 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbfHSDPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 23:15:45 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7J3Fhrd005516, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7J3Fhrd005516
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 19 Aug 2019 11:15:43 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV02.realtek.com.tw
 (172.21.6.19) with Microsoft SMTP Server id 14.3.468.0; Mon, 19 Aug 2019
 11:15:42 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: fix accessing skb after napi_gro_receive
Date:   Mon, 19 Aug 2019 11:15:19 +0800
Message-ID: <1394712342-15778-302-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-299-albertk@realtek.com>
References: <1394712342-15778-299-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix accessing skb after napi_gro_receive which is caused by
commit 47922fcde536 ("r8152: support skb_add_rx_frag").

Fixes: 47922fcde536 ("r8152: support skb_add_rx_frag")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 40d18e866269..b1db6df6f4ab 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2094,10 +2094,10 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			skb->protocol = eth_type_trans(skb, netdev);
 			rtl_rx_vlan_tag(rx_desc, skb);
 			if (work_done < budget) {
-				napi_gro_receive(napi, skb);
 				work_done++;
 				stats->rx_packets++;
 				stats->rx_bytes += skb->len;
+				napi_gro_receive(napi, skb);
 			} else {
 				__skb_queue_tail(&tp->rx_queue, skb);
 			}
-- 
2.21.0

