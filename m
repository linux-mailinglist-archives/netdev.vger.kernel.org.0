Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF6F2D89D5
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 20:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407840AbgLLTtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 14:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgLLTso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 14:48:44 -0500
Date:   Sat, 12 Dec 2020 11:48:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607802483;
        bh=thn/QnopDGhA36N1/urymNIm0L9PfHPZm62GdCE6Hkg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Azc9ZFkQAHNRPn3nxBtrugpyYHBvIhjbLIa03OSbRrBGZAxIQbnwSv0JJdjew+Dq2
         4AMfG89to+hsVFvX4cFFxim9z1Wtxx09yTLBPE98ZWr7JBPkcmYsmkMptbSlDyazZo
         dC8yk8p7cxAyQhg4n3ScJgZITfRvYE2Uh01vdDu4tdVZMF6p1P7LjngKL5O6Lp+TTi
         j/kIyoQmIvZaEZb16+08yq1bmM3Svl48Mnu37UuZfM3R/LcnkRfhYSvsYiXHesLA86
         oAqalet9KYBx23au21yKatRP7zDqokg08t9w9s6X3VKXOzGqDzN1ha+7Knioc/dd1P
         EDjrcI2yT559A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yonatan Linik <yonatanlinik@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, willemb@google.com,
        john.ogness@linutronix.de, arnd@arndb.de, maowenan@huawei.com,
        colin.king@canonical.com, orcohen@paloaltonetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 1/1] net: Fix use of proc_fs
Message-ID: <20201212114802.21a6b257@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211163749.31956-2-yonatanlinik@gmail.com>
References: <20201211163749.31956-1-yonatanlinik@gmail.com>
        <20201211163749.31956-2-yonatanlinik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 18:37:49 +0200 Yonatan Linik wrote:
> proc_fs was used, in af_packet, without a surrounding #ifdef,
> although there is no hard dependency on proc_fs.
> That caused the initialization of the af_packet module to fail
> when CONFIG_PROC_FS=n.
> 
> Specifically, proc_create_net() was used in af_packet.c,
> and when it fails, packet_net_init() returns -ENOMEM.
> It will always fail when the kernel is compiled without proc_fs,
> because, proc_create_net() for example always returns NULL.
> 
> The calling order that starts in af_packet.c is as follows:
> packet_init()
> register_pernet_subsys()
> register_pernet_operations()
> __register_pernet_operations()
> ops_init()
> ops->init() (packet_net_ops.init=packet_net_init())
> proc_create_net()
> 
> It worked in the past because register_pernet_subsys()'s return value
> wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
> packet_init.").
> It always returned an error, but was not checked before, so everything
> was working even when CONFIG_PROC_FS=n.
> 
> The fix here is simply to add the necessary #ifdef.
> 
> Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>

Hm, I'm guessing you hit this on a kernel upgrade of a real system?
It seems like all callers to proc_create_net (and friends) interpret
NULL as an error, but only handful is protected by an ifdef.

I checked a few and none of them cares about the proc_dir_entry pointer
that gets returned. Should we perhaps rework the return values of the
function so that we can return success if !CONFIG_PROC_FS without
having to yield a pointer?

Obviously we can apply this fix so we can backport to 5.4 if you need
it. I think the ifdef is fine, since it's what other callers have.

> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index 2b33e977a905..031f2b593720 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -4612,9 +4612,11 @@ static int __net_init packet_net_init(struct net *net)
>  	mutex_init(&net->packet.sklist_lock);
>  	INIT_HLIST_HEAD(&net->packet.sklist);
>  
> +#ifdef CONFIG_PROC_FS
>  	if (!proc_create_net("packet", 0, net->proc_net, &packet_seq_ops,
>  			sizeof(struct seq_net_private)))
>  		return -ENOMEM;
> +#endif /* CONFIG_PROC_FS */
>  
>  	return 0;
>  }

