Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACC120FA87
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387549AbgF3R1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731302AbgF3R1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 13:27:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191DD206C0;
        Tue, 30 Jun 2020 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593538034;
        bh=mfqc723QNnyfWTD0awpsXIdlQyYiHITVvoITdTcQxhs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NPS4U1CHor5oyHRllqLOywaq8ue8aIyezHS+DX85FpGyKDo1ZtS9oEly3fY/cGdvT
         L7Z4e6sXJ26muQGU1nJlv0LbjkpSkiA6P9NA1sHYBJ6bvTOKiTyTFnWDFlxojTrUHa
         /38uu6Q7ywWfHTnVQo/wC0W9rteq7UHtn4213VpQ=
Date:   Tue, 30 Jun 2020 10:27:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
Message-ID: <20200630102712.38df3a68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20e25b9c-db3c-e6cd-f383-aa4ac84a2177@gmail.com>
References: <20200625224435.GA2325089@tws>
        <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20e25b9c-db3c-e6cd-f383-aa4ac84a2177@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 12:21:14 +0200 Oliver Herms wrote:
> On 30.06.20 08:22, Jakub Kicinski wrote:
> > On Fri, 26 Jun 2020 00:44:35 +0200 Oliver Herms wrote:  
> >> The calculation of the effective tunnel mtu, that is used to create
> >> mtu exceptions if necessary, is currently not done correctly. This
> >> leads to unnecessary entries in the IPv6 route cache for any
> >> packet send through the tunnel.
> >>
> >> The root cause is, that "dev->hard_header_len" is subtracted from the
> >> tunnel destionations path mtu. Thus subtracting too much, if
> >> dev->hard_header_len is filled in. This is that case for SIT tunnels
> >> where hard_header_len is the underlyings dev hard_header_len (e.g. 14
> >> for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).  
> > 
> > It seems like SIT possibly got missed in evolution of the ip_tunnel
> > code? It seems to duplicate a lot of code, including pmtu checking.
> > Doesn't call ip_tunnel_init()...  
> 
> Are you open for patches cleaning this up?

Certainly! Maybe some of the oddities are justified, but cleanup /
re-aligning with the rest of ip_tunnels would be nice.

Not sure how much of it is qualifying as a bug, so perhaps two series
would be needed - one for net / stable with bug fixes and another of
pure cleanups for net-next?
