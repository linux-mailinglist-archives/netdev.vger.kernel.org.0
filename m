Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79F184E54A2
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbiCWO5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiCWO5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:57:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932747DE21;
        Wed, 23 Mar 2022 07:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893FB61710;
        Wed, 23 Mar 2022 14:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B89C340E8;
        Wed, 23 Mar 2022 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648047347;
        bh=cHeg4XtXSKgVyvX8tOP4tySGT9vRJ7ndAZJt2ckl/9s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dcYTchivxGaG6WxPPEba8PM2zS7O0KO2EdTM617uO2m3o8q5R7irBhAzrnirHy282
         eHEmQa5/xfeqTSMf9I4JTs/7ShcSfgTK515bn3KrpHY4tfpIpKnGwNxySG4WF3bOW8
         FBjNZ7zxGipf0SNk05gxu1V3EBoYyh2huO+Sh7gbHRMV0LYxHYVhgak9jQZO8PbkrG
         NvAUbqsDCwnCb2JYg6KFSdBTvQLs2eNBO7od2DRtSc4SpR4e5ZXd2p2gwn8bAZWBLL
         ArSh/2uU9eNNSfBWCOm/wf42D/+mTIl71JA+hF0C8Fg5kuqBH6ndYfJOXlhsY6dqZQ
         SCPd+W/uZFuGg==
Date:   Wed, 23 Mar 2022 23:55:39 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-Id: <20220323235539.644ad8ace98347467de3e897@kernel.org>
In-Reply-To: <YjssQKblWeKqr/x8@lakrids>
References: <164800288611.1716332.7053663723617614668.stgit@devnote2>
        <YjssQKblWeKqr/x8@lakrids>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 14:18:40 +0000
Mark Rutland <mark.rutland@arm.com> wrote:

> On Wed, Mar 23, 2022 at 11:34:46AM +0900, Masami Hiramatsu wrote:
> > Hi,
> 
> Hi Masami,
> 
> > Here is the 13th version of rethook x86 port. This is developed for a part
> > of fprobe series [1] for hooking function return. But since I forgot to send
> > it to arch maintainers, that caused conflict with IBT and SLS mitigation series.
> > Now I picked the x86 rethook part and send it to x86 maintainers to be
> > reviewed.
> > 
> > [1] https://lore.kernel.org/all/164735281449.1084943.12438881786173547153.stgit@devnote2/T/#u
> 
> As mentioned elsewhere, I have similar (though not identical) concerns
> to Peter for the arm64 patch, which was equally unreviewed by
> maintainers, and the overall structure.

Yes, those should be reviewed by arch maintainers.

> 
> > Note that this patch is still for the bpf-next since the rethook itself
> > is on the bpf-next tree. But since this also uses the ANNOTATE_NOENDBR
> > macro which has been introduced by IBT/ENDBR patch, to build this series
> > you need to merge the tip/master branch with the bpf-next.
> > (hopefully, it is rebased soon)
> 
> I thought we were going to drop the series from the bpf-next tree so
> that this could all go through review it had missed thusfar.
> 
> Is that still the plan? What's going on?

Now the arm64 (and other arch) port is reverted from bpf-next.
I'll send those to you soon.
Since bpf-next is focusing on x86 at first, I chose this for review in
this version. Sorry for confusion.

> 
> > The fprobe itself is for providing the function entry/exit probe
> > with multiple probe point. The rethook is a sub-feature to hook the
> > function return as same as kretprobe does. Eventually, I would like
> > to replace the kretprobe's trampoline with this rethook.
> 
> Can we please start by converting each architecture to rethook?

Yes. As Peter pointed, I'm planning to add a kretprobe patches to use
rethook if available in that series. let me prepare it.

> 
> Ideally we'd unify things such that each architecture only needs *one*
> return trampoline that both ftrace and krpboes can use, which'd be
> significantly easier to get right and manage.

Agreed :-)

Thank you,

> 
> Thanks,
> Mark.


-- 
Masami Hiramatsu <mhiramat@kernel.org>
