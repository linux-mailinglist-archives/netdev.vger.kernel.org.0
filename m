Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603BD2C1C92
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 05:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgKXELa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 23:11:30 -0500
Received: from smtp2.axis.com ([195.60.68.18]:25714 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgKXELa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 23:11:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=axis.com; l=1108; q=dns/txt; s=axis-central1;
  t=1606191090; x=1637727090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y1f7YDPg9br6ZPfXHfQarLxBdVY9HT3ViTHFbV/Iw/s=;
  b=YK2E9EnQBzzUyLuphzFodHJDYLcwP2Naxu/GYYjP5sB2empIPJ+LEtYw
   uHGQOtFA49P2Lgi2WcvHcqnALbHeDFjrveiTccVyAGoVqsQbyFtK1dJ9O
   f0KTIjBaY42zh7dpPTVuJ3GsY26R7Y8aOEPB5kkOYTi2Ggga1ZMuYOuaA
   RQnAo9iPM8aQna/+JvAJINZJHDVsTVuUvk3yIu6UTT8b37IOSZxZboVWE
   gwcXTxv1tg1PGwB0I4GFmM4tifDqHAhJoxQ0Qh0R2YEq8mAF8SOESsqpI
   9sMOFax8NgBktvhR+lX2Vf0drFR5Pf2zzvGAD4en60/dlsAj7NVcNXPUJ
   A==;
IronPort-SDR: tMm0+kpSgRj21pcR1+YJE0m8mfSZ2dRN4dtMT8ID1PIhgWj3DrNVD+mS5rrubT4/wXKOz94jwM
 namRJuqOxehCE15wUqGq6CDUgVNRmvdjEdlBwyiznAoSjl7bS0qvY9AjenX7xu4h6HO4CH8Ly8
 s8bqIcL0jVt033k249SNpVmLDcnbDve+p7OAcWENQ4GLcaTnGTesP8UXBhlBen3W5SRXDjXL0g
 jgizM4CFaTZWy6/ItHYMWr2024gKCTL1eL4XMjjybcGLJW9KelPPdthi49d8uHU2F0342ylDUA
 g6w=
X-IronPort-AV: E=Sophos;i="5.78,365,1599516000"; 
   d="scan'208";a="14822153"
Date:   Tue, 24 Nov 2020 05:11:27 +0100
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        kernel <kernel@axis.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: stmmac: Use hrtimer for TX coalescing
Message-ID: <20201124041127.c3uagg4cguqqvgji@axis.com>
References: <20201120150208.6838-1-vincent.whitchurch@axis.com>
 <20201123164600.434b6a9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201123164600.434b6a9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 01:46:00AM +0100, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 16:02:08 +0100 Vincent Whitchurch wrote:
> > This driver uses a normal timer for TX coalescing, which means that the
> > with the default tx-usecs of 1000 microseconds the cleanups actually
> > happen 10 ms or more later with HZ=100.  This leads to very low
> > througput with TCP when bridged to a slow link such as a 4G modem.  Fix
> > this by using an hrtimer instead.
> > 
> > On my ARM platform with HZ=100 and the default TX coalescing settings
> > (tx-frames 25 tx-usecs 1000), with "tc qdisc add dev eth0 root netem
> > delay 60ms 40ms rate 50Mbit" run on the server, netperf's TCP_STREAM
> > improves from ~5.5 Mbps to ~100 Mbps.
> > 
> > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> 
> Looks perfectly reasonable, but you marked it for net. Do you consider
> this to be a bug fix, and need it backported to stable? Otherwise I'd
> rather apply it to net-next.

No, sorry, I think a backport to stable is unnecessary.  It should be
fine to apply it to net-next.  Thanks.
