Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 239623C708C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhGMMm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbhGMMm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:42:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6614FC0613DD;
        Tue, 13 Jul 2021 05:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=21fOiOl5AIb9k8jOb9DFHX2kphCTyaUt0xG/F43XaZg=; b=jVHxEXQbkgT1ZHlGrYA/TifJEI
        5u+Ow777DU0VDfM5msD7HCkdgv+D3fkhdi1YWY9zgsL3D8Cg8uUzgCie6Nkrq0HUU1Lqw2QLitbC4
        aPPHzf1EKiHjLSWJJLGfcI7kgMnQnzakd7Wi82qgH9c4Jy2suQzqkeMFswAfih1LwOMS2FdqcLuVM
        s0jrOhS+Su19G0BpV+NCMGcXaH0zV5Aj7zNvxPhzoR2pp5N9VojgVH1m5vYCI19wKYpsRjbgidkjF
        6eLTCc1mnLyQzHTX+H/MTGxaRTO5avSyknan9YqAdih1HlK2lCffZKHePGCdGAisBY5bHoOdXovGF
        cy4z9kkg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3HgV-0016Vd-GU; Tue, 13 Jul 2021 12:38:53 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D0A3A987782; Tue, 13 Jul 2021 14:38:45 +0200 (CEST)
Date:   Tue, 13 Jul 2021 14:38:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kunit-dev@googlegroups.com, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Thomas Graf <tgraf@suug.ch>,
        Andrew Morton <akpm@linux-foundation.org>, jic23@kernel.org,
        linux@rasmusvillemoes.dk
Subject: Re: [PATCH v1 1/3] kernel.h: Don't pollute header with single user
 macros
Message-ID: <20210713123845.GA4170@worktop.programming.kicks-ass.net>
References: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713084541.7958-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 11:45:39AM +0300, Andy Shevchenko wrote:
> The COUNT_ARGS() and CONCATENATE() macros are used by a single user.
> Let move them to it.

That seems to be because people like re-implementing it instead of
reusing existing ones:

arch/x86/include/asm/efi.h:#define __efi_nargs__(_0, _1, _2, _3, _4, _5, _6, _7, n, ...)        \
arch/x86/include/asm/rmwcc.h:#define __RMWcc_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
include/linux/arm-smccc.h:#define ___count_args(_0, _1, _2, _3, _4, _5, _6, _7, _8, x, ...) x
include/linux/kernel.h:#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n

