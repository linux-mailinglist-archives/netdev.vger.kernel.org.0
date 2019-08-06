Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA683659
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732598AbfHFQKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:10:12 -0400
Received: from correo.us.es ([193.147.175.20]:46316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729638AbfHFQKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:10:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 736D8DA73F
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 18:10:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 645A21150DD
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 18:10:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5A3041150CC; Tue,  6 Aug 2019 18:10:10 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4CBE51150B9;
        Tue,  6 Aug 2019 18:10:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Aug 2019 18:10:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A87444265A31;
        Tue,  6 Aug 2019 18:10:07 +0200 (CEST)
Date:   Tue, 6 Aug 2019 18:10:00 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     jakub.kicinski@netronome.com, jiri@resnulli.us,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 5/6] flow_offload: support get
 multi-subsystem block
Message-ID: <20190806161000.3csoy3jlpq6cletq@salvia>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
 <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 09:24:00PM +0800, wenxu@ucloud.cn wrote:
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 8f1a7b8..6022dd0 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
[...]
> @@ -282,6 +282,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
>  }
>  EXPORT_SYMBOL(flow_block_cb_setup_simple);
>  
> +static LIST_HEAD(block_ing_cb_list);
> +
>  static struct rhashtable indr_setup_block_ht;
>  
>  struct flow_indr_block_cb {
> @@ -295,7 +297,6 @@ struct flow_indr_block_dev {
>  	struct rhash_head ht_node;
>  	struct net_device *dev;
>  	unsigned int refcnt;
> -	flow_indr_block_ing_cmd_t  *block_ing_cmd_cb;
>  	struct list_head cb_list;
>  };
>  
> @@ -389,6 +390,22 @@ static void flow_indr_block_cb_del(struct flow_indr_block_cb *indr_block_cb)
>  	kfree(indr_block_cb);
>  }
>  
> +static void flow_block_ing_cmd(struct net_device *dev,
> +			       flow_indr_block_bind_cb_t *cb,
> +			       void *cb_priv,
> +			       enum flow_block_command command)
> +{
> +	struct flow_indr_block_ing_entry *entry;
> +
> +	rcu_read_lock();
> +

unnecessary empty line.

> +	list_for_each_entry_rcu(entry, &block_ing_cb_list, list) {
> +		entry->cb(dev, cb, cb_priv, command);
> +	}
> +
> +	rcu_read_unlock();

OK, there's rcu_read_lock here...

> +}
> +
>  int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>  				  flow_indr_block_bind_cb_t *cb,
>  				  void *cb_ident)
> @@ -406,10 +423,8 @@ int __flow_indr_block_cb_register(struct net_device *dev, void *cb_priv,
>  	if (err)
>  		goto err_dev_put;
>  
> -	if (indr_dev->block_ing_cmd_cb)
> -		indr_dev->block_ing_cmd_cb(dev, indr_block_cb->cb,
> -					   indr_block_cb->cb_priv,
> -					   FLOW_BLOCK_BIND);
> +	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
> +			   FLOW_BLOCK_BIND);
>  
>  	return 0;
>  
> @@ -448,10 +463,8 @@ void __flow_indr_block_cb_unregister(struct net_device *dev,
>  	if (!indr_block_cb)
>  		return;
>  
> -	if (indr_dev->block_ing_cmd_cb)
> -		indr_dev->block_ing_cmd_cb(dev, indr_block_cb->cb,
> -					   indr_block_cb->cb_priv,
> -					   FLOW_BLOCK_UNBIND);
> +	flow_block_ing_cmd(dev, indr_block_cb->cb, indr_block_cb->cb_priv,
> +			   FLOW_BLOCK_UNBIND);
>  
>  	flow_indr_block_cb_del(indr_block_cb);
>  	flow_indr_block_dev_put(indr_dev);
> @@ -469,7 +482,6 @@ void flow_indr_block_cb_unregister(struct net_device *dev,
>  EXPORT_SYMBOL_GPL(flow_indr_block_cb_unregister);
>  
>  void flow_indr_block_call(struct net_device *dev,
> -			  flow_indr_block_ing_cmd_t cb,
>  			  struct flow_block_offload *bo,
>  			  enum flow_block_command command)
>  {
> @@ -480,15 +492,24 @@ void flow_indr_block_call(struct net_device *dev,
>  	if (!indr_dev)
>  		return;
>  
> -	indr_dev->block_ing_cmd_cb = command == FLOW_BLOCK_BIND
> -				     ? cb : NULL;
> -
>  	list_for_each_entry(indr_block_cb, &indr_dev->cb_list, list)
>  		indr_block_cb->cb(dev, indr_block_cb->cb_priv, TC_SETUP_BLOCK,
>  				  bo);
>  }
>  EXPORT_SYMBOL_GPL(flow_indr_block_call);
>  
> +void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry)
> +{

... but registration does not protect the list with a mutex.

> +	list_add_tail_rcu(&entry->list, &block_ing_cb_list);
> +}
> +EXPORT_SYMBOL_GPL(flow_indr_add_block_ing_cb);
