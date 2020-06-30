Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FE520FE3B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgF3UzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:34570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgF3UzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 16:55:25 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFE49206C0;
        Tue, 30 Jun 2020 20:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593550523;
        bh=8/jfzl09QncvCdMs7Y7cl0VwPtLXwxjLIFP2mihj2kM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=i+u9BBRpzJ4mw+mQCTJHn6sDG4S9opjeqrd7nDBKby95kKy9q/nBd51wzOERXCV3a
         Em9A/pdsu7B7iBubS611V11b+hnoXxjzp00oHZ/Pk7vG7c16kVGXmuyYCZgpIvJ4Sh
         zYSvrg8cnrxjG9Wj63zc8/SXvHEkYqULeFHl3hbo=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id B0AE43522640; Tue, 30 Jun 2020 13:55:23 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:55:23 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
Message-ID: <20200630205523.GJ9247@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-2-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630043343.53195-2-alexei.starovoitov@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 09:33:39PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
> bpf_free_used_maps() is called after bpf prog is no longer executing:
> bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
> Hence there is no need to call synchronize_rcu() to protect map elements.
> 
> Note that hash_of_maps and array_of_maps update/delete inner maps via
> sys_bpf() that calls maybe_wait_bpf_programs() and synchronize_rcu().
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

From an RCU perspective:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  kernel/bpf/arraymap.c         | 9 ---------
>  kernel/bpf/hashtab.c          | 8 +++-----
>  kernel/bpf/lpm_trie.c         | 5 -----
>  kernel/bpf/queue_stack_maps.c | 7 -------
>  kernel/bpf/reuseport_array.c  | 2 --
>  kernel/bpf/ringbuf.c          | 7 -------
>  kernel/bpf/stackmap.c         | 3 ---
>  7 files changed, 3 insertions(+), 38 deletions(-)
> 
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index ec5cd11032aa..c66e8273fccd 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -386,13 +386,6 @@ static void array_map_free(struct bpf_map *map)
>  {
>  	struct bpf_array *array = container_of(map, struct bpf_array, map);
>  
> -	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> -	 * so the programs (can be more than one that used this map) were
> -	 * disconnected from events. Wait for outstanding programs to complete
> -	 * and free the array
> -	 */
> -	synchronize_rcu();
> -
>  	if (array->map.map_type == BPF_MAP_TYPE_PERCPU_ARRAY)
>  		bpf_array_free_percpu(array);
>  
> @@ -546,8 +539,6 @@ static void fd_array_map_free(struct bpf_map *map)
>  	struct bpf_array *array = container_of(map, struct bpf_array, map);
>  	int i;
>  
> -	synchronize_rcu();
> -
>  	/* make sure it's empty */
>  	for (i = 0; i < array->map.max_entries; i++)
>  		BUG_ON(array->ptrs[i] != NULL);
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index acd06081d81d..d4378d7d442b 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1290,12 +1290,10 @@ static void htab_map_free(struct bpf_map *map)
>  {
>  	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
>  
> -	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> -	 * so the programs (can be more than one that used this map) were
> -	 * disconnected from events. Wait for outstanding critical sections in
> -	 * these programs to complete
> +	/* bpf_free_used_maps() or close(map_fd) will trigger this map_free callback.
> +	 * bpf_free_used_maps() is called after bpf prog is no longer executing.
> +	 * There is no need to synchronize_rcu() here to protect map elements.
>  	 */
> -	synchronize_rcu();
>  
>  	/* some of free_htab_elem() callbacks for elements of this map may
>  	 * not have executed. Wait for them.
> diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
> index 1abd4e3f906d..44474bf3ab7a 100644
> --- a/kernel/bpf/lpm_trie.c
> +++ b/kernel/bpf/lpm_trie.c
> @@ -589,11 +589,6 @@ static void trie_free(struct bpf_map *map)
>  	struct lpm_trie_node __rcu **slot;
>  	struct lpm_trie_node *node;
>  
> -	/* Wait for outstanding programs to complete
> -	 * update/lookup/delete/get_next_key and free the trie.
> -	 */
> -	synchronize_rcu();
> -
>  	/* Always start at the root and walk down to a node that has no
>  	 * children. Then free that node, nullify its reference in the parent
>  	 * and start over.
> diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
> index 80c66a6d7c54..44184f82916a 100644
> --- a/kernel/bpf/queue_stack_maps.c
> +++ b/kernel/bpf/queue_stack_maps.c
> @@ -101,13 +101,6 @@ static void queue_stack_map_free(struct bpf_map *map)
>  {
>  	struct bpf_queue_stack *qs = bpf_queue_stack(map);
>  
> -	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> -	 * so the programs (can be more than one that used this map) were
> -	 * disconnected from events. Wait for outstanding critical sections in
> -	 * these programs to complete
> -	 */
> -	synchronize_rcu();
> -
>  	bpf_map_area_free(qs);
>  }
>  
> diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
> index a09922f656e4..3625c4fcc65c 100644
> --- a/kernel/bpf/reuseport_array.c
> +++ b/kernel/bpf/reuseport_array.c
> @@ -96,8 +96,6 @@ static void reuseport_array_free(struct bpf_map *map)
>  	struct sock *sk;
>  	u32 i;
>  
> -	synchronize_rcu();
> -
>  	/*
>  	 * ops->map_*_elem() will not be able to access this
>  	 * array now. Hence, this function only races with
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index dbf37aff4827..13a8d3967e07 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -215,13 +215,6 @@ static void ringbuf_map_free(struct bpf_map *map)
>  {
>  	struct bpf_ringbuf_map *rb_map;
>  
> -	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> -	 * so the programs (can be more than one that used this map) were
> -	 * disconnected from events. Wait for outstanding critical sections in
> -	 * these programs to complete
> -	 */
> -	synchronize_rcu();
> -
>  	rb_map = container_of(map, struct bpf_ringbuf_map, map);
>  	bpf_ringbuf_free(rb_map->rb);
>  	kfree(rb_map);
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 27dc9b1b08a5..071f98d0f7c6 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -604,9 +604,6 @@ static void stack_map_free(struct bpf_map *map)
>  {
>  	struct bpf_stack_map *smap = container_of(map, struct bpf_stack_map, map);
>  
> -	/* wait for bpf programs to complete before freeing stack map */
> -	synchronize_rcu();
> -
>  	bpf_map_area_free(smap->elems);
>  	pcpu_freelist_destroy(&smap->freelist);
>  	bpf_map_area_free(smap);
> -- 
> 2.23.0
> 
