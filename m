Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC3B22D222
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGXXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgGXXVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 19:21:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550CF206EB;
        Fri, 24 Jul 2020 23:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595632897;
        bh=9c0tLHdWrHuDM0KgrtVKJLVM32E5hc3Gb8A36ydAlEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BhAfLRGN7J2ADXRgqSq6FwuB3PCWhu7EnqSVLc5JbFGSUyi1nCBGXzTvVKNOX5Dhv
         wwIjg0DQSsOUQXbypaXsr8vaZAyeKpgL8d/7tEjM81hr+lQD4DgivGGaApICmnnc28
         JpEcDKhJzpEZ1jNhw1aemAkXVP5xhu9LPab1uQ+o=
Date:   Fri, 24 Jul 2020 16:21:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] bareudp: forbid mixing IP and MPLS in multiproto
 mode
Message-ID: <20200724162134.7b0c8aaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f6e832e7632acf28b1d2b35dddb08769c7ce4fab.1595624517.git.gnault@redhat.com>
References: <f6e832e7632acf28b1d2b35dddb08769c7ce4fab.1595624517.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020 23:03:26 +0200 Guillaume Nault wrote:
> In multiproto mode, bareudp_xmit() accepts sending multicast MPLS and
> IPv6 packets regardless of the bareudp ethertype. In practice, this
> let an IP tunnel send multicast MPLS packets, or an MPLS tunnel send
> IPv6 packets.
> 
> We need to restrict the test further, so that the multiproto mode only
> enables
>   * IPv6 for IPv4 tunnels,
>   * or multicast MPLS for unicast MPLS tunnels.
> 
> To improve clarity, the protocol validation is moved to its own
> function, where each logical test has its own condition.
> 
> Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Hi! this adds 10 sparse warnings:

drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
drivers/net/bareudp.c:419:13: warning: restricted __be16 degrades to integer
drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
drivers/net/bareudp.c:423:22: warning: cast to restricted __be16

I think this:

	    proto == ntohs(ETH_P_MPLS_MC))

has to say htons() not ntohs(). For v6 as well.
