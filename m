Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F073A4E541C
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 15:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244739AbiCWOUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244700AbiCWOUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:20:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AEF1A7CDC6;
        Wed, 23 Mar 2022 07:18:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57972D6E;
        Wed, 23 Mar 2022 07:18:52 -0700 (PDT)
Received: from lakrids (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BE903F73D;
        Wed, 23 Mar 2022 07:18:49 -0700 (PDT)
Date:   Wed, 23 Mar 2022 14:18:40 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>, catalin.marinas@arm.com,
        will@kernel.org
Subject: Re: [PATCH v13 bpf-next 0/1] fprobe: Introduce fprobe function
 entry/exit probe
Message-ID: <YjssQKblWeKqr/x8@lakrids>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164800288611.1716332.7053663723617614668.stgit@devnote2>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 11:34:46AM +0900, Masami Hiramatsu wrote:
> Hi,

Hi Masami,

> Here is the 13th version of rethook x86 port. This is developed for a part
> of fprobe series [1] for hooking function return. But since I forgot to send
> it to arch maintainers, that caused conflict with IBT and SLS mitigation series.
> Now I picked the x86 rethook part and send it to x86 maintainers to be
> reviewed.
> 
> [1] https://lore.kernel.org/all/164735281449.1084943.12438881786173547153.stgit@devnote2/T/#u

As mentioned elsewhere, I have similar (though not identical) concerns
to Peter for the arm64 patch, which was equally unreviewed by
maintainers, and the overall structure.

> Note that this patch is still for the bpf-next since the rethook itself
> is on the bpf-next tree. But since this also uses the ANNOTATE_NOENDBR
> macro which has been introduced by IBT/ENDBR patch, to build this series
> you need to merge the tip/master branch with the bpf-next.
> (hopefully, it is rebased soon)

I thought we were going to drop the series from the bpf-next tree so
that this could all go through review it had missed thusfar.

Is that still the plan? What's going on?

> The fprobe itself is for providing the function entry/exit probe
> with multiple probe point. The rethook is a sub-feature to hook the
> function return as same as kretprobe does. Eventually, I would like
> to replace the kretprobe's trampoline with this rethook.

Can we please start by converting each architecture to rethook?

Ideally we'd unify things such that each architecture only needs *one*
return trampoline that both ftrace and krpboes can use, which'd be
significantly easier to get right and manage.

Thanks,
Mark.
