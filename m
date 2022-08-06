Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C21258B491
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 10:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiHFIa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 04:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiHFIa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 04:30:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71298E0E5;
        Sat,  6 Aug 2022 01:30:56 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659774653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jD62rE7HTpABv1viMwh70H2T9Lk2mqB4lZpeEUAn7rs=;
        b=E1CMU6Dl6hEHJsFFfONIFG26dG22lAy7Is0O1sAUYTeZ1srkiAZEe7JFtbZNyesMnJfwOG
        hUl5AvC0Q8mnm7GZzQ3J9/Iia437hi/gbtkY9hUoRA2lsMHbLgyX0UVJfWQtPEGx9PIkOy
        rVD4sGRedtJ32HjEjEm9vP2eUpVmvdQFXNbNNIwQ5GRxdCI4/pWC1nCj+dC83MG0pvimJs
        CRA9OKRL9jFO8rI43SoZSPV0YOAncDpoI6HG3tT/L+O7pxrJWFyCgdOHNayh2shIlZhFXa
        efXnddpctbWVUHH8KUnM/OgSzjMbs4JEdGxiriLaW5qE/huno18y5Yk2LZPGoQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659774653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jD62rE7HTpABv1viMwh70H2T9Lk2mqB4lZpeEUAn7rs=;
        b=+4GPKoy6VlEqy5c/lQ6BDMSTFeovlKihb/Hs4NPgW3pr8Uvtc+BYZDVGQyr5zslyvGvo1n
        CF9bgtDm4R23oZCA==
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Song Liu <songliubraving@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yonghong Song <yhs@fb.com>,
        Yury Norov <yury.norov@gmail.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 11/16] time: optimize tick_check_preferred()
In-Reply-To: <20220718192844.1805158-12-yury.norov@gmail.com>
References: <20220718192844.1805158-1-yury.norov@gmail.com>
 <20220718192844.1805158-12-yury.norov@gmail.com>
Date:   Sat, 06 Aug 2022 10:30:53 +0200
Message-ID: <87fsi9rcxu.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18 2022 at 12:28, Yury Norov wrote:

> tick_check_preferred() calls cpumask_equal() even if
> curdev->cpumask == newdev->cpumask. Fix it.

What's to fix here? It's a pointless operation in a slow path and all
your "fix' is doing is to make the code larger.

Thanks,

        tglx
