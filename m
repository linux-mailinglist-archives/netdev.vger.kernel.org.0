Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1E241E5D7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 03:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351424AbhJABip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 21:38:45 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:58990 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230256AbhJABin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 21:38:43 -0400
X-UUID: 3bcfb2b1a06848beb28bad7608c253d6-20211001
X-UUID: 3bcfb2b1a06848beb28bad7608c253d6-20211001
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <jason-ch.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2072459898; Fri, 01 Oct 2021 09:36:56 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 1 Oct 2021 09:36:55 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 1 Oct
 2021 09:36:55 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 1 Oct 2021 09:36:54 +0800
Message-ID: <a891e733157ca7e631ca120ebae15557a6f05738.camel@mediatek.com>
Subject: Re: [PATCH] r8152: stop submitting rx for -EPROTO
From:   Jason-ch Chen <jason-ch.chen@mediatek.com>
To:     Hayes Wang <hayeswang@realtek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
Date:   Fri, 1 Oct 2021 09:36:54 +0800
In-Reply-To: <7dc4198f05784b6686973500150faca7@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
         <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
         <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
         <7dc4198f05784b6686973500150faca7@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-09-30 at 02:41 +0000, Hayes Wang wrote:
> Jason-ch Chen <jason-ch.chen@mediatek.com>
> > Sent: Wednesday, September 29, 2021 5:53 PM
> 
> [...]
> > Hi Hayes,
> > 
> > Sometimes Rx submits rapidly and the USB kernel driver of
> > opensource
> > cannot receive any disconnect event due to CPU heavy loading, which
> > finally causes a system crash.
> > Do you have any suggestions to modify the r8152 driver to prevent
> > this
> > situation happened?
> 
> Do you mind to try the following patch?
> It avoids to re-submit RX immediately.
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 60ba9b734055..bfe00af8283f 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -767,6 +767,7 @@ enum rtl8152_flags {
>  	PHY_RESET,
>  	SCHEDULE_TASKLET,
>  	GREEN_ETHERNET,
> +	SCHEDULE_NAPI,
>  };
>  
>  #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
> @@ -1770,6 +1771,14 @@ static void read_bulk_callback(struct urb
> *urb)
>  		rtl_set_unplug(tp);
>  		netif_device_detach(tp->netdev);
>  		return;
> +	case -EPROTO:
> +		urb->actual_length = 0;
> +		spin_lock_irqsave(&tp->rx_lock, flags);
> +		list_add_tail(&agg->list, &tp->rx_done);
> +		spin_unlock_irqrestore(&tp->rx_lock, flags);
> +		set_bit(SCHEDULE_NAPI, &tp->flags);
> +		schedule_delayed_work(&tp->schedule, 1);
> +		return;
>  	case -ENOENT:
>  		return;	/* the urb is in unlink state */
>  	case -ETIME:
> @@ -2425,6 +2434,7 @@ static int rx_bottom(struct r8152 *tp, int
> budget)
>  	if (list_empty(&tp->rx_done))
>  		goto out1;
>  
> +	clear_bit(SCHEDULE_NAPI, &tp->flags);
>  	INIT_LIST_HEAD(&rx_queue);
>  	spin_lock_irqsave(&tp->rx_lock, flags);
>  	list_splice_init(&tp->rx_done, &rx_queue);
> @@ -2441,7 +2451,7 @@ static int rx_bottom(struct r8152 *tp, int
> budget)
>  
>  		agg = list_entry(cursor, struct rx_agg, list);
>  		urb = agg->urb;
> -		if (urb->actual_length < ETH_ZLEN)
> +		if (urb->status != 0 || urb->actual_length < ETH_ZLEN)
>  			goto submit;
>  
>  		agg_free = rtl_get_free_rx(tp, GFP_ATOMIC);
> @@ -6643,6 +6653,10 @@ static void rtl_work_func_t(struct work_struct
> *work)
>  	    netif_carrier_ok(tp->netdev))
>  		tasklet_schedule(&tp->tx_tl);
>  
> +	if (test_and_clear_bit(SCHEDULE_NAPI, &tp->flags) &&
> +	    !list_empty(&tp->rx_done))
> +		napi_schedule(&tp->napi);
> +
>  	mutex_unlock(&tp->control);
>  
>  out1:
> 
> 
> Best Regards,
> Hayes

Hi,

This patch has been verified.
It did avoid Rx re-submit immediately.

Thanks,
Jason

