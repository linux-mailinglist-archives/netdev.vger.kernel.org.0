Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF492ED05F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 14:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbhAGNHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 08:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGNHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 08:07:12 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56409C0612F4;
        Thu,  7 Jan 2021 05:06:31 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y24so7638974edt.10;
        Thu, 07 Jan 2021 05:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rk6wsfhcYnxhCiuowwvh3beez8z2QkbqZTVZVMpfFaY=;
        b=LQfz9drzfTwQMvmm7bHjP0fdGSSYZX0xkErLEi7mmkO4DojK4kxPQ36rlSPVkxLVm3
         MGUx/xlCHuuvP4eWAqiZEnIJRwT9gdVCTnYzOEDi9NvWB6AShh3CV0Jd8wjmo7h57WsQ
         q1Q4HyIhB5Y26WVv2E9TWKHKtcdwl2B2QaBJd8zKTKvWR+PBKhktXVGYt7gNiKIeruSY
         PoFKDJn50d3tvAcc/hSV8GaZKELOdA7KrNnxIzMkxRUIO3Oq04zPIVE60YBO0ymwzJ+v
         //yFauoFYfaJCPz2CKqqY3fF01WtBHXY0Rn49GQEnvWU/urea6RmypxXo7TZa952CIVv
         6Odg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rk6wsfhcYnxhCiuowwvh3beez8z2QkbqZTVZVMpfFaY=;
        b=IGq3pJKERH9KnX8IjVpVhH8N5OQQ2uxPVx6DF4QD5kxYJIsZfUULyGiZsBjyO4KAm5
         qqfIfJpLzO7gCyF2N6FbSp9LgqvpaYBh1qE5hfcGOmmvjhQVTCt7nvqnG+8v24GVmgiR
         SWCPd7cV1xl/e21m7CdUk+VYxbLlzoviDMXYU4/fim7dFuFpjSw6CBOu8yceuO7T1+Kc
         mfH3DZdp9MkuIjJYX6BNaahPqvUE7D8C68sMZcvd7SdkB0/e+deJ85FUINwvg1H7XE7G
         +bEgoR4EOU8jWihrn6Mndz7nvecRKeNU7inKmVAQzcA3jA1J+ETh+JwssoxlUm0I8Vbq
         6/5Q==
X-Gm-Message-State: AOAM532SkTURPtvThl1WhOsJgNNZDSt/f6ni99KLqbB3L9HQOxb8affs
        slk4EZ6Kj9il9DOPvpqQoadnEEQy3hKsFeKBfUA=
X-Google-Smtp-Source: ABdhPJzpb/qICC/VUlOv4f6jZesTk+6jApnks/vYmFVz79/7qLqPBq+AnSGgsJEFtMctsrBDebAbzNbdR11QC2U9guY=
X-Received: by 2002:aa7:c603:: with SMTP id h3mr1675921edq.254.1610024790076;
 Thu, 07 Jan 2021 05:06:30 -0800 (PST)
MIME-Version: 1.0
References: <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
 <CGME20210107005028epcas2p35dfa745fd92e31400024874f54243556@epcas2p3.samsung.com>
 <1609979953-181868-1-git-send-email-dseok.yi@samsung.com> <83a2b288-c0b2-ed98-9479-61e1cbe25519@iogearbox.net>
 <028b01d6e4e9$ddd5fd70$9981f850$@samsung.com> <c051bc98-6af2-f6ec-76d1-7feaa9da2436@iogearbox.net>
In-Reply-To: <c051bc98-6af2-f6ec-76d1-7feaa9da2436@iogearbox.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Jan 2021 08:05:53 -0500
Message-ID: <CAF=yD-KWByrahURXuUPm1WgwWS8M3StKDSFj0JzjU0qke9dCAg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix use-after-free when UDP GRO with shared fraglist
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
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

On Thu, Jan 7, 2021 at 7:52 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/7/21 12:40 PM, Dongseok Yi wrote:
> > On 2021-01-07 20:05, Daniel Borkmann wrote:
> >> On 1/7/21 1:39 AM, Dongseok Yi wrote:
> >>> skbs in fraglist could be shared by a BPF filter loaded at TC. It
> >>> triggers skb_ensure_writable -> pskb_expand_head ->
> >>> skb_clone_fraglist -> skb_get on each skb in the fraglist.
> >>>
> >>> While tcpdump, sk_receive_queue of PF_PACKET has the original fraglist.
> >>> But the same fraglist is queued to PF_INET (or PF_INET6) as the fraglist
> >>> chain made by skb_segment_list.
> >>>
> >>> If the new skb (not fraglist) is queued to one of the sk_receive_queue,
> >>> multiple ptypes can see this. The skb could be released by ptypes and
> >>> it causes use-after-free.
> >>>
> >>> [ 4443.426215] ------------[ cut here ]------------
> >>> [ 4443.426222] refcount_t: underflow; use-after-free.
> >>> [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> >>> refcount_dec_and_test_checked+0xa4/0xc8
> >>> [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> >>> [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> >>> [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> >>> [ 4443.426808] Call trace:
> >>> [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> >>> [ 4443.426823]  skb_release_data+0x144/0x264
> >>> [ 4443.426828]  kfree_skb+0x58/0xc4
> >>> [ 4443.426832]  skb_queue_purge+0x64/0x9c
> >>> [ 4443.426844]  packet_set_ring+0x5f0/0x820
> >>> [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> >>> [ 4443.426853]  __sys_setsockopt+0x188/0x278
> >>> [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> >>> [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> >>> [ 4443.426873]  el0_svc_handler+0x74/0x98
> >>> [ 4443.426880]  el0_svc+0x8/0xc
> >>>
> >>> Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> >>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> >>> Acked-by: Willem de Bruijn <willemb@google.com>
> >>> ---
> >>>    net/core/skbuff.c | 20 +++++++++++++++++++-
> >>>    1 file changed, 19 insertions(+), 1 deletion(-)
> >>>
> >>> v2: Expand the commit message to clarify a BPF filter loaded
> >>>
> >>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>> index f62cae3..1dcbda8 100644
> >>> --- a/net/core/skbuff.c
> >>> +++ b/net/core/skbuff.c
> >>> @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>     unsigned int delta_truesize = 0;
> >>>     unsigned int delta_len = 0;
> >>>     struct sk_buff *tail = NULL;
> >>> -   struct sk_buff *nskb;
> >>> +   struct sk_buff *nskb, *tmp;
> >>> +   int err;
> >>>
> >>>     skb_push(skb, -skb_network_offset(skb) + offset);
> >>>
> >>> @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>             nskb = list_skb;
> >>>             list_skb = list_skb->next;
> >>>
> >>> +           err = 0;
> >>> +           if (skb_shared(nskb)) {
> >>> +                   tmp = skb_clone(nskb, GFP_ATOMIC);
> >>> +                   if (tmp) {
> >>> +                           kfree_skb(nskb);
> >>
> >> Should use consume_skb() to not trigger skb:kfree_skb tracepoint when looking
> >> for drops in the stack.
> >
> > I will use to consume_skb() on the next version.
> >
> >>> +                           nskb = tmp;
> >>> +                           err = skb_unclone(nskb, GFP_ATOMIC);
> >>
> >> Could you elaborate why you also need to unclone? This looks odd here. tc layer
> >> (independent of BPF) from ingress & egress side generally assumes unshared skb,
> >> so above clone + dropping ref of nskb looks okay to make the main skb struct private
> >> for mangling attributes (e.g. mark) & should suffice. What is the exact purpose of
> >> the additional skb_unclone() in this context?
> >
> > Willem de Bruijn said:
> > udp_rcv_segment later converts the udp-gro-list skb to a list of
> > regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> > Now all the frags are fully fledged packets, with headers pushed
> > before the payload.
>
> Yes.
>
> > PF_PACKET handles untouched fraglist. To modify the payload only
> > for udp_rcv_segment, skb_unclone is necessary.
>
> I don't parse this last sentence here, please elaborate in more detail on why
> it is necessary.
>
> For example, if tc layer would modify mark on the skb, then __copy_skb_header()
> in skb_segment_list() will propagate it. If tc layer would modify payload, the
> skb_ensure_writable() will take care of that internally and if needed pull in
> parts from fraglist into linear section to make it private. The purpose of the
> skb_clone() above iff shared is to make the struct itself private (to safely
> modify its struct members). What am I missing?

If tc writes, it will call skb_make_writable and thus pskb_expand_head
to create a private linear section for the head_skb.

skb_segment_list overwrites part of the skb linear section of each
fragment itself. Even after skb_clone, the frag_skbs share their
linear section with their clone in pf_packet, so we need a
pskb_expand_head here, too.
