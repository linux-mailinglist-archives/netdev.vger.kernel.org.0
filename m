Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD44A523
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbfFRPUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:20:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53148 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729038AbfFRPUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 11:20:04 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 380AC882FF;
        Tue, 18 Jun 2019 15:19:59 +0000 (UTC)
Received: from carbon (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10C364D1;
        Tue, 18 Jun 2019 15:19:52 +0000 (UTC)
Date:   Tue, 18 Jun 2019 17:19:51 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>, brouer@redhat.com
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190618171951.17128ed8@carbon>
In-Reply-To: <20190618125431.GA5307@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
        <156045052249.29115.2357668905441684019.stgit@firesoul>
        <20190615093339.GB3771@khorivan>
        <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
        <20190618125431.GA5307@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 18 Jun 2019 15:20:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 18 Jun 2019 15:54:33 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> On Sun, Jun 16, 2019 at 10:56:25AM +0000, Tariq Toukan wrote:
> >
> >On 6/15/2019 12:33 PM, Ivan Khoronzhuk wrote:  
> >> On Thu, Jun 13, 2019 at 08:28:42PM +0200, Jesper Dangaard Brouer wrote:
[...]
> >>
> >> What would you recommend to do for the following situation:
> >>
> >> Same receive queue is shared between 2 network devices. The receive ring is
> >> filled by pages from page_pool, but you don't know the actual port (ndev)
> >> filling this ring, because a device is recognized only after packet is
> >> received.
> >>
> >> The API is so that xdp rxq is bind to network device, each frame has
> >> reference
> >> on it, so rxq ndev must be static. That means each netdev has it's own rxq
> >> instance even no need in it. Thus, after your changes, page must be
> >> returned to
> >> the pool it was taken from, or released from old pool and recycled in
> >> new one
> >> somehow.
> >>
> >> And that is inconvenience at least. It's hard to move pages between
> >> pools w/o performance penalty. No way to use common pool either,
> >> as unreg_rxq now drops the pool and 2 rxqa can't reference same
> >> pool. 
> >
> >Within the single netdev, separate page_pool instances are anyway
> >created for different RX rings, working under different NAPI's.  
> 
> The circumstances are so that same RX ring is shared between 2
> netdevs... and netdev can be known only after descriptor/packet is
> received. Thus, while filling RX ring, there is no actual device,
> but when packet is received it has to be recycled to appropriate
> net device pool. Before this change there were no difference from
> which pool the page was allocated to fill RX ring, as there were no
> owner. After this change there is owner - netdev page pool.

It not really a dependency added in this patchset.  A page_pool is
strictly bound to a single RX-queue, for performance, as this allow us
a NAPI fast-path return used for early drop (XDP_DROP).

I can see that the API xdp_rxq_info_reg_mem_model() make it possible to
call it on different xdp_rxq_info structs with the same page_pool
pointer.  But it was never intended to be used like that, and I
consider it an API usage violation.  I originally wanted to add the
allocator pointer to xdp_rxq_info_reg() call, but the API was extended
in different versions, so I didn't want to break users.  I've actually
tried hard to catch when drivers use the API wrong, via WARN(), but I
guess you found a loop hole.

Besides, we already have a dependency from the RX-queue to the netdev
in the xdp_rxq_info structure.  E.g. the xdp_rxq_info->dev is sort of
central, and dereferenced by BPF-code to read xdp_md->ingress_ifindex,
and also used by cpumap when creating SKBs.


> For cpsw the dma unmap is common for both netdevs and no difference
> who is freeing the page, but there is difference which pool it's
> freed to.
> 
> So that, while filling RX ring the page is taken from page pool of
> ndev1, but packet is received for ndev2, it has to be later
> returned/recycled to page pool of ndev1, but when xdp buffer is
> handed over to xdp prog the xdp_rxq_info has reference on ndev2 ...
>
> And no way to predict the final ndev before packet is received, so no
> way to choose appropriate page pool as now it becomes page owner.
> 
> So, while RX ring filling, the page/dma recycling is needed but should
> be some way to identify page owner only after receiving packet.
> 
> Roughly speaking, something like:
> 
> pool->pages_state_hold_cnt++;
> 
> outside of page allocation API, after packet is received.

Don't EVER manipulate the internal state outside of page allocation
API.  That kills the purpose of defining any API.

> and free of the counter while allocation (w/o owing the page).

You use-case of two netdev's sharing the same RX-queue sounds dubious,
and very hardware specific.  I'm not sure why we want to bend the APIs
to support this?
 If we had to allow page_pool to be registered twice, via
xdp_rxq_info_reg_mem_model() then I guess we could extend page_pool
with a usage/users reference count, and then only really free the
page_pool when refcnt reach zero.  But it just seems and looks wrong
(in the code) as the hole trick to get performance is to only have one
user.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
