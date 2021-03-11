Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B22337F3C
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 21:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhCKUr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 15:47:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhCKUrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 15:47:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D9764F6B;
        Thu, 11 Mar 2021 20:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615495626;
        bh=qe/hn8Lsht+gnx4Bgt48aM5Ghu1TjBpPO2EuJX7ynQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lhUK1xw8z2aJCvBH+NnpFX4gtq3a5dr/d654ugBAzFKEalJWSgO+Igrsf2JKbO9g5
         sUDlyzoxx0m4DN7u9d+HhngPyiiaGtndkAmIaQhbM9KT+73mnQ/e6pz63N3Dv5YxCP
         RoyiabEUJRyEkfjK2B5R4L6414HT4ul0Bn5b/ycM4tRhwE3ftItTZxWVk6j1dde/Ap
         7icWCk4VT0tB5Hk0jWXN80K36JKCqTvO/jzf+8m3JSogDszmgHyCwx9z7l8nwVS4hK
         sIIndNq/QGV4Fe/xmxTNyC/0C2UJ7DILsCCAG/V7JLMkNbpP4ld9yGYDzpvAJmz+Gi
         Hpo1+UWd5pjoA==
Date:   Thu, 11 Mar 2021 12:47:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 00/23] netfilter: flowtable enhancements
Message-ID: <20210311124705.0af44b8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 01:35:41 +0100 Pablo Neira Ayuso wrote:
> The following patchset augments the Netfilter flowtable fastpath to
> support for network topologies that combine IP forwarding, bridge,
> classic VLAN devices, bridge VLAN filtering, DSA and PPPoE. This
> includes support for the flowtable software and hardware datapaths.
> 
> The following pictures provides an example scenario:
> 
>                         fast path!
>                 .------------------------.
>                /                          \
>                |           IP forwarding  |
>                |          /             \ \/
>                |       br0               wan ..... eth0
>                .       / \                         host C
>                -> veth1  veth2  
>                    .           switch/router
>                    .
>                    .
>                  eth0
> 		host A
> 
> The bridge master device 'br0' has an IP address and a DHCP server is
> also assumed to be running to provide connectivity to host A which
> reaches the Internet through 'br0' as default gateway. Then, packet
> enters the IP forwarding path and Netfilter is used to NAT the packets
> before they leave through the wan device.
> 
> The general idea is to accelerate forwarding by building a fast path
> that takes packets from the ingress path of the bridge port and place
> them in the egress path of the wan device (and vice versa). Hence,
> skipping the classic bridge and IP stack paths.

And how did you solve the invalidation problem?
