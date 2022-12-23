Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6744B6552CB
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 17:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiLWQ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 11:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiLWQ1T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 11:27:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67265F6D;
        Fri, 23 Dec 2022 08:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tvgYFs2FAZdH+/felJr+94xqrzl/poYnFOMsR5Dg6fA=; b=n7lcCdiEfcq8NCgXEDNF/0Z4ci
        tIOpRAdjDXVUvE+5DzvrJ/9KcCMujjvsihTERwfIZtXtW7cfaSsL8gKUqzMyoqVPAuofBgFa35SaB
        eQ1a1u6TOi/d/R7Vm5HFe4N9BX10usAzaGFrUU15vE/Rp65o4AsfVdY7lDi7fEDOqTAv29Gk+rfsP
        x0FQmjE4t+01NANuuhbsYP+Q46PaNZUvkjZbeCs5rLNn0M9gxprited5koJ9kFvTzc2h7pRCrgsrh
        rRT4+62twBnE/keGANDiY5jPmax6kiPnXxTrwnrL02TafuDXWZfPgmANs4Q8lAfIEfRfYyeh0pO/9
        m+4fvEuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p8kt4-009yDY-Rs; Fri, 23 Dec 2022 16:27:10 +0000
Date:   Fri, 23 Dec 2022 08:27:10 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
        Will Deacon <will@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christian Brauner <brauner@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm: remove zap_page_range and change callers to use
 zap_vma_page_range
Message-ID: <Y6XW3hMtB7PrTSM5@infradead.org>
References: <20221216192012.13562-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216192012.13562-1-mike.kravetz@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  		unsigned long size = vma->vm_end - vma->vm_start;
>  
>  		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA64].dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #ifdef CONFIG_COMPAT_VDSO
>  		if (vma_is_special_mapping(vma, vdso_info[VDSO_ABI_AA32].dm))
> -			zap_page_range(vma, vma->vm_start, size);
> +			zap_vma_page_range(vma, vma->vm_start, size);
>  #endif

So for something called zap_vma_page_range I'd expect to just pass
the vma and zap all of it, which this and many other callers want
anyway.

> +++ b/arch/s390/mm/gmap.c
> @@ -722,7 +722,7 @@ void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
>  		if (is_vm_hugetlb_page(vma))
>  			continue;
>  		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
> -		zap_page_range(vma, vmaddr, size);
> +		zap_vma_page_range(vma, vmaddr, size);

And then just call zap_page_range_single directly for those that
don't want to zap the entire vma.
