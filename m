Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B684449BA9
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhKHSd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:33:56 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:43904 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235611AbhKHSdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:33:53 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6F5861FD4E;
        Mon,  8 Nov 2021 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636396266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XCt44ciTjHPqBO2xWONoM27y235Uqj1XS1pgFKfh1lY=;
        b=oR4Rs8LrrE2wh0pjmmsoiEgZk4Uco+owPrA8z7rJMAyfH9HUrmu0/vaxkGJNBvrGAAEpUL
        qAKkN5X6PkDnnWkRKCRblD+UodYxnQVbJMtjIbyB3cXBxzkOxKx7xpx6A4FOztkrilWaD2
        qiyjPZSGEBbFG9romrvi61mp7Vjd2q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636396266;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XCt44ciTjHPqBO2xWONoM27y235Uqj1XS1pgFKfh1lY=;
        b=5XKQZm3A0GQgccfJjWJc/L5fHp7SL2/HrLb6lUCIHOQg3+qixevztH+dmKeA/W8tlGx326
        04jfgETojWoLCOCw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 42AC0A3B85;
        Mon,  8 Nov 2021 18:31:05 +0000 (UTC)
Date:   Mon, 8 Nov 2021 19:31:05 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
cc:     jeyu@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, mcgrof@kernel.org
Subject: Re: [PATCH] module: Fix implicit type conversion
In-Reply-To: <1635473169-1848729-1-git-send-email-jiasheng@iscas.ac.cn>
Message-ID: <alpine.LSU.2.21.2111081925580.1710@pobox.suse.cz>
References: <1635473169-1848729-1-git-send-email-jiasheng@iscas.ac.cn>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CCing Luis]

Hi,

On Fri, 29 Oct 2021, Jiasheng Jiang wrote:

> The variable 'cpu' is defined as unsigned int.
> However in the for_each_possible_cpu, its values is assigned to -1.
> That doesn't make sense and in the cpumask_next() it is implicitly
> type conversed to int.
> It is universally accepted that the implicit type conversion is
> terrible.
> Also, having the good programming custom will set an example for
> others.
> Thus, it might be better to change the definition of 'cpu' from
> unsigned int to int.

Frankly, I don't see a benefit of changing this. It seems fine to me. 
Moreover this is not, by far, the only place in the kernel with the same 
pattern.

Miroslav

> Fixes: 10fad5e ("percpu, module: implement and use is_kernel/module_percpu_address()")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  kernel/module.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 927d46c..f10d611 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -632,7 +632,7 @@ static void percpu_modcopy(struct module *mod,
>  bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr)
>  {
>  	struct module *mod;
> -	unsigned int cpu;
> +	int cpu;
>  
>  	preempt_disable();
>  
> -- 
> 2.7.4
> 

