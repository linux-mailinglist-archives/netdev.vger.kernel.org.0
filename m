Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F14158D8BE
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 14:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241560AbiHIM31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 08:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiHIM30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 08:29:26 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0F51704C
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 05:29:24 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id s9so12825032ljs.6
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=3+KBkpV9m1bxJhsMtzeVGV+drTP66AAmd/wpftn5OL4=;
        b=E6FupvpTXxk3V7KyG/UrXwV0+9ePJHgQQbeBBwxS0LtgXCHuLfAblq2be3zPHNhFB/
         vU1EKkk3gRW0HTgiBX5BfrJuD1WggYV2YPN8v3MuvYDa3wYj8nRV2W4n1joyK0aa1b+4
         l8DJQzOPlXgjSBkJWS4VIsnVC0XlC5ryT1cJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=3+KBkpV9m1bxJhsMtzeVGV+drTP66AAmd/wpftn5OL4=;
        b=0G8UOJVFwRRMBW/Q5SGZKwhRBGVWfGSJrzPJYk5W4swiaz1Df1xjzw2aePyPpcAkzj
         sOyasPKIj6qcxkd+5WEMKZ/ZjbSeKjehyqni8xxuyGGuSjgJbYrmDQMc4TKwmITjTiai
         UW9dvfhzX66j2JzVdE4j+l6AASh1bYan4e/0pfA8o2WBvkjgix0CVDGlrwcuhBZsIK9l
         xkMUr9yRUiB6+thznSQdN+IbHbfmzfuB7R/3psYBB3Ag74SBf6rgJl4wdYFF4uzMCk/w
         65gw0Y+QeLMMzu5yJ8DJSPVCpqi8EF/lMJTu5XfvF+c4GKhkK/irvFHAuCavikYZmhQN
         hMFg==
X-Gm-Message-State: ACgBeo3T6xkNXfBQCZ1DyaRYMaz+ZCZjWnWvcwVhZiSGjRnw+hZ1c7DQ
        EIycM3dlJXvu8dvpUBpOA1GOzQ==
X-Google-Smtp-Source: AA6agR7f9t6NUk6GIPJFQim/LeGnjxzz1Ffi5AyCR+zSh+hscpnQ+tPNX0g+xvGZG32bZsniYdwOeQ==
X-Received: by 2002:a2e:8008:0:b0:25f:dd78:8312 with SMTP id j8-20020a2e8008000000b0025fdd788312mr3002868ljg.127.1660048162776;
        Tue, 09 Aug 2022 05:29:22 -0700 (PDT)
Received: from [172.16.11.74] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id y8-20020ac24208000000b0047f8e9826a1sm1752461lfh.31.2022.08.09.05.29.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 05:29:19 -0700 (PDT)
Message-ID: <79b1b62c-8ea1-5f47-bf80-3e003f7a3ac7@rasmusvillemoes.dk>
Date:   Tue, 9 Aug 2022 14:29:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 11/16] time: optimize tick_check_preferred()
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
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
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        linux-mm@kvack.org, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-12-yury.norov@gmail.com> <87fsi9rcxu.ffs@tglx>
 <87czdbq7up.ffs@tglx> <YvE8HGXFDicr/zI5@yury-laptop>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <YvE8HGXFDicr/zI5@yury-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/2022 18.38, Yury Norov wrote:
> On Mon, Aug 08, 2022 at 01:42:54PM +0200, Thomas Gleixner wrote:
>> On Sat, Aug 06 2022 at 10:30, Thomas Gleixner wrote:
>>> On Mon, Jul 18 2022 at 12:28, Yury Norov wrote:
>>>
>>>> tick_check_preferred() calls cpumask_equal() even if
>>>> curdev->cpumask == newdev->cpumask. Fix it.
>>>
>>> What's to fix here? It's a pointless operation in a slow path and all
>>> your "fix' is doing is to make the code larger.
> 
> Pointless operation in a slow path is still pointless.
>  
>> In fact cpumask_equal() should have the ptr1 == ptr2 check, so you don't
>> have to add it all over the place.
> 
> This adds to the image size:
> add/remove: 1/1 grow/shrink: 24/3 up/down: 507/-46 (461)
> 
> The more important, cpumask shouldn't check parameters because this is
> an internal function. This whole series point is about adding such checks
> under DEBUG_BITMAP config, and not affecting general case.

Yury, calling bitmap_equal (and by extension cpumask_equal) with
something that happens in some cases to be the same pointer for both
operands is not a bug.

If you want to optimize that case, add a check in __bitmap_equal(), it
will add a few bytes (maybe 2-4 instructions) to the kernel image, much
less than what this whole series does by open-coding that check all
over, and since it's comparing two registers, it won't in any way affect
the performance of the case where the pointers are distinct.

Rasmus
