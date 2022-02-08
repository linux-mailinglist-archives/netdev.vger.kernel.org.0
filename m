Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF444AD065
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346500AbiBHEdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346730AbiBHEdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:33:11 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A453BC0401EE
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:33:10 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id p5so46261049ybd.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U15Bb4/SR1RZDkOEppauFJ4545K69aj7PuaJsKbYMBU=;
        b=Ya9umnjKNBpJUPOOd9PT/HsapCHBgpwrSPnGwKsv3pcvtz8Bf8D/awWjLtYbdMRuaO
         L7lMGDrQynkXuntLgi0GCP5ZHRsC62tSqHVsOgPHqR//B2mZiNEYu1q/XJN9FsOvBVP5
         CjndC57LYfR2crHFFg282NmNFnu9gyRwWnJNeYnhieA+GDqg6kd2WlkwP7YGwBGDSorR
         5Q7SgYXvatVdyo6HQIbutPVAKNuXBGC7CkZ9KanCnl3DQnvNFefttFXEjw/MhDJE4C4f
         yrfK++HcOolpq3GSmuJ/iEpdoIpTXBxoMlcOwJxkiuu34qvDfhoMTp62zYI+6p7uc6h1
         LCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U15Bb4/SR1RZDkOEppauFJ4545K69aj7PuaJsKbYMBU=;
        b=2EmhprhSmf/O3qPXY/Y05Igdu7Omi++4AehCC6In7q5S3SbKnBPTKyhhZONMGxiIis
         Bd3dwPg1MMqFS6ODf5GbemF0jrf+cwFZFTwaO+ieAqWYsRYFEjrTR8atM6y4LN6gueO5
         ywaqLipxUAegtYpygF+QzJX8LVUTByYSmvTaUYv7GJQGSrTbvwNtN+OMd6IU1Fs9AvsI
         7Fb5nmmTOjY2EQEZeZhCCCAkPvPfiA6Y+B2XWIVNz1L7j32/Ir6QBdpS3H9EbNgUJzvj
         70HZAFObe4mKUy6/qliNWGoIf6DDdJHmn04gc0kRvBLsiDgdQGfY+yi0G8KvgjJwPu/A
         PNow==
X-Gm-Message-State: AOAM532slnO2BmZEhAwoQh5TznsD+mz9OhMiay20u/ypoK46SrmPSD5V
        rI5GdXxBrCg2M5h5plXIbtCK9wGgfYrRB77zz0c4Ow==
X-Google-Smtp-Source: ABdhPJy+B/0jeB1J6mLngvzrhTfPM6ngjaZEPqh4p9HII3btSu84wVNavInvQrsT1yi9/MwToxum8Oa7drbFNAaths4=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr2928804ybb.156.1644294789499;
 Mon, 07 Feb 2022 20:33:09 -0800 (PST)
MIME-Version: 1.0
References: <20220208035510.1200-1-dongli.zhang@oracle.com> <20220208035510.1200-2-dongli.zhang@oracle.com>
In-Reply-To: <20220208035510.1200-2-dongli.zhang@oracle.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Feb 2022 20:32:58 -0800
Message-ID: <CANn89i++X+QBtm=L19PBbGLUJb8ZiTib4AABL_WL+cUfgwVfOA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: tap: track dropped skb via kfree_skb_reason()
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Joao Martins <joao.m.martins@oracle.com>, joe.jin@oracle.com,
        David Ahern <dsahern@gmail.com>
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

On Mon, Feb 7, 2022 at 7:55 PM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>
> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
> the interface to forward the skb from TAP to vhost-net/virtio-net.
>
> However, there are many "goto drop" in the TAP driver. Therefore, the
> kfree_skb_reason() is involved at each "goto drop" to help userspace
> ftrace/ebpf to track the reason for the loss of packets
>
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
>  include/linux/skbuff.h     |  5 +++++
>  include/trace/events/skb.h |  5 +++++
>  3 files changed, 32 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> index 8e3a28ba6b28..232572289e63 100644
> --- a/drivers/net/tap.c
> +++ b/drivers/net/tap.c
> @@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>         struct tap_dev *tap;
>         struct tap_queue *q;
>         netdev_features_t features = TAP_FEATURES;
> +       int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>
>         tap = tap_dev_get_rcu(dev);
>         if (!tap)
> @@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>                 struct sk_buff *segs = __skb_gso_segment(skb, features, false);
>                 struct sk_buff *next;
>
> -               if (IS_ERR(segs))
> +               if (IS_ERR(segs)) {
> +                       drop_reason = SKB_DROP_REASON_SKB_GSO_SEGMENT;
>                         goto drop;
> +               }
>
>                 if (!segs) {
> -                       if (ptr_ring_produce(&q->ring, skb))
> +                       if (ptr_ring_produce(&q->ring, skb)) {
> +                               drop_reason = SKB_DROP_REASON_PTR_FULL;

PTR_FULL is strange .... How about FULL_RING, or FULL_QUEUE ?
