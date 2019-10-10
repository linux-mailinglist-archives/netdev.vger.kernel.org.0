Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE9D22CD
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 10:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732038AbfJJIbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 04:31:07 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:38469 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728388AbfJJIbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 04:31:06 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4297A256;
        Thu, 10 Oct 2019 04:31:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 10 Oct 2019 04:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xsUOza
        J+mm91F/hVF+eizlZ27D/IbsHgyxHhF/xxboc=; b=tQP+ej1sLOj8FGFxoOgDva
        edWBFbwlJskqr8b8UNSpPnLtt+EnANO2bD3b1RqLbcpTbbnw61yALRY0sdoI/Q1Z
        DlIcmxg7v78NW0h9/zL8633663zTRyAYJOb/Y0avAL3fV530GUstJnmJrv7sk4Oe
        4fGgdtoIAUtc3UuWiUtKomgl2mcIg2dNe4n+1lTladBxu2Ol/YUciYjJelMGQrdi
        F6nB3tsif+N2mpS/H/KqNLTAygMqmebiUD/BSwWlg9lK+JsoQQ8NY3uMc0nIG2W3
        CmTuFGUcsR/NPIZvQV/CYgKfOmEtQtmzbq9I0US+SEt4U99e2Uv/clNYUfO88Pbw
        ==
X-ME-Sender: <xms:SOyeXeKAh9eOsKbQrZue2syxMuc7fAz-Vnaei40GF6S1pX9RrYeJzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieefgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:SOyeXcBv29AOZCYK1cqPzBuPV1lc1LGpEfDcVS9q516skQxSM5xRdA>
    <xmx:SOyeXZ6rXbEF8bZplreagGU0dfvhdHAo6uLm3bNzrJ8KaPe3x88Mkw>
    <xmx:SOyeXdeKzz5GHPBzvoZhCEiRWC9E6XSQ90lvPt_URwqvrXH4SyQhXw>
    <xmx:SOyeXRG195cuZ4EJBcFR_6ip9WtCC2ixDNj3pFD2BRXjWFB6BeAUOw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1EBF280062;
        Thu, 10 Oct 2019 04:31:03 -0400 (EDT)
Date:   Thu, 10 Oct 2019 11:31:02 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jesse Hathaway <jesse@mbuki-mvuki.org>
Cc:     netdev@vger.kernel.org
Subject: Re: Race condition in route lookup
Message-ID: <20191010083102.GA1336@splinter>
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 11:00:07AM -0500, Jesse Hathaway wrote:
> We have been experiencing a route lookup race condition on our internet facing
> Linux routers. I have been able to reproduce the issue, but would love more
> help in isolating the cause.
> 
> Looking up a route found in the main table returns `*` rather than the directly
> connected interface about once for every 10-20 million requests. From my
> reading of the iproute2 source code an asterisk is indicative of the kernel
> returning and interface index of 0 rather than the correct directly connected
> interface.
> 
> This is reproducible with the following bash snippet on 5.4-rc2:
> 
>   $ cat route-race
>   #!/bin/bash
> 
>   # Generate 50 million individual route gets to feed as batch input to `ip`
>   function ip-cmds() {
>           route_get='route get 192.168.11.142 from 192.168.180.10 iif vlan180'
>           for ((i = 0; i < 50000000; i++)); do
>                   printf '%s\n' "${route_get}"
>           done
> 
>   }
> 
>   ip-cmds | ip -d -o -batch - | grep -E 'dev \*' | uniq -c
> 
> Example output:
> 
>   $ ./route-race
>         6 unicast 192.168.11.142 from 192.168.180.10 dev * table main
> \    cache iif vlan180
> 
> These routers have multiple routing tables and are ingesting full BGP routing
> tables from multiple ISPs:
> 
>   $ ip route show table all | wc -l
>   3105543
> 
>   $ ip route show table main | wc -l
>   54
> 
> Please let me know what other information I can provide, thanks in advance,

I think it's working as expected. Here is my theory:

If CPU0 is executing both the route get request and forwarding packets
through the directly connected interface, then the following can happen:

<CPU0, t0> - In process context, per-CPU dst entry cached in the nexthop
is found. Not yet dumped to user space

<Any CPU, t1> - Routes are added / removed, therefore invalidating the
cache by bumping 'net->ipv4.rt_genid'

<CPU0, t2> - In softirq, packet is forwarded through the nexthop. The
cached dst entry is found to be invalid. Therefore, it is replaced by a
newer dst entry. dst_dev_put() is called on old entry which assigns the
blackhole netdev to 'dst->dev'. This netdev has an ifindex of 0 because
it is not registered.

<CPU0, t3> - After softirq finished executing, your route get request
from t0 is resumed and the old dst entry is dumped to user space with
ifindex of 0.

I tested this on my system using your script to generate the route get
requests. I pinned it to the same CPU forwarding packets through the
nexthop. To constantly invalidate the cache I created another script
that simply adds and removes IP addresses from an interface.

If I stop the packet forwarding or the script that invalidates the
cache, then I don't see any '*' answers to my route get requests.

BTW, the blackhole netdev was added in 5.3. I assume (didn't test) that
with older kernel versions you'll see 'lo' instead of '*'.
