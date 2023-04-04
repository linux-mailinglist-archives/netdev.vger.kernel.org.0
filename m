Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59726D59D1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjDDHjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbjDDHjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:39:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC71BC7;
        Tue,  4 Apr 2023 00:39:36 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id k17so37570804ybm.11;
        Tue, 04 Apr 2023 00:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680593976;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6zDGREkbMif2c39FMAx/MM0pCEbIP/pCLv0cBdad+Ic=;
        b=JRHoMNS8MdJdR0uV1m4odUUDFwt0yaZMwM+HaW1rjM7czYyhf5zTwnvhZIgo3YPwTG
         9j4qc0M5nrZanrkcBNltP/fAhVh9bphxLfNB3LbDhv43AaXT/pxW5sqicJ8FJd82QXP4
         LgyloITpM21LZbakpY4svOkssyjUakoL9gQWWoFzeQESeE5nqUCy6QklZNiGT3OfEMYN
         x9j8tGqPIjJ9RrDHBOEbjwxi/oQvGoShwlk6d+xdK+/CcCteqFVWCiZQEJVdoAf7ELLF
         hE3m4hGrYbH3viM5ekFqa0DtzMYlPky/2iBFYFa8sIziL0JArr45oqOMKbl8tLNe9xNh
         V85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680593976;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6zDGREkbMif2c39FMAx/MM0pCEbIP/pCLv0cBdad+Ic=;
        b=bez+wMWyRm6XV2lVAQ5pETu1l0au0dgnw5OyKF+QXehuCLfXdThQW7J0AGkloDaosa
         gC2ynV0Z3c7p9Pw46XrhhNgzVl5hLtiFeKiNwy3Xy8L0PTLH8ozRjbQUauvRQXZhmi16
         5mwgQALMHxgs6yx+C3tPZb4vx+127DTqrh+vSTIVV49FfFL3gtK3zy0PYvlvjNTUH1Dh
         98rp7RMypo6IvncN6P6lpqMpby1wliFVHZu/yOTvxUuSqcIENRRdpdHvXf4iEnTn14Ur
         1Mu3vehCz/GkYAznuBOG7Dk2RjEZn80smeMrF6hIlkdpiHsUsww0t9rIE8L5if0OG3No
         vnHw==
X-Gm-Message-State: AAQBX9eEtt8+x0Q6GpsHXQ2w0vNsRE6uypRM/e5SSiYZdjvCVDncQIhz
        wfZK78lP/Nac+l19XnDt2A3kyoyE/gqMTq1nKI8=
X-Google-Smtp-Source: AKy350a/aue1HTaVSrLP0B84BX8ZsxQOelMSiZ1Pp5IEyPgFz96DwWRDFqtgkr/a3Zk/xitvor/ZaPHjipTic8eSo2E=
X-Received: by 2002:a25:cf42:0:b0:b8a:97ce:bfc0 with SMTP id
 f63-20020a25cf42000000b00b8a97cebfc0mr1014069ybg.5.1680593975985; Tue, 04 Apr
 2023 00:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com> <20230329180502.1884307-9-kal.conley@dectris.com>
In-Reply-To: <20230329180502.1884307-9-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 4 Apr 2023 09:39:24 +0200
Message-ID: <CAJ8uoz330DWzHabpqd+HaeAxBi2gr+GOTtnS9WJFWrt=6DaeWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 08/10] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 at 20:12, Kal Conley <kal.conley@dectris.com> wrote:
>
> Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
> enables sending/receiving jumbo ethernet frames up to the theoretical
> maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
> to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
> SKB mode is usable pending future driver work.
>
> For consistency, check for HugeTLB pages during UMEM registration. This
> implies that hugepages are required for XDP_COPY mode despite DMA not
> being used. This restriction is desirable since it ensures user software
> can take advantage of future driver support.
>
> Even in HugeTLB mode, continue to do page accounting using order-0
> (4 KiB) pages. This minimizes the size of this change and reduces the
> risk of impacting driver code. Taking full advantage of hugepages for
> accounting should improve XDP performance in the general case.
>
> No significant change in RX/TX performance was observed with this patch.
> A few data points are reproduced below:
>
> Machine : Dell PowerEdge R940
> CPU     : Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
> NIC     : MT27700 Family [ConnectX-4]
>
> +-----+------+------+-------+--------+--------+--------+
> |     |      |      | chunk | packet | rxdrop | rxdrop |
> |     | mode |  mtu |  size |   size | (Mpps) | (Gbps) |
> +-----+------+------+-------+--------+--------+--------+
> | old |   -z | 3498 |  4000 |    320 |   15.7 |   40.2 |
> | new |   -z | 3498 |  4000 |    320 |   15.8 |   40.4 |
> +-----+------+------+-------+--------+--------+--------+
> | old |   -z | 3498 |  4096 |    320 |   16.4 |   42.0 |
> | new |   -z | 3498 |  4096 |    320 |   16.3 |   41.7 |
> +-----+------+------+-------+--------+--------+--------+
> | new |   -c | 3498 | 10240 |    320 |    6.3 |   16.1 |
> +-----+------+------+-------+--------+--------+--------+
> | new |   -S | 9000 | 10240 |   9000 |   0.35 |   25.2 |
> +-----+------+------+-------+--------+--------+--------+
>
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  Documentation/networking/af_xdp.rst | 19 +++++++----
>  include/net/xdp_sock.h              |  3 ++
>  include/net/xdp_sock_drv.h          | 12 +++++++
>  include/net/xsk_buff_pool.h         | 15 ++++++++-
>  net/xdp/xdp_umem.c                  | 50 ++++++++++++++++++++++++-----
>  net/xdp/xsk_buff_pool.c             | 30 +++++++++++------
>  6 files changed, 105 insertions(+), 24 deletions(-)
>
> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
> index 247c6c4127e9..0017f83c8fb8 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -419,13 +419,20 @@ XDP_UMEM_REG setsockopt
>  -----------------------
>
>  This setsockopt registers a UMEM to a socket. This is the area that
> -contain all the buffers that packet can reside in. The call takes a
> +contains all the buffers that packets can reside in. The call takes a
>  pointer to the beginning of this area and the size of it. Moreover, it
> -also has parameter called chunk_size that is the size that the UMEM is
> -divided into. It can only be 2K or 4K at the moment. If you have an
> -UMEM area that is 128K and a chunk size of 2K, this means that you
> -will be able to hold a maximum of 128K / 2K = 64 packets in your UMEM
> -area and that your largest packet size can be 2K.
> +also has a parameter called chunk_size that is the size that the UMEM is
> +divided into. For example, if you have an UMEM area that is 128K and a
> +chunk size of 2K, this means that you will be able to hold a maximum of
> +128K / 2K = 64 packets in your UMEM and that your largest packet size
> +can be 2K.
> +
> +Valid chunk sizes range from 2K to 64K. However, the chunk size must not

Has to be a power of 2, so 2K, 4K, 8K, 16K, 32K, and 64K are valid in
aligned mode. In unaligned, any value from 2K to 64K is fine. Explain
that in unaligned mode this only signifies the max allowed size of a
packet.

> +exceed the size of a page (often 4K). This limitation is relaxed for
> +UMEM areas allocated with HugeTLB pages. In this case, chunk sizes up
> +to the system default hugepage size are supported.

Is not the max 64K as you test against XDP_UMEM_MAX_CHUNK_SIZE in
xdp_umem_reg()?

> Note, this only works
> +with hugepages allocated from the kernel's persistent pool. Using
> +Transparent Huge Pages (THP) has no effect on the maximum chunk size.
>
>  There is also an option to set the headroom of each single buffer in
>  the UMEM. If you set this to N bytes, it means that the packet will
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index e96a1151ec75..ed88880d4b68 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -28,6 +28,9 @@ struct xdp_umem {
>         struct user_struct *user;
>         refcount_t users;
>         u8 flags;
> +#ifdef CONFIG_HUGETLB_PAGE

Sanity check: have you tried compiling your code without this config set?

> +       bool hugetlb;
> +#endif
>         bool zc;
>         struct page **pgs;
>         int id;
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 9c0d860609ba..83fba3060c9a 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -12,6 +12,18 @@
>  #define XDP_UMEM_MIN_CHUNK_SHIFT 11
>  #define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
>
> +static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
> +
> +/* Allow chunk sizes up to the maximum size of an ethernet frame (64 KiB).
> + * Larger chunks are not guaranteed to fit in a single SKB.
> + */
> +#ifdef CONFIG_HUGETLB_PAGE
> +#define XDP_UMEM_MAX_CHUNK_SHIFT min(16, HPAGE_SHIFT)
> +#else
> +#define XDP_UMEM_MAX_CHUNK_SHIFT min(16, PAGE_SHIFT)
> +#endif
> +#define XDP_UMEM_MAX_CHUNK_SIZE (1 << XDP_UMEM_MAX_CHUNK_SHIFT)
> +
>  #ifdef CONFIG_XDP_SOCKETS
>
>  void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index d318c769b445..bb32112aefea 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -75,6 +75,9 @@ struct xsk_buff_pool {
>         u32 chunk_size;
>         u32 chunk_shift;
>         u32 frame_len;
> +#ifdef CONFIG_HUGETLB_PAGE
> +       u32 page_size;
> +#endif
>         u8 cached_need_wakeup;
>         bool uses_need_wakeup;
>         bool dma_need_sync;
> @@ -165,6 +168,15 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
>         xp_dma_sync_for_device_slow(pool, dma, size);
>  }
>
> +static inline u32 xp_get_page_size(struct xsk_buff_pool *pool)
> +{
> +#ifdef CONFIG_HUGETLB_PAGE
> +       return pool->page_size;
> +#else
> +       return PAGE_SIZE;
> +#endif
> +}
> +
>  /* Masks for xdp_umem_page flags.
>   * The low 12-bits of the addr will be 0 since this is the page address, so we
>   * can use them for flags.
> @@ -175,7 +187,8 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
>  static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>                                                  u64 addr, u32 len)
>  {
> -       bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
> +       const u32 page_size = xp_get_page_size(pool);
> +       bool cross_pg = (addr & (page_size - 1)) + len > page_size;
>
>         if (likely(!cross_pg))
>                 return false;
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 4681e8e8ad94..8ff687d7e735 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -10,6 +10,8 @@
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
>  #include <linux/bpf.h>
> +#include <linux/hugetlb.h>
> +#include <linux/hugetlb_inline.h>
>  #include <linux/mm.h>
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
> @@ -91,8 +93,37 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
>         }
>  }
>
> +#ifdef CONFIG_HUGETLB_PAGE
> +
> +/* Returns true if the UMEM contains HugeTLB pages exclusively, false otherwise.
> + *
> + * The mmap_lock must be held by the caller.
> + */
> +static bool xdp_umem_is_hugetlb(struct xdp_umem *umem, unsigned long address)
> +{
> +       unsigned long end = address + umem->size;
> +       struct vm_area_struct *vma;
> +       struct vma_iterator vmi;
> +
> +       vma_iter_init(&vmi, current->mm, address);
> +       for_each_vma_range(vmi, vma, end) {
> +               if (!is_vm_hugetlb_page(vma))
> +                       return false;
> +               /* Hugepage sizes smaller than the default are not supported. */
> +               if (huge_page_size(hstate_vma(vma)) < HPAGE_SIZE)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +#endif /* CONFIG_HUGETLB_PAGE */
> +
>  static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>  {
> +#ifdef CONFIG_HUGETLB_PAGE

Let us try to get rid of most of these #ifdefs sprinkled around the
code. How about hiding this inside xdp_umem_is_hugetlb() and get rid
of these #ifdefs below? Since I believe it is quite uncommon not to
have this config enabled, we could simplify things by always using the
page_size in the pool, for example. And dito for the one in struct
xdp_umem. What do you think?

> +       bool need_hugetlb = umem->chunk_size > PAGE_SIZE;
> +#endif
>         unsigned int gup_flags = FOLL_WRITE;
>         long npgs;
>         int err;
> @@ -102,8 +133,18 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>                 return -ENOMEM;
>
>         mmap_read_lock(current->mm);
> +
> +#ifdef CONFIG_HUGETLB_PAGE
> +       umem->hugetlb = IS_ALIGNED(address, HPAGE_SIZE) && xdp_umem_is_hugetlb(umem, address);
> +       if (need_hugetlb && !umem->hugetlb) {
> +               mmap_read_unlock(current->mm);
> +               err = -EINVAL;
> +               goto out_pgs;
> +       }
> +#endif
>         npgs = pin_user_pages(address, umem->npgs,
>                               gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
> +
>         mmap_read_unlock(current->mm);
>
>         if (npgs != umem->npgs) {
> @@ -156,15 +197,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>         unsigned int chunks, chunks_rem;
>         int err;
>
> -       if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
> -               /* Strictly speaking we could support this, if:
> -                * - huge pages, or*
> -                * - using an IOMMU, or
> -                * - making sure the memory area is consecutive
> -                * but for now, we simply say "computer says no".
> -                */
> +       if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > XDP_UMEM_MAX_CHUNK_SIZE)
>                 return -EINVAL;
> -       }
>
>         if (mr->flags & ~XDP_UMEM_UNALIGNED_CHUNK_FLAG)
>                 return -EINVAL;
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index b2df1e0f8153..10933f78a5a2 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -80,9 +80,12 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>         pool->headroom = umem->headroom;
>         pool->chunk_size = umem->chunk_size;
>         pool->chunk_shift = ffs(umem->chunk_size) - 1;
> -       pool->unaligned = unaligned;
>         pool->frame_len = umem->chunk_size - umem->headroom -
>                 XDP_PACKET_HEADROOM;
> +#ifdef CONFIG_HUGETLB_PAGE
> +       pool->page_size = umem->hugetlb ? HPAGE_SIZE : PAGE_SIZE;
> +#endif
> +       pool->unaligned = unaligned;
>         pool->umem = umem;
>         pool->addrs = umem->addrs;
>         INIT_LIST_HEAD(&pool->free_list);
> @@ -369,16 +372,25 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>  }
>  EXPORT_SYMBOL(xp_dma_unmap);
>
> -static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
> +/* HugeTLB pools consider contiguity at hugepage granularity only. Hence, all
> + * order-0 pages within a hugepage have the same contiguity value.
> + */
> +static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, u32 page_size)
>  {
> -       u32 i;
> +       u32 stride = page_size >> PAGE_SHIFT; /* in order-0 pages */
> +       u32 i, j;
>
> -       for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> -               if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> -                       dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> -               else
> -                       dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> +       for (i = 0; i + stride < dma_map->dma_pages_cnt;) {
> +               if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + stride]) {
> +                       for (j = 0; j < stride; i++, j++)
> +                               dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
> +               } else {
> +                       for (j = 0; j < stride; i++, j++)
> +                               dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
> +               }

Still somewhat too conservative :-). If your page size is large you
will waste a lot of the umem.  For the last page mark all the 4K
"pages" that cannot cross the end of the umem due to the max size of a
packet with the XSK_NEXT_PG_CONTIG_MASK bit. So you only need to add
one more for-loop here to mark this, and then adjust the last for-loop
below so it only marks the last bunch of 4K pages at the end of the
umem as not contiguous.

>         }
> +       for (; i < dma_map->dma_pages_cnt; i++)
> +               dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
>  }
>
>  static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
> @@ -441,7 +453,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>         }
>
>         if (pool->unaligned)
> -               xp_check_dma_contiguity(dma_map);
> +               xp_check_dma_contiguity(dma_map, xp_get_page_size(pool));
>
>         err = xp_init_dma_info(pool, dma_map);
>         if (err) {
> --
> 2.39.2
>
