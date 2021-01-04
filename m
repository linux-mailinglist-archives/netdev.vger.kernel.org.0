Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6872EA120
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbhADXuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbhADXuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:50:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B46C06179E;
        Mon,  4 Jan 2021 15:49:45 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id c7so29212593edv.6;
        Mon, 04 Jan 2021 15:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8xDAiTMr1Y9Zjyz3Do+aLLflQJZ8HhbQKE//whXZB0=;
        b=HdWcnf+rJPbz3CvbGkL8VSUBRqgAMeAJb1abAIDg6tZrGLnmp+3MB9uvt5AkvIcvQa
         5NwIdPWul8TFJUKjVqTSBw+gCJN61TUJVnYbeDfl07Dz3Zdq1hBwjfzQjK/Th+TUAIcd
         h2PaS9HEDS6wXfmLi2EDe6wfFThg6bSz31ij6t3YZzkkrqa7i0aqyf3RiCmY+Up2pYms
         ZlYA3MmA4CKA51xhKudSTvH+hmd2AkUGFG+o1moudtxNXm4bzw/fB9nFay+SMbH0UTPR
         amGIUDT/XUZ4warVRiNOn073AXAfmsHgqQ6iMmgBbwGxlb5nGa7VFxxtT+pgzDRtvnyp
         Qkzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8xDAiTMr1Y9Zjyz3Do+aLLflQJZ8HhbQKE//whXZB0=;
        b=jIqfSjRK4KYkrAxcNPp1URW2UJ6b5PkbErnNNZoDRpmGgVchX57yypCc6dwAhgp0/N
         L/yl4McihCEAphBhXPSnjy5h52GMtq8TEys66j6u7ojzeovVbFT0gtlQpHeGb+5pc85X
         3UZmG7jkkvEO9rObC2clt4GXP5ju2u5sHwCTBc8QthiY5Kjr5Jdc0385fkIVQevg4kO3
         EurkknPO49VCMIu4ebqihkaPP4H2C4PmEA89naR3YiIPc3sejkXpfMr2uobv7xk7mE21
         ocb5diw+npy/AFu46a8Wt8esK2ZZ85TvUYrKpA/j+9aEaQlRa4lw0Y7Dehv8R0ZuyfqA
         GivA==
X-Gm-Message-State: AOAM531Fy2LzPW40HEE4kayQwtUn7M/hcZBiBRmQQecW6tLRiUurKvTG
        xx6eVnYUFvqZbsePUuAyfsIDrKgLtibPEUUejntMoHK6
X-Google-Smtp-Source: ABdhPJwNhzlDy62/8o57lYELVNQBOraP7Lpc1yowiWpZPGHgBSMoO4UviAtG/CoG3BiW1HjrFyl8N0ZYt1UnYS/9BXY=
X-Received: by 2002:aa7:dd05:: with SMTP id i5mr72623237edv.223.1609794254808;
 Mon, 04 Jan 2021 13:04:14 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
 <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
In-Reply-To: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 4 Jan 2021 16:03:39 -0500
Message-ID: <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
Subject: Re: [PATCH net] net: fix use-after-free when UDP GRO with shared fraglist
To:     Dongseok Yi <dseok.yi@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guillaume Nault <gnault@redhat.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Marco Elver <elver@google.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, namkyu78.kim@samsung.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
>
> skbs in frag_list could be shared by pskb_expand_head() from BPF.

Can you elaborate on the BPF connection?

> While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> chain made by skb_segment_list().
>
> If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> multiple ptypes can see this. The skb could be released by ptypes and
> it causes use-after-free.

If I understand correctly, a udp-gro-list skb makes it up the receive
path with one or more active packet sockets.

The packet socket will call skb_clone after accepting the filter. This
replaces the head_skb, but shares the skb_shinfo and thus frag_list.

udp_rcv_segment later converts the udp-gro-list skb to a list of
regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
Now all the frags are fully fledged packets, with headers pushed
before the payload. This does not change their refcount anymore than
the skb_clone in pf_packet did. This should be 1.

Eventually udp_recvmsg will call skb_consume_udp on each packet.

The packet socket eventually also frees its cloned head_skb, which triggers

  kfree_skb_list(shinfo->frag_list)
    kfree_skb
      skb_unref
        refcount_dec_and_test(&skb->users)

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
> ---
>  net/core/skbuff.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f62cae3..1dcbda8 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>         unsigned int delta_truesize = 0;
>         unsigned int delta_len = 0;
>         struct sk_buff *tail = NULL;
> -       struct sk_buff *nskb;
> +       struct sk_buff *nskb, *tmp;
> +       int err;
>
>         skb_push(skb, -skb_network_offset(skb) + offset);
>
> @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
>                 nskb = list_skb;
>                 list_skb = list_skb->next;
>
> +               err = 0;
> +               if (skb_shared(nskb)) {

I must be missing something still. This does not square with my
understanding that the two sockets are operating on clones, with each
frag_list skb having skb->users == 1.

Unless the packet socket patch previously also triggered an
skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
calls skb_get on each frag_list skb.


> +                       tmp = skb_clone(nskb, GFP_ATOMIC);
> +                       if (tmp) {
> +                               kfree_skb(nskb);
> +                               nskb = tmp;
> +                               err = skb_unclone(nskb, GFP_ATOMIC);
> +                       } else {
> +                               err = -ENOMEM;
> +                       }
> +               }
> +
>                 if (!tail)
>                         skb->next = nskb;
>                 else
>                         tail->next = nskb;
>
> +               if (unlikely(err)) {
> +                       nskb->next = list_skb;
> +                       goto err_linearize;
> +               }
> +
>                 tail = nskb;
>
>                 delta_len += nskb->len;
> --
> 2.7.4
>
