Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70C86829DC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjAaKDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjAaKDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:03:02 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D5D10C7;
        Tue, 31 Jan 2023 02:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=35NY35ZTQdq0jK+LZ4igcXPsRMRGVAft6MTNkJwdTzM=; b=dO5IsznXm5mFnFeoyNc4/TG0s1
        mpOxkbM+OBJtgsGZLgoSpVZSLQb4T9VkTS2JeBKuFuxshM7ISz0KciiVRowmqcKxrQe8KsIVeSVSE
        xDRWXakwq+rYSNY/nV0p/uIzeJf2Hv/3lrS9BawTvUB7VKD9O2eWaj63J6ocr3VcXqxmONHLqg+QJ
        tg+ItIa96WWwZCejlfiXJoRDhXAAxCu1q7tBVVA9P3O885awA5zbkech37f4qphnvC9g8Dbc9rEhn
        3vlmuZFXbufWoF8t7ub/r+yvvk8g+pPRy/IE1fCdlUNrsbvO81Hvj+8FHHgQzkAwlMVmHLEyqsmCb
        R7z1bMiA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pMnSe-004J72-0s;
        Tue, 31 Jan 2023 10:01:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CBE51300673;
        Tue, 31 Jan 2023 11:02:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AA256240A5DF6; Tue, 31 Jan 2023 11:02:27 +0100 (CET)
Date:   Tue, 31 Jan 2023 11:02:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9jnM6BW5CcKjXNv@hirez.programming.kicks-ass.net>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
 <Y9LswwnPAf+nOVFG@do-x1extreme>
 <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net>
 <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble>
 <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net>
 <20230130195930.s5iu76e56j4q5bra@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130195930.s5iu76e56j4q5bra@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:59:30AM -0800, Josh Poimboeuf wrote:

> @@ -8662,16 +8665,19 @@ void sched_dynamic_update(int mode)
>  
>  	switch (mode) {
>  	case preempt_dynamic_none:
> -		preempt_dynamic_enable(cond_resched);
> +		if (!klp_override)
> +			preempt_dynamic_enable(cond_resched);
>  		preempt_dynamic_disable(might_resched);
>  		preempt_dynamic_disable(preempt_schedule);
>  		preempt_dynamic_disable(preempt_schedule_notrace);
>  		preempt_dynamic_disable(irqentry_exit_cond_resched);
> +		//FIXME avoid printk for klp restore

		if (mode != preempt_dynamic_mode)

>  		pr_info("Dynamic Preempt: none\n");
>  		break;
>  
>  	case preempt_dynamic_voluntary:
> -		preempt_dynamic_enable(cond_resched);
> +		if (!klp_override)
> +			preempt_dynamic_enable(cond_resched);
>  		preempt_dynamic_enable(might_resched);
>  		preempt_dynamic_disable(preempt_schedule);
>  		preempt_dynamic_disable(preempt_schedule_notrace);


