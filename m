Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86671D8086
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732618AbfJOTrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:47:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbfJOTrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 15:47:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qAeKbbFoBrZqrdMk0zxE4DPvohBkLfW8P1NU3Sv2QnM=; b=QF7swB3/dgRWBXOw7xuq9tvWcV
        Kw0+5pLNmY5NH09zYy8dAymsoO7m+KlerNOccfZc8xK0awT5BFn/WEZ4aiJvQINxcADuI7hQhjyFq
        Onrq5zs4LOhpRUxy56FAjUE43SLPlDXDXeFLeSBwSYKz+TIRFKconOBVhoHs3KvLQ1Vw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iKSme-0003gW-J7; Tue, 15 Oct 2019 21:47:04 +0200
Date:   Tue, 15 Oct 2019 21:47:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Message-ID: <20191015194704.GE7839@lunn.ch>
References: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
 <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
 <20191015192923.GC7839@lunn.ch>
 <20191015124017.64a3d19b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191015124017.64a3d19b@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 12:40:17PM -0700, Jakub Kicinski wrote:
> On Tue, 15 Oct 2019 21:29:23 +0200, Andrew Lunn wrote:
> > > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > index 5acd734a216b..c3c2c06195ae 100644
> > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > @@ -1235,6 +1235,8 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
> > >  	priv->rx_td_enabled = enable;
> > >  }
> > >  
> > > +static void update_tx_fqids(struct dpaa2_eth_priv *priv);
> > > +  
> > 
> > Hi Ioana and Ioana
> > 
> > Using forward declarations is generally not liked. Is there something
> > which is preventing you from having it earlier in the file?
> 
> Ha! I was just about to ask the same question 😊
> 
> +out_err:
> +	netdev_info(priv->net_dev,
> +		    "Error reading Tx FQID, fallback to QDID-based enqueue");
> +	priv->enqueue = dpaa2_eth_enqueue_qd;
> +}
> 
> Here dpaa2_eth_enqueue_qd is a function pointer which is is defined
> towards the end of the file :S

Hi Jakub

Thanks, i was too lazy to look.

So this is O.K. for net, since fixes should be minimal.

Ioana's please could you submit a patch to net-next, once this has
been merged, to move the code around to remove the forward
declarations.

> Also can I point out that this:
> 
> static inline int dpaa2_eth_enqueue_qd(struct dpaa2_eth_priv *priv,             
>                                        struct dpaa2_eth_fq *fq,                 
>                                        struct dpaa2_fd *fd, u8 prio)            
> {                                                                               
>         return dpaa2_io_service_enqueue_qd(fq->channel->dpio,                   
>                                            priv->tx_qdid, prio,                 
>                                            fq->tx_qdbin, fd);                   
> }                                                                               
>                                                                                 
> static inline int dpaa2_eth_enqueue_fq(struct dpaa2_eth_priv *priv,             
>                                        struct dpaa2_eth_fq *fq,                 
>                                        struct dpaa2_fd *fd, u8 prio)            
> {                                                                               
>         return dpaa2_io_service_enqueue_fq(fq->channel->dpio,                   
>                                            fq->tx_fqid[prio], fd);              
> }                                                                               
>                                                                                 
> static void set_enqueue_mode(struct dpaa2_eth_priv *priv)                       
> {                                                                               
>         if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_ENQUEUE_FQID_VER_MAJOR,           
>                                    DPNI_ENQUEUE_FQID_VER_MINOR) < 0)            
>                 priv->enqueue = dpaa2_eth_enqueue_qd;                           
>         else                                                                    
>                 priv->enqueue = dpaa2_eth_enqueue_fq; 
> }
> 
> Could be the most pointless use of the inline keyword possible :)
> Both dpaa2_eth_enqueue_qd() and dpaa2_eth_enqueue_fq() are only ever
> called via a pointer..

Is priv->enqueue used on the hotpath? SPECTRA/Meltdown etc make that
expensive.

	Andrew
