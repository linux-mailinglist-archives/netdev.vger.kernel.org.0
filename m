Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D9296828
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 02:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374108AbgJWAoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 20:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374101AbgJWAoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 20:44:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0F7421531;
        Fri, 23 Oct 2020 00:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603413893;
        bh=P801yupGfVJZpJBFR3gSGi8IVI4N2T8jCC9UpMeYlcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RCpc0n0ynyU9G0HiDO1pxAr1GSVz8bTo+B7+WpVhG9/rbaSTsDV/6GS+1s0PKqRTz
         TsaEQjrYU2rQRy1HEriSjWlzH2E6ZKUElVXmVnA0FBxk5nyBaN/1PPNziuBHN8UxGm
         rx1wYWPuMpNxbQwIRyvvHur2Aw8KNqNDRx7WApwI=
Date:   Thu, 22 Oct 2020 17:44:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
Message-ID: <20201022174451.1cd858ae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAJht_EM638CQDb5opnVxfQ81Z2U9hGZbnE581RFZrAQvenn+qQ@mail.gmail.com>
References: <20201022072814.91560-1-xie.he.0141@gmail.com>
        <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
        <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAJht_EM638CQDb5opnVxfQ81Z2U9hGZbnE581RFZrAQvenn+qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 12:59:45 -0700 Xie He wrote:
> On Thu, Oct 22, 2020 at 8:22 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Are most of these drivers using skb_padto()? Is that the reason they
> > can't be sharing the SKB?  
> 
> Yes, I think if a driver calls skb_pad / skb_padto / skb_put_padto /
> eth_skb_pad, the driver can't accept shared skbs because it may modify
> the skbs.
> 
> > I think the IFF_TX_SKB_SHARING flag is only used by pktgen, so perhaps
> > we can make sure pktgen doesn't generate skbs < dev->min_mtu, and then
> > the drivers won't pad?  
> 
> Yes, I see a lot of drivers just want to pad the skb to ETH_ZLEN, or
> just call eth_skb_pad. In this case, requiring the shared skb to be at
> least dev->min_mtu long can solve the problem for these drivers.
> 
> But I also see some drivers that want to pad the skb to a strange
> length, and don't set their special min_mtu to match this length. For
> example:
> 
> drivers/net/ethernet/packetengines/yellowfin.c wants to pad the skb to
> a dynamically calculated value.
> 
> drivers/net/ethernet/ti/cpsw.c, cpsw_new.c and tlan.c want to pad the
> skb to macro defined values.
> 
> drivers/net/ethernet/intel/iavf/iavf_txrx.c wants to pad the skb to
> IAVF_MIN_TX_LEN (17).
> 
> drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c wants to pad the skb to 17.

Hm, I see, that would be a slight loss of functionality if we started
requiring 64B, for example, while the driver could in practice xmit
17B frames (would matter only to VFs, but nonetheless).

> Another solution I can think of is to add a "skb_shared" check to
> "__skb_pad", so that if __skb_pad encounters a shared skb, it just
> returns an error. The driver would think this is a memory allocation
> failure. This way we can ensure shared skbs are not modified.

I'm not sure if we want to be adding checks to __skb_pad() to handle
what's effectively a pktgen specific condition.

We could create a new field in struct netdevice for min_frame_len, but I
think your patch is the simplest solution. Let's see if anyone objects.

BTW it seems like there is more drivers which will need the flag
cleared, e.g. drivers/net/ethernet/broadcom/bnxt/bnxt.c?
