Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658FD5756DD
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 23:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240798AbiGNV0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 17:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiGNV0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 17:26:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C88D6D57D
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 14:26:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d10so2973375pfd.9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 14:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A82TrBfvwK16A0WmBpUzkOCIu8QaflndhNSONWHsTyI=;
        b=Iige2mJGGUUPL5VGGoebtLr+8r+yZZTpb6RzXRHxCieHfegCfLjo8YRLUaQKCNYqHp
         2/Vmt7cgBe6z6fE7uDakqB1iKwoRvbnAsMAoX4PPhb/mUeRIoWRRvwnFhr0htM9yYsg3
         sjIoIFbhjbA0FzuDNGLBlzwGD7TdGnn5BzJ6o2/HnX+fLR29CWuDId34mT8C/ZljQGCB
         ZaV5sX5KAT6Se9xd0UwbjiL20z6V1hkGzVTjSF0ElJdpwjDuNCJ+643tPDQzdI/1Ob1v
         j0OXIvVZaoXYwJWf/kMXF0rMZa+tedS6jJphiIe7rpcYgat+ke4ruKiRByQWzElQtEaX
         HUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A82TrBfvwK16A0WmBpUzkOCIu8QaflndhNSONWHsTyI=;
        b=7udgjH/RLn2bDLnQqmgrVx1ncbUrcobgWwd8UOOqEhWNsn8Rj9rMiF43oXyjljPk21
         7Ih/Y+s82VJQZaSkG4SGsHPBXGxaREGbu3OIx5S/AhQSjgYD8K8XTiSi/SdEpUpm7D5m
         pEh/srlH4U96xsWSKgMKU7CuV5iU4N2G4bRPLV68uYTc/f7gKqwz3tiKgAbtwfh5ziYD
         GrYW/LF4JNE8Q3rKEPhbcCBzI8IRN0m7x9ilvBTNVCL8lZCeVC6y68EA1TmCugkGDl/k
         KbNCwTvB7IbGv/MvKeIelAeyscwjCotzDk+WILlbeYtsUFy5merSTqsMrCRZts14r8ul
         eONg==
X-Gm-Message-State: AJIora+eJzAyEercg2TokICbAMlYbXin0NJbPk/TG5vn6wAni1IjBjij
        FF0FuQxESjxxmcH1CAQDTYquWEWGTVagnuWTWF+F5w==
X-Google-Smtp-Source: AGRyM1tucHhmA1dXhZrSh53rKxTi0X7NS5UUXAMWuwVb4boYYkxJPXelYwHOoS6BTNufVRmuRATqRqcOKmKOG3MCZgY=
X-Received: by 2002:a62:6d05:0:b0:528:99a2:b10 with SMTP id
 i5-20020a626d05000000b0052899a20b10mr10183904pfc.72.1657834003735; Thu, 14
 Jul 2022 14:26:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220714060959.25232-1-shaozhengchao@huawei.com>
 <CAKH8qBtxJOCWoON6QXygOTD7AqjF+k=-4JWPHXEAQh-TO+W54A@mail.gmail.com> <7b333bcc-c8ed-f1f8-8331-58cba7897637@iogearbox.net>
In-Reply-To: <7b333bcc-c8ed-f1f8-8331-58cba7897637@iogearbox.net>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 14 Jul 2022 14:26:32 -0700
Message-ID: <CAKH8qBvd1mc_fM6Ha_=kMppvuy67aB5EzmoHmODmGtVT5pcq7A@mail.gmail.com>
Subject: Re: [PATCH v2,bpf-next] bpf: Don't redirect packets with invalid pkt_len
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 1:39 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/14/22 8:22 PM, Stanislav Fomichev wrote:
> > On Wed, Jul 13, 2022 at 11:05 PM Zhengchao Shao
> > <shaozhengchao@huawei.com> wrote:
> >>
> >> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> >> skbs, that is, the flow->head is null.
> >> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
> >> run a bpf prog which redirects empty skbs.
> >> So we should determine whether the length of the packet modified by bpf
> >> prog is valid before forwarding it directly.
> >>
> >> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
> >> LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html
> >>
> >> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> >> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> >
> > Daniel, do you see any issues with this approach?
>
> I think it's fine, maybe this could be folded into:
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 750d7d173a20..256cd18cfe22 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -957,6 +957,8 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
>
>          if (!__skb)
>                  return 0;
> +       if (!skb->len)
> +               return -EINVAL;

So putting it in convert___skb_to_skb lets us remove a goto :-) Works
for me, whichever you prefer.

>          /* make sure the fields we don't use are zeroed */
>          if (!range_is_zero(__skb, 0, offsetof(struct __sk_buff, mark)))
>
> > I wonder if we might also want to add some WARN_ON to the
> > __bpf_redirect_common routine gated by #ifdef CONFIG_DEBUG_NET ?
> > In case syscaller manages to hit similar issues elsewhere..
>
> Assuming the issue is generic (and CONFIG_DEBUG_NET only enabled by things like
> syzkaller), couldn't we do something like the below?

Based on [1] it's selected by DEBUG_KERNEL, so it feels like it's safe
to assume that it's mostly debugging/fuzzing workloads?
Your suggestion to put it into __dev_queue_xmit looks good to me!

[1] https://lore.kernel.org/netdev/20220509190851.1107955-3-eric.dumazet@gmail.com/

> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f6a27ab19202..c9988a785294 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2459,6 +2459,17 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
>
>   #endif /* NET_SKBUFF_DATA_USES_OFFSET */
>
> +static inline void skb_assert_len(struct sk_buff *skb)
> +{
> +#ifdef CONFIG_DEBUG_NET
> +       if (unlikey(!skb->len)) {
> +               pr_err("%s\n", __func__);
> +               skb_dump(KERN_ERR, skb, false);
> +               WARN_ON_ONCE(1);
> +       }
> +#endif /* CONFIG_DEBUG_NET */
> +}
> +
>   /*
>    *     Add data to an sk_buff
>    */
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 978ed0622d8f..53c4b9fd22c0 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4168,7 +4168,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>          bool again = false;
>
>          skb_reset_mac_header(skb);
> -
> +       skb_assert_len(skb);
>          if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
>                  __skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
>
>
>
> >> ---
> >> v1: should not check len in fast path
> >>
> >>   net/bpf/test_run.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >> index 2ca96acbc50a..750d7d173a20 100644
> >> --- a/net/bpf/test_run.c
> >> +++ b/net/bpf/test_run.c
> >> @@ -1152,6 +1152,12 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
> >>          ret = convert___skb_to_skb(skb, ctx);
> >>          if (ret)
> >>                  goto out;
> >> +
> >> +       if (skb->len == 0) {
> >> +               ret = -EINVAL;
> >> +               goto out;
> >> +       }
> >> +
> >>          ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
> >>          if (ret)
> >>                  goto out;
> >> --
> >> 2.17.1
> >>
>
