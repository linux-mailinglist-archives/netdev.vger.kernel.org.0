Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49CB839E7
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfHFTyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:54:11 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39903 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFTyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:54:10 -0400
Received: by mail-qk1-f196.google.com with SMTP id w190so63908428qkc.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 12:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=1rHDXdmOEwR8xptFY1wQGCbwesX8kKKPC5gJB64uoto=;
        b=b9GAepqRbKFM3pzqYg2LpdHR2OEdgWMc/HZxIv2Gp9vLLA3ZTzFCsANpReq6o3heh3
         W1ptDk2UP62oVh0l6motNAk9K+wx+wzmppMPTOJTEgaxY2+N7G1GfJsdfjFGK9J/ydhd
         1JAQk+iuy/FOLH+ODao/HTvc8ZtAAW1UurzvdNfmAUudfT/DZ0X+8DL+1u85ZSbBYCly
         WgtOdpYIMLK+B2j83KqX+LKq9JgvsjwdwG7j0sTwebuX3AHqYlKN3JJ05J8D/90qYLwr
         3ydTkB4DNAQnO7JPElLfGlkn1OHq07X5Z9MyGidOLtK0y+fU5ATneF1nAhI/NLAg8l8A
         ZIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=1rHDXdmOEwR8xptFY1wQGCbwesX8kKKPC5gJB64uoto=;
        b=Qskve1F2kcByigrYuvrADLJdrlhB6KhHcgMfaWS4mDV6wk+OgOz9+Ph9rQ6fDu6VZe
         Cw+wV9oF+sdcxxFc2IlKWc0bGXf/rMhTushJW3nNYplQv5OPWJmefma/TKhffoTOQ+iS
         Ex9DoQm+oF04itKaD+WPSrRbwZLouNx0AhbRctO35eU2KbCzEruOercy/Hurwl/3xXkF
         oOOc5kbcpiTqrtJUS4p2iaI7F7TKUG/XXmbxlebihHmW+OayNFHfo4Z9pgZnf6AmZ9FB
         FFT36ySyV2seNW9pMsT2HwyKcstQGmLsJnSchk04wjhE+IL/AdpS4swHb2tltb4QSB5j
         JOEQ==
X-Gm-Message-State: APjAAAUuTcd8mA0cnHSesVV3zq/BeQscvKzSDxIxt9RrTPSv8knyMnQL
        DDkwig1jgAjYrXBVaEtn3aty0g==
X-Google-Smtp-Source: APXvYqxrBdTEbJz96Q2eq+iIvW0j3N8XWLn08kcP6O+0VhSZ/q8ftrBCG23A5U4DAubf7/lDubR3mQ==
X-Received: by 2002:ae9:df84:: with SMTP id t126mr2672184qkf.328.1565121249378;
        Tue, 06 Aug 2019 12:54:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l8sm2170230qtr.38.2019.08.06.12.54.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 12:54:09 -0700 (PDT)
Date:   Tue, 6 Aug 2019 12:53:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] r8152: replace array with linking list for
 rx information
Message-ID: <20190806125342.4620a94f@cakuba.netronome.com>
In-Reply-To: <1394712342-15778-291-albertk@realtek.com>
References: <1394712342-15778-289-albertk@realtek.com>
        <1394712342-15778-291-albertk@realtek.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Aug 2019 19:18:01 +0800, Hayes Wang wrote:
> The original method uses an array to store the rx information. The
> new one uses a list to link each rx structure. Then, it is possible
> to increase/decrease the number of rx structure dynamically.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 187 ++++++++++++++++++++++++++++------------
>  1 file changed, 132 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index 0f07ed05ab34..44d832ceb516 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -22,6 +22,7 @@
>  #include <linux/mdio.h>
>  #include <linux/usb/cdc.h>
>  #include <linux/suspend.h>
> +#include <linux/atomic.h>
>  #include <linux/acpi.h>
>  
>  /* Information for net-next */
> @@ -694,7 +695,7 @@ struct tx_desc {
>  struct r8152;
>  
>  struct rx_agg {
> -	struct list_head list;
> +	struct list_head list, info_list;
>  	struct urb *urb;
>  	struct r8152 *context;
>  	void *buffer;
> @@ -719,7 +720,7 @@ struct r8152 {
>  	struct net_device *netdev;
>  	struct urb *intr_urb;
>  	struct tx_agg tx_info[RTL8152_MAX_TX];
> -	struct rx_agg rx_info[RTL8152_MAX_RX];
> +	struct list_head rx_info;
>  	struct list_head rx_done, tx_free;
>  	struct sk_buff_head tx_queue, rx_queue;
>  	spinlock_t rx_lock, tx_lock;
> @@ -744,6 +745,8 @@ struct r8152 {
>  		void (*autosuspend_en)(struct r8152 *tp, bool enable);
>  	} rtl_ops;
>  
> +	atomic_t rx_count;

I wonder what the advantage of rx_count being atomic is, perhpas it
could be protected by the same lock as the list head?

>  	int intr_interval;
>  	u32 saved_wolopts;
>  	u32 msg_enable;
> @@ -1468,19 +1471,86 @@ static inline void *tx_agg_align(void *data)
>  	return (void *)ALIGN((uintptr_t)data, TX_ALIGN);
>  }
>  
> +static void free_rx_agg(struct r8152 *tp, struct rx_agg *agg)
> +{
> +	list_del(&agg->info_list);
> +
> +	usb_free_urb(agg->urb);
> +	kfree(agg->buffer);
> +	kfree(agg);
> +
> +	atomic_dec(&tp->rx_count);
> +}
> +
> +static struct rx_agg *alloc_rx_agg(struct r8152 *tp, gfp_t mflags)
> +{
> +	struct net_device *netdev = tp->netdev;
> +	int node = netdev->dev.parent ? dev_to_node(netdev->dev.parent) : -1;
> +	struct rx_agg *rx_agg;
> +
> +	rx_agg = kmalloc_node(sizeof(*rx_agg), mflags, node);
> +	if (rx_agg) {

nit: you could possibly save the indentation by returning early here

> +		unsigned long flags;
> +		u8 *buf;
> +
> +		buf = kmalloc_node(tp->rx_buf_sz, mflags, node);
> +		if (!buf)
> +			goto free_rx;
> +
> +		if (buf != rx_agg_align(buf)) {
> +			kfree(buf);
> +			buf = kmalloc_node(tp->rx_buf_sz + RX_ALIGN, mflags,
> +					   node);
> +			if (!buf)
> +				goto free_rx;
> +		}
> +
> +		rx_agg->buffer = buf;
> +		rx_agg->head = rx_agg_align(buf);
> +
> +		rx_agg->urb = usb_alloc_urb(0, mflags);
> +		if (!rx_agg->urb)
> +			goto free_buf;
> +
> +		rx_agg->context = tp;
> +
> +		INIT_LIST_HEAD(&rx_agg->list);
> +		INIT_LIST_HEAD(&rx_agg->info_list);
> +		spin_lock_irqsave(&tp->rx_lock, flags);
> +		list_add_tail(&rx_agg->info_list, &tp->rx_info);
> +		spin_unlock_irqrestore(&tp->rx_lock, flags);
> +
> +		atomic_inc(&tp->rx_count);
> +	}
> +
> +	return rx_agg;
> +
> +free_buf:
> +	kfree(rx_agg->buffer);
> +free_rx:
> +	kfree(rx_agg);
> +	return NULL;
> +}
> +
>  static void free_all_mem(struct r8152 *tp)
>  {
> +	struct list_head *cursor, *next;
> +	unsigned long flags;
>  	int i;
>  
> -	for (i = 0; i < RTL8152_MAX_RX; i++) {
> -		usb_free_urb(tp->rx_info[i].urb);
> -		tp->rx_info[i].urb = NULL;
> +	spin_lock_irqsave(&tp->rx_lock, flags);
>  
> -		kfree(tp->rx_info[i].buffer);
> -		tp->rx_info[i].buffer = NULL;
> -		tp->rx_info[i].head = NULL;
> +	list_for_each_safe(cursor, next, &tp->rx_info) {

nit: list_for_each_entry_safe, perhaps?

> +		struct rx_agg *agg;
> +
> +		agg = list_entry(cursor, struct rx_agg, info_list);
> +		free_rx_agg(tp, agg);
>  	}
>  
> +	spin_unlock_irqrestore(&tp->rx_lock, flags);
> +
> +	WARN_ON(unlikely(atomic_read(&tp->rx_count)));

nit: WARN_ON() has an unlikely() already built in

>  	for (i = 0; i < RTL8152_MAX_TX; i++) {
>  		usb_free_urb(tp->tx_info[i].urb);
>  		tp->tx_info[i].urb = NULL;
> @@ -1503,46 +1573,28 @@ static int alloc_all_mem(struct r8152 *tp)
>  	struct usb_interface *intf = tp->intf;
>  	struct usb_host_interface *alt = intf->cur_altsetting;
>  	struct usb_host_endpoint *ep_intr = alt->endpoint + 2;
> -	struct urb *urb;
>  	int node, i;
> -	u8 *buf;
>  
>  	node = netdev->dev.parent ? dev_to_node(netdev->dev.parent) : -1;
>  
>  	spin_lock_init(&tp->rx_lock);
>  	spin_lock_init(&tp->tx_lock);
> +	INIT_LIST_HEAD(&tp->rx_info);
>  	INIT_LIST_HEAD(&tp->tx_free);
>  	INIT_LIST_HEAD(&tp->rx_done);
>  	skb_queue_head_init(&tp->tx_queue);
>  	skb_queue_head_init(&tp->rx_queue);
> +	atomic_set(&tp->rx_count, 0);
>  
>  	for (i = 0; i < RTL8152_MAX_RX; i++) {
> -		buf = kmalloc_node(tp->rx_buf_sz, GFP_KERNEL, node);
> -		if (!buf)
> -			goto err1;
> -
> -		if (buf != rx_agg_align(buf)) {
> -			kfree(buf);
> -			buf = kmalloc_node(tp->rx_buf_sz + RX_ALIGN, GFP_KERNEL,
> -					   node);
> -			if (!buf)
> -				goto err1;
> -		}
> -
> -		urb = usb_alloc_urb(0, GFP_KERNEL);
> -		if (!urb) {
> -			kfree(buf);
> +		if (!alloc_rx_agg(tp, GFP_KERNEL))
>  			goto err1;
> -		}
> -
> -		INIT_LIST_HEAD(&tp->rx_info[i].list);
> -		tp->rx_info[i].context = tp;
> -		tp->rx_info[i].urb = urb;
> -		tp->rx_info[i].buffer = buf;
> -		tp->rx_info[i].head = rx_agg_align(buf);
>  	}
>  
>  	for (i = 0; i < RTL8152_MAX_TX; i++) {
> +		struct urb *urb;
> +		u8 *buf;
> +
>  		buf = kmalloc_node(agg_buf_sz, GFP_KERNEL, node);
>  		if (!buf)
>  			goto err1;
> @@ -2331,44 +2383,69 @@ static void rxdy_gated_en(struct r8152 *tp, bool enable)
>  
>  static int rtl_start_rx(struct r8152 *tp)
>  {
> -	int i, ret = 0;
> +	struct list_head *cursor, *next, tmp_list;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	INIT_LIST_HEAD(&tmp_list);
> +
> +	spin_lock_irqsave(&tp->rx_lock, flags);
>  
>  	INIT_LIST_HEAD(&tp->rx_done);
> -	for (i = 0; i < RTL8152_MAX_RX; i++) {
> -		INIT_LIST_HEAD(&tp->rx_info[i].list);
> -		ret = r8152_submit_rx(tp, &tp->rx_info[i], GFP_KERNEL);
> -		if (ret)
> -			break;
> -	}
>  
> -	if (ret && ++i < RTL8152_MAX_RX) {
> -		struct list_head rx_queue;
> -		unsigned long flags;
> +	list_splice_init(&tp->rx_info, &tmp_list);
>  
> -		INIT_LIST_HEAD(&rx_queue);
> +	spin_unlock_irqrestore(&tp->rx_lock, flags);
>  
> -		do {
> -			struct rx_agg *agg = &tp->rx_info[i++];
> -			struct urb *urb = agg->urb;
> +	list_for_each_safe(cursor, next, &tmp_list) {
> +		struct rx_agg *agg;
>  
> -			urb->actual_length = 0;
> -			list_add_tail(&agg->list, &rx_queue);
> -		} while (i < RTL8152_MAX_RX);
> +		agg = list_entry(cursor, struct rx_agg, info_list);
> +		INIT_LIST_HEAD(&agg->list);
>  
> -		spin_lock_irqsave(&tp->rx_lock, flags);
> -		list_splice_tail(&rx_queue, &tp->rx_done);
> -		spin_unlock_irqrestore(&tp->rx_lock, flags);
> +		if (ret < 0)
> +			list_add_tail(&agg->list, &tp->rx_done);
> +		else
> +			ret = r8152_submit_rx(tp, agg, GFP_KERNEL);
>  	}
>  
> +	spin_lock_irqsave(&tp->rx_lock, flags);
> +	WARN_ON(unlikely(!list_empty(&tp->rx_info)));
> +	list_splice(&tmp_list, &tp->rx_info);
> +	spin_unlock_irqrestore(&tp->rx_lock, flags);
> +
>  	return ret;
>  }
>  
>  static int rtl_stop_rx(struct r8152 *tp)
>  {
> -	int i;
> +	struct list_head *cursor, *next, tmp_list;
> +	unsigned long flags;
> +
> +	INIT_LIST_HEAD(&tmp_list);
>  
> -	for (i = 0; i < RTL8152_MAX_RX; i++)
> -		usb_kill_urb(tp->rx_info[i].urb);
> +	/* The usb_kill_urb() couldn't be used in atomic.
> +	 * Therefore, move the list of rx_info to a tmp one.
> +	 * Then, list_for_each_safe could be used without
> +	 * spin lock.
> +	 */

Would you mind explaining in a little more detail why taking the
entries from the list for a brief period of time is safe? 

> +	spin_lock_irqsave(&tp->rx_lock, flags);
> +	list_splice_init(&tp->rx_info, &tmp_list);
> +	spin_unlock_irqrestore(&tp->rx_lock, flags);
> +
> +	list_for_each_safe(cursor, next, &tmp_list) {
> +		struct rx_agg *agg;
> +
> +		agg = list_entry(cursor, struct rx_agg, info_list);
> +		usb_kill_urb(agg->urb);
> +	}
> +
> +	/* Move back the list of temp to the rx_info */
> +	spin_lock_irqsave(&tp->rx_lock, flags);
> +	WARN_ON(unlikely(!list_empty(&tp->rx_info)));
> +	list_splice(&tmp_list, &tp->rx_info);
> +	spin_unlock_irqrestore(&tp->rx_lock, flags);
>  
>  	while (!skb_queue_empty(&tp->rx_queue))
>  		dev_kfree_skb(__skb_dequeue(&tp->rx_queue));

