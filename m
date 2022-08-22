Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C8859C09B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiHVNba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiHVNb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:31:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC9F27B20;
        Mon, 22 Aug 2022 06:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=57LbMv2SSV69f3b0nqG0xlqY4irKLICrqXlGHWibQ8I=; b=E9IrOodzNgd5O5GNBf3FPC8G5k
        2wstz74s2L84/Swr1xrKCKsF2Z5JSjF3mCvcX57Co7549WPmaXErvTjyyDPKpBv/lqTnfTu7CeNJg
        DcWWzzqndW3hOm2a/t7RhC40pKgrEzCJz7vsMvp9Wq1BgF8nsXC/62+7U6+sgpSejLgr1HX6EUvAi
        H8hGCIn0GsiRJvn160g8GVRbT+pZLvxdgevjtb7cjJntEaKxdPB0kVzzwVwmf9gsaTbYFw1gTp5Fg
        3sJA+uXOT/TvfKORiFPbQvfbeF3EHSgC9+UZgVBXfmIYJehP8cQlWirt/to6nKtKiJ+T0SK7SmJFn
        gFxcQDYA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oQ7W8-00EJNU-IM; Mon, 22 Aug 2022 13:31:00 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 69B549804A3; Mon, 22 Aug 2022 15:30:59 +0200 (CEST)
Date:   Mon, 22 Aug 2022 15:30:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?utf-8?B?546L5rW35byb?= <wanghaichi@tju.edu.cn>
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, lishuochuan@tju.edu.cn
Subject: Re: possible deadlock in __perf_install_in_context
Message-ID: <YwOFE1uIYAT+lml2@worktop.programming.kicks-ass.net>
References: <AFsAbgDYFNbqQK7Ox0JKtqpH.1.1661173960307.Hmail.3014218099@tju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AFsAbgDYFNbqQK7Ox0JKtqpH.1.1661173960307.Hmail.3014218099@tju.edu.cn>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:12:40PM +0800, 王海弛 wrote:
> Dear Linux maintainers and reviewers:
> We would like to report a linux kernel bug, found by a modified version of syzkaller.
> May affected file: arch/x86/events/core.c, include/linux/perf_event.h
> Kernel Version: 8fe31e0995f048d16b378b90926793a0aa4af1e5
> Kernel Config: see attach, linux.config
> Syzkaller Version: 3666edfeb55080ebe138d77417fa96fe2555d6bb
> reproducing program: see attach, reproducing.txt (There are syz-reproducing program, C reproducing program and crash report created by syzkaller, both of which can replay the crash)
> Feel free to  email us if any other infomations are needed. Hope the provided materials will help finding and fixing the bug.
> The full log crash log are as follows:(also in the attach, crash.report)
> -----------------
> 
> 
> unchecked MSR access error: WRMSR to 0x188 (tried to write 0x0000000300530000) at rIP: 0xffffffff810287de (__wrmsr arch/x86/include/asm/msr.h:103 [inline])
> unchecked MSR access error: WRMSR to 0x188 (tried to write 0x0000000300530000) at rIP: 0xffffffff810287de (native_write_msr arch/x86/include/asm/msr.h:160 [inline])
> unchecked MSR access error: WRMSR to 0x188 (tried to write 0x0000000300530000) at rIP: 0xffffffff810287de (wrmsrl arch/x86/include/asm/msr.h:281 [inline])
> unchecked MSR access error: WRMSR to 0x188 (tried to write 0x0000000300530000) at rIP: 0xffffffff810287de (__x86_pmu_enable_event arch/x86/events/intel/../perf_event.h:1120 [inline])
> unchecked MSR access error: WRMSR to 0x188 (tried to write 0x0000000300530000) at rIP: 0xffffffff810287de (intel_pmu_enable_event+0x3ce/0xfe0 arch/x86/events/intel/core.c:2693)

I'm guess this is some sort of broken virt setup?
