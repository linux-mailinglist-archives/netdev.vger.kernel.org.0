Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 717B62B4FD
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 14:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfE0MYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 08:24:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39798 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfE0MYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 08:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XYW6Bv1LchMVefhh2WDoaK3VxoyotGe8j5acHUJ6YR8=; b=V0EcI0RtOJJpB+YbYiMjW84SJ
        RaFIbLmIDNiEbmjmJ8DGCudJ/OzXkWaMgB0SjYCi3/DWNR2QKQXFekISwvHnRrlv5ysM4blDvEEmG
        G5aRvcIjzAgTxPtDCbcwcocVNHxH27LL5nKZXJivG+pmRc9tyjJwXcDD/Pcc5UsVHfX7AQCbzyOpL
        InUesZfcRGLTQYJNF4Z9nSHl2jVqcuKpE/0rdDCn8MTWBltA9on+6DqS1/CsIT9wi1+KgL5KqnfGD
        SEvP3cAO6zqGahEQ4X2aX/xTt3wDDdmYzmyxKfpTmfIE2ygIJ/f4lSZeEBBY3IrczBWHIHgKBbAGj
        JcOcmE+qw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVEfy-00039G-Jg; Mon, 27 May 2019 12:24:26 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 368AA20254842; Mon, 27 May 2019 14:24:25 +0200 (CEST)
Date:   Mon, 27 May 2019 14:24:25 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, namit@vmware.com,
        Meelis Roos <mroos@linux.ee>,
        "David S. Miller" <davem@davemloft.net>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v4 2/2] vmalloc: Avoid rare case of flushing tlb with
 weird arguements
Message-ID: <20190527122425.GQ2606@hirez.programming.kicks-ass.net>
References: <20190521205137.22029-1-rick.p.edgecombe@intel.com>
 <20190521205137.22029-3-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521205137.22029-3-rick.p.edgecombe@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 01:51:37PM -0700, Rick Edgecombe wrote:
> In a rare case, flush_tlb_kernel_range() could be called with a start
> higher than the end. Most architectures should be fine with with this, but
> some may not like it, so avoid doing this.
> 
> In vm_remove_mappings(), in case page_address() returns 0 for all pages,
> _vm_unmap_aliases() will be called with start = ULONG_MAX, end = 0 and
> flush = 1.
> 
> If at the same time, the vmalloc purge operation is triggered by something
> else while the current operation is between remove_vm_area() and
> _vm_unmap_aliases(), then the vm mapping just removed will be already
> purged. In this case the call of vm_unmap_aliases() may not find any other
> mappings to flush and so end up flushing start = ULONG_MAX, end = 0. So
> only set flush = true if we find something in the direct mapping that we
> need to flush, and this way this can't happen.
> 
> Fixes: 868b104d7379 ("mm/vmalloc: Add flag for freeing of special permsissions")
> Cc: Meelis Roos <mroos@linux.ee>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  mm/vmalloc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 836888ae01f6..537d1134b40e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2125,6 +2125,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
>  	unsigned long addr = (unsigned long)area->addr;
>  	unsigned long start = ULONG_MAX, end = 0;
>  	int flush_reset = area->flags & VM_FLUSH_RESET_PERMS;
> +	int flush_dmap = 0;
>  	int i;
>  
>  	/*
> @@ -2163,6 +2164,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
>  		if (addr) {
>  			start = min(addr, start);
>  			end = max(addr + PAGE_SIZE, end);
> +			flush_dmap = 1;
>  		}
>  	}
>  
> @@ -2172,7 +2174,7 @@ static void vm_remove_mappings(struct vm_struct *area, int deallocate_pages)
>  	 * reset the direct map permissions to the default.
>  	 */
>  	set_area_direct_map(area, set_direct_map_invalid_noflush);
> -	_vm_unmap_aliases(start, end, 1);
> +	_vm_unmap_aliases(start, end, flush_dmap);
>  	set_area_direct_map(area, set_direct_map_default_noflush);
>  }

Hurmph.. another clue that this range flushing is crap I feel. The phys
addrs of the page array can be scattered all over the place, a range
doesn't properly represent things.

But yes, this seems like a minimal fix in spirit with the existing code.
