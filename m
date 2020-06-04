Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77C31EDEED
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 09:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgFDH6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 03:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgFDH6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 03:58:19 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208C7C05BD1E;
        Thu,  4 Jun 2020 00:58:19 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jgklM-0007rw-IR; Thu, 04 Jun 2020 09:58:08 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id CB26BFFBE0; Thu,  4 Jun 2020 09:58:07 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 01/10] x86/mm/numa: Remove uninitialized_var() usage
In-Reply-To: <20200603233203.1695403-2-keescook@chromium.org>
Date:   Thu, 04 Jun 2020 09:58:07 +0200
Message-ID: <874krr8dps.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> -#ifdef NODE_NOT_IN_PAGE_FLAGS
> -	pfn_align = node_map_pfn_alignment();
> -	if (pfn_align && pfn_align < PAGES_PER_SECTION) {
> -		printk(KERN_WARNING "Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
> -		       PFN_PHYS(pfn_align) >> 20,
> -		       PFN_PHYS(PAGES_PER_SECTION) >> 20);
> -		return -EINVAL;
> +	if (IS_ENABLED(NODE_NOT_IN_PAGE_FLAGS)) {

Hrm, clever ...

> +		unsigned long pfn_align = node_map_pfn_alignment();
> +
> +		if (pfn_align && pfn_align < PAGES_PER_SECTION) {
> +			pr_warn("Node alignment %LuMB < min %LuMB, rejecting NUMA config\n",
> +				PFN_PHYS(pfn_align) >> 20,
> +				PFN_PHYS(PAGES_PER_SECTION) >> 20);
> +			return -EINVAL;
> +		}
>  	}
> -#endif
>  	if (!numa_meminfo_cover_memory(mi))
>  		return -EINVAL;
>  
> diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
> index 71283739ffd2..1a4cdec2bd29 100644
> --- a/include/linux/page-flags-layout.h
> +++ b/include/linux/page-flags-layout.h
> @@ -100,7 +100,7 @@
>   * there.  This includes the case where there is no node, so it is implicit.
>   */
>  #if !(NODES_WIDTH > 0 || NODES_SHIFT == 0)
> -#define NODE_NOT_IN_PAGE_FLAGS
> +#define NODE_NOT_IN_PAGE_FLAGS 1

but if we ever lose the 1 then the above will silently compile the code
within the IS_ENABLED() section out.

Thanks,

        tglx
