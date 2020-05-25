Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872DB1E1248
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391148AbgEYQBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391039AbgEYQBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:01:22 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 048D82071A;
        Mon, 25 May 2020 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590422481;
        bh=avDkU5Jjuebevkd4SZsxVJL6Ja7RQnT1k48r9xXVXc8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=xoLB4qJHhALbjzDaqHagI7R/tK/GcGFA5wU2teKGhRlsdaJ/ogUEh1EPX/Veroart
         VWBrOlUlDQMq2w7hLhiyRUIPObXQTFZix9ES+y1beBoLuHTswZdSj7wgB9/rKStp2i
         o3ljARxjjPFS0vAUXzyRieaR2PELD0hPPXcYT/s0=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id D91CF352267E; Mon, 25 May 2020 09:01:20 -0700 (PDT)
Date:   Mon, 25 May 2020 09:01:20 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/7] bpf: implement BPF ring buffer and
 verifier support for it
Message-ID: <20200525160120.GX2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-2-andriin@fb.com>
 <20200522002502.GF2869@paulmck-ThinkPad-P72>
 <CAEf4Bza26AbRMtWcoD5+TFhnmnU6p5YJ8zO+SoAJCDtp1jVhcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza26AbRMtWcoD5+TFhnmnU6p5YJ8zO+SoAJCDtp1jVhcQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 11:46:49AM -0700, Andrii Nakryiko wrote:
> On Thu, May 21, 2020 at 5:25 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sun, May 17, 2020 at 12:57:21PM -0700, Andrii Nakryiko wrote:
> > > This commits adds a new MPSC ring buffer implementation into BPF ecosystem,
> > > which allows multiple CPUs to submit data to a single shared ring buffer. On
> > > the consumption side, only single consumer is assumed.
> >
> > [ . . . ]
> >
> > Focusing just on the ring-buffer mechanism, with a question or two
> > below.  Looks pretty close, actually!
> >
> >                                                         Thanx, Paul
> >
> 
> Thanks for review, Paul!
> 
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  include/linux/bpf.h            |  13 +
> > >  include/linux/bpf_types.h      |   1 +
> > >  include/linux/bpf_verifier.h   |   4 +
> > >  include/uapi/linux/bpf.h       |  84 +++++-
> > >  kernel/bpf/Makefile            |   2 +-
> > >  kernel/bpf/helpers.c           |  10 +
> > >  kernel/bpf/ringbuf.c           | 487 +++++++++++++++++++++++++++++++++
> > >  kernel/bpf/syscall.c           |  12 +
> > >  kernel/bpf/verifier.c          | 157 ++++++++---
> > >  kernel/trace/bpf_trace.c       |  10 +
> > >  tools/include/uapi/linux/bpf.h |  90 +++++-
> > >  11 files changed, 832 insertions(+), 38 deletions(-)
> > >  create mode 100644 kernel/bpf/ringbuf.c
> >
> > [ . . . ]
> >
> > > diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> > > new file mode 100644
> > > index 000000000000..3c19f0f07726
> > > --- /dev/null
> > > +++ b/kernel/bpf/ringbuf.c
> > > @@ -0,0 +1,487 @@
> > > +#include <linux/bpf.h>
> > > +#include <linux/btf.h>
> > > +#include <linux/err.h>
> > > +#include <linux/irq_work.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/filter.h>
> > > +#include <linux/mm.h>
> > > +#include <linux/vmalloc.h>
> > > +#include <linux/wait.h>
> > > +#include <linux/poll.h>
> > > +#include <uapi/linux/btf.h>
> > > +
> > > +#define RINGBUF_CREATE_FLAG_MASK (BPF_F_NUMA_NODE)
> > > +
> > > +/* non-mmap()'able part of bpf_ringbuf (everything up to consumer page) */
> > > +#define RINGBUF_PGOFF \
> > > +     (offsetof(struct bpf_ringbuf, consumer_pos) >> PAGE_SHIFT)
> > > +/* consumer page and producer page */
> > > +#define RINGBUF_POS_PAGES 2
> > > +
> > > +#define RINGBUF_MAX_RECORD_SZ (UINT_MAX/4)
> > > +
> > > +/* Maximum size of ring buffer area is limited by 32-bit page offset within
> > > + * record header, counted in pages. Reserve 8 bits for extensibility, and take
> > > + * into account few extra pages for consumer/producer pages and
> > > + * non-mmap()'able parts. This gives 64GB limit, which seems plenty for single
> > > + * ring buffer.
> > > + */
> > > +#define RINGBUF_MAX_DATA_SZ \
> > > +     (((1ULL << 24) - RINGBUF_POS_PAGES - RINGBUF_PGOFF) * PAGE_SIZE)
> > > +
> > > +struct bpf_ringbuf {
> > > +     wait_queue_head_t waitq;
> > > +     struct irq_work work;
> > > +     u64 mask;
> > > +     spinlock_t spinlock ____cacheline_aligned_in_smp;
> > > +     /* Consumer and producer counters are put into separate pages to allow
> > > +      * mapping consumer page as r/w, but restrict producer page to r/o.
> > > +      * This protects producer position from being modified by user-space
> > > +      * application and ruining in-kernel position tracking.
> > > +      */
> > > +     unsigned long consumer_pos __aligned(PAGE_SIZE);
> > > +     unsigned long producer_pos __aligned(PAGE_SIZE);
> > > +     char data[] __aligned(PAGE_SIZE);
> > > +};
> > > +
> > > +struct bpf_ringbuf_map {
> > > +     struct bpf_map map;
> > > +     struct bpf_map_memory memory;
> > > +     struct bpf_ringbuf *rb;
> > > +};
> > > +
> > > +/* 8-byte ring buffer record header structure */
> > > +struct bpf_ringbuf_hdr {
> > > +     u32 len;
> > > +     u32 pg_off;
> > > +};
> > > +
> > > +static struct bpf_ringbuf *bpf_ringbuf_area_alloc(size_t data_sz, int numa_node)
> > > +{
> > > +     const gfp_t flags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_NOWARN |
> > > +                         __GFP_ZERO;
> > > +     int nr_meta_pages = RINGBUF_PGOFF + RINGBUF_POS_PAGES;
> > > +     int nr_data_pages = data_sz >> PAGE_SHIFT;
> > > +     int nr_pages = nr_meta_pages + nr_data_pages;
> > > +     struct page **pages, *page;
> > > +     size_t array_size;
> > > +     void *addr;
> > > +     int i;
> > > +
> > > +     /* Each data page is mapped twice to allow "virtual"
> > > +      * continuous read of samples wrapping around the end of ring
> > > +      * buffer area:
> > > +      * ------------------------------------------------------
> > > +      * | meta pages |  real data pages  |  same data pages  |
> > > +      * ------------------------------------------------------
> > > +      * |            | 1 2 3 4 5 6 7 8 9 | 1 2 3 4 5 6 7 8 9 |
> > > +      * ------------------------------------------------------
> > > +      * |            | TA             DA | TA             DA |
> > > +      * ------------------------------------------------------
> > > +      *                               ^^^^^^^
> > > +      *                                  |
> > > +      * Here, no need to worry about special handling of wrapped-around
> > > +      * data due to double-mapped data pages. This works both in kernel and
> > > +      * when mmap()'ed in user-space, simplifying both kernel and
> > > +      * user-space implementations significantly.
> > > +      */
> > > +     array_size = (nr_meta_pages + 2 * nr_data_pages) * sizeof(*pages);
> > > +     if (array_size > PAGE_SIZE)
> > > +             pages = vmalloc_node(array_size, numa_node);
> > > +     else
> > > +             pages = kmalloc_node(array_size, flags, numa_node);
> > > +     if (!pages)
> > > +             return NULL;
> > > +
> > > +     for (i = 0; i < nr_pages; i++) {
> > > +             page = alloc_pages_node(numa_node, flags, 0);
> > > +             if (!page) {
> > > +                     nr_pages = i;
> > > +                     goto err_free_pages;
> > > +             }
> > > +             pages[i] = page;
> > > +             if (i >= nr_meta_pages)
> > > +                     pages[nr_data_pages + i] = page;
> > > +     }
> > > +
> > > +     addr = vmap(pages, nr_meta_pages + 2 * nr_data_pages,
> > > +                 VM_ALLOC | VM_USERMAP, PAGE_KERNEL);
> > > +     if (addr)
> > > +             return addr;
> > > +
> > > +err_free_pages:
> > > +     for (i = 0; i < nr_pages; i++)
> > > +             free_page((unsigned long)pages[i]);
> > > +     kvfree(pages);
> > > +     return NULL;
> > > +}
> > > +
> > > +static void bpf_ringbuf_notify(struct irq_work *work)
> > > +{
> > > +     struct bpf_ringbuf *rb = container_of(work, struct bpf_ringbuf, work);
> > > +
> > > +     wake_up_all(&rb->waitq);
> > > +}
> > > +
> > > +static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
> > > +{
> > > +     struct bpf_ringbuf *rb;
> > > +
> > > +     if (!data_sz || !PAGE_ALIGNED(data_sz))
> > > +             return ERR_PTR(-EINVAL);
> > > +
> > > +     if (data_sz > RINGBUF_MAX_DATA_SZ)
> > > +             return ERR_PTR(-E2BIG);
> > > +
> > > +     rb = bpf_ringbuf_area_alloc(data_sz, numa_node);
> > > +     if (!rb)
> > > +             return ERR_PTR(-ENOMEM);
> > > +
> > > +     spin_lock_init(&rb->spinlock);
> > > +     init_waitqueue_head(&rb->waitq);
> > > +     init_irq_work(&rb->work, bpf_ringbuf_notify);
> > > +
> > > +     rb->mask = data_sz - 1;
> > > +     rb->consumer_pos = 0;
> > > +     rb->producer_pos = 0;
> > > +
> > > +     return rb;
> > > +}
> > > +
> > > +static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
> > > +{
> > > +     struct bpf_ringbuf_map *rb_map;
> > > +     u64 cost;
> > > +     int err;
> > > +
> > > +     if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
> > > +             return ERR_PTR(-EINVAL);
> > > +
> > > +     if (attr->key_size || attr->value_size ||
> > > +         attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> > > +             return ERR_PTR(-EINVAL);
> > > +
> > > +     rb_map = kzalloc(sizeof(*rb_map), GFP_USER);
> > > +     if (!rb_map)
> > > +             return ERR_PTR(-ENOMEM);
> > > +
> > > +     bpf_map_init_from_attr(&rb_map->map, attr);
> > > +
> > > +     cost = sizeof(struct bpf_ringbuf_map) +
> > > +            sizeof(struct bpf_ringbuf) +
> > > +            attr->max_entries;
> > > +     err = bpf_map_charge_init(&rb_map->map.memory, cost);
> > > +     if (err)
> > > +             goto err_free_map;
> > > +
> > > +     rb_map->rb = bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_node);
> > > +     if (IS_ERR(rb_map->rb)) {
> > > +             err = PTR_ERR(rb_map->rb);
> > > +             goto err_uncharge;
> > > +     }
> > > +
> > > +     return &rb_map->map;
> > > +
> > > +err_uncharge:
> > > +     bpf_map_charge_finish(&rb_map->map.memory);
> > > +err_free_map:
> > > +     kfree(rb_map);
> > > +     return ERR_PTR(err);
> > > +}
> > > +
> > > +static void bpf_ringbuf_free(struct bpf_ringbuf *ringbuf)
> > > +{
> > > +     kvfree(ringbuf);
> > > +}
> > > +
> > > +static void ringbuf_map_free(struct bpf_map *map)
> > > +{
> > > +     struct bpf_ringbuf_map *rb_map;
> > > +
> > > +     /* at this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
> > > +      * so the programs (can be more than one that used this map) were
> > > +      * disconnected from events. Wait for outstanding critical sections in
> > > +      * these programs to complete
> > > +      */
> > > +     synchronize_rcu();
> > > +
> > > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > > +     bpf_ringbuf_free(rb_map->rb);
> > > +     kfree(rb_map);
> > > +}
> > > +
> > > +static void *ringbuf_map_lookup_elem(struct bpf_map *map, void *key)
> > > +{
> > > +     return ERR_PTR(-ENOTSUPP);
> > > +}
> > > +
> > > +static int ringbuf_map_update_elem(struct bpf_map *map, void *key, void *value,
> > > +                                u64 flags)
> > > +{
> > > +     return -ENOTSUPP;
> > > +}
> > > +
> > > +static int ringbuf_map_delete_elem(struct bpf_map *map, void *key)
> > > +{
> > > +     return -ENOTSUPP;
> > > +}
> > > +
> > > +static int ringbuf_map_get_next_key(struct bpf_map *map, void *key,
> > > +                                 void *next_key)
> > > +{
> > > +     return -ENOTSUPP;
> > > +}
> > > +
> > > +static size_t bpf_ringbuf_mmap_page_cnt(const struct bpf_ringbuf *rb)
> > > +{
> > > +     size_t data_pages = (rb->mask + 1) >> PAGE_SHIFT;
> > > +
> > > +     /* consumer page + producer page + 2 x data pages */
> > > +     return RINGBUF_POS_PAGES + 2 * data_pages;
> > > +}
> > > +
> > > +static int ringbuf_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
> > > +{
> > > +     struct bpf_ringbuf_map *rb_map;
> > > +     size_t mmap_sz;
> > > +
> > > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > > +     mmap_sz = bpf_ringbuf_mmap_page_cnt(rb_map->rb) << PAGE_SHIFT;
> > > +
> > > +     if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) > mmap_sz)
> > > +             return -EINVAL;
> > > +
> > > +     return remap_vmalloc_range(vma, rb_map->rb,
> > > +                                vma->vm_pgoff + RINGBUF_PGOFF);
> > > +}
> > > +
> > > +static unsigned long ringbuf_avail_data_sz(struct bpf_ringbuf *rb)
> > > +{
> > > +     unsigned long cons_pos, prod_pos;
> > > +
> > > +     cons_pos = smp_load_acquire(&rb->consumer_pos);
> >
> > What happens if there is a delay here?  (The delay might be due to
> > interrupts, preemption in PREEMPT=y kernels, vCPU preemption, ...)
> >
> > If this is called from a producer holding the lock, then the only
> > ->consumer_pos can change, and that can only decrease the amount of
> > data available.  Besides which, ->consumer_pos is sampled first.
> > But why would a producer care how much data was queued, as opposed
> > to how much free space was available?
> 
> see second point below, it's for BPF program to implement custom
> notification policy/heuristics
> 
> >
> > From the consumer, only ->producer_pos can change, and that can only
> > increase the amount of data available.  (Assuming that producers cannot
> > erase old data on wrap-around before the consumer consumes it.)
> 
> right, they can't overwrite data
> 
> >
> > So probably nothing bad happens.
> >
> > On the bit about the producer holding the lock, some lockdep assertions
> > might make things easier on your future self.
> 
> So this function is currently called in two situations, both not
> holding the spinlock. I'm fully aware this is a racy way to do this,
> but it's ok for the applications.
> 
> So the first place is during initial poll "subscription", when we need
> to figure out if there is already some unconsumed data in ringbuffer
> to let poll/epoll subsystem know whether caller can do read without
> waiting. If this is done from consumer thread, it's race free, because
> consumer position won't change, so either we'll see that producer >
> consumer, or if we race with producer, producer will see that consumer
> pos == to-be-committed record pos, so will send notification. If epoll
> happens from non-consumer thread, it's similarly racy to perf buffer
> poll subscription implementation, but with next record subscriber will
> get notification anyways.
> 
> The second place is from BPF side (so potential producer), but it's
> outside of producer lock. It's called from bpf_ringbuf_query() helper
> which is supposed to return various potentially stale properties of
> ringbuf (e.g., consumer/producer position, amount of unconsumed data,
> etc). The use case here is for BPF program to implement its own
> flexible poll notification strategy (or whatever else creative
> programmer will come up with, of course). E.g., batched notification,
> which happens not on every record, but only once enough data is
> accumulated. In this case exact amount of unconsumed data is not
> critical, it's only a heuristics. And it's more convenient than amount
> of data left free, IMO, but both can be calculated using the other,
> provided the total size of ring buffer is known (which can be returned
> by bpf_ringbuf_query() helper as well).
> 
> So I think in both cases I don't want to take spinlock. If this is not
> done under spinlock, then I have to read consumer pos first, producer
> pos second, otherwise I can get into a situation of having
> consumer_pos > producer_pos (due to delays), which is really bad.
> 
> It's a bit wordy explanation, but I hope this makes sense.

Fair enough, and the smp_load_acquire() calls do telegraph the lockless
access.  But what if timing results in the difference below coming out
negative, that is, a very large unsigned long value?

> > > +     prod_pos = smp_load_acquire(&rb->producer_pos);
> > > +     return prod_pos - cons_pos;
> > > +}
> > > +
> > > +static __poll_t ringbuf_map_poll(struct bpf_map *map, struct file *filp,
> > > +                              struct poll_table_struct *pts)
> > > +{
> > > +     struct bpf_ringbuf_map *rb_map;
> > > +
> > > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > > +     poll_wait(filp, &rb_map->rb->waitq, pts);
> > > +
> > > +     if (ringbuf_avail_data_sz(rb_map->rb))
> > > +             return EPOLLIN | EPOLLRDNORM;
> > > +     return 0;
> > > +}
> > > +
> > > +const struct bpf_map_ops ringbuf_map_ops = {
> > > +     .map_alloc = ringbuf_map_alloc,
> > > +     .map_free = ringbuf_map_free,
> > > +     .map_mmap = ringbuf_map_mmap,
> > > +     .map_poll = ringbuf_map_poll,
> > > +     .map_lookup_elem = ringbuf_map_lookup_elem,
> > > +     .map_update_elem = ringbuf_map_update_elem,
> > > +     .map_delete_elem = ringbuf_map_delete_elem,
> > > +     .map_get_next_key = ringbuf_map_get_next_key,
> > > +};
> > > +
> > > +/* Given pointer to ring buffer record metadata and struct bpf_ringbuf itself,
> > > + * calculate offset from record metadata to ring buffer in pages, rounded
> > > + * down. This page offset is stored as part of record metadata and allows to
> > > + * restore struct bpf_ringbuf * from record pointer. This page offset is
> > > + * stored at offset 4 of record metadata header.
> > > + */
> > > +static size_t bpf_ringbuf_rec_pg_off(struct bpf_ringbuf *rb,
> > > +                                  struct bpf_ringbuf_hdr *hdr)
> > > +{
> > > +     return ((void *)hdr - (void *)rb) >> PAGE_SHIFT;
> > > +}
> > > +
> > > +/* Given pointer to ring buffer record header, restore pointer to struct
> > > + * bpf_ringbuf itself by using page offset stored at offset 4
> > > + */
> > > +static struct bpf_ringbuf *
> > > +bpf_ringbuf_restore_from_rec(struct bpf_ringbuf_hdr *hdr)
> > > +{
> > > +     unsigned long addr = (unsigned long)(void *)hdr;
> > > +     unsigned long off = (unsigned long)hdr->pg_off << PAGE_SHIFT;
> > > +
> > > +     return (void*)((addr & PAGE_MASK) - off);
> > > +}
> > > +
> > > +static void *__bpf_ringbuf_reserve(struct bpf_ringbuf *rb, u64 size)
> > > +{
> > > +     unsigned long cons_pos, prod_pos, new_prod_pos, flags;
> > > +     u32 len, pg_off;
> > > +     struct bpf_ringbuf_hdr *hdr;
> > > +
> > > +     if (unlikely(size > RINGBUF_MAX_RECORD_SZ))
> > > +             return NULL;
> > > +
> > > +     len = round_up(size + BPF_RINGBUF_HDR_SZ, 8);
> > > +     cons_pos = smp_load_acquire(&rb->consumer_pos);
> >
> > There might be a longish delay acquiring the spinlock, which could mean
> > that cons_pos was out of date, which might result in an unnecessary
> > producer-side failure.  Why not pick up cons_pos after the lock is
> > acquired?  After all, it is in the same cache line as the lock, so this
> > should have negligible effect on lock-hold time.
> 
> Right, the goal was to minimize amount of time that spinlock is hold.
> 
> Spinlock and consumer_pos are certainly not on the same cache line,
> consumer_pos is deliberately on a different *page* altogether (due to
> mmap() and to avoid unnecessary sharing between consumers, who don't
> touch spinlock, and producers, who do use lock to coordinate).
> 
> So I chose to potentially drop sample due to a bit stale consumer pos,
> but speed up locked section.

OK, fair enough!

> > (Unless you had either really small cachelines or really big locks.
> >
> > > +     if (in_nmi()) {
> > > +             if (!spin_trylock_irqsave(&rb->spinlock, flags))
> > > +                     return NULL;
> > > +     } else {
> > > +             spin_lock_irqsave(&rb->spinlock, flags);
> > > +     }
> > > +
> > > +     prod_pos = rb->producer_pos;
> > > +     new_prod_pos = prod_pos + len;
> > > +
> > > +     /* check for out of ringbuf space by ensuring producer position
> > > +      * doesn't advance more than (ringbuf_size - 1) ahead
> > > +      */
> > > +     if (new_prod_pos - cons_pos > rb->mask) {
> > > +             spin_unlock_irqrestore(&rb->spinlock, flags);
> > > +             return NULL;
> > > +     }
> > > +
> > > +     hdr = (void *)rb->data + (prod_pos & rb->mask);
> > > +     pg_off = bpf_ringbuf_rec_pg_off(rb, hdr);
> > > +     hdr->len = size | BPF_RINGBUF_BUSY_BIT;
> > > +     hdr->pg_off = pg_off;
> > > +
> > > +     /* ensure header is written before updating producer positions */
> > > +     smp_wmb();
> >
> > The smp_store_release() makes this unnecessary with respect to
> > ->producer_pos.  So what later write is it also ordering against?
> > If none, this smp_wmb() can go away.
> >
> > And if the later write is the xchg() in bpf_ringbuf_commit(), the
> > xchg() implies full barriers before and after, so that the smp_wmb()
> > could still go away.
> >
> > So other than the smp_store_release() and the xchg(), what later write
> > is the smp_wmb() ordering against?
> 
> I *think* my intent here was to make sure that when consumer reads
> producer_pos, it sees hdr->len with busy bit set. But I also think
> that you are right and smp_store_release (producer_pos) ensures that
> if consumer does smp_read_acquire(producer_pos) it will see up-to-date
> hdr->len, for a given value of producer_pos. So yeah, I think I should
> drop smp_wmb(). I dropped it in litmus tests, and they still pass,
> which gives me a bit more confidence as well. :)
> 
> I say "I *think*", because this algorithm started off completely
> locklessly without producer spinlock, so maybe I needed this barrier
> for something there, but I honestly don't remember details of lockless
> implementation by now.
> 
> So in summary, yeah, I'll drop smp_wmb().

Sounds good!

							Thanx, Paul

> > > +     /* pairs with consumer's smp_load_acquire() */
> > > +     smp_store_release(&rb->producer_pos, new_prod_pos);
> > > +
> > > +     spin_unlock_irqrestore(&rb->spinlock, flags);
> > > +
> > > +     return (void *)hdr + BPF_RINGBUF_HDR_SZ;
> > > +}
> > > +
> > > +BPF_CALL_3(bpf_ringbuf_reserve, struct bpf_map *, map, u64, size, u64, flags)
> > > +{
> > > +     struct bpf_ringbuf_map *rb_map;
> > > +
> > > +     if (unlikely(flags))
> > > +             return 0;
> > > +
> > > +     rb_map = container_of(map, struct bpf_ringbuf_map, map);
> > > +     return (unsigned long)__bpf_ringbuf_reserve(rb_map->rb, size);
> > > +}
> > > +
> > > +const struct bpf_func_proto bpf_ringbuf_reserve_proto = {
> > > +     .func           = bpf_ringbuf_reserve,
> > > +     .ret_type       = RET_PTR_TO_ALLOC_MEM_OR_NULL,
> > > +     .arg1_type      = ARG_CONST_MAP_PTR,
> > > +     .arg2_type      = ARG_CONST_ALLOC_SIZE_OR_ZERO,
> > > +     .arg3_type      = ARG_ANYTHING,
> > > +};
> > > +
> > > +static void bpf_ringbuf_commit(void *sample, u64 flags, bool discard)
> > > +{
> > > +     unsigned long rec_pos, cons_pos;
> > > +     struct bpf_ringbuf_hdr *hdr;
> > > +     struct bpf_ringbuf *rb;
> > > +     u32 new_len;
> > > +
> > > +     hdr = sample - BPF_RINGBUF_HDR_SZ;
> > > +     rb = bpf_ringbuf_restore_from_rec(hdr);
> > > +     new_len = hdr->len ^ BPF_RINGBUF_BUSY_BIT;
> > > +     if (discard)
> > > +             new_len |= BPF_RINGBUF_DISCARD_BIT;
> > > +
> > > +     /* update record header with correct final size prefix */
> > > +     xchg(&hdr->len, new_len);
> > > +
> > > +     /* if consumer caught up and is waiting for our record, notify about
> > > +      * new data availability
> > > +      */
> > > +     rec_pos = (void *)hdr - (void *)rb->data;
> > > +     cons_pos = smp_load_acquire(&rb->consumer_pos) & rb->mask;
> > > +
> > > +     if (flags & BPF_RB_FORCE_WAKEUP)
> > > +             irq_work_queue(&rb->work);
> > > +     else if (cons_pos == rec_pos && !(flags & BPF_RB_NO_WAKEUP))
> > > +             irq_work_queue(&rb->work);
> > > +}
