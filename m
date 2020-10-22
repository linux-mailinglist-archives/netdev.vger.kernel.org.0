Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59874295C9F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896450AbgJVKY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896431AbgJVKY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:24:26 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DC4C0613CF
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 03:24:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 13so1392611wmf.0
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 03:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/yj2rbbQBTkccNot+4ztSL0oINISL4HD8xkeO52XNZM=;
        b=Wn64FWlnY8/HVIlOpxkjCGjT//turhz2yOZ3EY/vf7AhDnvUAMiRRhwuianc8aLC+p
         jfjnnRSXLvRazZFS7aOjvx/VnUchJjV8d5x14no1Xd9XXBNpCvDpZdZnss5zLveHTSj+
         b/FVVkFsqHnMdEXCdf0oUHnCktIx8EQGjgfl+AZ4rXKfYZ3LNLXDkl3FjURAS03aXtkn
         9IaDDHoCurBfiygMi06Fl5GPdhLjLWsVZZzEpzXzCj0uyZFALlzAMd9k+8XdbU1953FT
         mZxCRRTzmPRDKJsr36Ot7H/LVQpPnvPTMbIuMmILt08I/w5zsFP1WuHVD5chBFCti0BW
         AXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=/yj2rbbQBTkccNot+4ztSL0oINISL4HD8xkeO52XNZM=;
        b=bLFS4n8MLgW/rWUlLUR7ZaCydWi2SExBPq1whA4KO5bmEy0f1+xo0S4sn/dur1Mmp3
         vnvu7+14C44NfHxnM5tI0N5yMuaz47y0VAF2pdLGEJFwMeulCHZwfir6Z31IrzBe/pHV
         q+Fu+qVz0Xke8IT7sH6vQsRqRznXGpZRo/WSICtomRG0JAdYa9a0gN9RGet4zsfUhwIg
         vspdHlxPJP9DolJUgsLZNfT99x9XdLlXGrQmSWsOt7d03o2kG4N6KO97OiFmZggzPFmC
         G/XsBSjwGljm9dosLu2GZaVgALHDtaU4t1GTmHHZoU/raf3fvolIR5XmdekK4Jnhnhrh
         hDuw==
X-Gm-Message-State: AOAM530Gq5pkdFbBjoRb+LqmcYsTXsQKWRx6tD6TEf6+MeEa40DTNHqP
        jeohhFjONwVnidrgh0TR4kfh+g==
X-Google-Smtp-Source: ABdhPJzk60Z9E5p7HQXp7eVUqpPQVts4rnUUTUaxweOC3NP3BzfEO75TRSyt6HpQnsEK0LNZGWluZA==
X-Received: by 2002:a7b:cb98:: with SMTP id m24mr1939467wmi.133.1603362263550;
        Thu, 22 Oct 2020 03:24:23 -0700 (PDT)
Received: from debil (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id p9sm2695332wma.12.2020.10.22.03.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 03:24:22 -0700 (PDT)
Message-ID: <a0d79083b43d212351d56718a0ec40d8e9b4888b.camel@blackwall.org>
Subject: Re: [PATCH net-next,v2 4/9] bridge: resolve forwarding path for
 bridge devices
From:   Nikolay Aleksandrov <razor@blackwall.org>
Reply-To: razor@blackwall.org
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Date:   Thu, 22 Oct 2020 13:24:21 +0300
In-Reply-To: <20201015163038.26992-5-pablo@netfilter.org>
References: <20201015163038.26992-1-pablo@netfilter.org>
         <20201015163038.26992-5-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-15 at 18:30 +0200, Pablo Neira Ayuso wrote:
> Add .ndo_fill_forward_path for bridge devices.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: no changes
> 
>  include/linux/netdevice.h |  1 +
>  net/bridge/br_device.c    | 22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d4263ed5dd79..4cabdbc672d3 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -836,6 +836,7 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
>  enum net_device_path_type {
>  	DEV_PATH_ETHERNET = 0,
>  	DEV_PATH_VLAN,
> +	DEV_PATH_BRIDGE,
>  };
>  
>  struct net_device_path {
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index 6f742fee874a..06046a35868d 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -391,6 +391,27 @@ static int br_del_slave(struct net_device *dev, struct net_device *slave_dev)
>  	return br_del_if(br, slave_dev);
>  }
>  
> +static int br_fill_forward_path(struct net_device_path_ctx *ctx,
> +				struct net_device_path *path)
> +{
> +	struct net_bridge_fdb_entry *f;
> +	struct net_bridge *br;
> +
> +	if (netif_is_bridge_port(ctx->dev))
> +		return -1;
> +
> +	br = netdev_priv(ctx->dev);
> +	f = br_fdb_find_rcu(br, ctx->daddr, 0);
> +	if (!f || !f->dst)
> +		return -1;
> +
> +	path->type = DEV_PATH_BRIDGE;
> +	path->dev = f->dst->br->dev;
> +	ctx->dev = f->dst->dev;

Please use READ_ONCE() for f->dst since it can become NULL if the entry
is changed to point to the bridge device itself after the check above. I've had
a patch in my queue that changes the bridge to use WRITE_ONCE() to annotate it
as a lockless read.

Thanks,
 Nik

> +
> +	return 0;
> +}
> +
>  static const struct ethtool_ops br_ethtool_ops = {
>  	.get_drvinfo		 = br_getinfo,
>  	.get_link		 = ethtool_op_get_link,
> @@ -425,6 +446,7 @@ static const struct net_device_ops br_netdev_ops = {
>  	.ndo_bridge_setlink	 = br_setlink,
>  	.ndo_bridge_dellink	 = br_dellink,
>  	.ndo_features_check	 = passthru_features_check,
> +	.ndo_fill_forward_path	 = br_fill_forward_path,
>  };
>  
>  static struct device_type br_type = {


