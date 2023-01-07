Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAE5660BB1
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 03:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbjAGCEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 21:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjAGCEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 21:04:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3542284BC9;
        Fri,  6 Jan 2023 18:04:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA36761FC9;
        Sat,  7 Jan 2023 02:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79737C433EF;
        Sat,  7 Jan 2023 02:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673057069;
        bh=eXKo7QYU90F0i+EYDEsUIHPHKJBoRS8xY5pfwKzPS9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UNxJqKKEbdICrNiQVuxmXTG9U7Pdb9HJe5AikMAS2GyghC+PLAyiomDf1ZMN/8b8q
         wNJ6svHD+OZqPlNv0zLIy1xTsA79xMZmk1BfOJx1x/nGcBBcliM4/uhE/NnA8FXVmy
         gXZTMbefvBwkZ4o4DK6abTTXvdCnywq1EB8842T+thIgTLZ3DGj+iFfFlKXP8FgS2s
         6m6qjg+scB2kq+GCa6BUhXidGTKEa75FqC/Aibaev4dvWCVl5M2OEcT8abRloSXkDY
         DeW8ab8EhcWhrO+OJhOzzv74YEnSWwCP6SaXYtBCp50Bul3vcQUS81Ep6Ze3dPMW4y
         ZR6/XAuX98ebA==
Date:   Fri, 6 Jan 2023 18:04:27 -0800
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
Subject: Re: [PATCH v2 2/5] crypto/pool: Add crypto_pool_reserve_scratch()
Message-ID: <20230106180427.2ccbea51@kernel.org>
In-Reply-To: <20230103184257.118069-3-dima@arista.com>
References: <20230103184257.118069-1-dima@arista.com>
        <20230103184257.118069-3-dima@arista.com>
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

On Tue,  3 Jan 2023 18:42:54 +0000 Dmitry Safonov wrote:
> Instead of having build-time hardcoded constant, reallocate scratch
> area, if needed by user. Different algos, different users may need
> different size of temp per-CPU buffer. Only up-sizing supported for
> simplicity.

> -static int crypto_pool_scratch_alloc(void)
> +/* Slow-path */
> +/**
> + * crypto_pool_reserve_scratch - re-allocates scratch buffer, slow-path
> + * @size: request size for the scratch/temp buffer
> + */
> +int crypto_pool_reserve_scratch(unsigned long size)

Does this have to be a separate call? Can't we make it part of 
the pool allocation? AFAICT the scratch gets freed when last
pool is freed, so the user needs to know to allocate the pool
_first_ otherwise there's a potential race:

 CPU 1               CPU 2

 alloc pool
                    set scratch
 free pool
 [frees scratch]
                    alloc pool

>  {
> -	int cpu;
> -
> -	lockdep_assert_held(&cpool_mutex);
> +#define FREE_BATCH_SIZE		64
> +	void *free_batch[FREE_BATCH_SIZE];
> +	int cpu, err = 0;
> +	unsigned int i = 0;
>  
> +	mutex_lock(&cpool_mutex);
> +	if (size == scratch_size) {
> +		for_each_possible_cpu(cpu) {
> +			if (per_cpu(crypto_pool_scratch, cpu))
> +				continue;
> +			goto allocate_scratch;
> +		}
> +		mutex_unlock(&cpool_mutex);
> +		return 0;
> +	}
> +allocate_scratch:
> +	size = max(size, scratch_size);
> +	cpus_read_lock();
>  	for_each_possible_cpu(cpu) {
> -		void *scratch = per_cpu(crypto_pool_scratch, cpu);
> +		void *scratch, *old_scratch;
>  
> -		if (scratch)
> +		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
> +		if (!scratch) {
> +			err = -ENOMEM;
> +			break;
> +		}
> +
> +		old_scratch = per_cpu(crypto_pool_scratch, cpu);
> +		/* Pairs with crypto_pool_get() */
> +		WRITE_ONCE(*per_cpu_ptr(&crypto_pool_scratch, cpu), scratch);

You're using RCU for protection here, please use rcu accessors.

> +		if (!cpu_online(cpu)) {
> +			kfree(old_scratch);
>  			continue;
> +		}
> +		free_batch[i++] = old_scratch;
> +		if (i == FREE_BATCH_SIZE) {
> +			cpus_read_unlock();
> +			synchronize_rcu();
> +			while (i > 0)
> +				kfree(free_batch[--i]);
> +			cpus_read_lock();
> +		}

This is a memory allocation routine, can we simplify this by
dynamically sizing "free_batch" and using call_rcu()?

struct humf_blah {
	struct rcu_head rcu;
	unsigned int cnt;
	void *data[];
};

cheezit = kmalloc(struct_size(blah, data, num_possible_cpus()));

for_each ..
	cheezit->data[cheezit->cnt++] = old_scratch;

call_rcu(&cheezit->rcu, my_free_them_scratches)

etc.

Feels like that'd be much less locking, unlocking and general
carefully'ing.

> +	}
> +	cpus_read_unlock();
> +	if (!err)
> +		scratch_size = size;

