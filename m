Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EBE3E9B28
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhHKXRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232771AbhHKXRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 19:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C410F60F21;
        Wed, 11 Aug 2021 23:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628723820;
        bh=JP5ab2WoWc4CuxFe/Sov5XSsoXt4HwHFx8A90SN+yfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pMgeLQJUuZSuI2kXxIWxOTYePdyrj+nl7+s/5HtNPBCtHvxSjtlHg/oQ0NQo+hXKi
         b/utA85SgOeOQvbAzEUM9//UQ6oGnG0PFhLx+Zkg+oxhPzMrWkha79PtyYp5Sgr+mF
         R7iEfTMrYyhHC+wg4EglVb0yOYXORTYvmHxuo/PAlbKbRkowSp5mzY4M6a2ZviWMN5
         8O6q0kzYv/DNU+E5M1BNPhMEF8srjOndxaLCDR4WOifXd+bl7Yb0OukruwqZyvYm9c
         qtZ/FaU2/F3PODztc9E3hIuIrDOgJrg+MpvL2KGIteZC3LYT4cqk3rIQcEC6agATqK
         MOmk5bKPpaVHQ==
Date:   Wed, 11 Aug 2021 16:16:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Jeffrey Huang <huangjw@broadcom.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Andrew Gospodarek <gospo@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net v2 3/4] bnxt: make sure xmit_more + errors does not
 miss doorbells
Message-ID: <20210811161658.64551a1c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLikXmSem_anENYaxh63e9uQNf-9W3cUtMmBoDUoZ+XsOkQ@mail.gmail.com>
References: <20210811213749.3276687-1-kuba@kernel.org>
        <20210811213749.3276687-4-kuba@kernel.org>
        <CACKFLinMd6a9Lwq_H1yNp8PFpvNmBsG5R+YGAYuCiF+i0OF+3w@mail.gmail.com>
        <20210811154441.3b593d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLikXmSem_anENYaxh63e9uQNf-9W3cUtMmBoDUoZ+XsOkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 16:00:52 -0700 Michael Chan wrote:
> On Wed, Aug 11, 2021 at 3:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 11 Aug 2021 15:36:34 -0700 Michael Chan wrote:  
> > > On Wed, Aug 11, 2021 at 2:38 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > @@ -367,6 +368,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
> > > >         return md_dst->u.port_info.port_id;
> > > >  }
> > > >
> > > > +static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
> > > > +                            u16 prod)
> > > > +{
> > > > +       bnxt_db_write(bp, &txr->tx_db, prod);
> > > > +       txr->kick_pending = 0;
> > > > +}
> > > > +
> > > >  static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > >  {
> > > >         struct bnxt *bp = netdev_priv(dev);
> > > > @@ -396,6 +404,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > >         free_size = bnxt_tx_avail(bp, txr);
> > > >         if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
> > > >                 netif_tx_stop_queue(txq);
> > > > +               if (net_ratelimit() && txr->kick_pending)
> > > > +                       netif_warn(bp, tx_err, dev, "bnxt: ring busy!\n");  
> > >
> > > You forgot to remove this.  
> >
> > I changed my mind. I added the && txr->kick_pending to the condition,
> > if there is a race and napi starts the queue unnecessarily the kick
> > can't be pending.  
> 
> I don't understand.  The queue should be stopped if we have <=
> MAX_SKB_FRAGS + 1 descriptors left.  If there is a race and the queue
> is awake, the first TX packet may slip through if
> skb_shinfo(skb)->nr_frags is small and we have enough descriptors for
> it.  Let's say xmit_more is set for this packet and so kick is
> pending.  The next packet may not fit anymore and it will hit this
> check here.

But even if we slip past this check we can only do it once, the check 
at the end of start_xmit() will see we have fewer slots than MAX_FRAGS
+ 2, ring the doorbell and stop.

> > > > @@ -661,7 +668,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> > > >                                PCI_DMA_TODEVICE);
> > > >         }
> > > >
> > > > +tx_free:
> > > >         dev_kfree_skb_any(skb);
> > > > +tx_kick_pending:
> > > > +       tx_buf->skb = NULL;  
> > >
> > > I think we should remove the setting of tx_buf->skb to NULL in the
> > > tx_dma_error path since we are setting it here now.  
> >
> > Are you suggesting to do something along the lines of:
> >
> >         txr->tx_buf_ring[txr->tx_prod].skb = NULL;  
> 
> Yeah, I like this the best.

Roger that, I'll send v3 tomorrow, I run out of day.
