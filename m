Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 304C1643A2
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 10:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfGJIhf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Jul 2019 04:37:35 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:52820 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfGJIhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 04:37:35 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x6A8aotx005820, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x6A8aotx005820
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 10 Jul 2019 16:36:50 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 10 Jul
 2019 16:36:50 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/2] rtw88: pci: Rearrange the memory usage for skb in RX ISR
Thread-Topic: [PATCH v2 1/2] rtw88: pci: Rearrange the memory usage for skb
 in RX ISR
Thread-Index: AQHVNkAp+Pmh+ukZi0a1oZ+M+t8Cp6bDiFdg
Date:   Wed, 10 Jul 2019 08:36:49 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1864779@RTITMBSVM04.realtek.com.tw>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
 <20190709102059.7036-1-jian-hong@endlessm.com>
In-Reply-To: <20190709102059.7036-1-jian-hong@endlessm.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: [PATCH v2 1/2] rtw88: pci: Rearrange the memory usage for skb in
> RX ISR
> 
> Testing with RTL8822BE hardware, when available memory is low, we
> frequently see a kernel panic and system freeze.
> 
> First, rtw_pci_rx_isr encounters a memory allocation failure (trimmed):
> 
> rx routine starvation
> WARNING: CPU: 7 PID: 9871 at drivers/net/wireless/realtek/rtw88/pci.c:822
> rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
> [ 2356.580313] RIP: 0010:rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
> 
> Then we see a variety of different error conditions and kernel panics,
> such as this one (trimmed):
> 
> rtw_pci 0000:02:00.0: pci bus timeout, check dma status
> skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415
> head:00000000d2880c6f data:000000007a02b1ea tail:0x1df end:0xc0
> dev:<NULL>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:105!
> invalid opcode: 0000 [#1] SMP NOPTI
> RIP: 0010:skb_panic+0x43/0x45
> 
> When skb allocation fails and the "rx routine starvation" is hit, the
> function returns immediately without updating the RX ring. At this
> point, the RX ring may continue referencing an old skb which was already
> handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
> bad things happen.
> 
> This patch allocates a new, data-sized skb first in RX ISR. After
> copying the data in, we pass it to the upper layers. However, if skb
> allocation fails, we effectively drop the frame. In both cases, the
> original, full size ring skb is reused.
> 
> In addition, to fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 49 +++++++++++-------------
>  1 file changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index cfe05ba7280d..e9fe3ad896c8 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -763,6 +763,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev,
> struct rtw_pci *rtwpci,
>  	u32 pkt_offset;
>  	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
>  	u32 buf_desc_sz = chip->rx_buf_desc_sz;
> +	u32 new_len;
>  	u8 *rx_desc;
>  	dma_addr_t dma;
> 
> @@ -790,40 +791,34 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev,
> struct rtw_pci *rtwpci,
>  		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
>  			     pkt_stat.shift;
> 
> -		if (pkt_stat.is_c2h) {
> -			/* keep rx_desc, halmac needs it */
> -			skb_put(skb, pkt_stat.pkt_len + pkt_offset);
> +		/* discard current skb if the new skb cannot be allocated as a
> +		 * new one in rx ring later
> +		 */
> +		new_len = pkt_stat.pkt_len + pkt_offset;
> +		new = dev_alloc_skb(new_len);
> +		if (WARN_ONCE(!new, "rx routine starvation\n"))
> +			goto next_rp;
> +
> +		/* put the DMA data including rx_desc from phy to new skb */
> +		skb_put_data(new, skb->data, new_len);
> 
> -			/* pass offset for further operation */
> -			*((u32 *)skb->cb) = pkt_offset;
> -			skb_queue_tail(&rtwdev->c2h_queue, skb);
> +		if (pkt_stat.is_c2h) {
> +			 /* pass rx_desc & offset for further operation */
> +			*((u32 *)new->cb) = pkt_offset;
> +			skb_queue_tail(&rtwdev->c2h_queue, new);
>  			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
>  		} else {
> -			/* remove rx_desc, maybe use skb_pull? */
> -			skb_put(skb, pkt_stat.pkt_len);
> -			skb_reserve(skb, pkt_offset);
> -
> -			/* alloc a smaller skb to mac80211 */
> -			new = dev_alloc_skb(pkt_stat.pkt_len);
> -			if (!new) {
> -				new = skb;
> -			} else {
> -				skb_put_data(new, skb->data, skb->len);
> -				dev_kfree_skb_any(skb);
> -			}
> -			/* TODO: merge into rx.c */
> -			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> +			/* remove rx_desc */
> +			skb_pull(new, pkt_offset);
> +
> +			rtw_rx_stats(rtwdev, pkt_stat.vif, new);
>  			memcpy(new->cb, &rx_status, sizeof(rx_status));
>  			ieee80211_rx_irqsafe(rtwdev->hw, new);
>  		}
> 
> -		/* skb delivered to mac80211, alloc a new one in rx ring */
> -		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> -		if (WARN(!new, "rx routine starvation\n"))
> -			return;
> -
> -		ring->buf[cur_rp] = new;
> -		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);
> +next_rp:
> +		/* new skb delivered to mac80211, re-enable original skb DMA */
> +		rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc_sz);
> 
>  		/* host read next element in ring */
>  		if (++cur_rp >= ring->r.len)
> --
> 2.22.0

Now it looks good to me. Thanks.

Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Yan-Hsuan
