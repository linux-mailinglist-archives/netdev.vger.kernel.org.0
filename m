Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D3606739
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 19:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJTRpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 13:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJTRpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 13:45:14 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3379A99ED
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 10:45:12 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n73so163814iod.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 10:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wg7uLm8hb6d0j5RKObW05MRzaH2V+TfFRuQ5MxvKm0o=;
        b=fZZnoSxGIcgKFd4uhCh2i5r8s3URjmVgSmX83EZPreC9Xnsf7D5LzCpYPZUZkfHtOB
         n/+IfjcROO0p+vN6ona5A6mDFbyfPrjYVMooKZ6gg4i3t1fQvQufskeFMZRZAiQqIIer
         GV4rpenq9HxAfPreu3J+JBmvIbZAkvCatCmVTyPKJRiJBj8VVWrL40yEIdAMh3Eio9h9
         iWPJVGryqWTeNKi5Iq+y2tv7hryD7TbGYGzXry1IyuFxlfRJynb/H9Jrn++gQUyH1P5C
         dYeArQy0Ykuy860XIU7dYYY32IBCPbqnoN09MZdLYRxxnXe8w8g8qHbAlXBSZZdggzJD
         S3DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wg7uLm8hb6d0j5RKObW05MRzaH2V+TfFRuQ5MxvKm0o=;
        b=7JtOmVnRBP5QK/sKeS662JnnbL2n4xjL2qchncxI4bHhN/lgkVA6ILoon9G9Xqlu/E
         S0XiS4gfRjDLtqwMmdRjyDMo+RQwW9GUs2rJMt1pg4iqN/G7dcWKXabHrihYG/eKhwNH
         bashsGTLD/Ugoq4r3jHa9aJ4zIZaHW6zFMBCjbYXSglHCT7gKN0b5StRpFnh7AFblIXz
         kRB4RMQhpb5k7UonBa6wqdRAaXp2rialq8hGK3qg9wWtszIbylgeE/alTGOkNGRgEgMh
         Sh8HsBOfdSetk9+uLyAcTkIKo2ZeK0ewbkfA2FTu3p7tTM5SlEq9kpj7tHqu7Y9hZM6s
         20PQ==
X-Gm-Message-State: ACrzQf3l3oUdPqIdv2gR+O7Q84iQKNgtH1pOzQ0m84SevOPix7GtLTBt
        k2WZho/64u632iNVeDQ93m0onFhINYqBnX/6+ELBzA==
X-Google-Smtp-Source: AMsMyM5g6GQEtsbdSpZrTiB+BouLLfBCqOPirtHCtygTwjbx5dvYMIXr2Rr61+zofRrbcYfhWlvVOLD3PixMI+K3XyU=
X-Received: by 2002:a05:6602:2a48:b0:6bc:e1c7:797b with SMTP id
 k8-20020a0566022a4800b006bce1c7797bmr10651335iov.131.1666287912064; Thu, 20
 Oct 2022 10:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <20221015092448.117563-1-shaozhengchao@huawei.com>
 <CAKH8qBugSdWHP7mtNxrnLLR+56u_0OCx3xQOkJSV-+RUvDAeNg@mail.gmail.com> <d830980c-4a38-5537-b594-bc5fb86b0acd@huawei.com>
In-Reply-To: <d830980c-4a38-5537-b594-bc5fb86b0acd@huawei.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 20 Oct 2022 10:45:00 -0700
Message-ID: <CAKH8qBtyfS0Otpugn7_ZiG5APA_WTKOVAe1wsFfyaxF-03X=5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix issue that packet only contains l2 is dropped
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, oss@lmb.io, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 6:47 PM shaozhengchao <shaozhengchao@huawei.com> wrote:
>
>
>
> On 2022/10/18 0:36, Stanislav Fomichev wrote:
> > On Sat, Oct 15, 2022 at 2:16 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> >>
> >> As [0] see, bpf_prog_test_run_skb() should allow user space to forward
> >> 14-bytes packet via BPF_PROG_RUN instead of dropping packet directly.
> >> So fix it.
> >>
> >> 0: https://github.com/cilium/ebpf/commit/a38fb6b5a46ab3b5639ea4d421232a10013596c0
> >>
> >> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
> >> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >> ---
> >>   net/bpf/test_run.c | 6 +++---
> >>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >> index 13d578ce2a09..aa1b49f19ca3 100644
> >> --- a/net/bpf/test_run.c
> >> +++ b/net/bpf/test_run.c
> >> @@ -979,9 +979,6 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
> >>   {
> >>          struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
> >>
> >> -       if (!skb->len)
> >> -               return -EINVAL;
> >> -
> >>          if (!__skb)
> >>                  return 0;
> >>
> >> @@ -1102,6 +1099,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
> >>          if (IS_ERR(data))
> >>                  return PTR_ERR(data);
> >>
> >> +       if (size == ETH_HLEN)
> >> +               is_l2 = true;
> >> +
> >
> > Don't think this will work? That is_l2 is there to expose proper l2/l3
> > skb for specific hooks; we can't suddenly start exposing l2 headers to
> > the hooks that don't expect it.
> > Does it make sense to start with a small reproducer that triggers the
> > issue first? We can have a couple of cases for
> > len=0/ETH_HLEN-1/ETH_HLEN+1 and trigger them from the bpf program that
> > redirects to different devices (to trigger dev_is_mac_header_xmit).
> >
> >
> Hi Stanislav:
>         Thank you for your review. Is_l2 is the flag of a specific
> hook. Therefore, do you mean that if skb->len is equal to 0, just
> add the length back?

Not sure I understand your question. All I'm saying is - you can't
flip that flag arbitrarily. This flag depends on the attach point that
you're running the prog against. Some attach points expect packets
with l2, some expect packets without l2.

What about starting with a small reproducer? Does it make sense to
create a small selftest that adds net namespace + fq_codel +
bpf_prog_test run and do redirect ingress/egress with len
0/1...tcphdr? Because I'm not sure I 100% understand whether it's only
len=0 that's problematic or some other combination as well?

> >
> >
> >
> >>          ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
> >>          if (IS_ERR(ctx)) {
> >>                  kfree(data);
> >> --
> >> 2.17.1
> >>
