Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA207162D5F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgBRRsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:48:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbgBRRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:48:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582048129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdsEAPFgShQY67BuytKtr1SrRhmYCaZWAWtNbLCKDG8=;
        b=SvK0tHEShKBC3FFRQEqrnGvAK7FYVgTuwKcQe09MlY0jgsZrlWNBbGsfTXOElEnRjXk58N
        1XuZKz18EXpzMr6w0rA9ikmzO1dWNYpWYl5VduJqvxPcHsTbJJUCJWlo1nr76RT65k4pYS
        hcVuUs2h8XGlVeWwCiaq8jMpSqOM9bc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-Jtchoy2MN_uf-N_v7xRjqw-1; Tue, 18 Feb 2020 12:48:46 -0500
X-MC-Unique: Jtchoy2MN_uf-N_v7xRjqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D97E518B9FC1;
        Tue, 18 Feb 2020 17:48:44 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 007E95D9E5;
        Tue, 18 Feb 2020 17:48:32 +0000 (UTC)
Date:   Tue, 18 Feb 2020 18:48:31 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, andrew@lunn.ch,
        dsahern@kernel.org, bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@redhat.com>, brouer@redhat.com
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200218184831.4359a61a@carbon>
In-Reply-To: <20200218171716.GA13376@localhost.localdomain>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
        <20200218180210.130f0e6d@carbon>
        <20200218171716.GA13376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 18:17:16 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> > On Tue, 18 Feb 2020 01:14:29 +0100
> > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >   
> > > Introduce "rx" prefix in the name scheme for xdp counters
> > > on rx path.
> > > Differentiate between XDP_TX and ndo_xdp_xmit counters
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++-----
> > >  1 file changed, 17 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > index b7045b6a15c2..6223700dc3df 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -344,6 +344,7 @@ enum {
> > >  	ETHTOOL_XDP_REDIRECT,
> > >  	ETHTOOL_XDP_PASS,
> > >  	ETHTOOL_XDP_DROP,
> > > +	ETHTOOL_XDP_XMIT,
> > >  	ETHTOOL_XDP_TX,
> > >  	ETHTOOL_MAX_STATS,
> > >  };
> > > @@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_statistics[] = {
> > >  	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
> > >  	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
> > >  	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
> > > -	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
> > > -	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
> > > -	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
> > > -	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
> > > +	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
> > > +	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
> > > +	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
> > > +	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx_xmit", },  
> > 
> > Hmmm... "rx_xdp_tx_xmit", I expected this to be named "rx_xdp_tx" to
> > count the XDP_TX actions, but I guess this means something else.  
> 
> just reused mlx5 naming scheme here :)

Well, IMHO the naming in mlx5 should not automatically be seen as the
correct way ;-)
 
> >   
> > > +	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },  
> > 
> > Okay, maybe.  I guess, this will still be valid for when we add an
> > XDP egress/TX-hook point.  
> 
> same here
> 
> >   
> > >  };
> > >  
> > >  struct mvneta_stats {
> > > @@ -414,6 +416,7 @@ struct mvneta_stats {
> > >  	u64	xdp_redirect;
> > >  	u64	xdp_pass;
> > >  	u64	xdp_drop;
> > > +	u64	xdp_xmit;
> > >  	u64	xdp_tx;
> > >  };
> > >  
> > > @@ -2050,7 +2053,10 @@ mvneta_xdp_submit_frame(struct mvneta_port
> > > *pp, struct mvneta_tx_queue *txq,
> > > u64_stats_update_begin(&stats->syncp); stats->es.ps.tx_bytes +=
> > > xdpf->len; stats->es.ps.tx_packets++;
> > > -	stats->es.ps.xdp_tx++;
> > > +	if (buf->type == MVNETA_TYPE_XDP_NDO)
> > > +		stats->es.ps.xdp_xmit++;
> > > +	else
> > > +		stats->es.ps.xdp_tx++;  
> > 
> > I don't like that you add a branch (if-statement) in this fast-path
> > code.
> > 
> > Do we really need to account in the xmit frame function, if this
> > was a XDP_REDIRECT or XDP_TX that started the xmit?  I mean we
> > already have action counters for XDP_REDIRECT and XDP_TX (but I
> > guess you skipped the XDP_TX action counter).   
> 
> ack, good point..I think we can move the code in
> mvneta_xdp_xmit_back/mvneta_xdp_xmit in order to avoid the if()
> condition. Moreover we can move it out the for loop in
> mvneta_xdp_xmit().

Sure, but I want the "xmit" counter (or what every we call it) to only
increment if the Ethernet frame was successfully queued. For me that is
an important property of the counter.  As I want a sysadm to be able to
use this counter to see if frames are getting dropped due to TX-queue
overflow by comparing/correlating counters.

This also begs the question: Should we have a counter for TX-queue
overflows?  That will make it even easier to diagnose problems from a
sysadm perspective?


> I will fix in a formal patch


> >   
> > >  	u64_stats_update_end(&stats->syncp);
> > >  
> > >  	mvneta_txq_inc_put(txq);
> > > @@ -4484,6 +4490,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
> > >  		u64 xdp_redirect;
> > >  		u64 xdp_pass;
> > >  		u64 xdp_drop;
> > > +		u64 xdp_xmit;
> > >  		u64 xdp_tx;
> > >  
> > >  		stats = per_cpu_ptr(pp->stats, cpu);
> > > @@ -4494,6 +4501,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
> > >  			xdp_redirect = stats->es.ps.xdp_redirect;
> > >  			xdp_pass = stats->es.ps.xdp_pass;
> > >  			xdp_drop = stats->es.ps.xdp_drop;
> > > +			xdp_xmit = stats->es.ps.xdp_xmit;
> > >  			xdp_tx = stats->es.ps.xdp_tx;
> > >  		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
> > >  
> > > @@ -4502,6 +4510,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
> > >  		es->ps.xdp_redirect += xdp_redirect;
> > >  		es->ps.xdp_pass += xdp_pass;
> > >  		es->ps.xdp_drop += xdp_drop;
> > > +		es->ps.xdp_xmit += xdp_xmit;
> > >  		es->ps.xdp_tx += xdp_tx;
> > >  	}
> > >  }
> > > @@ -4555,6 +4564,9 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
> > >  			case ETHTOOL_XDP_TX:
> > >  				pp->ethtool_stats[i] = stats.ps.xdp_tx;
> > >  				break;
> > > +			case ETHTOOL_XDP_XMIT:
> > > +				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
> > > +				break;
> > >  			}
> > >  			break;
> > >  		}  
> > 
> > It doesn't look like you have an action counter for XDP_TX, but we have
> > one for XDP_REDIRECT?  
> 
> I did not get you here sorry, I guess they should be accounted in two
> separated counters.

Checking code that got applied, you have xdp "action" counters for:
 - XDP_PASS     => stats->xdp_pass++;
 - XDP_REDIRECT => stats->xdp_redirect++ (on xdp_do_redirect == 0)
 - XDP_TX       => no-counter
 - XDP_ABORTED  => fall-through (to stats->xdp_drop++);
 - XDP_DROP     => stats->xdp_drop++

Notice the action XDP_TX is not accounted, that was my point.  While
all other XDP "actions" have a counter.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

