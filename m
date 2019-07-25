Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6587874F8B
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387959AbfGYNds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:33:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52351 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfGYNdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:33:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id s3so45017114wms.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 06:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=U+dLjEf1u94onlzPHtYLzX6YYU/MqKMGMSUygWmmq7o=;
        b=TgLed18jiWpMlH7QEBFZCmoMCVBWqYimXqrMbZRHkdJ8SJXQKIk8W1YtLBSAG0OFkq
         SbUiuCckWsjmV3XSbZAHwOmJAkMB+2OMr/7n735ICLwwApujkWcSDBIuerOMjlWcOmwP
         l4Sdf7tiA+OanTdbxdppAz+OyMqREKOuMYdQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U+dLjEf1u94onlzPHtYLzX6YYU/MqKMGMSUygWmmq7o=;
        b=coYB/jS3G18T/PTcFiq/rlkXvzIdjuznllvdmpInmGz21gJXECRDOOATt/x379HG5N
         Jc+vHrrqQ4BvEgb+IPMDa3iueroWTFKlKR4gq3fn6L6XdRodR+iZHb3+Ees3Kn4t3CeM
         wt+jLvY6CjR/jyOp+Y0qilWgOEnYpMT8QjEfhb+HP50HftzIT2FflWP8/pRsWZaRIdp7
         cXgQ8FBri5l5qBjVpW5ERrG0zKQn0yZKLh26DB09fQMBlILcXFPbReht+NmZoNu4Xuox
         vrAkJfsvFXe6uzn+CUXG2kx6xWWmlozHcjtvlHzJEVe9CBX+d7QCq7ZIWrnbqrtnmr+D
         U9OA==
X-Gm-Message-State: APjAAAUYifkVWMjDLdpncF1pffCmnASSDxSEhhz712oCGDsm1/7LJTlp
        JDtP8FaFyv6BRiZOlInT/JjLlQ==
X-Google-Smtp-Source: APXvYqzUi5WFrE2+eAUYjEGdYJ87YceB4K/Ob0SCx6t+a28s5UAaYHJsZDK3Oaep/g88VrKK2IrMjw==
X-Received: by 2002:a7b:ce83:: with SMTP id q3mr83185351wmj.116.1564059964769;
        Thu, 25 Jul 2019 06:06:04 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id i13sm42718497wrr.73.2019.07.25.06.06.03
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 06:06:04 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
Date:   Thu, 25 Jul 2019 16:06:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2019 14:44, Horatiu Vultur wrote:
> There is no way to configure the bridge, to receive only specific link
> layer multicast addresses. From the description of the command 'bridge
> fdb append' is supposed to do that, but there was no way to notify the
> network driver that the bridge joined a group, because LLADDR was added
> to the unicast netdev_hw_addr_list.
> 
> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
> and if the source is NULL, which represent the bridge itself. Then add
> address to multicast netdev_hw_addr_list for each bridge interfaces.
> And then the .ndo_set_rx_mode function on the driver is called. To notify
> the driver that the list of multicast mac addresses changed.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 46 insertions(+), 3 deletions(-)
> 

Hi,
I'm sorry but this patch is wrong on many levels, some notes below. In general
NLM_F_APPEND is only used in vxlan, the bridge does not handle that flag at all.
FDB is only for *unicast*, nothing is joined and no multicast should be used with fdbs.
MDB is used for multicast handling, but both of these are used for forwarding.
The reason the static fdbs are added to the filter is for non-promisc ports, so they can
receive traffic destined for these FDBs for forwarding.
If you'd like to join any multicast group please use the standard way, if you'd like to join
it only on a specific port - join it only on that port (or ports) and the bridge and you'll
have the effect that you're describing. What do you mean there's no way ?

In addition you're allowing a mix of mcast functions to be called with unicast addresses
and vice versa, it is not that big of a deal because the kernel will simply return an error
but still makes no sense.

Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index b1d3248..d93746d 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>  	}
>  }
>  
> +static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
> +{
> +	int err;
> +	struct net_bridge_port *p;
> +
> +	ASSERT_RTNL();
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		if (!br_promisc_port(p)) {
> +			err = dev_mc_add(p->dev, addr);
> +			if (err)
> +				goto undo;
> +		}
> +	}
> +
> +	return;
> +undo:
> +	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
> +		if (!br_promisc_port(p))
> +			dev_mc_del(p->dev, addr);
> +	}
> +}
> +
>  /* When a static FDB entry is deleted, the HW address from that entry is
>   * also removed from the bridge private HW address list and updates all
>   * the ports with needed information.
> @@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>  	}
>  }
>  
> +static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
> +{
> +	struct net_bridge_port *p;
> +
> +	ASSERT_RTNL();
> +
> +	list_for_each_entry(p, &br->port_list, list) {
> +		if (!br_promisc_port(p))
> +			dev_mc_del(p->dev, addr);
> +	}
> +}
> +
>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>  		       bool swdev_notify)
>  {
>  	trace_fdb_delete(br, f);
>  
> -	if (f->is_static)
> +	if (f->is_static) {
>  		fdb_del_hw_addr(br, f->key.addr.addr);
> +		fdb_del_hw_maddr(br, f->key.addr.addr);

Walking over all ports again for each static delete is a no-go.

> +	}
>  
>  	hlist_del_init_rcu(&f->fdb_node);
>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
> @@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>  			fdb->is_local = 1;
>  			if (!fdb->is_static) {
>  				fdb->is_static = 1;
> -				fdb_add_hw_addr(br, addr);
> +				if (flags & NLM_F_APPEND && !source)
> +					fdb_add_hw_maddr(br, addr);
> +				else
> +					fdb_add_hw_addr(br, addr);
>  			}
>  		} else if (state & NUD_NOARP) {
>  			fdb->is_local = 0;
>  			if (!fdb->is_static) {
>  				fdb->is_static = 1;
> -				fdb_add_hw_addr(br, addr);
> +				if (flags & NLM_F_APPEND && !source)
> +					fdb_add_hw_maddr(br, addr);
> +				else
> +					fdb_add_hw_addr(br, addr);
>  			}
>  		} else {
>  			fdb->is_local = 0;
> 

