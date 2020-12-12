Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CE52D8A75
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 23:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408120AbgLLWvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 17:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:38178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLWvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 17:51:04 -0500
Date:   Sat, 12 Dec 2020 14:50:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607813423;
        bh=u+hGxbaXkNMWfXeyoSRrs6XQjgrEFniY7s844WPHHws=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=gr4TJbz0l0t5dZpP8hVTM5Lt79hyy7+0D/8jL3NA4jy673PuPBiZ5yJqste+FfHNv
         UpVTVnCPQc3Cbm7yCdBYiVZO80b660NZ8DSv6q6PTk7gxj/w6ff6u+bvtgB4+Avl6H
         ryOd6eMFHLgaY7330DLln8yLY+SqdZlJrzKceq/uyCMa0njhaKIPQjaPV4sz13E7yS
         jTibWVrEZjqZp9jrG9QZCI5998z8p0rBwxj8c4LzWuso1Qusehww9efp/cgwH/3iSj
         kKkhGiitHRQLZ882GbyplqDgH+WpG71HTL8XdJibgXdNG6KAHtrenFTLZlRcxAf8CT
         F4hhut8aD4csg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
Message-ID: <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201209005444.1949356-3-weiwan@google.com>
References: <20201209005444.1949356-1-weiwan@google.com>
        <20201209005444.1949356-3-weiwan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 16:54:43 -0800 Wei Wang wrote:
> This patch allows running each napi poll loop inside its own
> kernel thread.
> The threaded mode could be enabled through napi_set_threaded()
> api, and does not require a device up/down. The kthread gets
> created on demand when napi_set_threaded() is called, and gets
> shut down eventually in napi_disable().
> 
> Once that threaded mode is enabled and the kthread is
> started, napi_schedule() will wake-up such thread instead
> of scheduling the softirq.
> 
> The threaded poll loop behaves quite likely the net_rx_action,
> but it does not have to manipulate local irqs and uses
> an explicit scheduling point based on netdev_budget.
> 
> Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

> @@ -4234,6 +4265,11 @@ int gro_normal_batch __read_mostly = 8;
>  static inline void ____napi_schedule(struct softnet_data *sd,
>  				     struct napi_struct *napi)
>  {
> +	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
> +		wake_up_process(napi->thread);

FTR your implementation depends on the fact that this is the only
place that can wake the worker and not set kthread_should_stop().
Which I trust you is the case :) maybe I already mentioned this..

> +		return;
> +	}
> +
>  	list_add_tail(&napi->poll_list, &sd->poll_list);
>  	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
>  }

>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>  		    int (*poll)(struct napi_struct *, int), int weight)
>  {
> @@ -6731,6 +6790,7 @@ void napi_disable(struct napi_struct *n)
>  		msleep(1);
>  
>  	hrtimer_cancel(&n->timer);
> +	napi_kthread_stop(n);

I'm surprised that we stop the thread on napi_disable() but there is no
start/create in napi_enable(). NAPIs can (and do get) disabled and
enabled again. But that'd make your code crash with many popular
drivers if you tried to change rings with threaded napi enabled so I
feel like I must be missing something..

>  	clear_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state);
>  	clear_bit(NAPI_STATE_DISABLE, &n->state);

