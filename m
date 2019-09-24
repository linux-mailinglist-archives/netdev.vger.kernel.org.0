Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E6EBC050
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 04:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408001AbfIXCrw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Sep 2019 22:47:52 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:36172 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbfIXCrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 22:47:52 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x8O2lmp1013586, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x8O2lmp1013586
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 24 Sep 2019 10:47:48 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Tue, 24 Sep
 2019 10:47:47 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH] r8152: Use guard clause and fix comment typos
Thread-Topic: [PATCH] r8152: Use guard clause and fix comment typos
Thread-Index: AQHVcl4Je97jOVw1OE2mv82gmv1qzac6GP4A
Date:   Tue, 24 Sep 2019 02:47:47 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18E1587@RTITMBSVM03.realtek.com.tw>
References: <20190923222657.253628-1-pmalani@chromium.org>
In-Reply-To: <20190923222657.253628-1-pmalani@chromium.org>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prashant Malani [mailto:pmalani@chromium.org]
> Sent: Tuesday, September 24, 2019 6:27 AM
> To: Hayes Wang
[...]
> -	do {
> +	while (1) {
>  		struct tx_agg *agg;
> +		struct net_device *netdev = tp->netdev;
> 
>  		if (skb_queue_empty(&tp->tx_queue))
>  			break;
> @@ -2188,26 +2189,25 @@ static void tx_bottom(struct r8152 *tp)
>  			break;
> 
>  		res = r8152_tx_agg_fill(tp, agg);
> -		if (res) {
> -			struct net_device *netdev = tp->netdev;
> +		if (!res)
> +			break;

I let the loop run continually until an error occurs or the queue is empty.
However, you stop the loop when r8152_tx_agg_fill() is successful.
If an error occurs continually, the loop may not be broken.

> -			if (res == -ENODEV) {
> -				rtl_set_unplug(tp);
> -				netif_device_detach(netdev);
> -			} else {
> -				struct net_device_stats *stats = &netdev->stats;
> -				unsigned long flags;
> +		if (res == -ENODEV) {
> +			rtl_set_unplug(tp);
> +			netif_device_detach(netdev);
> +		} else {
> +			struct net_device_stats *stats = &netdev->stats;
> +			unsigned long flags;
> 
> -				netif_warn(tp, tx_err, netdev,
> -					   "failed tx_urb %d\n", res);
> -				stats->tx_dropped += agg->skb_num;
> +			netif_warn(tp, tx_err, netdev,
> +				   "failed tx_urb %d\n", res);
> +			stats->tx_dropped += agg->skb_num;
> 
> -				spin_lock_irqsave(&tp->tx_lock, flags);
> -				list_add_tail(&agg->list, &tp->tx_free);
> -				spin_unlock_irqrestore(&tp->tx_lock, flags);
> -			}
> +			spin_lock_irqsave(&tp->tx_lock, flags);
> +			list_add_tail(&agg->list, &tp->tx_free);
> +			spin_unlock_irqrestore(&tp->tx_lock, flags);
>  		}
> -	} while (res == 0);
> +	}

I think the behavior is different from the current one.

Best Regards,
Hayes

