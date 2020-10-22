Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D419029596C
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508766AbgJVHlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:41:39 -0400
Received: from kernel.crashing.org ([76.164.61.194]:45166 "EHLO
        kernel.crashing.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506935AbgJVHlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:41:39 -0400
Received: from localhost (gate.crashing.org [63.228.1.57])
        (authenticated bits=0)
        by kernel.crashing.org (8.14.7/8.14.7) with ESMTP id 09M7fDFQ027629
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 22 Oct 2020 02:41:18 -0500
Message-ID: <428dc31828795ce0b010509c8c30bf0049ad9190.camel@kernel.crashing.org>
Subject: Re: [PATCH] net: ftgmac100: Ensure tx descriptor updates are visible
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Arnd Bergmann <arnd@kernel.org>, Joel Stanley <joel@jms.id.au>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>
Date:   Thu, 22 Oct 2020 18:41:13 +1100
In-Reply-To: <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
References: <20201020220639.130696-1-joel@jms.id.au>
         <CAK8P3a3gz4rMSkvZZ+TPaBx3B1yHXcUVFDdMFQMGUtEi4xXzyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-21 at 14:40 +0200, Arnd Bergmann wrote:
> On Wed, Oct 21, 2020 at 12:39 PM Joel Stanley <joel@jms.id.au> wrote:
> 
> > 
> > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> > index 331d4bdd4a67..15cdfeb135b0 100644
> > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > @@ -653,6 +653,11 @@ static bool ftgmac100_tx_complete_packet(struct ftgmac100 *priv)
> >         ftgmac100_free_tx_packet(priv, pointer, skb, txdes, ctl_stat);
> >         txdes->txdes0 = cpu_to_le32(ctl_stat & priv->txdes0_edotr_mask);
> > 
> > +       /* Ensure the descriptor config is visible before setting the tx
> > +        * pointer.
> > +        */
> > +       smp_wmb();
> > +
> >         priv->tx_clean_pointer = ftgmac100_next_tx_pointer(priv, pointer);
> > 
> >         return true;
> > @@ -806,6 +811,11 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
> >         dma_wmb();
> >         first->txdes0 = cpu_to_le32(f_ctl_stat);
> > 
> > +       /* Ensure the descriptor config is visible before setting the tx
> > +        * pointer.
> > +        */
> > +       smp_wmb();
> > +
> 
> Shouldn't these be paired with smp_rmb() on the reader side?

(Not near the code right now) I *think* the reader already has them
where it matters but I might have overlooked something when I quickly
checked the other day.

Cheers,
Ben.


