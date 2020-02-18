Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E570162B37
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgBRRC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:02:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51427 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726403AbgBRRC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582045347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=icIeh1VYwN1vz+jlOHFF+iV6L33s19ZLs82Zd9uQ9AU=;
        b=WLOzl1qsBhqYDnxbQlX89HTVv7BGPfDDzfn8g7lNw4psMb+TECAerZKJ5MM6d6vfhAI/qU
        pMFNpQrCFs1sac4WbS6c4zoTxwmFPFRDpSfQGW4dOQ9EatJ+TcF9FWNLBIsB2cKUOzJTTU
        eFVmDzBT6mo11Vio+SsgyvpeVfiUmMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-HcXZNYKWMv2L1sulpvpQPQ-1; Tue, 18 Feb 2020 12:02:25 -0500
X-MC-Unique: HcXZNYKWMv2L1sulpvpQPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E7B28017DF;
        Tue, 18 Feb 2020 17:02:23 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BF9A19756;
        Tue, 18 Feb 2020 17:02:12 +0000 (UTC)
Date:   Tue, 18 Feb 2020 18:02:10 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com, andrew@lunn.ch,
        dsahern@kernel.org, bpf@vger.kernel.org, brouer@redhat.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [RFC net-next] net: mvneta: align xdp stats naming scheme to
 mlx5 driver
Message-ID: <20200218180210.130f0e6d@carbon>
In-Reply-To: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
References: <526238d9bcc60500ed61da1a4af8b65af1af9583.1581984697.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 01:14:29 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce "rx" prefix in the name scheme for xdp counters
> on rx path.
> Differentiate between XDP_TX and ndo_xdp_xmit counters
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index b7045b6a15c2..6223700dc3df 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -344,6 +344,7 @@ enum {
>  	ETHTOOL_XDP_REDIRECT,
>  	ETHTOOL_XDP_PASS,
>  	ETHTOOL_XDP_DROP,
> +	ETHTOOL_XDP_XMIT,
>  	ETHTOOL_XDP_TX,
>  	ETHTOOL_MAX_STATS,
>  };
> @@ -399,10 +400,11 @@ static const struct mvneta_statistic mvneta_statistics[] = {
>  	{ ETHTOOL_STAT_EEE_WAKEUP, T_SW, "eee_wakeup_errors", },
>  	{ ETHTOOL_STAT_SKB_ALLOC_ERR, T_SW, "skb_alloc_errors", },
>  	{ ETHTOOL_STAT_REFILL_ERR, T_SW, "refill_errors", },
> -	{ ETHTOOL_XDP_REDIRECT, T_SW, "xdp_redirect", },
> -	{ ETHTOOL_XDP_PASS, T_SW, "xdp_pass", },
> -	{ ETHTOOL_XDP_DROP, T_SW, "xdp_drop", },
> -	{ ETHTOOL_XDP_TX, T_SW, "xdp_tx", },
> +	{ ETHTOOL_XDP_REDIRECT, T_SW, "rx_xdp_redirect", },
> +	{ ETHTOOL_XDP_PASS, T_SW, "rx_xdp_pass", },
> +	{ ETHTOOL_XDP_DROP, T_SW, "rx_xdp_drop", },
> +	{ ETHTOOL_XDP_TX, T_SW, "rx_xdp_tx_xmit", },

Hmmm... "rx_xdp_tx_xmit", I expected this to be named "rx_xdp_tx" to
count the XDP_TX actions, but I guess this means something else.

> +	{ ETHTOOL_XDP_XMIT, T_SW, "tx_xdp_xmit", },

Okay, maybe.  I guess, this will still be valid for when we add an XDP
egress/TX-hook point.

>  };
>  
>  struct mvneta_stats {
> @@ -414,6 +416,7 @@ struct mvneta_stats {
>  	u64	xdp_redirect;
>  	u64	xdp_pass;
>  	u64	xdp_drop;
> +	u64	xdp_xmit;
>  	u64	xdp_tx;
>  };
>  
> @@ -2050,7 +2053,10 @@ mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
>  	u64_stats_update_begin(&stats->syncp);
>  	stats->es.ps.tx_bytes += xdpf->len;
>  	stats->es.ps.tx_packets++;
> -	stats->es.ps.xdp_tx++;
> +	if (buf->type == MVNETA_TYPE_XDP_NDO)
> +		stats->es.ps.xdp_xmit++;
> +	else
> +		stats->es.ps.xdp_tx++;

I don't like that you add a branch (if-statement) in this fast-path code.

Do we really need to account in the xmit frame function, if this was a
XDP_REDIRECT or XDP_TX that started the xmit?  I mean we already have
action counters for XDP_REDIRECT and XDP_TX (but I guess you skipped
the XDP_TX action counter). 


>  	u64_stats_update_end(&stats->syncp);
>  
>  	mvneta_txq_inc_put(txq);
> @@ -4484,6 +4490,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
>  		u64 xdp_redirect;
>  		u64 xdp_pass;
>  		u64 xdp_drop;
> +		u64 xdp_xmit;
>  		u64 xdp_tx;
>  
>  		stats = per_cpu_ptr(pp->stats, cpu);
> @@ -4494,6 +4501,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
>  			xdp_redirect = stats->es.ps.xdp_redirect;
>  			xdp_pass = stats->es.ps.xdp_pass;
>  			xdp_drop = stats->es.ps.xdp_drop;
> +			xdp_xmit = stats->es.ps.xdp_xmit;
>  			xdp_tx = stats->es.ps.xdp_tx;
>  		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
>  
> @@ -4502,6 +4510,7 @@ mvneta_ethtool_update_pcpu_stats(struct mvneta_port *pp,
>  		es->ps.xdp_redirect += xdp_redirect;
>  		es->ps.xdp_pass += xdp_pass;
>  		es->ps.xdp_drop += xdp_drop;
> +		es->ps.xdp_xmit += xdp_xmit;
>  		es->ps.xdp_tx += xdp_tx;
>  	}
>  }
> @@ -4555,6 +4564,9 @@ static void mvneta_ethtool_update_stats(struct mvneta_port *pp)
>  			case ETHTOOL_XDP_TX:
>  				pp->ethtool_stats[i] = stats.ps.xdp_tx;
>  				break;
> +			case ETHTOOL_XDP_XMIT:
> +				pp->ethtool_stats[i] = stats.ps.xdp_xmit;
> +				break;
>  			}
>  			break;
>  		}

It doesn't look like you have an action counter for XDP_TX, but we have
one for XDP_REDIRECT?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

