Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91790424F3
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405914AbfFLMCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:02:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:43208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405097AbfFLMCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 08:02:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7839CB026;
        Wed, 12 Jun 2019 12:02:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5DAF9E00E3; Wed, 12 Jun 2019 14:02:16 +0200 (CEST)
Date:   Wed, 12 Jun 2019 14:02:16 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     davem@davemloft.net, dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ipoib: show VF broadcast address
Message-ID: <20190612120216.GH31797@unicorn.suse.cz>
References: <20190612113348.59858-1-dkirjanov@suse.com>
 <20190612113348.59858-4-dkirjanov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612113348.59858-4-dkirjanov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 01:33:48PM +0200, Denis Kirjanov wrote:
> in IPoIB case we can't see a VF broadcast address for but
> can see for PF
> 
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
> trust off, query_rss off
> ...
> 
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>     vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
> ...
> 
> Signed-off-by: Denis Kirjanov <dkirjanov@suse.com>
> ---
>  net/core/rtnetlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 2e1b9ffbe602..f70902b57a40 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1248,6 +1248,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
>  	if (!vf)
>  		goto nla_put_vfinfo_failure;
>  	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
> +	    nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast) ||
>  	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
>  	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
>  		    &vf_rate) ||

This doesn't seem right, IFLA_BROADCAST is 2 which is the same as
IFLA_VF_VLAN. You should add a new constant in the same enum as other
IFLA_VF_* attribute types expected in this context. You should then also
add an entry to ifla_vf_policy and account for the new attribute size in
rtnl_vfinfo_size().

Michal
