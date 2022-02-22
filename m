Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6504BF154
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 06:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiBVF2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 00:28:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiBVF2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 00:28:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825AC64EE;
        Mon, 21 Feb 2022 21:27:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D55B80E58;
        Tue, 22 Feb 2022 04:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF0EC340E8;
        Tue, 22 Feb 2022 04:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645505921;
        bh=lz7d+ajv2glqcSs4dUUHQK532fSPLIuatPETj6QhqmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GIyY7Eo5EOu0P+JyIfROzmSCQuMMpYhHAuNuqd7Q/fG+LiM7e/r0vu41xyHJO7q87
         0vpcD45iwitBrJtpFhxHUKgqdjgvmkw/rxXyI5ulBKi7Jh2IIZ9I39wc/ENYLU50SZ
         XcZLlU3mKVTWy6P/RttLpi6MfGN6braSjrHxipPoclktO3BaWiKO6N8N3C3amV4Xnh
         Yjydt5h79nusyiHd6u0ry8EK2kM/VDJ0e5+qRUgdzc7grpIA9dh4jT/MU4Oq31c+Mp
         OVu+GIErg1PjD2zV4N8OUXGZ17t/mkoQPYnCIYIyKT4Fhh/b9FSAW2WVseeLGxWPd/
         l28rMFpvCnc+Q==
Date:   Mon, 21 Feb 2022 20:58:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 5/5] netfilter: nf_tables: fix memory leak during
 stateful obj update
Message-ID: <20220221205840.08110cab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220221161757.250801-6-pablo@netfilter.org>
References: <20220221161757.250801-1-pablo@netfilter.org>
        <20220221161757.250801-6-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022 17:17:57 +0100 Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> stateful objects can be updated from the control plane.
> The transaction logic allocates a temporary object for this purpose.
> 
> The ->init function was called for this object, so plain kfree() leaks
> resources. We must call ->destroy function of the object.
> 
> nft_obj_destroy does this, but it also decrements the module refcount,
> but the update path doesn't increment it.
> 
> To avoid special-casing the update object release, do module_get for
> the update case too and release it via nft_obj_destroy().
> 
> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
> Cc: Fernando Fernandez Mancera <ffmancera@riseup.net>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 3081c4399f10..49060f281342 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6553,10 +6553,13 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
>  	struct nft_trans *trans;
>  	int err;
>  
> +	if (!try_module_get(type->owner))
> +		return -ENOENT;
> +
>  	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
>  				sizeof(struct nft_trans_obj));
>  	if (!trans)
> -		return -ENOMEM;
> +		goto err_trans;
>  
>  	newobj = nft_obj_init(ctx, type, attr);
>  	if (IS_ERR(newobj)) {
> @@ -6573,6 +6576,8 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
>  
>  err_free_trans:
>  	kfree(trans);
> +err_trans:
> +	module_put(type->owner);
>  	return err;
>  }
>  
> @@ -8185,7 +8190,7 @@ static void nft_obj_commit_update(struct nft_trans *trans)
>  	if (obj->ops->update)
>  		obj->ops->update(obj, newobj);
>  
> -	kfree(newobj);
> +	nft_obj_destroy(&trans->ctx, newobj);
>  }
>  
>  static void nft_commit_release(struct nft_trans *trans)
> @@ -8976,7 +8981,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
>  			break;
>  		case NFT_MSG_NEWOBJ:
>  			if (nft_trans_obj_update(trans)) {
> -				kfree(nft_trans_obj_newobj(trans));
> +				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
>  				nft_trans_destroy(trans);
>  			} else {
>  				trans->ctx.table->use--;

net/netfilter/nf_tables_api.c:6561:6: warning: variable 'err' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
        if (!trans)
            ^~~~~~
net/netfilter/nf_tables_api.c:6581:9: note: uninitialized use occurs here
        return err;
               ^~~
net/netfilter/nf_tables_api.c:6561:2: note: remove the 'if' if its condition is always false
        if (!trans)
        ^~~~~~~~~~~
net/netfilter/nf_tables_api.c:6554:9: note: initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
