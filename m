Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298E51FD573
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 21:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgFQT3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 15:29:50 -0400
Received: from correo.us.es ([193.147.175.20]:49366 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgFQT3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 15:29:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0103D8C3C56
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 21:29:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E77B0DA789
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 21:29:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DCF82DA78E; Wed, 17 Jun 2020 21:29:46 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A741FDA78A;
        Wed, 17 Jun 2020 21:29:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 17 Jun 2020 21:29:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8D9C842EE395;
        Wed, 17 Jun 2020 21:29:44 +0200 (CEST)
Date:   Wed, 17 Jun 2020 21:29:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vladbu@mellanox.com,
        simon.horman@netronome.com
Subject: Re: [PATCH net v4 1/4] flow_offload: add
 flow_indr_block_cb_alloc/remove function
Message-ID: <20200617192944.GA11655@salvia>
References: <1592412907-3856-1-git-send-email-wenxu@ucloud.cn>
 <1592412907-3856-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592412907-3856-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:55:04AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add flow_indr_block_cb_alloc/remove function prepare for the bug fix
> in the third patch.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/net/flow_offload.h | 13 +++++++++++++
>  net/core/flow_offload.c    | 43 ++++++++++++++++++++++++++++++++-----------
>  2 files changed, 45 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index f2c8311..bf43430 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -467,6 +467,12 @@ struct flow_block_cb {
>  struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
>  					  void *cb_ident, void *cb_priv,
>  					  void (*release)(void *cb_priv));
> +struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
> +					       void *cb_ident, void *cb_priv,
> +					       void (*release)(void *cb_priv),
> +					       struct flow_block_offload *bo,
> +					       struct net_device *dev, void *data,
> +					       void (*cleanup)(struct flow_block_cb *block_cb));
>  void flow_block_cb_free(struct flow_block_cb *block_cb);
>  
>  struct flow_block_cb *flow_block_cb_lookup(struct flow_block *block,
> @@ -488,6 +494,13 @@ static inline void flow_block_cb_remove(struct flow_block_cb *block_cb,
>  	list_move(&block_cb->list, &offload->cb_list);
>  }
>  
> +static inline void flow_indr_block_cb_remove(struct flow_block_cb *block_cb,
> +					     struct flow_block_offload *offload)
> +{
> +	list_del(&block_cb->indr.list);
> +	list_move(&block_cb->list, &offload->cb_list);
> +}
> +
>  bool flow_block_cb_is_busy(flow_setup_cb_t *cb, void *cb_ident,
>  			   struct list_head *driver_block_list);
>  
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 0cfc35e..9fe4b58 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -329,6 +329,38 @@ struct flow_indr_dev {
>  	struct rcu_head			rcu;
>  };
>  
> +static void flow_block_indr_init(struct flow_block_cb *flow_block,
> +				 struct flow_block_offload *bo,
> +				 struct net_device *dev, void *data,
> +				 void (*cleanup)(struct flow_block_cb *block_cb))
> +{
> +	flow_block->indr.binder_type = bo->binder_type;
> +	flow_block->indr.data = data;
> +	flow_block->indr.dev = dev;
> +	flow_block->indr.cleanup = cleanup;
> +}
> +
> +struct flow_block_cb *flow_indr_block_cb_alloc(flow_setup_cb_t *cb,
> +					       void *cb_ident, void *cb_priv,
> +					       void (*release)(void *cb_priv),
> +					       struct flow_block_offload *bo,
> +					       struct net_device *dev, void *data,
> +					       void (*cleanup)(struct flow_block_cb *block_cb))
> +{
> +	struct flow_block_cb *block_cb;
> +
> +	block_cb = flow_block_cb_alloc(cb, cb_ident, cb_priv, release);
> +	if (IS_ERR(block_cb))
> +		goto out;
> +
> +	flow_block_indr_init(block_cb, bo, dev, data, cleanup);
> +	list_add(&block_cb->indr.list, &flow_block_indr_list);
> +
> +out:
> +	return block_cb;
> +}
> +EXPORT_SYMBOL(flow_indr_block_cb_alloc);

You can probably place flow_indr_block_cb_alloc() right before
flow_indr_dev_setup_offload(), so you don't have to move
flow_block_indr_init() ?
