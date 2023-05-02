Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314586F4266
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjEBLOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEBLOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:14:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5FAA4;
        Tue,  2 May 2023 04:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qSL9OkS9lUf+/Y0rKTYhB5gamqdgUqvemLYpwvoIblc=; b=nyzYxVwkDYSGs+p8GZKdRUmbVj
        Guk04quwpkt4KIxKlgvRq3hDoGXk8vII7ZwOwysVQJCDxD43IcwITOv8Ukdr45u9zmDX6QMz4+ZLF
        LqkGMCkKLaN//YYSjQyG5rR4N3Zm3NnDNwEoajETpYIv0qstEhNJpklrqzN+7T7GAfsy1KwEUWIp3
        2ZzcofszrGMZajnGYhtwC+KoakXv3sPRbf2mmipIl0Okn41UYHFcjQqBRK0YkzxsIQRNfunJH19jn
        gmExS18rx3m3bAnr1WnkjVxjqHvFlbaQ4e4wrs7y3THRwDT87WlmVeGXRICl7RWDw8PvbZ2LrvrCF
        9u27uBeQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1ptnwv-00GI5F-13;
        Tue, 02 May 2023 11:13:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BEDB2300348;
        Tue,  2 May 2023 13:13:34 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 79C6A23C5C34E; Tue,  2 May 2023 13:13:34 +0200 (CEST)
Date:   Tue, 2 May 2023 13:13:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v6 3/3] mm/gup: disallow FOLL_LONGTERM GUP-fast writing
 to file-backed mappings
Message-ID: <20230502111334.GP1597476@hirez.programming.kicks-ass.net>
References: <cover.1682981880.git.lstoakes@gmail.com>
 <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dee4f4ad6532b0f94d073da263526de334d5d7e0.1682981880.git.lstoakes@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 12:11:49AM +0100, Lorenzo Stoakes wrote:
> @@ -95,6 +96,77 @@ static inline struct folio *try_get_folio(struct page *page, int refs)
>  	return folio;
>  }
>  
> +#ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
> +static bool stabilise_mapping_rcu(struct folio *folio)
> +{
> +	struct address_space *mapping = READ_ONCE(folio->mapping);
> +
> +	rcu_read_lock();
> +
> +	return mapping == READ_ONCE(folio->mapping);

This doesn't make sense; why bother reading the same thing twice?

Who cares if the thing changes from before; what you care about is that
the value you see has stable storage, this doesn't help with that.

> +}
> +
> +static void unlock_rcu(void)
> +{
> +	rcu_read_unlock();
> +}
> +#else
> +static bool stabilise_mapping_rcu(struct folio *)
> +{
> +	return true;
> +}
> +
> +static void unlock_rcu(void)
> +{
> +}
> +#endif

Anyway, this all can go away. RCU can't progress while you have
interrupts disabled anyway.

> +/*
> + * Used in the GUP-fast path to determine whether a FOLL_PIN | FOLL_LONGTERM |
> + * FOLL_WRITE pin is permitted for a specific folio.
> + *
> + * This assumes the folio is stable and pinned.
> + *
> + * Writing to pinned file-backed dirty tracked folios is inherently problematic
> + * (see comment describing the writeable_file_mapping_allowed() function). We
> + * therefore try to avoid the most egregious case of a long-term mapping doing
> + * so.
> + *
> + * This function cannot be as thorough as that one as the VMA is not available
> + * in the fast path, so instead we whitelist known good cases.
> + *
> + * The folio is stable, but the mapping might not be. When truncating for
> + * instance, a zap is performed which triggers TLB shootdown. IRQs are disabled
> + * so we are safe from an IPI, but some architectures use an RCU lock for this
> + * operation, so we acquire an RCU lock to ensure the mapping is stable.
> + */
> +static bool folio_longterm_write_pin_allowed(struct folio *folio)
> +{
> +	bool ret;
> +
> +	/* hugetlb mappings do not require dirty tracking. */
> +	if (folio_test_hugetlb(folio))
> +		return true;
> +

This:

> +	if (stabilise_mapping_rcu(folio)) {
> +		struct address_space *mapping = folio_mapping(folio);

And this is 3rd read of folio->mapping, just for giggles?

> +
> +		/*
> +		 * Neither anonymous nor shmem-backed folios require
> +		 * dirty tracking.
> +		 */
> +		ret = folio_test_anon(folio) ||
> +			(mapping && shmem_mapping(mapping));
> +	} else {
> +		/* If the mapping is unstable, fallback to the slow path. */
> +		ret = false;
> +	}
> +
> +	unlock_rcu();
> +
> +	return ret;

then becomes:


	if (folio_test_anon(folio))
		return true;

	/*
	 * Having IRQs disabled (as per GUP-fast) also inhibits RCU
	 * grace periods from making progress, IOW. they imply
	 * rcu_read_lock().
	 */
	lockdep_assert_irqs_disabled();

	/*
	 * Inodes and thus address_space are RCU freed and thus safe to
	 * access at this point.
	 */
	mapping = folio_mapping(folio);
	if (mapping && shmem_mapping(mapping))
		return true;

	return false;

> +}
