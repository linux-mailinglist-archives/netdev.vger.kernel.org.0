Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A671E6E66
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436884AbgE1WLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:11:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:49796 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436844AbgE1WLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:11:42 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jeQkT-0006fq-7p; Fri, 29 May 2020 00:11:37 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jeQkS-000CJf-To; Fri, 29 May 2020 00:11:36 +0200
Subject: Re: [PATCH v3 bpf-next 1/5] bpf: implement BPF ring buffer and
 verifier support for it
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20200526063255.1675186-1-andriin@fb.com>
 <20200526063255.1675186-2-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <15c1dd7f-b24b-6482-bdf0-f80b79280e91@iogearbox.net>
Date:   Fri, 29 May 2020 00:11:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200526063255.1675186-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25826/Thu May 28 14:33:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Andrii,

On 5/26/20 8:32 AM, Andrii Nakryiko wrote:
[...]
> +static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> +{
> +	const gfp_t flags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
> +			    __GFP_ZERO;
> +	int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
> +	int nr_data_pages = data_sz >> PAGE_SHIFT;
> +	int nr_pages = nr_meta_pages + nr_data_pages;
> +	struct page **pages, *page;
> +	size_t array_size;
> +	void *addr;
> +	int i;
> +
> +	/* Each data page is mapped twice to allow "virtual"
> +	 * continuous read of samples wrapping around the end of ring
> +	 * buffer area:
> +	 * ------------------------------------------------------
> +	 * | meta pages |  real data pages  |  same data pages  |
> +	 * ------------------------------------------------------
> +	 * |            | 1 2 3 4 5 6 7 8 9 | 1 2 3 4 5 6 7 8 9 |
> +	 * ------------------------------------------------------
> +	 * |            | TA             DA | TA             DA |
> +	 * ------------------------------------------------------
> +	 *                               ^^^^^^^
> +	 *                                  |
> +	 * Here, no need to worry about special handling of wrapped-around
> +	 * data due to double-mapped data pages. This works both in kernel and
> +	 * when mmap()'ed in user-space, simplifying both kernel and
> +	 * user-space implementations significantly.
> +	 */
> +	array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
> +	if (array_size > PAGE_SIZE)
> +		pages = vmalloc_node(array_size, numa_node);
> +	else
> +		pages = kmalloc_node(array_size, flags, numa_node);
> +	if (!pages)
> +		return NULL;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		page = alloc_pages_node(numa_node, flags, 0);
> +		if (!page) {
> +			nr_pages = i;
> +			goto err_free_pages;
> +		}
> +		pages[i] = page;
> +		if (i >= nr_meta_pages)
> +			pages[nr_data_pages + i] = page;
> +	}
> +
> +	addr = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> +		    VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> +	if (addr)
> +		return addr;

Does this need an explicit vunmap() as well in bpf_ringbuf_free()? I can see that the
__vfree() calls __vunmap(addr, 1) which does the deallocation, but how does this stand
with the case of kmalloc_node()? (And does it even make sense to support < PAGE_SIZE
array size here?)

> +err_free_pages:
> +	for (i = 0; i < nr_pages; i++)
> +		free_page((unsigned long)pages[i]);
> +	kvfree(pages);
> +	return NULL;
> +}
> +
> +static void bpf_ringbuf_notify(struct irq_work *work)
> +{
> +	struct bpf_ringbuf *rb = container_of(work, struct bpf_ringbuf, work);
> +
> +	wake_up_all(&rb->waitq);
> +}
> +
> +static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
> +{
> +	struct bpf_ringbuf *rb;
> +
> +	if (!data_sz || !PAGE_ALIGNED(data_sz))
> +		return ERR_PTR(-EINVAL);
> +
> +#ifdef CONFIG_64BIT
> +	/* on 32-bit arch, it's impossible to overflow record's hdr->pgoff */
> +	if (data_sz > RINGBUF_MAX_DATA_SZ)
> +		return ERR_PTR(-E2BIG);
> +#endif
> +
> +	rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
> +	if (!rb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_init(&rb->spinlock);
> +	init_waitqueue_head(&rb->waitq);
> +	init_irq_work(&rb->work, bpf_ringbuf_notify);
> +
> +	rb->mask = data_sz - 1;
> +	rb->consumer_pos = 0;
> +	rb->producer_pos = 0;
> +
> +	return rb;
> +}
> +
> +static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +	u64 cost;
> +	int err;
> +
> +	if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (attr->key_size || attr->value_size ||
> +	    attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> +		return ERR_PTR(-EINVAL);
> +
> +	rb_map = kzalloc(sizeof(*rb_map), GFP_USER);
> +	if (!rb_map)
> +		return ERR_PTR(-ENOMEM);
> +
> +	bpf_map_init_from_attr(&rb_map->map, attr);
> +
> +	cost = sizeof(struct bpf_ringbuf_map) +
> +	       sizeof(struct bpf_ringbuf) +
> +	       attr->max_entries;
> +	err = bpf_map_charge_init(&rb_map->map.memory, cost);
> +	if (err)
> +		goto err_free_map;
> +
> +	rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
> +	if (IS_ERR(rb_map->rb)) {
> +		err = PTR_ERR(rb_map->rb);
> +		goto err_uncharge;
> +	}
> +
> +	return &rb_map->map;
> +
> +err_uncharge:
> +	bpf_map_charge_finish(&rb_map->map.memory);
> +err_free_map:
> +	kfree(rb_map);
> +	return ERR_PTR(err);
> +}
> +
> +static void bpf_ringbuf_free(struct bpf_ringbuf *ringbuf)
> +{
> +	kvfree(ringbuf);

... here.

> +}
> +
> +static void ringbuf_map_free(struct bpf_map *map)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	/* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> +	 * so the programs (can be more than one that used this map) were
> +	 * disconnected from events. Wait for outstanding critical sections in
> +	 * these programs to complete
> +	 */
> +	synchronize_rcu();
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	bpf_ringbuf_free(rb_map->rb);
> +	kfree(rb_map);
> +}
> +
> +static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
> +{
> +	return ERR_PTR(-ENOTSUPP);
> +}
> +
> +static int ringbuf_map_update_elem(struct bpf_map *map, void *key, void *value,
> +				   u64 flags)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int ringbuf_map_delete_elem(struct bpf_map *map, void *key)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int ringbuf_map_get_next_key(struct bpf_map *map, void *key,
> +				    void *next_key)
> +{
> +	return -ENOTSUPP;
> +}

One use-case we'd have that would be quite interesting to resolve as well is
to implement ->map_push_elem() callback from here and have a bpf_ringbuf_output()
like way to feed also data from user space into the same ring buffer that BPF
programs do. In our case we use perf RB for all sort of event messages from BPF
side and we also have trace events from our golang agent, both get "merged" into
an event stream together and then exported. I think it might be really useful to
allow this here natively.

> +static size_t bpf_ringbuf_mmap_page_cnt(const struct bpf_ringbuf *rb)
> +{
> +	size_t data_pages = (rb->mask + 1) >> PAGE_SHIFT;
> +
> +	/* consumer page + producer page + 2 x data pages */
> +	return RINGBUF_POS_PAGES + 2 * data_pages;
> +}
> +
> +static int ringbuf_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +	size_t mmap_sz;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	mmap_sz = bpf_ringbuf_mmap_page_cnt(rb_map->rb) << PAGE_SHIFT;
> +
> +	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) > mmap_sz)
> +		return -EINVAL;
> +
> +	return remap_vmalloc_range(vma, rb_map->rb,
> +				   vma->vm_pgoff + RINGBUF_PGOFF);
> +}
> +
> +static unsigned long ringbuf_avail_data_sz(struct bpf_ringbuf *rb)
> +{
> +	unsigned long cons_pos, prod_pos;
> +
> +	cons_pos = smp_load_acquire(&rb->consumer_pos);
> +	prod_pos = smp_load_acquire(&rb->producer_pos);
> +	return prod_pos - cons_pos;
> +}
> +
> +static __poll_t ringbuf_map_poll(struct bpf_map *map, struct file *filp,
> +				 struct poll_table_struct *pts)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	poll_wait(filp, &rb_map->rb->waitq, pts);
> +
> +	if (ringbuf_avail_data_sz(rb_map->rb))
> +		return EPOLLIN | EPOLLRDNORM;
> +	return 0;
> +}
> +
> +const struct bpf_map_ops ringbuf_map_ops = {
> +	.map_alloc = ringbuf_map_alloc,
> +	.map_free = ringbuf_map_free,
> +	.map_mmap = ringbuf_map_mmap,
> +	.map_poll = ringbuf_map_poll,
> +	.map_lookup_elem = ringbuf_map_lookup_elem,
> +	.map_update_elem = ringbuf_map_update_elem,
> +	.map_delete_elem = ringbuf_map_delete_elem,
> +	.map_get_next_key = ringbuf_map_get_next_key,
> +};
> +
> +/* Given pointer to ring buffer record metadata and struct bpf_ringbuf itself,
> + * calculate offset from record metadata to ring buffer in pages, rounded
> + * down. This page offset is stored as part of record metadata and allows to
> + * restore struct bpf_ringbuf * from record pointer. This page offset is
> + * stored at offset 4 of record metadata header.
> + */
> +static size_t bpf_ringbuf_rec_pg_off(struct bpf_ringbuf *rb,
> +				     struct bpf_ringbuf_hdr *hdr)
> +{
> +	return ((void *)hdr - (void *)rb) >> PAGE_SHIFT;
> +}
> +
> +/* Given pointer to ring buffer record header, restore pointer to struct
> + * bpf_ringbuf itself by using page offset stored at offset 4
> + */
> +static struct bpf_ringbuf *
> +bpf_ringbuf_restore_from_rec(struct bpf_ringbuf_hdr *hdr)
> +{
> +	unsigned long addr = (unsigned long)(void *)hdr;
> +	unsigned long off = (unsigned long)hdr->pg_off << PAGE_SHIFT;
> +
> +	return (void*)((addr & PAGE_MASK) - off);
> +}
> +
> +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> +{
> +	unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> +	u32 len, pg_off;
> +	struct bpf_ringbuf_hdr *hdr;
> +
> +	if (unlikely(size > RINGBUF_MAX_RECORD_SZ))
> +		return NULL;
> +
> +	len = round_up(size + BPF_RINGBUF_HDR_SZ, 8);
> +	cons_pos = smp_load_acquire(&rb->consumer_pos);
> +
> +	if (in_nmi()) {
> +		if (!spin_trylock_irqsave(&rb->spinlock, flags))
> +			return NULL;
> +	} else {
> +		spin_lock_irqsave(&rb->spinlock, flags);

Should this side probe with trylock as well to avoid potential blockage?

> +	}
> +
> +	prod_pos = rb->producer_pos;
> +	new_prod_pos = prod_pos + len;
> +
> +	/* check for out of ringbuf space by ensuring producer position
> +	 * doesn't advance more than (ringbuf_size - 1) ahead
> +	 */
> +	if (new_prod_pos - cons_pos > rb->mask) {
> +		spin_unlock_irqrestore(&rb->spinlock, flags);
> +		return NULL;
> +	}
> +
> +	hdr = (void *)rb->data + (prod_pos & rb->mask);
> +	pg_off = bpf_ringbuf_rec_pg_off(rb, hdr);
> +	hdr->len = size | BPF_RINGBUF_BUSY_BIT;
> +	hdr->pg_off = pg_off;
> +
> +	/* pairs with consumer's smp_load_acquire() */
> +	smp_store_release(&rb->producer_pos, new_prod_pos);
> +
> +	spin_unlock_irqrestore(&rb->spinlock, flags);
> +
> +	return (void *)hdr + BPF_RINGBUF_HDR_SZ;
> +}
> +
> +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +
> +	if (unlikely(flags))
> +		return 0;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_reserve_proto = {
> +	.func		= bpf_ringbuf_reserve,
> +	.ret_type	= RET_PTR_TO_ALLOC_MEM_OR_NULL,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_CONST_ALLOC_SIZE_OR_ZERO,
> +	.arg3_type	= ARG_ANYTHING,
> +};
> +
> +static void bpf_ringbuf_commit(void *sample, u64 flags, bool discard)
> +{
> +	unsigned long rec_pos, cons_pos;
> +	struct bpf_ringbuf_hdr *hdr;
> +	struct bpf_ringbuf *rb;
> +	u32 new_len;
> +
> +	hdr = sample - BPF_RINGBUF_HDR_SZ;
> +	rb = bpf_ringbuf_restore_from_rec(hdr);
> +	new_len = hdr->len ^ BPF_RINGBUF_BUSY_BIT;
> +	if (discard)
> +		new_len |= BPF_RINGBUF_DISCARD_BIT;
> +
> +	/* update record header with correct final size prefix */
> +	xchg(&hdr->len, new_len);
> +
> +	/* if consumer caught up and is waiting for our record, notify about
> +	 * new data availability
> +	 */
> +	rec_pos = (void *)hdr - (void *)rb->data;
> +	cons_pos = smp_load_acquire(&rb->consumer_pos) & rb->mask;
> +
> +	if (flags & BPF_RB_FORCE_WAKEUP)
> +		irq_work_queue(&rb->work);
> +	else if (cons_pos == rec_pos && !(flags & BPF_RB_NO_WAKEUP))
> +		irq_work_queue(&rb->work);
> +}
> +
> +BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
> +{
> +	bpf_ringbuf_commit(sample, flags, false /* discard */);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_submit_proto = {
> +	.func		= bpf_ringbuf_submit,
> +	.ret_type	= RET_VOID,
> +	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
> +	.arg2_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_2(bpf_ringbuf_discard, void *, sample, u64, flags)
> +{
> +	bpf_ringbuf_commit(sample, flags, true /* discard */);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_discard_proto = {
> +	.func		= bpf_ringbuf_discard,
> +	.ret_type	= RET_VOID,
> +	.arg1_type	= ARG_PTR_TO_ALLOC_MEM,
> +	.arg2_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_4(bpf_ringbuf_output, struct bpf_map *, map, void *, data, u64, size,
> +	   u64, flags)
> +{
> +	struct bpf_ringbuf_map *rb_map;
> +	void *rec;
> +
> +	if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
> +		return -EINVAL;
> +
> +	rb_map = container_of(map, struct bpf_ringbuf_map, map);
> +	rec = __bpf_ringbuf_reserve(rb_map->rb, size);
> +	if (!rec)
> +		return -EAGAIN;
> +
> +	memcpy(rec, data, size);

As discussed, (non-linear) skb capture would be needed as well. Is the plan to
integrate this here into the same record (data + skb capture as one)?

> +	bpf_ringbuf_commit(rec, flags, false /* discard */);
> +	return 0;
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_output_proto = {
> +	.func		= bpf_ringbuf_output,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_PTR_TO_MEM,
> +	.arg3_type	= ARG_CONST_SIZE_OR_ZERO,
> +	.arg4_type	= ARG_ANYTHING,
> +};
> +
> +BPF_CALL_2(bpf_ringbuf_query, struct bpf_map *, map, u64, flags)
> +{
> +	struct bpf_ringbuf *rb;
> +
> +	rb = container_of(map, struct bpf_ringbuf_map, map)->rb;
> +
> +	switch (flags) {
> +	case BPF_RB_AVAIL_DATA:
> +		return ringbuf_avail_data_sz(rb);
> +	case BPF_RB_RING_SIZE:
> +		return rb->mask + 1;
> +	case BPF_RB_CONS_POS:
> +		return smp_load_acquire(&rb->consumer_pos);
> +	case BPF_RB_PROD_POS:
> +		return smp_load_acquire(&rb->producer_pos);

Do you have an example where the latter two are needed/useful for non-debugging?
Maybe leave out for now if only used for debugging?

> +	default:
> +		return 0;
> +	}
> +}
> +
> +const struct bpf_func_proto bpf_ringbuf_query_proto = {
> +	.func		= bpf_ringbuf_query,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_ANYTHING,
> +};
