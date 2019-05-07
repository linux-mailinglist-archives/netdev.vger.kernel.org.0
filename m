Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78C5F15819
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 05:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfEGDlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 23:41:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45111 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfEGDlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 23:41:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id i21so7525171pgi.12
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 20:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B4+PZsdWqrjOI3MvXiyuGrVMVJfHfgA5la24b8mu6G8=;
        b=VM1b1BasAXh/Y4MsAwyQlj9NSAzm1Egb/4+hce5VELm0xzTVs7NkwmOMO0lfSChv9F
         yr0hCQaseiOedCwaNOiduY540Yqwt3bn30F95jHkoQo3lgg3lry5SWmyg1zG5cplDs8F
         P9r+KN5Sq1qs6Ief3Nv85QyzAnIToMfz+hoEpDCJJ7rPPV2fCne8mznozsRgWkee2h6E
         MwTq9vMDJYwy+IVnFvvnsymaCnNsG7zswIpiCdkx5fwEEQZRRBHZh/BCCxcjtYR9NMpg
         x6oAMpTI3SEVcUqAWrGCIAWQrhF68m/0IfbnpHh1cC+uLisov2cF/Eg9PawC1dhW07pC
         JHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B4+PZsdWqrjOI3MvXiyuGrVMVJfHfgA5la24b8mu6G8=;
        b=C3JWx5J9HLtNUKi2Io6+gxEcFGHG/zU4HP6D7KkeLN/6QNibvuxX1uYXk70fom6bwh
         jBC2AeScXfFzrxl76pGSmNx7iAEBPeNa5+tOreNk8DH3fLaoHep1UcDRAf2cH094X91o
         dpMY7gZHNWziFdv7DxF2CthoihuaXOOHSpcHiytzjY3w0+TcMdGCNnT/L4mnvh5usxSZ
         iPzHaOSVJjIf0z5ChB9N21faVp9XQ3zQrnZ4SpSusMLLKKNU1fvTGkdE4j3GNtTsix43
         pVoOrIk9cTlWSEAVjZY98cz5u5MGQ7ypoukOwl9QoniLntsLIr6xMRX7xt+wXkwaTJn/
         GFZw==
X-Gm-Message-State: APjAAAUywJkKPfZw+lPefS/31Svv75SqtO1qX+8GYVXRecmaUI6NBQQ2
        iBJJ7TAKlXWCEGGvx/fvhbM=
X-Google-Smtp-Source: APXvYqzqZFOcdif+ZqWjsG33Rtb1iNe8H+QO9WLP5E8Xo6eqayfUugAl7m+3iPBYrAg1rg18sJWz3w==
X-Received: by 2002:a62:e117:: with SMTP id q23mr38432918pfh.60.1557200473344;
        Mon, 06 May 2019 20:41:13 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id e8sm21265496pfc.47.2019.05.06.20.41.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 20:41:11 -0700 (PDT)
Subject: Re: [PATCH net] tuntap: synchronize through tfiles array instead of
 tun->numqueues
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     mst@redhat.com, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>
References: <1557199416-55253-1-git-send-email-jasowang@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7b9744b4-42ec-7d0a-20ff-d65f71b16c63@gmail.com>
Date:   Mon, 6 May 2019 20:41:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557199416-55253-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/6/19 11:23 PM, Jason Wang wrote:
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
> Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/tun.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index e9ca1c0..a64c928 100644
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
> @@ -1306,13 +1308,13 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>  	rcu_read_lock();
>  
>  	numqueues = READ_ONCE(tun->numqueues);
> -	if (!numqueues) {
> -		rcu_read_unlock();
> -		return -ENXIO; /* Caller will free/return all frames */
> -	}
>  

If you remove the test on (!numqueues),
the following might crash with a divide by zero...

>  	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
>  					    numqueues]);

