Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1664CCAB4
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 01:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiCDAY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 19:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiCDAY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 19:24:26 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D52F10529C;
        Thu,  3 Mar 2022 16:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/6Asc1kuXCqlyUyBpJVWR3WYcUaPQlxeHwanFGxnWUA=; b=pwc7auhdwTjfEryudBhNUHhadZ
        j817TFuFaVCkRG4K02eM6NN3V9hpbDyxLiKmcnKqcLWmnGZT8/+sfsZ3qXVga3V/hixH0FwwN1QmA
        rjpJao3Slt8sVmFtSttFGEmk5ww+zx4r7pcfcwe05wBFOTYJEVQid6TaQoxWV5qfWNYzufIJAthME
        yZaLJIUPToWR3f8LiTcfZbADAGZIEYRfRKJRDZy2/jfkgJj4yc2hfIuawzldgw/SrnZdzfpsnlC7r
        M6rMZEdN61VHcgpJePGd+HuVt6VTAAJEVUYtkjwA49AgjGLJQiMnrFKSCPBBjuoeI3Zd0hTJcMEDM
        r4TXb6LQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nPvjC-0089dk-PG; Fri, 04 Mar 2022 00:23:26 +0000
Date:   Thu, 3 Mar 2022 16:23:26 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yan Zhu <zhuyan34@huawei.com>, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        liucheng32@huawei.com, netdev@vger.kernel.org,
        nixiaoming@huawei.com, songliubraving@fb.com,
        xiechengliang1@huawei.com, yhs@fb.com, yzaikin@google.com,
        zengweilin@huawei.com
Subject: Re: [PATCH v3 sysctl-next] bpf: move bpf sysctls from
 kernel/sysctl.c to bpf module
Message-ID: <YiFb/lZzPDIIf2rC@bombadil.infradead.org>
References: <Yh1dtBTeRtjD0eGp@bombadil.infradead.org>
 <20220302020412.128772-1-zhuyan34@huawei.com>
 <Yh/V5QN1OhN9IKsI@bombadil.infradead.org>
 <d8843ebe-b8df-8aa0-a930-c0742af98157@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8843ebe-b8df-8aa0-a930-c0742af98157@iogearbox.net>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 12:44:48AM +0100, Daniel Borkmann wrote:
> On 3/2/22 9:39 PM, Luis Chamberlain wrote:
> > On Wed, Mar 02, 2022 at 10:04:12AM +0800, Yan Zhu wrote:
> > > We're moving sysctls out of kernel/sysctl.c as its a mess. We
> > > already moved all filesystem sysctls out. And with time the goal is
> > > to move all sysctls out to their own susbsystem/actual user.
> > > 
> > > kernel/sysctl.c has grown to an insane mess and its easy to run
> > > into conflicts with it. The effort to move them out is part of this.
> > > 
> > > Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> > 
> > Daniel, let me know if this makes more sense now, and if so I can
> > offer take it through sysctl-next to avoid conflicts more sysctl knobs
> > get moved out from kernel/sysctl.c.
> 
> If this is a whole ongoing effort rather than drive-by patch,

It is ongoing effort, but it will take many releases before we tidy
this whole thing up.

> then it's
> fine with me. 

OK great. Thanks for understanding the mess.

> Btw, the patch itself should also drop the linux/bpf.h
> include from kernel/sysctl.c since nothing else is using it after the
> patch.

I'll let Yan deal with that.

> Btw, related to cleanups.. historically, we have a bunch of other knobs
> for BPF under net (in net_core_table), that is:
> 
>   /proc/sys/net/core/bpf_jit_enable
>   /proc/sys/net/core/bpf_jit_harden
>   /proc/sys/net/core/bpf_jit_kallsyms
>   /proc/sys/net/core/bpf_jit_limit
> 
> Would be nice to consolidate all under e.g. /proc/sys/kernel/bpf_* for

Oh the actual "name" / directory location is not changing.
What changes is just where in code you declare them.

> future going forward, and technically, they should be usable also w/o
> net configured into kernel.

That's up to you, and just consider if you have scrupts using these
already. You may need backward compatibility. You don't need networking
to create the net directory for sysctls too. The first sysctl to create
the directory creates it, if its not created, it will be created.

> Is there infra to point the sysctl knobs
> e.g. under net/core/ to kernel/, or best way would be to have single
> struct ctl_table and register for both?

Try proc_symlink().

  Luis
