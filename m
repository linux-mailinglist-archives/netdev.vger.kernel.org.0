Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E6B3680E2
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhDVMyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhDVMyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28C6761421;
        Thu, 22 Apr 2021 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619096020;
        bh=QY4q0Wt0COJBeXEbp9vPIxWFGHaGiOrakwpjUWPB1aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ibKfsQmd0KaSiH0RVUfeEnW09IXzLMfWDpJLewySDNOiLvqG0gPVlZa5aAYmhkGU5
         HEpOtY8D213CFK5vGfeKWGzJGkLSEkc26M0fQ73oJfrPcE82hn2fM3rVvySu6/vwtb
         DzEbaA7sp4Q5qliKJpU7SqlsIRcWaOGs6vPj5XvCgNnDgU8TjiGrbi2SNOVT+/tzB/
         D+VJgevS3sTAeGOETYeYn92QCNd0AlhV5LeaWymZhhmXhhlaHcX+lg0c20Rj4v7pST
         46x7WpQSA2OujBNCcG95ZNbVGsmjnO+r4Vc8X+uSGQqqgou0gDBb/eiIvCNCvaOE+0
         Si5khKEWxAysA==
Date:   Thu, 22 Apr 2021 13:53:34 +0100
From:   Will Deacon <will@kernel.org>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH 3/3] arch/arm64/kernel/traps: Use find_vma_intersection()
 in traps for setting si_code
Message-ID: <20210422125334.GB1521@willie-the-truck>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
 <20210420165001.3790670-3-Liam.Howlett@Oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420165001.3790670-3-Liam.Howlett@Oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
> find_vma() will continue to search upwards until the end of the virtual
> memory space.  This means the si_code would almost never be set to
> SEGV_MAPERR even when the address falls outside of any VMA.  The result
> is that the si_code is not reliable as it may or may not be set to the
> correct result, depending on where the address falls in the address
> space.
> 
> Using find_vma_intersection() allows for what is intended by only
> returning a VMA if it falls within the range provided, in this case a
> window of 1.
> 
> Fixes: bd35a4adc413 (arm64: Port SWP/SWPB emulation support from arm)
> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> ---
>  arch/arm64/kernel/traps.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index a05d34f0e82a..a44007904a64 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code, unsigned long address, unsigned i
>  void arm64_notify_segfault(unsigned long addr)
>  {
>  	int code;
> +	unsigned long ut_addr = untagged_addr(addr);
>  
>  	mmap_read_lock(current->mm);
> -	if (find_vma(current->mm, untagged_addr(addr)) == NULL)
> +	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) == NULL)
>  		code = SEGV_MAPERR;
>  	else
>  		code = SEGV_ACCERR;

I'm not seeing how this addresses VM_GROWSDOWN as Catalin mentioned before.

Will
