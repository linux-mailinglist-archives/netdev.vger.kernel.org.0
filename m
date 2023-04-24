Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD346ED3A1
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjDXRgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjDXRgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:36:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F41B8A7B
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 10:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 775166276F
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 17:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A96BC433EF;
        Mon, 24 Apr 2023 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682357766;
        bh=pDfChoxmfYCrko5Slc+lKPS62kghy42BpYvUJU8Gr8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEPdhYXnl7b5+YVKFlbIuUvq0jiPtTBTZXHiPWP5iPdf+z0wnj9sV+Ve1P8XRiOWJ
         X2CjxSj1Q2LYjVWtUUuyOKYU9RJdCt1xxsIFyFwMOgLYmvCXL0eFjMXvNZNBubNMAv
         FxCEopSGVamZJQuNq8DSC9n7n5uFNpi9LRC6t5zQShhtX5ylI5BhForit0YZh8hge1
         CADMXAHarrHnnTAaYc/Divvcpuy3wgL/uV/Ibb8Ft2IM96k8LGuJxNBNk5oaBuETGX
         hVidBc+x0WI5SoKxEw0jw/K3m/lLncFPKqkc8Z6WchD65N9N62HbbSj1KHPd0TW8Cu
         O68XuvLOs327A==
Date:   Mon, 24 Apr 2023 20:36:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kernel@mojatatu.com
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
Message-ID: <20230424173602.GA27649@unreal>
References: <20230424170832.549298-1-victor@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424170832.549298-1-victor@mojatatu.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 05:08:32PM +0000, Victor Nogueira wrote:
> There are cases where the device is adminstratively UP, but operationally 
> down. For example, we have a physical device (Nvidia ConnectX-6 Dx, 25Gbps)
> who's cable was pulled out, here is its ip link output:
> 
> 5: ens2f1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
>     link/ether b8:ce:f6:4b:68:35 brd ff:ff:ff:ff:ff:ff
>     altname enp179s0f1np1
> 
> As you can see, it's administratively UP but operationally down.
> In this case, sending a packet to this port caused a nasty kernel hang (so
> nasty that we were unable to capture it). Aborting a transmit based on
> operational status (in addition to administrative status) fixes the issue.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 

Please no blank line between tags.

> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> ---
>  net/sched/act_mirred.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It will be great to have changelog to see the changes between versions.

Thanks

> 
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index ec43764e92e7..0a711c184c29 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -264,7 +264,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
>  		goto out;
>  	}
>  
> -	if (unlikely(!(dev->flags & IFF_UP))) {
> +	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
>  		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
>  				       dev->name);
>  		goto out;
> -- 
> 2.25.1
> 
