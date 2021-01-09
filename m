Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6E92EFD59
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 04:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbhAIDPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 22:15:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbhAIDPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 22:15:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE7F2399C;
        Sat,  9 Jan 2021 03:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610162092;
        bh=2F7nLhTTdXrprSm87Hth/K8KuE4Ca1QxMEcNohZJGnQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AFat8HIEnT1ZnPGSC7ybRX4yjTliL1hZxD1T/70SDyUGO9Ngjd1HNmETWaTRI9xgN
         MaPOnC+CxKVWxrTukg5/Gp2Tgy019q7lmKAsa7AlumZRXIw+AWoG7rIAReDls0R0TF
         S2TYuppBOgqgqGuQrGfp+tlaq4+uG2u4foJdubC8wcL7UnlC4Q4CyKV4ZeDmg493iW
         5ldqmhdNfDVI/rXoL08CkNKy0dXT2NUp91EA4DODOu8zCNWu4Ka7xc+1+JPrTf891v
         TvOCfKsyY1UsYtekbCvZfG9EQZ+a2ey2nuBSOgX8AOUAmZjZB9sxJUyGGM+iqyYtqF
         F6PzdfVG8Parw==
Date:   Fri, 8 Jan 2021 19:14:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Willem de Bruijn <willemb@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Marco Elver <elver@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, namkyu78.kim@samsung.com
Subject: Re: [PATCH net v3] net: fix use-after-free when UDP GRO with shared
 fraglist
Message-ID: <20210108191451.4eaa29a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9d8cccfe-21d1-4bd2-0cce-4e8af2dd6ef6@iogearbox.net>
References: <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
        <CGME20210108024017epcas2p455fe96b8483880f9b7a654dbcf600b20@epcas2p4.samsung.com>
        <1610072918-174177-1-git-send-email-dseok.yi@samsung.com>
        <9d8cccfe-21d1-4bd2-0cce-4e8af2dd6ef6@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 11:18:39 +0100 Daniel Borkmann wrote:
> On 1/8/21 3:28 AM, Dongseok Yi wrote:
> > skbs in fraglist could be shared by a BPF filter loaded at TC. If TC
> > writes, it will call skb_ensure_writable -> pskb_expand_head to create
> > a private linear section for the head_skb. And then call
> > skb_clone_fraglist -> skb_get on each skb in the fraglist.
> > 
> > skb_segment_list overwrites part of the skb linear section of each
> > fragment itself. Even after skb_clone, the frag_skbs share their
> > linear section with their clone in PF_PACKET.
> > 
> > Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
> > a link for the same frag_skbs chain. If a new skb (not frags) is
> > queued to one of the sk_receive_queue, multiple ptypes can see and
> > release this. It causes use-after-free.
> > 
> > [ 4443.426215] ------------[ cut here ]------------
> > [ 4443.426222] refcount_t: underflow; use-after-free.
> > [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> > refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> > [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> > [ 4443.426808] Call trace:
> > [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> > [ 4443.426823]  skb_release_data+0x144/0x264
> > [ 4443.426828]  kfree_skb+0x58/0xc4
> > [ 4443.426832]  skb_queue_purge+0x64/0x9c
> > [ 4443.426844]  packet_set_ring+0x5f0/0x820
> > [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> > [ 4443.426853]  __sys_setsockopt+0x188/0x278
> > [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> > [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> > [ 4443.426873]  el0_svc_handler+0x74/0x98
> > [ 4443.426880]  el0_svc+0x8/0xc
> > 
> > Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > Acked-by: Willem de Bruijn <willemb@google.com>  
> 
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>

Applied, thanks!
