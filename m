Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 353806C2CC0
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjCUInM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjCUInI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:43:08 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026D62722;
        Tue, 21 Mar 2023 01:42:24 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5418d54d77bso267767627b3.12;
        Tue, 21 Mar 2023 01:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679388140;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5QYqTXyyzhOOfke1rUfEhRFfGWMgzECgMaf1miGsErc=;
        b=QuDGHxm0F3HDbcambGGTUitF2P+2oQnJGigubDxm7gQu8Qr3B5PgWqyQYAMPitlNFc
         Oxh9Q4rb54hwOCg8K1Ki3XtGIxPsEdG71747yKp7wN5dwPe24kl3rKhViJ5HbdZNuxha
         H3W5nUGANR3iaElSRvkJ6MYPCCjwiBKsbX+lyoXA0GsDQ0RGBw8TjwSXa5ogJ9cCTt6K
         8tEfupPtyQ+CzAi3E3fojzAHg/xHff6RDRCr+p0CEtpTitDN+YpFWI446XG0OG5ARyM3
         W2E7xRGjj17nYoo1Jey+gIT92iJ4Jhp7ZS1L2eveGmKJ513Da5WHn0C+AAjPZG2LB6AB
         5FuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388140;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5QYqTXyyzhOOfke1rUfEhRFfGWMgzECgMaf1miGsErc=;
        b=4LV3Wg91dRzs7Oqjtx19kET2VKzOuY99GnWhStMXC8Q2YNLJcfvxVW5HF6ItB3Qi6v
         U7reIwrmDRInVH7FDxqiz+wEEkdxvqWanHsGrhcQnP62xO+BYtkXlazGZS7dD4e6hLJ8
         3yFazmQEjuzYidrQaIQ8ZzQjD0GV+FnF+uO/ZFoqGLZeRJyozPcqfKmkATbxyvxz5rbv
         0wwPGzf0m3W8zaItDfZ4upCSbqeQUgZeQTm6TY2PZanTHDIpDlGsiW3tKFN8ueuIhHbS
         Cmhq/NCuZxmlL9cfj235nazr2C8yQiPqli2+dKQ/3pn/2F5BUGcRhV15oTwhaP5P+Gnq
         b08w==
X-Gm-Message-State: AAQBX9fiLF9Pp2JD5HS6QUigOLMw/Z/raNI+vaUL8pa3dkeEAheu8JV2
        LcX+j/6X4NyJVIOqaMaFUaeNNTeo2pVxMUQzP2Y=
X-Google-Smtp-Source: AKy350ZCmThUaUIBHzt6EdPCAYgjUiiNhz1R35+6YmNFfDnhsmeeSycv1G2ThvpvXefEalLdZvztvoPlP+Xg2uGfJCo=
X-Received: by 2002:a81:a945:0:b0:541:8285:b25 with SMTP id
 g66-20020a81a945000000b0054182850b25mr527126ywh.10.1679388140490; Tue, 21 Mar
 2023 01:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230319195656.326701-1-kal.conley@dectris.com> <20230319195656.326701-2-kal.conley@dectris.com>
In-Reply-To: <20230319195656.326701-2-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Mar 2023 09:42:09 +0100
Message-ID: <CAJ8uoz2d9cSvLeguJ+5KenCqibxpshCiAKms4c75mGgzJVmkBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 at 21:03, Kal Conley <kal.conley@dectris.com> wrote:
>
> Add core AF_XDP support for chunk sizes larger than PAGE_SIZE. This
> enables sending/receiving jumbo ethernet frames up to the theoretical
> maxiumum of 64 KiB. For chunk sizes > PAGE_SIZE, the UMEM is required
> to consist of HugeTLB VMAs (and be hugepage aligned). Initially, only
> XDP_COPY mode is usuable pending future driver work.

nit: useable

> For consistency, check for HugeTLB pages during UMEM registration. This
> implies that hugepages are required for XDP_COPY mode despite DMA not
> being used. This restriction is desirable since it ensures user software
> can take advantage of future driver support.
>
> Even in HugeTLB mode, continue to do page accounting using order-0
> (4 KiB) pages. This minimizes the size of this change and reduces the
> risk of impacting driver code. Taking full advantage of hugepages for
> accounting should improve XDP performance in the general case.

Thank you Kal for working on this. Interesting stuff.

First some general comments and questions on the patch set:

* Please document this new feature in Documentation/networking/af_xdp.rst
* Have you verified the SKB path for Rx? Tx was exercised by running l2fwd.
* Have you checked that an XDP program can access the full >4K packet?
The xdp_buff has no problem with this as the buffer is consecutive,
but just wondering if there is some other check or limit in there?
Jesper and Toke will likely know, so roping them in.
* Would be interesting to know your thoughts about taking this to
zero-copy mode too. It would be good if you could support all modes
from the get go, instead of partial support for some unknown amount of
time and then zero-copy support. Partial support makes using the
feature more cumbersome when an app is deployed on various systems.
The continuity checking code you have at the end of the patch is a
step in the direction of zero-copy support, it seems.
* What happens if I try to run this in zero-copy mode with a chunk_size > 4K?
* There are some compilation errors to fix from the kernel test robot

> No significant change in RX/TX performance was observed with this patch.
> A few data points are reproduced below:

Looks good.

> Machine : Dell PowerEdge R940
> CPU     : Intel(R) Xeon(R) Platinum 8168 CPU @ 2.70GHz
> NIC     : MT27700 Family [ConnectX-4]
>
> +-----+------------+-------------+---------------+
> |     | frame size | packet size | rxdrop (Mpps) |
> +-----+------------+-------------+---------------+
> | old |       4000 |         320 |          15.7 |
> | new |       4000 |         320 |          15.8 |
> +-----+------------+-------------+---------------+
> | old |       4096 |         320 |          16.4 |
> | new |       4096 |         320 |          16.3 |
> +-----+------------+-------------+---------------+
> | new |       9000 |         320 |           6.3 |
> | new |      10240 |        9000 |           0.4 |
> +-----+------------+-------------+---------------+
>
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  include/net/xdp_sock.h      |  1 +
>  include/net/xdp_sock_drv.h  |  6 +++++
>  include/net/xsk_buff_pool.h |  4 +++-
>  net/xdp/xdp_umem.c          | 46 +++++++++++++++++++++++++++++--------
>  net/xdp/xsk.c               |  3 +++
>  net/xdp/xsk_buff_pool.c     | 16 +++++++++----
>  6 files changed, 61 insertions(+), 15 deletions(-)
>
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 3057e1a4a11c..e562ac3f5295 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -28,6 +28,7 @@ struct xdp_umem {
>         struct user_struct *user;
>         refcount_t users;
>         u8 flags;
> +       bool hugetlb;
>         bool zc;
>         struct page **pgs;
>         int id;
> diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
> index 9c0d860609ba..eb630d17f994 100644
> --- a/include/net/xdp_sock_drv.h
> +++ b/include/net/xdp_sock_drv.h
> @@ -12,6 +12,12 @@
>  #define XDP_UMEM_MIN_CHUNK_SHIFT 11
>  #define XDP_UMEM_MIN_CHUNK_SIZE (1 << XDP_UMEM_MIN_CHUNK_SHIFT)
>
> +/* Allow chunk sizes up to the maximum size of an ethernet frame (64 KiB).
> + * Larger chunks are not guaranteed to fit in a single SKB.
> + */
> +#define XDP_UMEM_MAX_CHUNK_SHIFT 16
> +#define XDP_UMEM_MAX_CHUNK_SIZE (1 << XDP_UMEM_MAX_CHUNK_SHIFT)
> +
>  #ifdef CONFIG_XDP_SOCKETS
>
>  void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 3e952e569418..69e3970da092 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -78,6 +78,7 @@ struct xsk_buff_pool {
>         u8 cached_need_wakeup;
>         bool uses_need_wakeup;
>         bool dma_need_sync;
> +       bool hugetlb;
>         bool unaligned;
>         void *addrs;
>         /* Mutual exclusion of the completion ring in the SKB mode. Two cases to protect:
> @@ -175,7 +176,8 @@ static inline void xp_dma_sync_for_device(struct xsk_buff_pool *pool,
>  static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
>                                                  u64 addr, u32 len)
>  {
> -       bool cross_pg = (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
> +       bool cross_pg = pool->hugetlb ? (addr & (HPAGE_SIZE - 1)) + len > HPAGE_SIZE :
> +                                       (addr & (PAGE_SIZE - 1)) + len > PAGE_SIZE;
>
>         if (likely(!cross_pg))
>                 return false;
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 02207e852d79..c96eefb9f5ae 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -10,6 +10,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
>  #include <linux/bpf.h>
> +#include <linux/hugetlb_inline.h>
>  #include <linux/mm.h>
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
> @@ -19,6 +20,9 @@
>  #include "xdp_umem.h"
>  #include "xsk_queue.h"
>
> +_Static_assert(XDP_UMEM_MIN_CHUNK_SIZE <= PAGE_SIZE);
> +_Static_assert(XDP_UMEM_MAX_CHUNK_SIZE <= HPAGE_SIZE);
> +
>  static DEFINE_IDA(umem_ida);
>
>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
> @@ -91,7 +95,26 @@ void xdp_put_umem(struct xdp_umem *umem, bool defer_cleanup)
>         }
>  }
>
> -static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
> +/* Returns true if the UMEM contains HugeTLB pages exclusively, false otherwise.
> + *
> + * The mmap_lock must be held by the caller.
> + */
> +static bool xdp_umem_is_hugetlb(struct xdp_umem *umem, unsigned long address)
> +{
> +       unsigned long end = address + umem->npgs * PAGE_SIZE;
> +       struct vm_area_struct *vma;
> +       struct vma_iterator vmi;
> +
> +       vma_iter_init(&vmi, current->mm, address);
> +       for_each_vma_range(vmi, vma, end) {
> +               if (!is_vm_hugetlb_page(vma))
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address, bool hugetlb)
>  {
>         unsigned int gup_flags = FOLL_WRITE;
>         long npgs;
> @@ -102,8 +125,17 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
>                 return -ENOMEM;
>
>         mmap_read_lock(current->mm);
> +
> +       umem->hugetlb = IS_ALIGNED(address, HPAGE_SIZE) && xdp_umem_is_hugetlb(umem, address);
> +       if (hugetlb && !umem->hugetlb) {
> +               mmap_read_unlock(current->mm);
> +               err = -EINVAL;
> +               goto out_pgs;
> +       }
> +
>         npgs = pin_user_pages(address, umem->npgs,
>                               gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
> +
>         mmap_read_unlock(current->mm);
>
>         if (npgs != umem->npgs) {
> @@ -152,20 +184,14 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>  {
>         bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
>         u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
> +       bool hugetlb = chunk_size > PAGE_SIZE;

require_hugetlb would be a clearer name

>         u64 addr = mr->addr, size = mr->len;
>         u32 chunks_rem, npgs_rem;
>         u64 chunks, npgs;
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
> @@ -215,7 +241,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
>         if (err)
>                 return err;
>
> -       err = xdp_umem_pin_pages(umem, (unsigned long)addr);
> +       err = xdp_umem_pin_pages(umem, (unsigned long)addr, hugetlb);
>         if (err)
>                 goto out_account;
>
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 2ac58b282b5e..3899a2d235bb 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -421,6 +421,9 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>         sock_wfree(skb);
>  }
>
> +/* Chunks must fit in the SKB `frags` array. */
> +_Static_assert(XDP_UMEM_MAX_CHUNK_SIZE / PAGE_SIZE <= MAX_SKB_FRAGS);
> +
>  static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
>                                               struct xdp_desc *desc)
>  {
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index b2df1e0f8153..777e8a38a232 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -80,6 +80,7 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
>         pool->headroom = umem->headroom;
>         pool->chunk_size = umem->chunk_size;
>         pool->chunk_shift = ffs(umem->chunk_size) - 1;
> +       pool->hugetlb = umem->hugetlb;
>         pool->unaligned = unaligned;
>         pool->frame_len = umem->chunk_size - umem->headroom -
>                 XDP_PACKET_HEADROOM;
> @@ -369,16 +370,23 @@ void xp_dma_unmap(struct xsk_buff_pool *pool, unsigned long attrs)
>  }
>  EXPORT_SYMBOL(xp_dma_unmap);
>
> -static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map)
> +/* HugeTLB pools consider contiguity at hugepage granularity only. Hence, all
> + * order-0 pages within a hugepage have the same contiguity value.
> + */
> +static void xp_check_dma_contiguity(struct xsk_dma_map *dma_map, bool hugetlb)
>  {
> +       u32 page_size = hugetlb ? HPAGE_SIZE : PAGE_SIZE;
> +       u32 n = page_size >> PAGE_SHIFT;

next_mapping? n as a name is not very descriptive.

>         u32 i;
>
> -       for (i = 0; i < dma_map->dma_pages_cnt - 1; i++) {
> -               if (dma_map->dma_pages[i] + PAGE_SIZE == dma_map->dma_pages[i + 1])
> +       for (i = 0; i + n < dma_map->dma_pages_cnt; i++) {
> +               if (dma_map->dma_pages[i] + page_size == dma_map->dma_pages[i + n])
>                         dma_map->dma_pages[i] |= XSK_NEXT_PG_CONTIG_MASK;
>                 else
>                         dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;
>         }
> +       for (; i < dma_map->dma_pages_cnt; i++)
> +               dma_map->dma_pages[i] &= ~XSK_NEXT_PG_CONTIG_MASK;

Is this not too conservative? If your umem consists of two huge pages
mappings but they are not mapped consecutively in physical memory, you
are going to mark all the chunks as non-consecutive. Would it not be
better to just look chunk_size ahead of you instead of page_size
above? The only thing you care about is that the chunk you are in is
in consecutive physical memory, and that is strictly only true for
zero-copy mode. So this seems to be in preparation for zero-copy mode.


>  }
>
>  static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_map)
> @@ -441,7 +449,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
>         }
>
>         if (pool->unaligned)
> -               xp_check_dma_contiguity(dma_map);
> +               xp_check_dma_contiguity(dma_map, pool->hugetlb);
>
>         err = xp_init_dma_info(pool, dma_map);
>         if (err) {
> --
> 2.39.2
>
