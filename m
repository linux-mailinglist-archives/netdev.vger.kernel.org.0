Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4503E9B06
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhHKWpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232456AbhHKWpG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:45:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E68C561008;
        Wed, 11 Aug 2021 22:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628721882;
        bh=KRIDsvn548D+8WPv40zHFXc+poNoraZ6Uy6Y+dhxJtk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NHrFRjMghc0PcskZP2eaYE15D5Po2+PT3wh2TbXGA8EjELeuJBtUK01fgS8Lm6Lke
         ZB5/PxsBe7KCjX2y0qTj9Ae3WdUjNGoHYWVP3wVg3kng3AJnSjTIzgGVonsmwer+PD
         i/7bXUgDayYdWbnCjN7aKDtvthEq3DGjWOmZB3bvr5FZOVb1YZBL12hkuU1s/fpXeV
         OdwcSXbOLJ4wjHAOr9SC2aj+XJU9uCDHqGg6M3fbXI/fXMXAnOQn+IjEkE13y0zMv2
         /4UYZfKKpDoVsxeCtxQYJVkSHkE6SIIUZkYihVlBWbl5VRccHF3ovnmLY233jOopYn
         O+nIfHc9qoEQA==
Date:   Wed, 11 Aug 2021 15:44:41 -0700
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
Message-ID: <20210811154441.3b593d94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLinMd6a9Lwq_H1yNp8PFpvNmBsG5R+YGAYuCiF+i0OF+3w@mail.gmail.com>
References: <20210811213749.3276687-1-kuba@kernel.org>
        <20210811213749.3276687-4-kuba@kernel.org>
        <CACKFLinMd6a9Lwq_H1yNp8PFpvNmBsG5R+YGAYuCiF+i0OF+3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 15:36:34 -0700 Michael Chan wrote:
> On Wed, Aug 11, 2021 at 2:38 PM Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > ---
> > v2: - netdev_warn() -> netif_warn() [Edwin]
> >     - use correct prod value [Michael]
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 36 +++++++++++++++--------
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
> >  2 files changed, 25 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > index 52f5c8405e76..79bbd6ec7ef7 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -72,7 +72,8 @@
> >  #include "bnxt_debugfs.h"
> >
> >  #define BNXT_TX_TIMEOUT                (5 * HZ)
> > -#define BNXT_DEF_MSG_ENABLE    (NETIF_MSG_DRV | NETIF_MSG_HW)
> > +#define BNXT_DEF_MSG_ENABLE    (NETIF_MSG_DRV | NETIF_MSG_HW | \
> > +                                NETIF_MSG_TX_ERR)
> >
> >  MODULE_LICENSE("GPL");
> >  MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
> > @@ -367,6 +368,13 @@ static u16 bnxt_xmit_get_cfa_action(struct sk_buff *skb)
> >         return md_dst->u.port_info.port_id;
> >  }
> >
> > +static void bnxt_txr_db_kick(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
> > +                            u16 prod)
> > +{
> > +       bnxt_db_write(bp, &txr->tx_db, prod);
> > +       txr->kick_pending = 0;
> > +}
> > +
> >  static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  {
> >         struct bnxt *bp = netdev_priv(dev);
> > @@ -396,6 +404,8 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >         free_size = bnxt_tx_avail(bp, txr);
> >         if (unlikely(free_size < skb_shinfo(skb)->nr_frags + 2)) {
> >                 netif_tx_stop_queue(txq);
> > +               if (net_ratelimit() && txr->kick_pending)
> > +                       netif_warn(bp, tx_err, dev, "bnxt: ring busy!\n");  
> 
> You forgot to remove this.

I changed my mind. I added the && txr->kick_pending to the condition,
if there is a race and napi starts the queue unnecessarily the kick
can't be pending.

> >                 return NETDEV_TX_BUSY;
> >         }
> >
> > @@ -516,21 +526,16 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  normal_tx:
> >         if (length < BNXT_MIN_PKT_SIZE) {
> >                 pad = BNXT_MIN_PKT_SIZE - length;
> > -               if (skb_pad(skb, pad)) {
> > +               if (skb_pad(skb, pad))
> >                         /* SKB already freed. */
> > -                       tx_buf->skb = NULL;
> > -                       return NETDEV_TX_OK;
> > -               }
> > +                       goto tx_kick_pending;
> >                 length = BNXT_MIN_PKT_SIZE;
> >         }
> >
> >         mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
> >
> > -       if (unlikely(dma_mapping_error(&pdev->dev, mapping))) {
> > -               dev_kfree_skb_any(skb);
> > -               tx_buf->skb = NULL;
> > -               return NETDEV_TX_OK;
> > -       }
> > +       if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
> > +               goto tx_free;
> >
> >         dma_unmap_addr_set(tx_buf, mapping, mapping);
> >         flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
> > @@ -617,13 +622,15 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >         txr->tx_prod = prod;
> >
> >         if (!netdev_xmit_more() || netif_xmit_stopped(txq))
> > -               bnxt_db_write(bp, &txr->tx_db, prod);
> > +               bnxt_txr_db_kick(bp, txr, prod);
> > +       else
> > +               txr->kick_pending = 1;
> >
> >  tx_done:
> >
> >         if (unlikely(bnxt_tx_avail(bp, txr) <= MAX_SKB_FRAGS + 1)) {
> >                 if (netdev_xmit_more() && !tx_buf->is_push)
> > -                       bnxt_db_write(bp, &txr->tx_db, prod);
> > +                       bnxt_txr_db_kick(bp, txr, prod);
> >
> >                 netif_tx_stop_queue(txq);
> >
> > @@ -661,7 +668,12 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >                                PCI_DMA_TODEVICE);
> >         }
> >
> > +tx_free:
> >         dev_kfree_skb_any(skb);
> > +tx_kick_pending:
> > +       tx_buf->skb = NULL;  
> 
> I think we should remove the setting of tx_buf->skb to NULL in the
> tx_dma_error path since we are setting it here now.

But tx_buf gets moved IIRC - if we hit tx_dma_error tx_buf will be one
of the fragment bufs at this point. It should be legal to clear the skb
pointer on those AFAICT.

Are you suggesting to do something along the lines of:

	txr->tx_buf_ring[txr->tx_prod].skb = NULL;

?

> > +       if (txr->kick_pending)
> > +               bnxt_txr_db_kick(bp, txr, txr->tx_prod);
> >         return NETDEV_TX_OK;
> >  }
> >  

