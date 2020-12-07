Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7C92D0AA2
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 07:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgLGGXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 01:23:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgLGGXP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 01:23:15 -0500
Message-ID: <fd1e65f000f3d1ce929562ca44e7644bdfc2ea76.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607322154;
        bh=as/7leNXHMxSqGY3OL/iZnpHK+H+oP4E5iUZwN6mWk0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NhH2c0pIs7IXBUr2kpDaHeVw9vvbZiS7EYKvpmiY+GeO2JLi+SN9ArDYmrRT0XShq
         sQFYUoOXIMyueClDb0WyM0t9I9BKX+NzuOV2V7MrTf4sO151jop/VsuEklMrDFeFG2
         nTNQZVbcE1Zyj1AT6+ejuqAbQnhN0R+No6mvMBos04IBkW4WkJOrPwwfXDn8hA0YfP
         zyjaH4dbCd49EBG1+hkyk6uvMaLHBT4EHrpImvLBk3GVXtmTE/xjBauuMrT9yYu3Vi
         OLbeeX+FHpYkqJI5VMgyYCG0QO66cXhZx+dhVQJls31PmNH3jo0/JDgGWl20canSER
         0VFqOhw7X8/Kg==
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 06 Dec 2020 22:22:33 -0800
In-Reply-To: <20201205005530.lcngtpksxged2ewo@skbuf>
References: <20201203042108.232706-1-saeedm@nvidia.com>
         <20201203042108.232706-9-saeedm@nvidia.com>
         <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
         <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
         <20201204145240.7c1a5a1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <20201205005530.lcngtpksxged2ewo@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-12-05 at 00:55 +0000, Vladimir Oltean wrote:
> Hi Jakub,
> 
> On Fri, Dec 04, 2020 at 02:52:40PM -0800, Jakub Kicinski wrote:
> > On Fri, 04 Dec 2020 13:57:49 -0800 Saeed Mahameed wrote:
> > > > Why not use the PTP classification helpers we already have?
> > > 
> > > do you mean ptp_parse_header() or the ebpf prog ?
> > > We use skb_flow_dissect() which should be simple enough.
> > 
> > Not sure which exact one TBH, I just know we have helpers for this,
> > so if we don't use them it'd be good to at least justify why.
> > 
> > Maybe someone with more practical knowledge here can chime in with
> > a recommendation for a helper to find PTP frames on TX?
> 
> ptp_classify_raw is optimized to identify PTP event messages (the
> only
> ones that need to be timestamped as far as the protocol is
> concerned).
> PTP general messages (Follow-Up, Delay_Resp, Announce etc) will
> return
> PTP_CLASS_NONE from ptp_classify_raw.
> 

I looked at the implementation, while it is nice to see that it is
running an ebpf program, but it seems these functions are meant for
those who care about the content of those PTP messages.

Select queue has to be consistent for a specific stream so
I'd rather lookup the well known ptp port via the standard flow
dissector and select the queue accordingly, using any other mechanism
might cause inconsistencies and ooo.

also the flow dissector handles non linear skbs very nicely, whereas,
the two ptp classifier methods don't. They actually have different
purposes than what we are looking for.

so I think we should stick with our simple flow dissector
implementation.

> But maybe there is an even better way, since this is on the TX path,
> maybe the .ndo_select_queue operation can simply look at
> 	skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP
> when deciding whether to send it to the "good" queue or not. This has
> the advantage of being less expensive than any sort of frame
> classification.
> 

We also considered this, this is bad in our case because this will
easily break performance for users who do setsockopt(SO_TIMESTAMPING)
on TCP/UDP sockets that favor performance over precision but still want
HW timestamping.

> Nonetheless, some tests would need to be run. In theory, practice and
> theory are the same, whereas in practice they aren't.

In Theory, I don't agree ;-).



