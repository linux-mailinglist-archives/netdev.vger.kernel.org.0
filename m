Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0705C1F9A08
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 16:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgFOOYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 10:24:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43374 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728510AbgFOOYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 10:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592231080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UiGf3gARYDyYq7gcr6NhU0cCm6vwerWcROaD0jYBV/g=;
        b=azcOgM8NHqARKGpEmfJhY5fEJY9e66pqAY17UvJ6+hsOaBzBqD8twIH5Re0Cizyacoy6hN
        a25BIgK05YFhGx1m73QXFeS+VCm0+8kV5mE7slizUc8EWGyJuia3WRFysXhZse+yTBEnmp
        gCrMwqDc7rcQ3nrC07/KwNoJJdm3SIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-lvKCcVFKO2SHaBSHOEo0eg-1; Mon, 15 Jun 2020 10:24:38 -0400
X-MC-Unique: lvKCcVFKO2SHaBSHOEo0eg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD80718A0761;
        Mon, 15 Jun 2020 14:24:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E22E1DC;
        Mon, 15 Jun 2020 14:24:36 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 4CD5FC08D9; Mon, 15 Jun 2020 11:24:34 -0300 (-03)
Date:   Mon, 15 Jun 2020 11:24:34 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Alaa Hleihel <alaa@mellanox.com>
Subject: Re: [PATCH net 2/2] netfilter: flowtable: Make
 nf_flow_table_offload_add/del_cb inline
Message-ID: <20200615142434.GS47542@localhost.localdomain>
References: <20200614111249.6145-1-roid@mellanox.com>
 <20200614111249.6145-3-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614111249.6145-3-roid@mellanox.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 02:12:49PM +0300, Roi Dayan wrote:
> From: Alaa Hleihel <alaa@mellanox.com>
> 
> Currently, nf_flow_table_offload_add/del_cb are exported by nf_flow_table
> module, therefore modules using them will have hard-dependency
> on nf_flow_table and will require loading it all the time.
> 
> This can lead to an unnecessary overhead on systems that do not
> use this API.
> 
> To relax the hard-dependency between the modules, we unexport these
> functions and make them static inline.
> 
> Fixes: 978703f42549 ("netfilter: flowtable: Add API for registering to flow table events")
> Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  include/net/netfilter/nf_flow_table.h | 49 ++++++++++++++++++++++++++++++++---
>  net/netfilter/nf_flow_table_core.c    | 45 --------------------------------
>  2 files changed, 45 insertions(+), 49 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index c54a7f707e50..8a8f0e64edc3 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -161,10 +161,51 @@ struct nf_flow_route {
>  struct flow_offload *flow_offload_alloc(struct nf_conn *ct);
>  void flow_offload_free(struct flow_offload *flow);
>  
> -int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
> -				 flow_setup_cb_t *cb, void *cb_priv);
> -void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
> -				  flow_setup_cb_t *cb, void *cb_priv);
> +static inline int
> +nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
> +			     flow_setup_cb_t *cb, void *cb_priv)
> +{
> +	struct flow_block *block = &flow_table->flow_block;
> +	struct flow_block_cb *block_cb;
> +	int err = 0;
> +
> +	down_write(&flow_table->flow_block_lock);
> +	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
> +	if (block_cb) {
> +		err = -EEXIST;
> +		goto unlock;
> +	}
> +
> +	block_cb = flow_block_cb_alloc(cb, cb_priv, cb_priv, NULL);
> +	if (IS_ERR(block_cb)) {
> +		err = PTR_ERR(block_cb);
> +		goto unlock;
> +	}
> +
> +	list_add_tail(&block_cb->list, &block->cb_list);
> +
> +unlock:
> +	up_write(&flow_table->flow_block_lock);
> +	return err;
> +}
> +
> +static inline void
> +nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
> +			     flow_setup_cb_t *cb, void *cb_priv)
> +{
> +	struct flow_block *block = &flow_table->flow_block;
> +	struct flow_block_cb *block_cb;
> +
> +	down_write(&flow_table->flow_block_lock);
> +	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
> +	if (block_cb) {
> +		list_del(&block_cb->list);
> +		flow_block_cb_free(block_cb);
> +	} else {
> +		WARN_ON(true);
> +	}
> +	up_write(&flow_table->flow_block_lock);
> +}
>  
>  int flow_offload_route_init(struct flow_offload *flow,
>  			    const struct nf_flow_route *route);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 42da6e337276..647680175213 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -387,51 +387,6 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
>  	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
>  }
>  
> -int nf_flow_table_offload_add_cb(struct nf_flowtable *flow_table,
> -				 flow_setup_cb_t *cb, void *cb_priv)
> -{
> -	struct flow_block *block = &flow_table->flow_block;
> -	struct flow_block_cb *block_cb;
> -	int err = 0;
> -
> -	down_write(&flow_table->flow_block_lock);
> -	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
> -	if (block_cb) {
> -		err = -EEXIST;
> -		goto unlock;
> -	}
> -
> -	block_cb = flow_block_cb_alloc(cb, cb_priv, cb_priv, NULL);
> -	if (IS_ERR(block_cb)) {
> -		err = PTR_ERR(block_cb);
> -		goto unlock;
> -	}
> -
> -	list_add_tail(&block_cb->list, &block->cb_list);
> -
> -unlock:
> -	up_write(&flow_table->flow_block_lock);
> -	return err;
> -}
> -EXPORT_SYMBOL_GPL(nf_flow_table_offload_add_cb);
> -
> -void nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
> -				  flow_setup_cb_t *cb, void *cb_priv)
> -{
> -	struct flow_block *block = &flow_table->flow_block;
> -	struct flow_block_cb *block_cb;
> -
> -	down_write(&flow_table->flow_block_lock);
> -	block_cb = flow_block_cb_lookup(block, cb, cb_priv);
> -	if (block_cb) {
> -		list_del(&block_cb->list);
> -		flow_block_cb_free(block_cb);
> -	} else {
> -		WARN_ON(true);
> -	}
> -	up_write(&flow_table->flow_block_lock);
> -}
> -EXPORT_SYMBOL_GPL(nf_flow_table_offload_del_cb);
>  
>  static int nf_flow_nat_port_tcp(struct sk_buff *skb, unsigned int thoff,
>  				__be16 port, __be16 new_port)
> -- 
> 2.8.4
> 

