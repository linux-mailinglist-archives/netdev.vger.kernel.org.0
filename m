Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549354370A0
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 06:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhJVEDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 00:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhJVEDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 00:03:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BA8C061220
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 21:00:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gn3so2029240pjb.0
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 21:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=63mhhziKLiqFO4zSrh9ukWKmqfg2gNncagqLuotvmtA=;
        b=X39ypBn4CFGyhh2sL9znOr84NnhkCZ2dA8quRYgjwHWkDgmOEmgYHM8c6Mom/wBP40
         SU5jAJWBBxqkVabzf7HmWjQafrkN1Yp3s0phP8OooZWlipf8a3KFdcohgAYXL2YE4ddy
         w0UbekNVppvN0r+cy2CltOEugZ45mOSYsGbO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=63mhhziKLiqFO4zSrh9ukWKmqfg2gNncagqLuotvmtA=;
        b=W7NeXv+rSI4WTroRPy++ddCGH2icf6ezrHa+HPlsCY1SyOgu0eS0Bavh3Be6nLcryr
         ZMVNqYnrLqokXbceshKaa2jcySteNEcU7UFIkNtnlCNeB1H63FqRCPfeDPiVMGadTnLV
         SiCCtZuUxTSUPeWHTnQv37cwtwA2mLmYXZQz59960fbqYoLOl2kGCFUIizdsmnOlvTZO
         B3tMsjH8mCwhnUlv1mHW6jmuk24N4z3EBPud2pU1HKqGXRke17AGebVCqIZiJCMKe7F0
         ZJEmkmcBZnEBe80W1ewrvpT4MxOErZyjRC9/WsW+e+nFf9NnhjGPkBsBsHXBPAJzMinz
         xX+g==
X-Gm-Message-State: AOAM5316PI+frhx6EqO+lJbluXNy87AVKjqsbUhoU/wyoPhZ1u3afQtN
        00eUTX6jYVGpBGCl0g4pE02CpA==
X-Google-Smtp-Source: ABdhPJxQzmqVL9IyfLWuElQLRxcTB3CxCGbMXf8BpqcMpBM3XiYUy5l2z9cTTWG+8hwuQBLPHvmRtg==
X-Received: by 2002:a17:902:a50f:b029:11a:cd45:9009 with SMTP id s15-20020a170902a50fb029011acd459009mr9269460plq.38.1634875252833;
        Thu, 21 Oct 2021 21:00:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a7sm7618987pfo.32.2021.10.21.21.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 21:00:52 -0700 (PDT)
Date:   Thu, 21 Oct 2021 21:00:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Yafang Shao <laoar.shao@gmail.com>, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
        pmladek@suse.com, peterz@infradead.org, viro@zeniv.linux.org.uk,
        valentin.schneider@arm.com, qiang.zhang@windriver.com,
        robdclark@chromium.org, christian@brauner.io,
        dietmar.eggemann@arm.com, mingo@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oliver.sang@intel.com, lkp@intel.com
Subject: Re: [PATCH v5 00/15] extend task comm from 16 to 24 for
 CONFIG_BASE_FULL
Message-ID: <202110212053.6F3BB603@keescook>
References: <20211021034516.4400-1-laoar.shao@gmail.com>
 <20211021205222.714a76c854cc0e7a7d6db890@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021205222.714a76c854cc0e7a7d6db890@linux-foundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 08:52:22PM -0700, Andrew Morton wrote:
> On Thu, 21 Oct 2021 03:45:07 +0000 Yafang Shao <laoar.shao@gmail.com> wrote:
> 
> > This patchset changes files among many subsystems. I don't know which
> > tree it should be applied to, so I just base it on Linus's tree.
> 
> I can do that ;)
> 
> > There're many truncated kthreads in the kernel, which may make trouble
> > for the user, for example, the user can't get detailed device
> > information from the task comm.
> 
> That sucked of us.
> 
> > This patchset tries to improve this problem fundamentally by extending
> > the task comm size from 16 to 24. In order to do that, we have to do
> > some cleanups first.
> 
> It's at v5 and there's no evidence of review activity?  C'mon, folks!

It's on my list! :) It's a pretty subtle area that rarely changes, so I
want to make sure I'm a full coffee to do the review. :)

> > 1. Make the copy of task comm always safe no matter what the task
> > comm size is. For example,
> > 
> >   Unsafe                 Safe
> >   strlcpy                strscpy_pad
> >   strncpy                strscpy_pad
> >   bpf_probe_read_kernel  bpf_probe_read_kernel_str
> >                          bpf_core_read_str
> >                          bpf_get_current_comm
> >                          perf_event__prepare_comm
> >                          prctl(2)
> > 
> > 2. Replace the old hard-coded 16 with a new macro TASK_COMM_LEN_16 to
> > make it more grepable.
> > 
> > 3. Extend the task comm size to 24 for CONFIG_BASE_FULL case and keep it
> > as 16 for CONFIG_BASE_SMALL.
> 
> Is this justified?  How much simpler/more reliable/more maintainable/
> would the code be if we were to make CONFIG_BASE_SMALL suffer with the
> extra 8 bytes?

Does anyone "own" CONFIG_BASE_SMALL? Gonna go with "no":

$ git ann init/Kconfig| grep 'config BASE_SMALL'
1da177e4c3f41   (Linus Torvalds 2005-04-16 15:20:36 -0700 2054)config BASE_SMALL

And it looks mostly unused:

$ git grep CONFIG_BASE_SMALL | cut -d: -f1 | sort -u | xargs -n1 git ann -f | grep 'CONFIG_BASE_SMALL'
b2af018ff26f1   (Ingo Molnar    2009-01-28 17:36:56 +0100       18)#if CONFIG_BASE_SMALL == 0
fcdba07ee390d   ( Jiri Olsa     2011-02-07 19:31:25 +0100       54)#define CON_BUF_SIZE (CONFIG_BASE_SMALL ? 256 : PAGE_SIZE)
Blaming lines: 100% (46/46), done.
1da177e4c3f41   (Linus Torvalds 2005-04-16 15:20:36 -0700       28)#define PID_MAX_DEFAULT (CONFIG_BASE_SMALL ? 0x1000 : 0x8000)
1da177e4c3f41   (Linus Torvalds 2005-04-16 15:20:36 -0700       34)#define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
Blaming lines: 100% (162/162), done.
f86dcc5aa8c79   (Eric Dumazet   2009-10-07 00:37:59 +0000       31)#define UDP_HTABLE_SIZE_MIN     (CONFIG_BASE_SMALL ? 128 : 256)
02c02bf12c5d8   (Matthew Wilcox 2017-11-03 23:09:45 -0400       1110)#define XA_CHUNK_SHIFT        (CONFIG_BASE_SMALL ? 4 : 6)
a52b89ebb6d44   (Davidlohr Bueso        2014-01-12 15:31:23 -0800       4249)#if CONFIG_BASE_SMALL
7b44ab978b77a   (Eric W. Biederman      2011-11-16 23:20:58 -0800       78)#define UIDHASH_BITS (CONFIG_BASE_SMALL ? 3 : 7)


-- 
Kees Cook
