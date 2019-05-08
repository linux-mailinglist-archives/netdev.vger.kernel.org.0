Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979BA16FE0
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 06:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfEHEQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 00:16:15 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36674 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfEHEQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 00:16:14 -0400
Received: by mail-qk1-f194.google.com with SMTP id c14so285239qke.3
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 21:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IZrISjnTH3+th9zbZuIHlGxFs+vBvqW81DWxpAAqNTI=;
        b=qwnZdwQMLZ2sGfsU4Xpw9i0LbZAzTX/IaPM+ZNBi6vEvv1Sc60KySHWPvoz3PhnLe2
         yp3SnzZzaf+65ozho+NRc0kMb2hGY1vzij/8Gm/aaUMH7HKk+mj/s6o+PjK7sdqu+y2M
         09F1PhbikLO16HBwFd9Uq1SwsbshMHggOmZHgPcb+n+EWv5RCMP9jH+E4IvBNlsmo7+G
         H55QyrnLxKPK3dTQd0I9G6chVPOh2zhxLh0bluY+ae35Ftctc4Uah1eIpIvVYnZb8iz+
         LlubHZaHSNEfHFK8cfiReu7XEPz8OR58vhpgKe4uVU34tPEH/AGGqm/yrZRnPfc9HQlq
         +SsQ==
X-Gm-Message-State: APjAAAXb3Xxdpk17Ztcy5v9Wmu0k6cEoGgsGPySImIGnxam+M9jm4aio
        PpURkMnN3JtUDfYMvFu55MeH5g==
X-Google-Smtp-Source: APXvYqxKO8nO8IbDUZfIm1V2fKJiKjWdF5+sqUr/5SLJTcJm0KkppVJQ2X6//aPr+vTvs/q2nGkvZQ==
X-Received: by 2002:a05:620a:34b:: with SMTP id t11mr28384109qkm.279.1557288973944;
        Tue, 07 May 2019 21:16:13 -0700 (PDT)
Received: from redhat.com (pool-173-76-105-71.bstnma.fios.verizon.net. [173.76.105.71])
        by smtp.gmail.com with ESMTPSA id a7sm1301785qkl.60.2019.05.07.21.16.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 21:16:13 -0700 (PDT)
Date:   Wed, 8 May 2019 00:16:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
Message-ID: <20190508001518-mutt-send-email-mst@kernel.org>
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 07, 2019 at 12:03:36AM -0400, Jason Wang wrote:
> When a queue(tfile) is detached through __tun_detach(), we move the
> last enabled tfile to the position where detached one sit but don't
> NULL out last position. We expect to synchronize the datapath through
> tun->numqueues. Unfortunately, this won't work since we're lacking
> sufficient mechanism to order or synchronize the access to
> tun->numqueues.
> 
> To fix this, NULL out the last position during detaching and check
> RCU protected tfile against NULL instead of checking tun->numqueues in
> datapath.
> 
> Cc: YueHaibing <yuehaibing@huawei.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: weiyongjun (A) <weiyongjun1@huawei.com>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> Changes from V1:
> - keep the check in tun_xdp_xmit()
> ---
>  drivers/net/tun.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index e9ca1c0..32a0b23 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>  				   tun->tfiles[tun->numqueues - 1]);
>  		ntfile = rtnl_dereference(tun->tfiles[index]);
>  		ntfile->queue_index = index;
> +		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
> +				   NULL);
>  
>  		--tun->numqueues;
>  		if (clean) {
> @@ -1082,7 +1084,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	tfile = rcu_dereference(tun->tfiles[txq]);
>  
>  	/* Drop packet if interface is not attached */
> -	if (txq >= tun->numqueues)
> +	if (!tfile)
>  		goto drop;
>  
>  	if (!rcu_dereference(tun->steering_prog))

Hmm don't we need to range check txq?


> @@ -1313,6 +1315,10 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>  
>  	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
>  					    numqueues]);
> +	if (!tfile) {
> +		rcu_read_unlock();
> +		return -ENXIO; /* Caller will free/return all frames */
> +	}
>  
>  	spin_lock(&tfile->tx_ring.producer_lock);
>  	for (i = 0; i < n; i++) {
> -- 
> 1.8.3.1
