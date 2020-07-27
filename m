Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C2E22F5E0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgG0Q7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:59:15 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:28939 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgG0Q7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:59:15 -0400
Received: (qmail 51919 invoked by uid 89); 27 Jul 2020 16:59:10 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 27 Jul 2020 16:59:10 -0000
Date:   Mon, 27 Jul 2020 09:59:04 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        borisp@mellanox.com, david@redhat.com
Subject: Re: [RFC PATCH v2 08/21] skbuff: add a zc_netgpu bitflag
Message-ID: <20200727165904.twsfhafflw2ws4t4@bsd-mbp.dhcp.thefacebook.com>
References: <20200727052846.4070247-1-jonathan.lemon@gmail.com>
 <20200727052846.4070247-9-jonathan.lemon@gmail.com>
 <CANn89i+AZ9PnRssWpiE5zj41V1=85Jcy80Rtbp7mLjp73Y71Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+AZ9PnRssWpiE5zj41V1=85Jcy80Rtbp7mLjp73Y71Pw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 08:24:55AM -0700, Eric Dumazet wrote:
> On Mon, Jul 27, 2020 at 12:20 AM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
> >
> > This could likely be moved elsewhere.  The presence of the flag on
> > the skb indicates that one of the fragments may contain zerocopy
> > RX data, where the data is not accessible to the cpu.
> 
> Why do we need yet another flag in skb exactly ?
> 
> Please define what means "data not accessible to the cpu" ?
> 
> This kind of change is a red flag for me.

The architecture this is targeting is a ML cluster, where a 200Gbps NIC
is attached to a PCIe switch which also has a GPU card attached.  There
are several of these, and the link(s) to the host cpu (which has another
NIC attached) can't handle the incoming traffic.

So what we're doing here is transferring the data directly from the NIC
to the GPU via DMA.  The host never sees the data, but can control it
indirectly via the handles returned to userspace.

I'm not sure that a flag on the skb is the right location for this -
perhaps moving it into skb_shared() instead would be better?
-- 
Jonathan
