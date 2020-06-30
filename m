Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E12520F0FB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 10:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731743AbgF3I5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 04:57:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:40932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgF3I5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 04:57:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 87A42AE61;
        Tue, 30 Jun 2020 08:57:06 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id E8BAB604DC; Tue, 30 Jun 2020 10:57:05 +0200 (CEST)
Date:   Tue, 30 Jun 2020 10:57:05 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH 04/16] net: bpfilter: use 'userprogs' syntax to build
 bpfilter_umh
Message-ID: <20200630085705.txwn62zixvxxs7rt@lion.mk-sys.cz>
References: <20200423073929.127521-1-masahiroy@kernel.org>
 <20200423073929.127521-5-masahiroy@kernel.org>
 <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
 <CAK7LNARGKCyWbfWUOX3nLLOBS3gi1QU3acdXLPVK4C+ErMDLpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNARGKCyWbfWUOX3nLLOBS3gi1QU3acdXLPVK4C+ErMDLpA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 03:30:04PM +0900, Masahiro Yamada wrote:
> On Mon, Jun 8, 2020 at 8:56 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> >
> > I just noticed that this patch (now in mainline as commit 8a2cc0505cc4)
> > drops the test if CONFIG_BPFILTER_UMH is "y" so that -static is now
> > passed to the linker even if bpfilter_umh is built as a module which
> > wasn't the case in v5.7.
> >
> > This is not mentioned in the commit message and the comment still says
> > "*builtin* bpfilter_umh should be linked with -static" so this change
> > doesn't seem to be intentional. Did I miss something?
> 
> I was away for a while from this because I saw long discussion in
> "net/bpfilter: Remove this broken and apparently unmaintained"
> 
> 
> Please let me resume this topic now.
> 
> 
> The original behavior of linking umh was like this:
>   - If CONFIG_BPFILTER_UMH=y, bpfilter_umh was linked with -static
>   - If CONFIG_BPFILTER_UMH=m, bpfilter_umh was linked without -static
> 
> 
> 
> Restoring the original behavior will add more complexity because
> now we have CONFIG_CC_CAN_LINK and CONFIG_CC_CAN_LINK_STATIC
> since commit b1183b6dca3e0d5
> 
> If CONFIG_BPFILTER_UMH=y, we need to check CONFIG_CC_CAN_LINK_STATIC.
> If CONFIG_BPFILTER_UMH=m, we need to check CONFIG_CC_CAN_LINK.
> This would make the Kconfig dependency logic too complicated.
> 
> 
> To make it simpler, I'd like to suggest two options.
> 
> 
> 
> Idea 1:
> 
>   Always use -static irrespective of whether
>   CONFIG_BPFILTER_UMH is y or m.
> 
>   Add two more lines to clarify this
>   in the comment in net/bpfilter/Makefile:
> 
>   # builtin bpfilter_umh should be linked with -static
>   # since rootfs isn't mounted at the time of __init
>   # function is called and do_execv won't find elf interpreter.
>   # Static linking is not required when bpfilter is modular, but
>   # we always pass -static to keep the 'depends on' in Kconfig simple.

I wouldn't be very happy with this solution as that would mean adding an
extra build dependency which we don't really need. We might even
consider disabling CONFIG_BPFILTER_UMH instead.

> Idea 2:
> 
>    Allow umh to become only modular,
>    and drop -static flag entirely.
> 
>    If you look at net/bpfilter/Kconfig,
>    BPFILTER_UMH already has 'default m'.
>    So, I assume the most expected use-case
>    is modular.
> 
>    My suggestion is to replace 'default m' with 'depends on m'.
> 
>    config BPFILTER_UMH
>            tristate "bpfilter kernel module with user mode helper"
>            depends on CC_CAN_LINK
>            depends on m
> 
>    Then BPFILTER_UMH will be restricted to either m or n.
>    Link umh dynamically because we can expect rootfs
>    is already mounted for the module case.

This wouldn't be a problem for me or openSUSE kernels as we already have
CONFIG_BPFILTER_UMH=m. But I can't speak for others, I'm not sure if
there are some use cases requiring CONFIG_BPFILTER_UMH=y.

Michal
