Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2C292DF8
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 21:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731085AbgJSTAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 15:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbgJSTAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 15:00:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0939C222E9;
        Mon, 19 Oct 2020 19:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603134042;
        bh=+lMFQYIaCukUHpnNzD/k9KmQbsLsX0WIpfiaShqpt7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pVbfww0z1+dboGRtcWGyS41djkdOeHZbebVtyHOdrvrukBgld1z74g6/lLt8fM7zj
         OpmPtCao9LdTgaMuIeGVwdtwVhy2oEqaL+prVsub3plWFVgmHp5jx7Rr7PZKmnm/pY
         ala8lrc38fgkCBN2a8y3QjMwDO6n4AuoaDG4mJR8=
Date:   Mon, 19 Oct 2020 12:00:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     Dylan Hung <dylan_hung@aspeedtech.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Po-Yu Chuang <ratbert@faraday-tech.com>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        OpenBMC Maillist <openbmc@lists.ozlabs.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Message-ID: <20201019120040.3152ea0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
References: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
        <CACPK8Xfn+Gn0PHCfhX-vgLTA6e2=RT+D+fnLF67_1j1iwqh7yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 08:57:03 +0000 Joel Stanley wrote:
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 00024dd41147..9a99a87f29f3 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -804,7 +804,8 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
> >          * before setting the OWN bit on the first descriptor.
> >          */
> >         dma_wmb();
> > -       first->txdes0 = cpu_to_le32(f_ctl_stat);
> > +       WRITE_ONCE(first->txdes0, cpu_to_le32(f_ctl_stat));
> > +       READ_ONCE(first->txdes0);  
> 
> I understand what you're trying to do here, but I'm not sure that this
> is the correct way to go about it.
> 
> It does cause the compiler to produce a store and then a load.

+1 @first is system memory from dma_alloc_coherent(), right?

You shouldn't have to do this. Is coherent DMA memory broken 
on your platform?
