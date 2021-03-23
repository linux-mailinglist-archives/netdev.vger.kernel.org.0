Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D355834645D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhCWQFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:05:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232860AbhCWQFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616515501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7G9TRyqCPEjqwjL/9hHbjywdhJ+Pi9pcaNINuGxnQ94=;
        b=SgxH7p7R71uEsUJnE0DKq5Bw494udVs1rGcrFH27VarZA2D2SJ3hCED5m4RV1YgGCa+DB+
        FmHZqbVLFW0jW+G2+EVnJTjcrxI87A3eUr00Sbg5kUib5rmYDFsfr/qJ9Tywyuw0fz5o5H
        Dalif4t+WuYg8DMYeVd+psYLIXtlbPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-sR3hhaPOP3us2CkMFO8jpQ-1; Tue, 23 Mar 2021 12:04:56 -0400
X-MC-Unique: sR3hhaPOP3us2CkMFO8jpQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7FC01B18BC2;
        Tue, 23 Mar 2021 16:04:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 616B660877;
        Tue, 23 Mar 2021 16:04:51 +0000 (UTC)
Date:   Tue, 23 Mar 2021 17:04:47 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
Message-ID: <20210323170447.78d65d05@carbon>
In-Reply-To: <YFoNoohTULmcpeCr@enceladus>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
        <20210323154112.131110-1-alobakin@pm.me>
        <YFoNoohTULmcpeCr@enceladus>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Mar 2021 17:47:46 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Tue, Mar 23, 2021 at 03:41:23PM +0000, Alexander Lobakin wrote:
> > From: Matteo Croce <mcroce@linux.microsoft.com>
> > Date: Mon, 22 Mar 2021 18:02:55 +0100
> >   
> > > From: Matteo Croce <mcroce@microsoft.com>
> > >
> > > This series enables recycling of the buffers allocated with the page_pool API.
> > > The first two patches are just prerequisite to save space in a struct and
> > > avoid recycling pages allocated with other API.
> > > Patch 2 was based on a previous idea from Jonathan Lemon.
> > >
> > > The third one is the real recycling, 4 fixes the compilation of __skb_frag_unref
> > > users, and 5,6 enable the recycling on two drivers.
> > >
> > > In the last two patches I reported the improvement I have with the series.
> > >
> > > The recycling as is can't be used with drivers like mlx5 which do page split,
> > > but this is documented in a comment.
> > > In the future, a refcount can be used so to support mlx5 with no changes.
> > >
> > > Ilias Apalodimas (2):
> > >   page_pool: DMA handling and allow to recycles frames via SKB
> > >   net: change users of __skb_frag_unref() and add an extra argument
> > >
> > > Jesper Dangaard Brouer (1):
> > >   xdp: reduce size of struct xdp_mem_info
> > >
> > > Matteo Croce (3):
> > >   mm: add a signature in struct page
> > >   mvpp2: recycle buffers
> > >   mvneta: recycle buffers
> > >
> > >  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
> > >  drivers/net/ethernet/marvell/mvneta.c         |  4 +-
> > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
> > >  drivers/net/ethernet/marvell/sky2.c           |  2 +-
> > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
> > >  include/linux/mm_types.h                      |  1 +
> > >  include/linux/skbuff.h                        | 33 +++++++++++--
> > >  include/net/page_pool.h                       | 15 ++++++
> > >  include/net/xdp.h                             |  5 +-
> > >  net/core/page_pool.c                          | 47 +++++++++++++++++++
> > >  net/core/skbuff.c                             | 20 +++++++-
> > >  net/core/xdp.c                                | 14 ++++--
> > >  net/tls/tls_device.c                          |  2 +-
> > >  13 files changed, 138 insertions(+), 26 deletions(-)  
> > 
> > Just for the reference, I've performed some tests on 1G SoC NIC with
> > this patchset on, here's direct link: [0]
> >   
> 
> Thanks for the testing!
> Any chance you can get a perf measurement on this?

I guess you mean perf-report (--stdio) output, right?

> Is DMA syncing taking a substantial amount of your cpu usage?

(+1 this is an important question)
 
> > 
> > [0] https://lore.kernel.org/netdev/20210323153550.130385-1-alobakin@pm.me
> > 

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

