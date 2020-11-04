Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856FD2A70DE
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgKDW73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:59:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbgKDW73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 17:59:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D94FF206FA;
        Wed,  4 Nov 2020 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604530769;
        bh=Vux1VEy1bNbnVcwFVfkX+o/VauBK/sNNHvr1Ny7Oj4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BiT1xxBkm5CjOrKfQFDS5gEpWrpMwb7mkVZJZPqSvvaZNRci3DfYAj14JiFvvelra
         tckDvUb8ATZifIEP3KhU9VZUNS3O/06vhP+Kn8MLhHkFj8G4D38KISHzmH7dA8GNgL
         diaCtxKu4wl+KgtMUQ59/SJHZfyMk0dGmx8iUkBY=
Date:   Wed, 4 Nov 2020 14:59:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net 4/9] net/mlx5e: Fix refcount leak on kTLS RX resync
Message-ID: <20201104145927.3e7efaa2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103191830.60151-5-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
        <20201103191830.60151-5-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 11:18:25 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maximmi@mellanox.com>
> 
> On resync, the driver calls inet_lookup_established
> (__inet6_lookup_established) that increases sk_refcnt of the socket. To
> decrease it, the driver set skb->destructor to sock_edemux. However, it
> didn't work well, because the TCP stack also sets this destructor for
> early demux, and the refcount gets decreased only once

Why is the stack doing early_demux if there is already a socket
assigned? Or is it not early_demux but something else?
Can you point us at the code?

IPv4:
	if (net->ipv4.sysctl_ip_early_demux &&
	    !skb_dst(skb) &&
	    !skb->sk &&                              <============
	    !ip_is_fragment(iph)) {
		const struct net_protocol *ipprot;
		int protocol = iph->protocol;

		ipprot = rcu_dereference(inet_protos[protocol]);
		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
					      udp_v4_early_demux, skb);
			if (unlikely(err))
				goto drop_error;
			/* must reload iph, skb->head might have changed */
			iph = ip_hdr(skb);
		}
	}

IPv6:
	if (net->ipv4.sysctl_ip_early_demux && !skb_dst(skb) && skb->sk == NULL) {
                                                                ~~~~~~~~~~~~~~~
		const struct inet6_protocol *ipprot;

		ipprot = rcu_dereference(inet6_protos[ipv6_hdr(skb)->nexthdr]);
		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux)))
			INDIRECT_CALL_2(edemux, tcp_v6_early_demux,
					udp_v6_early_demux, skb);
	}
