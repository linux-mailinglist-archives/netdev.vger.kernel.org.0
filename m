Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358F335FB64
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349349AbhDNTN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:13:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234810AbhDNTN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618427616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F6FTiB8UzDW4wKvTNKebl00UCwFSLpS/fkluHFZvJPI=;
        b=LFCu0zgR5WmkUYI9SBSiZ8dQbh0fh+4Cold0XU9fqwZavcSL5jp3wuEufJ5aIiYj5QhpqZ
        lM/u1Hw8O4pbyAzA/nOK9F6OUhv+Vnjpfe30RV1RCsYaQrCHKg7ZDIKuYUEt04s1ztR1OZ
        CI1nw/uUZvU8elS1lqnh9daO0BQtmS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-dEgJCfFYO6qLSVsI6D4wlQ-1; Wed, 14 Apr 2021 15:13:32 -0400
X-MC-Unique: dEgJCfFYO6qLSVsI6D4wlQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F38BC6D241;
        Wed, 14 Apr 2021 19:13:30 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 666961000324;
        Wed, 14 Apr 2021 19:13:23 +0000 (UTC)
Date:   Wed, 14 Apr 2021 21:13:22 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Christoph Hellwig <hch@lst.de>, brouer@redhat.com
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210414211322.3799afd4@carbon>
In-Reply-To: <20210414115052.GS2531743@casper.infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
        <20210410205246.507048-2-willy@infradead.org>
        <20210411114307.5087f958@carbon>
        <20210411103318.GC2531743@casper.infradead.org>
        <20210412011532.GG2531743@casper.infradead.org>
        <20210414101044.19da09df@carbon>
        <20210414115052.GS2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 12:50:52 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> > That said, I think we need to have a quicker fix for the immediate
> > issue with 64-bit bit dma_addr on 32-bit arch and the misalignment hole
> > it leaves[3] in struct page.  In[3] you mention ppc32, does it only
> > happens on certain 32-bit archs? =20
>=20
> AFAICT it happens on mips32, ppc32, arm32 and arc.  It doesn't happen
> on x86-32 because dma_addr_t is 32-bit aligned.

(If others want to reproduce).  First I could not reproduce on ARM32.
Then I found out that enabling CONFIG_XEN on ARCH=3Darm was needed to
cause the issue by enabling CONFIG_ARCH_DMA_ADDR_T_64BIT.

Details below signature.
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

=46rom file: arch/arm/Kconfig

config XEN
	bool "Xen guest support on ARM"
	depends on ARM && AEABI && OF
	depends on CPU_V7 && !CPU_V6
	depends on !GENERIC_ATOMIC64
	depends on MMU
	select ARCH_DMA_ADDR_T_64BIT
	select ARM_PSCI
	select SWIOTLB
	select SWIOTLB_XEN
	select PARAVIRT
	help
	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.

My make compile command:

 export VERSION=3Dgcc-arm-10.2-2020.11-x86_64-arm-none-linux-gnueabihf/
 export CROSS_COMPILE=3D"/home/${USER}/cross-compilers/${VERSION}/bin/arm-n=
one-linux-gnueabihf-"
 make -j8 ARCH=3Darm CROSS_COMPILE=3D$CROSS_COMPILE

Pahole output:
 $ pahole -C page mm/page_alloc.o

 struct page {
        long unsigned int          flags;                /*     0     4 */

        /* XXX 4 bytes hole, try to pack */

        union {
                struct {
                        struct list_head lru;            /*     8     8 */
                        struct address_space * mapping;  /*    16     4 */
                        long unsigned int index;         /*    20     4 */
                        long unsigned int private;       /*    24     4 */
                };                                       /*     8    20 */
                struct {
                        dma_addr_t dma_addr;             /*     8     8 */
                };                                       /*     8     8 */
                struct {
                        union {
                                struct list_head slab_list; /*     8     8 =
*/
                                struct {
                                        struct page * next; /*     8     4 =
*/
                                        short int pages; /*    12     2 */
                                        short int pobjects; /*    14     2 =
*/
                                };                       /*     8     8 */
                        };                               /*     8     8 */
                        struct kmem_cache * slab_cache;  /*    16     4 */
                        void *     freelist;             /*    20     4 */
                        union {
                                void * s_mem;            /*    24     4 */
                                long unsigned int counters; /*    24     4 =
*/
                                struct {
                                        unsigned int inuse:16; /*    24: 0 =
 4 */
                                        unsigned int objects:15; /*    24:1=
6  4 */
                                        unsigned int frozen:1; /*    24:31 =
 4 */
                                };                       /*    24     4 */
                        };                               /*    24     4 */
                };                                       /*     8    20 */
                struct {
                        long unsigned int compound_head; /*     8     4 */
                        unsigned char compound_dtor;     /*    12     1 */
                        unsigned char compound_order;    /*    13     1 */

                        /* XXX 2 bytes hole, try to pack */

                        atomic_t   compound_mapcount;    /*    16     4 */
                        unsigned int compound_nr;        /*    20     4 */
                };                                       /*     8    16 */
                struct {
                        long unsigned int _compound_pad_1; /*     8     4 */
                        atomic_t   hpage_pinned_refcount; /*    12     4 */
                        struct list_head deferred_list;  /*    16     8 */
                };                                       /*     8    16 */
                struct {
                        long unsigned int _pt_pad_1;     /*     8     4 */
                        pgtable_t  pmd_huge_pte;         /*    12     4 */
                        long unsigned int _pt_pad_2;     /*    16     4 */
                        union {
                                struct mm_struct * pt_mm; /*    20     4 */
                                atomic_t pt_frag_refcount; /*    20     4 */
                        };                               /*    20     4 */
                        spinlock_t ptl;                  /*    24     4 */
                };                                       /*     8    20 */
                struct {
                        struct dev_pagemap * pgmap;      /*     8     4 */
                        void *     zone_device_data;     /*    12     4 */
                };                                       /*     8     8 */
                struct callback_head callback_head __attribute__((__aligned=
__(4))); /*     8     8 */
        } __attribute__((__aligned__(8)));               /*     8    24 */
        union {
                atomic_t           _mapcount;            /*    32     4 */
                unsigned int       page_type;            /*    32     4 */
                unsigned int       active;               /*    32     4 */
                int                units;                /*    32     4 */
        };                                               /*    32     4 */
        atomic_t                   _refcount;            /*    36     4 */

        /* size: 40, cachelines: 1, members: 4 */
        /* sum members: 36, holes: 1, sum holes: 4 */
        /* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
        /* last cacheline: 40 bytes */
} __attribute__((__aligned__(8)));



