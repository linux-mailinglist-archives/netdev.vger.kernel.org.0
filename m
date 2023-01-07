Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C65660BA5
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 02:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjAGBxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 20:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbjAGBxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 20:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C17C87932;
        Fri,  6 Jan 2023 17:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8942B81EFF;
        Sat,  7 Jan 2023 01:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A27C433D2;
        Sat,  7 Jan 2023 01:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673056408;
        bh=6XskKwH1CcZPB6O4nU/7JgwwAU5XHZ3lVHzF1vTq5Hw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BGkNH17nlSOCeDY+Hd+W1EEpFyZlxMLfAvXiMTK+K5HQFZg/AQlzgt1GEfK48zDHQ
         sSDnIFVhaSWC8da37uqt8M91WVQYg2pKPh69uh8Pt+PpUd/xgOT/HIH6GROlrF0sh2
         4SCThLZe1wi3HZ8U7b3qklyxU+hDq5Fddxg6XrB5l2z3B2igCRPsy6bkYmEO9wWYJ/
         sFi5kkO3Ul1WXeuruMUaeyI0CTwNJPgseXnnljALc3zvSercpjxgZOJQKisHzkAPxR
         l5nz9YgRmbCFJ+iLK31bbHlA+vVOSl9RCTwfY9+TG8DJEY3cD5txwLc7NO+jrsKsqt
         4/IeHxnwZMvIQ==
Date:   Fri, 6 Jan 2023 17:53:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/5] crypto: Introduce crypto_pool
Message-ID: <20230106175326.2d6a4dcd@kernel.org>
In-Reply-To: <20230103184257.118069-2-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
        <20230103184257.118069-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Jan 2023 18:42:53 +0000 Dmitry Safonov wrote:
> Introduce a per-CPU pool of async crypto requests that can be used
> in bh-disabled contexts (designed with net RX/TX softirqs as users in
> mind). Allocation can sleep and is a slow-path.
> Initial implementation has only ahash as a backend and a fix-sized array
> of possible algorithms used in parallel.
> 
> Signed-off-by: Dmitry Safonov <dima@arista.com>

> +config CRYPTO_POOL
> +	tristate "Per-CPU crypto pool"
> +	default n
> +	help
> +	  Per-CPU pool of crypto requests ready for usage in atomic contexts.

Let's make it a hidden symbol? It seems like a low-level library
which gets select'ed, so no point bothering users with questions.

config CRYPTO_POOL
	tristate

that's it.

> +static int crypto_pool_scratch_alloc(void)

This isn't called by anything in this patch..
crypto_pool_alloc_ahash() should call it I'm guessing?

> +{
> +	int cpu;
> +
> +	lockdep_assert_held(&cpool_mutex);
> +
> +	for_each_possible_cpu(cpu) {
> +		void *scratch = per_cpu(crypto_pool_scratch, cpu);
> +
> +		if (scratch)
> +			continue;
> +
> +		scratch = kmalloc_node(scratch_size, GFP_KERNEL,
> +				       cpu_to_node(cpu));
> +		if (!scratch)
> +			return -ENOMEM;
> +		per_cpu(crypto_pool_scratch, cpu) = scratch;
> +	}
> +	return 0;
> +}

> +out_free:
> +	if (!IS_ERR_OR_NULL(hash) && e->needs_key)
> +		crypto_free_ahash(hash);
> +
> +	for_each_possible_cpu(cpu) {
> +		if (*per_cpu_ptr(e->req, cpu) == NULL)
> +			break;
> +		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->req, cpu));

Could you use a local variable here instead of @hash?
That way you won't need the two separate free_ahash()
one before and one after the loop..

> +		ahash_request_free(*per_cpu_ptr(e->req, cpu));

I think using @req here would be beneficial as well :S

> +		if (e->needs_key) {
> +			crypto_free_ahash(hash);
> +			hash = NULL;
> +		}
> +	}
> +
> +	if (hash)
> +		crypto_free_ahash(hash);

This error handling is tricky as hell, please just add a separate
variable to hold the 

> +out_free_req:
> +	free_percpu(e->req);
> +out_free_alg:
> +	kfree(e->alg);
> +	e->alg = NULL;
> +	return ret;
> +}
> +
> +/**
> + * crypto_pool_alloc_ahash - allocates pool for ahash requests
> + * @alg: name of async hash algorithm
> + */
> +int crypto_pool_alloc_ahash(const char *alg)
> +{
> +	int i, ret;
> +
> +	/* slow-path */
> +	mutex_lock(&cpool_mutex);
> +
> +	for (i = 0; i < cpool_populated; i++) {
> +		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
> +			if (kref_read(&cpool[i].kref) > 0) {

In the current design we can as well resurrect a pool waiting to 
be destroyed, right? Just reinit the ref and we're good.

Otherwise the read() + get() looks quite suspicious to a reader.

> +				kref_get(&cpool[i].kref);
> +				ret = i;
> +				goto out;
> +			} else {
> +				break;
> +			}
> +		}
> +	}
> +
> +	for (i = 0; i < cpool_populated; i++) {
> +		if (!cpool[i].alg)
> +			break;
> +	}
> +	if (i >= CPOOL_SIZE) {
> +		ret = -ENOSPC;
> +		goto out;
> +	}
> +
> +	ret = __cpool_alloc_ahash(&cpool[i], alg);
> +	if (!ret) {
> +		ret = i;
> +		if (i == cpool_populated)
> +			cpool_populated++;
> +	}
> +out:
> +	mutex_unlock(&cpool_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(crypto_pool_alloc_ahash);

> +/**
> + * crypto_pool_add - increases number of users (refcounter) for a pool
> + * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
> + */
> +void crypto_pool_add(unsigned int id)
> +{
> +	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
> +		return;
> +	kref_get(&cpool[id].kref);
> +}
> +EXPORT_SYMBOL_GPL(crypto_pool_add);
> +
> +/**
> + * crypto_pool_get - disable bh and start using crypto_pool
> + * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
> + * @c: returned crypto_pool for usage (uninitialized on failure)
> + */
> +int crypto_pool_get(unsigned int id, struct crypto_pool *c)

Is there a precedent somewhere for the _add() and _get() semantics
you're using here? I don't think I've seen _add() for taking a
reference, maybe _get() -> start(), _add() -> _get()?

> +{
> +	struct crypto_pool_ahash *ret = (struct crypto_pool_ahash *)c;
> +
> +	local_bh_disable();
> +	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg)) {
> +		local_bh_enable();
> +		return -EINVAL;
> +	}
> +	ret->req = *this_cpu_ptr(cpool[id].req);
> +	ret->base.scratch = this_cpu_read(crypto_pool_scratch);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(crypto_pool_get);

