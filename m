Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8F61BC4
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729507AbfGHIhA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jul 2019 04:37:00 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:21433 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729434AbfGHIg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:36:59 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-58-GxZAHFndPNeufvGAW7tiGg-1; Mon, 08 Jul 2019 09:36:53 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 8 Jul 2019 09:36:52 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 8 Jul 2019 09:36:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jian-Hong Pan' <jian-hong@endlessm.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
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
Thread-Index: AQHVNVeEF2VH1aWcW0SX/aCCs+qgc6bAY9qw
Date:   Mon, 8 Jul 2019 08:36:52 +0000
Message-ID: <e95fe2b6d5664aa4b256cdad1707f09f@AcuMS.aculab.com>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
In-Reply-To: <20190708063252.4756-1-jian-hong@endlessm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: GxZAHFndPNeufvGAW7tiGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian-Hong Pan
> Sent: 08 July 2019 07:33
> To: Yan-Hsuan Chuang; Kalle Valo; David S . Miller
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
> skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415 head:00000000d2880c6f
> data:000000007a02b1ea tail:0x1df end:0xc0 dev:<NULL>
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
> This patch allocates a new skb first in RX ISR. If we don't have memory
> available, we discard the current frame, allowing the existing skb to be
> reused in the ring. Otherwise, we simplify the code flow and just hand
> over the RX-populated skb over to mac80211.
> 
> In addition, to fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.

Under low memory conditions it may be preferable to limit the amount
of memory assigned to the receive ring.

I also thought it was preferable (DM may correct me here) to do the
skb allocates from the 'bh' of the driver rather than from the hardware
interrupt.

It is also almost certainly preferable (especially on IOMMU systems)
to copy small frames into a new skb (of the right size) and then
reuse the skb (with its dma-mapped buffer) for a later frame.

Allocating a new skb before ay px processing just seems wrong...

	David

> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Reviewed-by: Daniel Drake <drake@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 28 +++++++++++-------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index cfe05ba7280d..1bfc99ae6b84 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -786,6 +786,15 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
>  		rx_desc = skb->data;
>  		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_status);
> 
> +		/* discard current skb if the new skb cannot be allocated as a
> +		 * new one in rx ring later
> +		 * */
> +		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
> +		if (WARN(!new, "rx routine starvation\n")) {
> +			new = skb;
> +			goto next_rp;
> +		}
> +
>  		/* offset from rx_desc to payload */
>  		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
>  			     pkt_stat.shift;
> @@ -803,25 +812,14 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
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
> --
> 2.22.0

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

