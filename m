Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B900B511E10
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243812AbiD0RPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243861AbiD0RPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:15:19 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8759427EA
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:12:07 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2ec42eae76bso26199677b3.10
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4feES2Sddw46dbD+QpCGRHLo+aj6Fyq3FZG8hoLSTM=;
        b=NP3m3zLaa10Ysl5ta/mneNTmTPwWtlrfJfjWvJgootw5QtZfn3Jntl9VdVCjtNdpVk
         oshbvYJF44v7YiDRhegzyJQ5g3wVtnQZuxUqdYI5gAw1QT/02PNFXI2V8dgeEJG5GpFx
         Shv4VjwwNNJgwyNw60frdWVX9kGJ0AACQpP4UeJb/c7YRjCdPmxETlHzTCCzTz9M0bSp
         pjlHJ8vEkG0y4yH7LaXV7JgOYIx4Ao2eZAKENJzrfSn99rJk5Su4U+qhgZIPYexQQ9Z5
         nf17IOIWb0S+TV07coOqlxLPbfYr0OGx7jPDfSnBtvT3coYp6IC9jBoaD5/W4yNpVZAF
         +vMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4feES2Sddw46dbD+QpCGRHLo+aj6Fyq3FZG8hoLSTM=;
        b=OKRoOSsnIubLtreeQca3VK6MXNRALGqBXZDKrVhWAcysEjucvLwMzvrIWEwlTAQbRb
         RtjaOwhtlNHkfd05v9NVg63QHbP9pFXs0JuDLewiRqegFnU3vu6aAL+5PRwq0cbhh9ga
         7wUIRqtYc5oBIEsuJswy+UksopNx7f0Tp9BITM8hxlBqG5L3XoGXmBJBCiXSyfbukbFb
         keXV16tvres8ZHlfOfv0ynKH/FX5HB17uFJjUKPqWn/7ztK6/b5Bb/QkHjyumx/1cwzs
         GfrV9HIr/5toVfMi/5QtErvHdbKG5teUeth40OQesPldH5GUXx5Ki08Phs5C4NE5cyeI
         H1JA==
X-Gm-Message-State: AOAM5318EIkvLqoOOcEASL8XEbh0yI4vkXaNPqnhQ+0I04bKv9bvnuXu
        IILNMDgqLLMvvSBXzEsJ0DLMFwcFEBkhiVaQN41rlQ==
X-Google-Smtp-Source: ABdhPJwXbWEEixa2UaEumNv9YWZcVG/KMFL2eL99akOuW2Mi5dvzGFeAZob83jmP3h7TI5xpDk81Td1U62ba2UUbwLQ=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr7149956ywb.255.1651079526900; Wed, 27
 Apr 2022 10:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
 <YmlilMi5MmApVqTX@shredder> <CANn89i+x44iM97YmGa6phMMUx6L5a3Cn86aNwq3OsbQf3iVgWA@mail.gmail.com>
In-Reply-To: <CANn89i+x44iM97YmGa6phMMUx6L5a3Cn86aNwq3OsbQf3iVgWA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 27 Apr 2022 10:11:55 -0700
Message-ID: <CANn89iLue8fy-6TTEsTwzWAog-KnAcsG19up34621W8Bp+0=NQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
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

On Wed, Apr 27, 2022 at 9:53 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Wed, Apr 27, 2022 at 8:34 AM Ido Schimmel <idosch@idosch.org> wrote:
> >
>
> >
> > Eric, with this patch I'm seeing memory leaks such as these [1][2] after
> > boot. The system is using the igb driver for its management interface
> > [3]. The leaks disappear after reverting the patch.
> >
> > Any ideas?
> >
>
> No idea, skbs allocated to send an ACK can not be stored in receive
> queue, I guess this is a kmemleak false positive.
>
> Stress your host for hours, and check if there are real kmemleaks, as
> in memory being depleted.

AT first when I saw your report I wondered if the following was needed,
but I do not think so. Nothing in __kfree_skb(skb) cares about skb->next.

But you might give it a try, maybe I am wrong.

diff --git a/net/core/dev.c b/net/core/dev.c
index 611bd719706412723561c27753150b27e1dc4e7a..9dc3443649b962586cc059899ac3d71e9c7a3559
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6594,6 +6594,7 @@ static void skb_defer_free_flush(struct softnet_data *sd)

        while (skb != NULL) {
                next = skb->next;
+               skb_mark_not_on_list(skb);
                __kfree_skb(skb);
                skb = next;
        }
