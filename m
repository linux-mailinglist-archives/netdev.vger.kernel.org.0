Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE53980D9
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 07:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFBGBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229779AbhFBGBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 02:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB97D61027;
        Wed,  2 Jun 2021 05:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622613570;
        bh=WFGn28PIenT8iwgpyo1Uh1UYGjMQG1gWUpqwqXSvJlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PfDD9zftySnlohgnH0popDk3aWgGYjbEafnbJopaPd7jvH+1yCL5jnQgWlZ2ahGI/
         34+u5QMuxWSbIYs+srYytLppF3vvE37DCrQquvxNh6bFaEUvCVJuvNVol36aXBnXd9
         2+V11/33toVh4lB/DD3MH/exJbS8sHyeTWICoCjUXdNtaHyPnXYTiUYG59NWugIJuk
         tEboug6LCa/Y5ByPtTBuFNgq9A2g5pbrmZpCbuW6Hr9o7nkHNglUBqVy009PIYUkvD
         dhlkBkRWpo5G+bN9nSd9y2mbpvEf9H6yCrMiSqRsQuPMyaM/9V4L9K44Dgz2mmvkdF
         ota0lbaMbWaLQ==
Date:   Wed, 2 Jun 2021 08:59:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_net: Remove BUG() to aviod machine dead
Message-ID: <YLcePtKhnt9gXq8E@unreal>
References: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
 <20210518055336-mutt-send-email-mst@kernel.org>
 <4aaf5125-ce75-c72a-4b4a-11c91cb85a72@linux.alibaba.com>
 <72f284c6-b2f5-a395-a68f-afe801eb81be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72f284c6-b2f5-a395-a68f-afe801eb81be@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 02:19:03PM +0800, Jason Wang wrote:
> 
> 在 2021/5/19 下午10:18, Xianting Tian 写道:
> > thanks, I submit the patch as commented by Andrew
> > https://lkml.org/lkml/2021/5/18/256
> > 
> > Actually, if xmit_skb() returns error, below code will give a warning
> > with error code.
> > 
> >     /* Try to transmit */
> >     err = xmit_skb(sq, skb);
> > 
> >     /* This should not happen! */
> >     if (unlikely(err)) {
> >         dev->stats.tx_fifo_errors++;
> >         if (net_ratelimit())
> >             dev_warn(&dev->dev,
> >                  "Unexpected TXQ (%d) queue failure: %d\n",
> >                  qnum, err);
> >         dev->stats.tx_dropped++;
> >         dev_kfree_skb_any(skb);
> >         return NETDEV_TX_OK;
> >     }
> > 
> > 
> > 
> > 
> > 
> > 在 2021/5/18 下午5:54, Michael S. Tsirkin 写道:
> > > typo in subject
> > > 
> > > On Tue, May 18, 2021 at 05:46:56PM +0800, Xianting Tian wrote:
> > > > When met error, we output a print to avoid a BUG().
> 
> 
> So you don't explain why you need to remove BUG(). I think it deserve a
> BUG().

BUG() will crash the machine and virtio_net is not kernel core
functionality that must stop the machine to prevent anything truly
harmful and basic.

I would argue that code in drivers/* shouldn't call BUG() macros at all.

If it is impossible, don't check for that or add WARN_ON() and recover,
but don't crash whole system.

Thanks
