Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030DF2A5BDF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgKDB0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgKDB0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:26:48 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE2720870;
        Wed,  4 Nov 2020 01:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604453207;
        bh=zRz7lN2mWm7XjA4D67Aa4p2jJ4PcqfE06/L1N+87SUQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ECJMSBJpta1OwFaiD5gYUv+edD2IUQluloF4EvbJAlQnePAcbITLz98yJAuspKrSV
         cA6Q7SX/E6YIuwctK/pBlbzJMHl2I1A5zy4juSjDcugbO2g8nD0voUN8QeU+n3T3vg
         c7LluP+QHPlY2gmc/QAlXaF2m1AlZetu8E9CUh6s=
Date:   Tue, 3 Nov 2020 17:26:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: allow virtual netdevs to forward
 UDP L4 and fraglist GSO skbs
Message-ID: <20201103172646.30dc9502@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <NysZRGMkuWq0KPTCJ1Dz2FTjRkeJXDH3edVrsEeJkQI@cp4-web-036.plabs.ch>
References: <NysZRGMkuWq0KPTCJ1Dz2FTjRkeJXDH3edVrsEeJkQI@cp4-web-036.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 01 Nov 2020 13:16:32 +0000 Alexander Lobakin wrote:
> NETIF_F_GSO_UDP_L4 and NETIF_F_GSO_FRAGLIST allow drivers to offload
> GSO UDP L4. This works well on simple setups, but when any logical
> netdev (e.g. VLAN) is present, kernel stack always performs software
> resegmentation which actually kills the performance.
> 
> The full path in such cases is like:
> 1. Our NIC driver advertises a support for fraglists, GSO UDP L4, GSO
>    fraglists.
> 2. User enables fraglisted GRO via Ethtool.
> 3. GRO subsystem receives UDP frames from driver and merges the packets
>    into fraglisted GSO skb(s).
> 4. Networking stack queues it up for xmitting.
> 5. Virtual device like VLAN doesn't advertise a support for GSO UDP L4
>    and GSO fraglists, so skb_gso_check() doesn't allow to pass this skb
>    as is to the real driver.
> 6. Kernel then has to form a bunch of regular UDP skbs from that one and
>    pass it to the driver instead. This fallback is *extremely* slow for
>    any GSO types, but especially for GSO fraglists.
> 7. All further processing performs with a series of plain UDP skbs, and
>    the driver gets it one-by-one, despite that it supports UDP L4 and
>    fraglisted GSO.
> 
> That's not OK because:
> a) logical/virtual netdevs like VLANs, bridges etc. should pass GSO skbs
>    as is;
> b) even if the final driver doesn't support such type of GSO, this
>    software resegmenting should be performed right before it, not in the
>    middle of processing -- I think I even saw that note somewhere in
>    kernel documentation, and it's totally reasonable in terms of
>    performance.
> 
> Despite the fact that no mainline drivers currently supports fraglist
> GSO, this should and can be easily fixed by adding UDP L4 and fraglist
> GSO to the list of GSO types that can be passed-through the logical
> interfaces (NETIF_F_GSO_SOFTWARE). After this change, no resegmentation
> occurs (if a particular driver supports and advertises this), and the
> performance goes on par with e.g. 1:1 forwarding.
> The only logical netdevs that seem to be unaffected to this are bridge
> interfaces, as their code uses full NETIF_F_GSO_MASK.
> 
> Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
> 20 Mbps baseline, 1 Gbps / link speed with this patch.
> 
> Since v1 [1]:
>  - handle bonding and team drivers as suggested by Willem de Bruijn;
>  - reword and expand the introduction with the particular example. 
> 
> [1] https://lore.kernel.org/netdev/Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch


Applied, thanks!
