Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F44C2EF08D
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbhAHKTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 05:19:42 -0500
Received: from www62.your-server.de ([213.133.104.62]:33198 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbhAHKTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 05:19:42 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kxoqv-0004vR-1g; Fri, 08 Jan 2021 11:18:41 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kxoqu-0005en-NO; Fri, 08 Jan 2021 11:18:40 +0100
Subject: Re: [PATCH net v3] net: fix use-after-free when UDP GRO with shared
 fraglist
To:     Dongseok Yi <dseok.yi@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
References: <1609979953-181868-1-git-send-email-dseok.yi@samsung.com>
 <CGME20210108024017epcas2p455fe96b8483880f9b7a654dbcf600b20@epcas2p4.samsung.com>
 <1610072918-174177-1-git-send-email-dseok.yi@samsung.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9d8cccfe-21d1-4bd2-0cce-4e8af2dd6ef6@iogearbox.net>
Date:   Fri, 8 Jan 2021 11:18:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1610072918-174177-1-git-send-email-dseok.yi@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26042/Thu Jan  7 13:37:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/21 3:28 AM, Dongseok Yi wrote:
> skbs in fraglist could be shared by a BPF filter loaded at TC. If TC
> writes, it will call skb_ensure_writable -> pskb_expand_head to create
> a private linear section for the head_skb. And then call
> skb_clone_fraglist -> skb_get on each skb in the fraglist.
> 
> skb_segment_list overwrites part of the skb linear section of each
> fragment itself. Even after skb_clone, the frag_skbs share their
> linear section with their clone in PF_PACKET.
> 
> Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
> a link for the same frag_skbs chain. If a new skb (not frags) is
> queued to one of the sk_receive_queue, multiple ptypes can see and
> release this. It causes use-after-free.
> 
> [ 4443.426215] ------------[ cut here ]------------
> [ 4443.426222] refcount_t: underflow; use-after-free.
> [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> refcount_dec_and_test_checked+0xa4/0xc8
> [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> [ 4443.426808] Call trace:
> [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> [ 4443.426823]  skb_release_data+0x144/0x264
> [ 4443.426828]  kfree_skb+0x58/0xc4
> [ 4443.426832]  skb_queue_purge+0x64/0x9c
> [ 4443.426844]  packet_set_ring+0x5f0/0x820
> [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> [ 4443.426853]  __sys_setsockopt+0x188/0x278
> [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> [ 4443.426873]  el0_svc_handler+0x74/0x98
> [ 4443.426880]  el0_svc+0x8/0xc
> 
> Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Acked-by: Daniel Borkmann <daniel@iogearbox.net>
