Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9740D2E6A3B
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 20:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgL1TCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 14:02:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbgL1TCE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 14:02:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B87A224D2;
        Mon, 28 Dec 2020 19:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609182083;
        bh=NC/QkoNP4Uz67jTZe07UUrxPzf42ImWhgggUZiiLUSU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JxZuVOJNtSmudR7rQQgs/6zv+qJ+lvgH1Q9PBdJBBWGQzBmuzhlrBbrpJ89zJnSwi
         8LP8yd/aVD28gPbTvw5p+vFb5HOaT2OVFW1j3OGmDU+kT0WP71hrcBpfVlVdaO32p6
         KIYiTwxty+A8VClYJakQn7TdI6QQs8ygjvAOQTNgyqZB+O2DdaWl/sjefxATe7vgs6
         aKcsv/WwnDQg5mmXsl4iwFdNq2DordfD2v3WcbOnFDYo+P8vxdNRytwGPhSS+OO+lJ
         Z3B/hIXD5KnI1zqMeynU5JpGssH9Awy3zx8S1hn87GWeqsSmrXJ5OOsjWWjvYHyPCg
         +cgkFANv+Qc2g==
Date:   Mon, 28 Dec 2020 11:01:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Sudarsana Reddy Kalluru" <skalluru@marvell.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
Message-ID: <20201228110122.04cb8e31@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR18MB33885269B2564DE156996AF4ABDD0@DM6PR18MB3388.namprd18.prod.outlook.com>
References: <20201221145530.7771-1-manishc@marvell.com>
        <DM6PR18MB33885269B2564DE156996AF4ABDD0@DM6PR18MB3388.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 10:46:47 +0000 Manish Chopra wrote:
> > -----Original Message-----
> > From: Manish Chopra <manishc@marvell.com>
> > Sent: Monday, December 21, 2020 8:26 PM
> > To: davem@davemloft.net
> > Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Igor Russkikh
> > <irusskikh@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Subject: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
> > 
> > IPIP tunnels packets are unknown to device, hence these packets are
> > incorrectly parsed and caused the packet corruption, so disable offlods for
> > such packets at run time.
> > 
> > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
> > Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > index a2494bf..ca0ee29 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
> > @@ -1799,6 +1799,11 @@ netdev_features_t qede_features_check(struct
> > sk_buff *skb,
> >  			      ntohs(udp_hdr(skb)->dest) != gnv_port))
> >  				return features & ~(NETIF_F_CSUM_MASK |
> >  						    NETIF_F_GSO_MASK);
> > +		} else if (l4_proto == IPPROTO_IPIP) {
> > +			/* IPIP tunnels are unknown to the device or at least
> > unsupported natively,
> > +			 * offloads for them can't be done trivially, so disable
> > them for such skb.
> > +			 */
> > +			return features & ~(NETIF_F_CSUM_MASK |
> > NETIF_F_GSO_MASK);
> >  		}
> >  	}
> 
> Hello Jakub,  can you please queue up for stable releases
> (specifically for long term linux 5.4)?

It's in the queue:

https://patchwork.kernel.org/bundle/netdev/stable/?state=*

I'll submit it later this week.
