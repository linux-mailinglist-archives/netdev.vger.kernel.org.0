Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6881FFBAE
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgFRTT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgFRTT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:19:27 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD307C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:19:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i4so5360863iov.11
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 12:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1RoYwxOw8RI3OWUFlccnZ59wPh7dWuoC1CUmrqD5Htw=;
        b=q8uh1UJ83BxLKuKJgE8VoEEgPxhJ8sLhigamAQMtliNhBipxAVMkpqW8KrOag/e/kv
         MoF/7IsIoPs+AVIP7jTuFRHktUwVtzJFh/5UUw+fcuncCD2TFVINsc3nGjTUnNyTPoHC
         cEl40LIQ1r0myftPWg5m+uA4a/OtFyINc5JbvC2DoiMcja6Snmch79lVPXotZ396RZqA
         39jDwcGTg2TgXGxhW5E/G+5LZ9dSICoaJyVW75w7mV4nEVFG4APn9hD1Oi67jbPBhNTE
         pMx607rLOhpIadem1XiNynx4qCBOBUeRHLmg3YAslwvVuxr5f56PPNWaTNAD5UEF7oiX
         32fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RoYwxOw8RI3OWUFlccnZ59wPh7dWuoC1CUmrqD5Htw=;
        b=aa8CvPNsdZ2ExI7ceMgO9QZcpX+0WAvDDfkuXJBb65/LGfBVnH6saj6nyDmLT6gUM3
         a3nM8BPLP0KjK+PF6u+aVLZOJWEojA/IVe9icTh4E7ccpajuKxAtJjagO56TuSubeye4
         TQbLmH1EixVrbRsGf2jW5XG/VHzLNS1l05ylmLl1dEhSSAZV43GYqoeKhGLHI+rHc5cA
         6ow0UTm3g32E7tWLeyzS1c2CBkQs3TXkoFTA+PChidyylCBwHgBBvVorK3RzhbShDAJt
         y0RH5Ey61z4pR7zp7syF391BjGZYd9GnUEGtL5SlZYwfaLlL2yDLSWFwDHfXWJcBWqSv
         +qAA==
X-Gm-Message-State: AOAM532AJwuZ/fummOnyFbQP3O4uz3EUDOuN364T/Yzu6MoHC6r3dkLY
        ychEGb6JkudsC0D4QgLa2wfr8Tu9mB7PxeIWuhg=
X-Google-Smtp-Source: ABdhPJy+7FF0IbbSZFSQUrDwVzeeMbM/gmePn3j6IT/CTF2mY19fLEGwNrLVTVG2C5ZKux0SsjxI3UqoQDHL8GGipj4=
X-Received: by 2002:a02:1a08:: with SMTP id 8mr124236jai.124.1592507964928;
 Thu, 18 Jun 2020 12:19:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200616180352.18602-1-xiyou.wangcong@gmail.com> <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
In-Reply-To: <141629e1-55b5-34b1-b2ab-bab6b68f0671@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 18 Jun 2020 12:19:13 -0700
Message-ID: <CAM_iQpUFFHPnMxS2sAHZqMUs80tTn0+C_jCcne4Ddx2b9omCxg@mail.gmail.com>
Subject: Re: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Zefan Li <lizefan@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=C3=ABl_Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 6:44 PM Zefan Li <lizefan@huawei.com> wrote:
>
> Cc: Roman Gushchin <guro@fb.com>
>
> Thanks for fixing this.
>
> On 2020/6/17 2:03, Cong Wang wrote:
> > When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
> > copied, so the cgroup refcnt must be taken too. And, unlike the
> > sk_alloc() path, sock_update_netprioidx() is not called here.
> > Therefore, it is safe and necessary to grab the cgroup refcnt
> > even when cgroup_sk_alloc is disabled.
> >
> > sk_clone_lock() is in BH context anyway, the in_interrupt()
> > would terminate this function if called there. And for sk_alloc()
> > skcd->val is always zero. So it's safe to factor out the code
> > to make it more readable.
> >
> > Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
>
> but I don't think the bug was introduced by this commit, because there
> are already calls to cgroup_sk_alloc_disable() in write_priomap() and
> write_classid(), which can be triggered by writing to ifpriomap or
> classid in cgroupfs. This commit just made it much easier to happen
> with systemd invovled.
>
> I think it's 4bfc0bb2c60e2f4c ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself"),
> which added cgroup_bpf_get() in cgroup_sk_alloc().

Good point.

I take a deeper look, it looks like commit d979a39d7242e06
is the one to blame, because it is the first commit that began to
hold cgroup refcnt in cgroup_sk_alloc().

The commit you mentioned above merely adds a refcnt for
cgroup bpf on to of cgroup refcnt.

Thanks.
