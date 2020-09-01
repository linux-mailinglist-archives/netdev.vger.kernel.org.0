Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257DD259762
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbgIAQN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbgIAPgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 11:36:14 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B18F214D8;
        Tue,  1 Sep 2020 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974573;
        bh=l1KxbslgXDTTFr//cJ3Gfyy1Gco4KliBv+y/wKQgfew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jOqn0iuYFzorU/TALy7/NaFHLNxaHjeM66V447+gk7sU/ArUiRPcNR4hJncWIDc/m
         quMoc8AKiGuz2a6YKeomOhQ16P2X2ysHvILxTv0wbp2GJ9R/plHqscBfD0YKrNk2pE
         +QMg6JaAsC0W2bXhUgAWFcUA1Pc6uWfwvEuSB/CA=
Date:   Tue, 1 Sep 2020 16:36:08 +0100
From:   Will Deacon <will@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     William Mcvicker <willmcvicker@google.com>, security@kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] netfilter: nat: add a range check for l3/l4
 protonum
Message-ID: <20200901153607.GC4292@willie-the-truck>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com>
 <20200731175115.GA16982@salvia>
 <20200731181633.GA1209076@google.com>
 <20200803183156.GA3084830@google.com>
 <20200804113711.GA20988@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804113711.GA20988@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will, Pablo,

On Tue, Aug 04, 2020 at 01:37:11PM +0200, Pablo Neira Ayuso wrote:
> This patch is much smaller and if you confirm this is address the
> issue, then this is awesome.

Did that ever get confirmed? AFAICT, nothing ended up landing in the stable
trees for this.

Cheers,

Will


> On Mon, Aug 03, 2020 at 06:31:56PM +0000, William Mcvicker wrote:
> [...]
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 31fa94064a62..56d310f8b29a 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
> >  	if (!tb[CTA_TUPLE_IP])
> >  		return -EINVAL;
> >  
> > +	if (l3num >= NFPROTO_NUMPROTO)
> > +		return -EINVAL;
> 
> l3num can only be either NFPROTO_IPV4 or NFPROTO_IPV6.
> 
> Other than that, bail out with EOPNOTSUPP.
> 
> Thank you.
