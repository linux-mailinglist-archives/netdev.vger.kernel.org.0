Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C51398A18
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFBMz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229579AbhFBMzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2042161359;
        Wed,  2 Jun 2021 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622638452;
        bh=Q3i434w1bmGmD1vtai1MkkJTr+dgXvu2ulIVLc9vZy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OABGGpJ71fVScwcSSNGLlSEa9pB0Pdt3q3rH0+DgibprO8Ghk0xcNnm4+FmHvRmqZ
         5b7Sz0Jn6zHV+zcCdZhp+0I0j2MIh8zph71MhoTl2CsHYhgFnXkTRoghzlZ9e445qc
         9JN/trpBUAmwxegcjW0cQmWMqdtOLcvSE+BFKjPGkeWwqMoS1kbKIN1NAjajlvzHu8
         FCU/NwCg4Xj4gU2lj3fr7dSZN3hrew7Zt6IManYGjaFsaiuAIlfshNyg69v9u+54eM
         VVZSmcwhfVViwZRvqbE/Ds/kndDgfXciR+3On2xeUndj4UV21bWoW1JN7ooqwpuaMv
         0OBkTiIaREp4Q==
Date:   Wed, 2 Jun 2021 15:54:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Remove BUG() to aviod machine dead
Message-ID: <YLd/cdL5F964G+Sb@unreal>
References: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
 <20210518055336-mutt-send-email-mst@kernel.org>
 <4aaf5125-ce75-c72a-4b4a-11c91cb85a72@linux.alibaba.com>
 <72f284c6-b2f5-a395-a68f-afe801eb81be@redhat.com>
 <YLcePtKhnt9gXq8E@unreal>
 <b80a2841-32aa-02ff-b2cc-f2fb3eeed9a1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b80a2841-32aa-02ff-b2cc-f2fb3eeed9a1@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 03:14:50PM +0800, Jason Wang wrote:
> 
> 在 2021/6/2 下午1:59, Leon Romanovsky 写道:
> > On Tue, May 25, 2021 at 02:19:03PM +0800, Jason Wang wrote:
> > > 在 2021/5/19 下午10:18, Xianting Tian 写道:
> > > > thanks, I submit the patch as commented by Andrew
> > > > https://lkml.org/lkml/2021/5/18/256
> > > > 
> > > > Actually, if xmit_skb() returns error, below code will give a warning
> > > > with error code.
> > > > 
> > > >      /* Try to transmit */
> > > >      err = xmit_skb(sq, skb);
> > > > 
> > > >      /* This should not happen! */
> > > >      if (unlikely(err)) {
> > > >          dev->stats.tx_fifo_errors++;
> > > >          if (net_ratelimit())
> > > >              dev_warn(&dev->dev,
> > > >                   "Unexpected TXQ (%d) queue failure: %d\n",
> > > >                   qnum, err);
> > > >          dev->stats.tx_dropped++;
> > > >          dev_kfree_skb_any(skb);
> > > >          return NETDEV_TX_OK;
> > > >      }
> > > > 
> > > > 
> > > > 
> > > > 
> > > > 
> > > > 在 2021/5/18 下午5:54, Michael S. Tsirkin 写道:
> > > > > typo in subject
> > > > > 
> > > > > On Tue, May 18, 2021 at 05:46:56PM +0800, Xianting Tian wrote:
> > > > > > When met error, we output a print to avoid a BUG().
> > > 
> > > So you don't explain why you need to remove BUG(). I think it deserve a
> > > BUG().
> > BUG() will crash the machine and virtio_net is not kernel core
> > functionality that must stop the machine to prevent anything truly
> > harmful and basic.
> 
> 
> Note that the BUG() here is not for virtio-net itself. It tells us that a
> bug was found by virtio-net.
> 
> That is, the one that produces the skb has a bug, usually it's the network
> core.
> 
> There could also be the issue of the packet from untrusted source (userspace
> like TAP or packet socket) but they should be validated there.

So it is even worse than I thought. You are saying that in theory untrusted
remote host can crash system. IMHO, It is definitely not the place to put BUG().

I remind you that in-kernel API is build on the promise that data passed
between and calls are safe and already checked. You don't need to set a
protection from the net/core.

Thanks

> 
> Thanks
> 
> 
> > 
> > I would argue that code in drivers/* shouldn't call BUG() macros at all.
> > 
> > If it is impossible, don't check for that or add WARN_ON() and recover,
> > but don't crash whole system.
> > 
> > Thanks
> > 
> 
