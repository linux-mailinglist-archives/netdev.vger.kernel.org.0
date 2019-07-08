Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D6761B30
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 09:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbfGHHXN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 03:23:13 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:37073 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfGHHXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 03:23:13 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x687N1D1015818, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x687N1D1015818
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Jul 2019 15:23:01 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Mon, 8 Jul
 2019 15:23:01 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Thread-Topic: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR
Thread-Index: AQHVNVeEOhZgR6M53kuE5XrXitIVDqbAR+xA
Date:   Mon, 8 Jul 2019 07:23:00 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1861A6D@RTITMBSVM04.realtek.com.tw>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
In-Reply-To: <20190708063252.4756-1-jian-hong@endlessm.com>
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

> Subject: [PATCH] rtw88/pci: Rearrange the memory usage for skb in RX ISR

nit, "rtw88: pci:" would be better.

> 
> 
> When skb allocation fails and the "rx routine starvation" is hit, the
> function returns immediately without updating the RX ring. At this
> point, the RX ring may continue referencing an old skb which was already
> handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
> bad things happen.
> 
> This patch allocates a new skb first in RX ISR. If we don't have memory
> available, we discard the current frame, allowing the existing skb to be
> reused in the ring. Otherwise, we simplify the code flow and just hand
> over the RX-populated skb over to mac80211.
> 
> In addition, to fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Reviewed-by: Daniel Drake <drake@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 28 +++++++++++-------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> b/drivers/net/wireless/realtek/rtw88/pci.c
> index cfe05ba7280d..1bfc99ae6b84 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -786,6 +786,15 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev,
> struct rtw_pci *rtwpci,
>  		rx_desc = skb->data;
>  		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
> 
> +		/* discard current skb if the new skb cannot be allocated as a
> +		 * new one in rx ring later
> +		 * */

nit, comment indentation.

> +		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> +		if (WARN(!new, "rx routine starvation\n")) {
> +			new = skb;
> +			goto next_rp;
> +		}
> +
>  		/* offset from rx_desc to payload */
>  		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
>  			     pkt_stat.shift;
> @@ -803,25 +812,14 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev,
> struct rtw_pci *rtwpci,
>  			skb_put(skb, pkt_stat.pkt_len);
>  			skb_reserve(skb, pkt_offset);
> 
> -			/* alloc a smaller skb to mac80211 */
> -			new = dev_alloc_skb(pkt_stat.pkt_len);
> -			if (!new) {
> -				new = skb;
> -			} else {
> -				skb_put_data(new, skb->data, skb->len);
> -				dev_kfree_skb_any(skb);
> -			}

I am not sure if it's fine to deliver every huge SKB to mac80211.
Because it will then be delivered to TCP/IP stack.
Hence I think either it should be tested to know if the performance
would be impacted or find out a more efficient way to send
smaller SKB to mac80211 stack.

>  			/* TODO: merge into rx.c */
>  			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
> -			memcpy(new->cb, &rx_status, sizeof(rx_status));
> -			ieee80211_rx_irqsafe(rtwdev->hw, new);
> +			memcpy(skb->cb, &rx_status, sizeof(rx_status));
> +			ieee80211_rx_irqsafe(rtwdev->hw, skb);
>  		}
> 
> -		/* skb delivered to mac80211, alloc a new one in rx ring */
> -		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> -		if (WARN(!new, "rx routine starvation\n"))
> -			return;
> -
> +next_rp:
> +		/* skb delivered to mac80211, attach the new one into rx ring */
>  		ring->buf[cur_rp] = new;
>  		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);
> 

--

Yan-Hsuan
