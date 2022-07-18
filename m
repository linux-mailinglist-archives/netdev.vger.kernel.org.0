Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F2F578CBD
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiGRVbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbiGRVbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:31:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D4E29CA5;
        Mon, 18 Jul 2022 14:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Vc3qso9ymLtA66nsgaSk3Fy1snAD6uHt7i9HTlSHNiE=; b=EkBE3hq6xruIeTN5pEWtycoPia
        nTHhukDaToLTtOiyz5ifrYaL/pk2PEsOqtxeu/aJZ2V2cSPXMTmolnSS8WPs5A2KV5yTVPnrrZ1EN
        vOw0TUxhvDeRjpE1mx/2K3fMGW84q5XAjOK5+M7rdK7bROK809nD43PZ3epjvCcNnwPTVXcvbsDu8
        u1S71EsomcWjaM9RrRzbyUezQioixsfbADKuWHNK1IwJGl3YizTAxUeifKpU6slDevnkbBMuu5SHS
        RQ6jCJo4M1vU85mqk4SFqv/uBiBRg8NE95nkeb0lHBIjEFKa1XB5sqocejkiCQ5PzK8hi8vOtZxSi
        PBFnLfzQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oDYJz-004uBp-SO; Mon, 18 Jul 2022 21:30:32 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 783B49802A7; Mon, 18 Jul 2022 23:30:31 +0200 (CEST)
Date:   Mon, 18 Jul 2022 23:30:31 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Klimov <aklimov@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ben Segall <bsegall@google.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Ingo Molnar <mingo@redhat.com>,
        Isabella Basso <isabbasso@riseup.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>, Miroslav Benes <mbenes@suse.cz>,
        Nathan Chancellor <nathan@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 09/16] irq: don't copy cpu affinity mask if source is
 equal to destination
Message-ID: <YtXQ96UAA4GINTNU@worktop.programming.kicks-ass.net>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-10-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718192844.1805158-10-yury.norov@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28:37PM -0700, Yury Norov wrote:

>  kernel/irq/manage.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 8c396319d5ac..f9c1b21584ec 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -284,7 +284,8 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>  	switch (ret) {
>  	case IRQ_SET_MASK_OK:
>  	case IRQ_SET_MASK_OK_DONE:
> -		cpumask_copy(desc->irq_common_data.affinity, mask);
> +		if (desc->irq_common_data.affinity != mask)
> +			cpumask_copy(desc->irq_common_data.affinity, mask);

Seems like mostly pointless logic at this point. This is not a
performance senstive operation afaik.

>  		fallthrough;
>  	case IRQ_SET_MASK_OK_NOCOPY:
>  		irq_validate_effective_affinity(data);
> -- 
> 2.34.1
> 
