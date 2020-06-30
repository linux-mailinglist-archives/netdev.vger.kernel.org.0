Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D1020EE34
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgF3GWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgF3GWi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 02:22:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49F1220672;
        Tue, 30 Jun 2020 06:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593498157;
        bh=7+RrcvhYNnvBS5xQ+Jw+mqaq070fEazR3lmUkNoMyk0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JqErRIeG3gErBT4GcWaIKxpVGt0a1r62j0OiYioalEZ5f8fEOGcz5S1MosTt7Tfh8
         Yzxo8CqGU6kzStU5Yk8LDciDeNvOb0VHCcd8ewTk/WmVe1kTfGtBVLC0Ud8tc1OXLl
         PjT9KYO2fOAsSOcU4BhOa6pOK6h8DzQVb2aFADzc=
Date:   Mon, 29 Jun 2020 23:22:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
Message-ID: <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200625224435.GA2325089@tws>
References: <20200625224435.GA2325089@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jun 2020 00:44:35 +0200 Oliver Herms wrote:
> The calculation of the effective tunnel mtu, that is used to create
> mtu exceptions if necessary, is currently not done correctly. This
> leads to unnecessary entries in the IPv6 route cache for any
> packet send through the tunnel.
> 
> The root cause is, that "dev->hard_header_len" is subtracted from the
> tunnel destionations path mtu. Thus subtracting too much, if
> dev->hard_header_len is filled in. This is that case for SIT tunnels
> where hard_header_len is the underlyings dev hard_header_len (e.g. 14
> for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).

It seems like SIT possibly got missed in evolution of the ip_tunnel
code? It seems to duplicate a lot of code, including pmtu checking.
Doesn't call ip_tunnel_init()...

My understanding is that for a while now tunnels are not supposed to use
dev->hard_header_len to reserve skb space, and use dev->needed_headroom, 
instead. sit uses hard_header_len and doesn't even copy needed_headroom
of the lower device.

> However, the MTU of the path is exclusive of the ethernet header
> and the 20 bytes for the IP header are being subtracted separately
> already. Thus hard_header_len is removed from this calculation.
> 
> For IPIP and GRE tunnels this doesn't change anything as
> hard_header_len is zero in those cases anyways.

This statement is definitely not true. Please see the calls to
ether_setup() in ip_gre.c, and the implementation of this function.

> This patch also corrects the calculation of the payload's packet size.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>

All in all, I think it's the SIT code that needs work, not ip_tunnel.
