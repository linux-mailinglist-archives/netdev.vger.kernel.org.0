Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6F92CF672
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 22:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgLDV6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 16:58:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgLDV6c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 16:58:32 -0500
Message-ID: <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607119071;
        bh=ultBWZkYr8AL8YDaGGjF9fL3uS7cqH79NjI0A6ylQK4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j5S33rWLdQ9itK/L6lp7wG2tGn4s0q3bKle51XTPXPNtFJzaXkNP5nYQlFLD84LgS
         RlrVJOlOftaGSOwOxVkVGFvAQgDMXpDjQLuv3fXOAziYbOg5NUs6xcGfRwiX9F+mkV
         KiJc+BvmrFlwUkwOQFas0NRwGdnh1FuCUHnvrK185I02bfd0/6mshTZi9tADmmjlFe
         ZxSSvfdwbX0k2UBGXspPu11F8t4jDUMQfTNChkIzGcnt78qan4DcVL+AjwdotAHdp7
         QI2yRWoQ7ZopD34nm5Cu8UABm1ncBto8cEFxE1AV+QOvFTbnSjFudvfpjCD+g6DYey
         n20JOCRomGWmw==
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 04 Dec 2020 13:57:49 -0800
In-Reply-To: <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
         <20201203042108.232706-9-saeedm@nvidia.com>
         <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
         <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-04 at 12:26 -0800, Jakub Kicinski wrote:
> On Fri, 04 Dec 2020 11:33:26 -0800 Saeed Mahameed wrote:
> > On Thu, 2020-12-03 at 18:29 -0800, Jakub Kicinski wrote:
> > > On Wed, 2 Dec 2020 20:21:01 -0800 Saeed Mahameed wrote:  
> > > > Add TX PTP port object support for better TX timestamping
> > > > accuracy.
> > > > Currently, driver supports CQE based TX port timestamp. Device
> > > > also offers TX port timestamp, which has less jitter and better
> > > > reflects the actual time of a packet's transmit.  
> > > 
> > > How much better is it?
> > > 
> > > Is the new implementation is standard compliant or just a "better
> > > guess"?
> > 
> > It is not a guess for sure, the closer to the output port you take
> > the
> > stamp the more accurate you get, this is why we need the HW
> > timestamp
> > in first place, i don't have the exact number though, but we target
> > to
> > be compliant with G.8273.2 class C, (30 nsec), and this code allow
> > Linux systems to be deployed in the 5G telco edge. Where this
> > standard
> > is needed.
> 
> I see. IIRC there was also an IEEE standard which specified the exact
> time stamping point (i.e. SFD crosses layer X). If it's class C that
> answers the question, I think.
> 
> > > > Define new driver layout called ptpsq, on which driver will
> > > > create
> > > > SQs that will support TX port timestamp for their transmitted
> > > > packets.
> > > > Driver to identify PTP TX skbs and steer them to these
> > > > dedicated
> > > > SQs
> > > > as part of the select queue ndo.
> > > > 
> > > > Driver to hold ptpsq per TC and report them at
> > > > netif_set_real_num_tx_queues().
> > > > 
> > > > Add support for all needed functionality in order to xmit and
> > > > poll
> > > > completions received via ptpsq.
> > > > 
> > > > Add ptpsq to the TX reporter recover, diagnose and dump
> > > > methods.
> > > > 
> > > > Creation of ptpsqs is disabled by default, and can be enabled
> > > > via
> > > > tx_port_ts private flag.  
> > > 
> > > This flag is pretty bad user experience.
> > 
> > Yeah, nothing i  could do about this, there is a large memory foot
> > print i want to avoid, and we don't want to complicate PTP ctrl API
> > of
> > the HW operating mode, so until we improve the HW, we prefer to
> > keep
> > this feature as a private flag.
> > 
> > > > This patch steer all timestamp related packets to a ptpsq, but
> > > > it
> > > > does not open the port timestamp support for it. The support
> > > > will
> > > > be added in the following patch.  
> > > 
> > > Overall I'm a little shocked by this, let me sleep on it :)
> > > 
> > > More info on the trade offs and considerations which led to the
> > > implementation would be useful.  
> > 
> > To get the Improved accuracy we need a special type of SQs attached
> > to
> > special HW objects that will provide more accurate stamping.
> > 
> > Trade-offs are :
> > 
> > options 1) convert ALL regular txqs (SQs) to work in this port
> > stamping
> > mode.
> > 
> > Pros: no need for any special mode in driver, no additional memory,
> > other than the new HW objects we create for the special stamping.
> > 
> > Cons: significant performance hit for non PTP traffic, (the hw
> > stamps
> > all packets in the slow but more accurate mode)
> 
> Just to be clear (Alexei brought this up when I mentioned these
> patches) - the requirement for the separate queues is because the
> time
> stamp enable is a queue property, not a per WQE / frame thing? I
> couldn't find this in the code - could you point me to where it's
> set?
> 

Yes, it is not per WQE, a new SQ property and we set it on:
mlx5e_ptp_open_txqsq() and then pass it to mlx5e_create_sq()

where we set it in the hw context like so:

MLX5_SET(sqc,  sqc, ts_cqe_to_dest_cqn, csp->ts_cqe_to_dest_cqn);

A nice quirk ! this will be Line #1234 in mlx5/core/en_main.c :)


> > option 2) route PTP traffic to a special SQs per ring, this SQ will
> > be
> > PTP port accurate, Normal traffic will continue through regular SQs
> > 
> > Pros: Regular non PTP traffic not affected.
> > Cons: High memory footprint for creating special SQs
> > 
> > 
> > So we prefer (2) + private flag to avoid the performance hit and
> > the
> > redundant memory usage out of the box.
> 
> Option 3 - have only one special PTP queue in the system. PTP traffic
> is rather low rate, queue per core doesn't seem necessary.
> 

We only forward ptp traffic to the new special queue but we create more
than one to avoid internal locking as we will utilize the tx softirq
percpu.

After double checking the code it seems Eran and Tariq have decided to
forward all UDP traffic, let me double check with them what happened
here.


> 
> Since you said the PTP queues are slower / higher overhead - are you
> not
> concerned that QUIC traffic will get mis-directed to them? People
> like
> hardware time stamps for all sort of measurements these days. Plus,
> since UDP doesn't itself set ooo those applications may be surprised
> to
> see increased out-of-order rate.
> 

Right, i thought Eran was looking for the ptp udp port as well.
Let me verify what happened here.

> Why not use the PTP classification helpers we already have?

do you mean ptp_parse_header() or the ebpf prog ?
We use skb_flow_dissect() which should be simple enough.


