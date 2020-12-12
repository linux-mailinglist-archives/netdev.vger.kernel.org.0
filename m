Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7382D8A38
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408038AbgLLVwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:52:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408022AbgLLVwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 16:52:02 -0500
Date:   Sat, 12 Dec 2020 13:51:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607809881;
        bh=MpmTZDYvsuyckChPfpiFw4PCoYaOJ5VfYZAIYusX6U8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=qqieKxnMKzAZdMQcLSnTj55DKscZ1s9/VojDduAml6i8IGAc5UrFdHgbXwwhC+PqW
         NO3DLXvfQBYLXiU4WqYC5Rx6crydVVwvfhPBwhj0dA+gXudztISBuujcB0xbxRtya4
         Ho4s88RQ5J1DniSAhLk1/rUhEOMVVCDXczLAZSVUzXdTtdCRQNI2uojinl2HYhyBtT
         hl+jVxA4bHMpKBPtNuJ8sIVaViCAzKtN6P2ZWWmHUDW57yMTKxgZTehbTVP9oWTfs0
         ftdJHDOLUQi4Rb+IwYXMvmPYyuHqHI55K1G2fhtYU2b18+R4zn76X5maxLhpQC5B1J
         o7YUf+tSJqsvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonatan Linik <yonatanlinik@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Willem de Bruijn <willemb@google.com>,
        john.ogness@linutronix.de, Arnd Bergmann <arnd@arndb.de>,
        Mao Wenan <maowenan@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        orcohen@paloaltonetworks.com, Networking <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: Fix use of proc_fs
Message-ID: <20201212135119.0db6723e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+s=kw3gmvk7CLu9NyiEwtBQ05eNFsTM2A679arPESVb55E2Xw@mail.gmail.com>
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
        <20201211163749.31956-2-yonatanlinik@gmail.com>
        <20201212114802.21a6b257@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+s=kw3gmvk7CLu9NyiEwtBQ05eNFsTM2A679arPESVb55E2Xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Dec 2020 23:39:20 +0200 Yonatan Linik wrote:
> On Sat, Dec 12, 2020 at 9:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 11 Dec 2020 18:37:49 +0200 Yonatan Linik wrote:  
> > > proc_fs was used, in af_packet, without a surrounding #ifdef,
> > > although there is no hard dependency on proc_fs.
> > > That caused the initialization of the af_packet module to fail
> > > when CONFIG_PROC_FS=n.
> > >
> > > Specifically, proc_create_net() was used in af_packet.c,
> > > and when it fails, packet_net_init() returns -ENOMEM.
> > > It will always fail when the kernel is compiled without proc_fs,
> > > because, proc_create_net() for example always returns NULL.
> > >
> > > The calling order that starts in af_packet.c is as follows:
> > > packet_init()
> > > register_pernet_subsys()
> > > register_pernet_operations()
> > > __register_pernet_operations()
> > > ops_init()
> > > ops->init() (packet_net_ops.init=packet_net_init())
> > > proc_create_net()
> > >
> > > It worked in the past because register_pernet_subsys()'s return value
> > > wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
> > > packet_init.").
> > > It always returned an error, but was not checked before, so everything
> > > was working even when CONFIG_PROC_FS=n.
> > >
> > > The fix here is simply to add the necessary #ifdef.
> > >
> > > Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>  
> >
> > Hm, I'm guessing you hit this on a kernel upgrade of a real system?  
> 
> Yeah, suddenly using socket with AF_PACKET didn't work,
> so I checked what happened.
> 
> > It seems like all callers to proc_create_net (and friends) interpret
> > NULL as an error, but only handful is protected by an ifdef.  
> 
> I guess where there is no ifdef,
> there should be a hard dependency on procfs,
> using depends on in the Kconfig.
> Maybe that's not the case everywhere it should be.

You're right, on a closer look most of the places have a larger #ifdef
block (which my grep didn't catch) or are under Kconfig. Of those I
checked only TLS looks wrong (good job me) - would you care to fix that
one as well, or should I?

> > I checked a few and none of them cares about the proc_dir_entry pointer
> > that gets returned. Should we perhaps rework the return values of the
> > function so that we can return success if !CONFIG_PROC_FS without
> > having to yield a pointer?  
> 
> Sometimes the pointer returned is used,
> for example in drivers/acpi/button.c.
> Are you suggesting returning a bool while
> having the pointer as an out parameter?
> Because that would still be problematic where the pointer is used.

Ack, I was only thinking of changing proc_create_net* but as you
rightly pointed out most callers already deal with the problem, 
so maybe it's not worth refactoring.

> > Obviously we can apply this fix so we can backport to 5.4 if you need
> > it. I think the ifdef is fine, since it's what other callers have.
> 
> It would be great to apply this where the problem exists,
> I believe this applies to other versions as well.

Will do. Linus is likely to cut the final 5.11 release on Sunday, so
it needs to wait until next week for process reasons but it won't get
lost. For the record:

Fixes: 36096f2f4fa0 ("packet: Fix error path in packet_init")
