Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22ED835CF9E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbhDLRoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:44:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243735AbhDLRoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 13:44:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADD5261354;
        Mon, 12 Apr 2021 17:43:46 +0000 (UTC)
Date:   Mon, 12 Apr 2021 18:43:44 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Message-ID: <20210412174343.GG2060@arm.com>
References: <20210407150940.542103-1-Liam.Howlett@Oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407150940.542103-1-Liam.Howlett@Oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 07, 2021 at 03:11:06PM +0000, Liam Howlett wrote:
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

I don't think your change is entirely correct either. We can have a
fault below the vma of a stack (with VM_GROWSDOWN) and
find_vma_intersection() would return NULL but it should be a SEGV_ACCERR
instead.

Maybe this should employ similar checks as __do_page_fault() (with
expand_stack() and VM_GROWSDOWN).

-- 
Catalin
