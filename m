Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8702D5A5758
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 00:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiH2W7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 18:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2W7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 18:59:17 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9493A86892
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:59:16 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-334dc616f86so232412427b3.8
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 15:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=TpzfH8uFA8X+gJilMZHJck1FdXHlT1YXvSC1/1vNKak=;
        b=Am+UOqsZNc2yS1ZK5qkXXJnM5T8vlzHOPzm4S4xa8Acz38rCXradL5qKxIx8kF29KL
         8TtqZJdjfzgHpJMduxT7nfKXnO3FhMWL/gXAl/nB26bFU9xJrNsCgrmGYpj9Y33o/d/g
         02+MjFWCIqegahYM26M+tvRE7AsoYNUyZALI3/batAa5uD4Z/YQmoaiEJr2i++4XIqbU
         RluJOy4LS+yH4FlpVovEYEI3dh+xsAhaagy0R8KbYZas7lRxTzXf9TU+JlCqV96Mtx49
         OTpABqmKgRRXi1yNTaAL3wErWOYCS8/eYhFMPzzdbYFuL2EHXulMKWxiSbG8rjZn63oC
         gnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=TpzfH8uFA8X+gJilMZHJck1FdXHlT1YXvSC1/1vNKak=;
        b=Vz1qRELFvZBBrOBAzG5Vyjwp5o0/R3HTYCYhkNFt14j/b4mIvZqFHM0aaJbt1vWbSX
         dwSKSpKCpvHtsV1krs2y3jkUtt0hyqG+NZuRwsstGPy/Xot6IgoWtkxpfFPDKseFgox0
         H3uRy/aZ8V4LBg9yebOSQnh0egamxA1F93VGkj51rtazqdzvxOY73vlPBMqm0qSH1naV
         1uEgAheWGmWVQ2HhpLDS+DTErwR0y/R1lks10p6wC0phT7KDP/F3CdvGw5CKVw0TfQTt
         uIjb/PdE0h95hjGJB+YxyQkFOdlQiHsCPmBv59/3WQW6n3CGdDrZcI3vCXxNLxpLFUAg
         OumQ==
X-Gm-Message-State: ACgBeo3VvaZ6HBR23LOllYUwjjr6NvOt+HoHzksCFoWf4Xzeqq98Jx6F
        2/VWC5rbihJBC3FM3gSct0W7qkfnoW7jZ0NTQSw68Q==
X-Google-Smtp-Source: AA6agR7AKQX1x+rDnZU+gBuPplTEeRAswrPKXXHVQDIouMdeqzDB+c4f6JIbGivJAYda5/tyEN4xSx5/LvKCjr7QuuQ=
X-Received: by 2002:a0d:fd06:0:b0:324:e4fe:9e6c with SMTP id
 n6-20020a0dfd06000000b00324e4fe9e6cmr10973781ywf.332.1661813955613; Mon, 29
 Aug 2022 15:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220829161920.99409-1-kuniyu@amazon.com> <20220829161920.99409-6-kuniyu@amazon.com>
In-Reply-To: <20220829161920.99409-6-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 15:59:04 -0700
Message-ID: <CANn89iJ55OHnWh88-pRxMt4d_4cbr5Fa+JOH2VDrT1SWq1t=ZA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 5/5] tcp: Introduce optional per-netns ehash.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
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

On Mon, Aug 29, 2022 at 9:21 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> The more sockets we have in the hash table, the longer we spend looking
> up the socket.  While running a number of small workloads on the same
> host, they penalise each other and cause performance degradation.>

...
> +static int proc_tcp_child_ehash_entries(struct ctl_table *table, int write,
> +                                       void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +       unsigned int tcp_child_ehash_entries;
> +       int ret;
> +
> +       ret = proc_douintvec_minmax(table, write, buffer, lenp, ppos);
> +       if (!write || ret)
> +               return ret;
> +
> +       tcp_child_ehash_entries = READ_ONCE(*(unsigned int *)table->data);
> +       if (tcp_child_ehash_entries)
> +               tcp_child_ehash_entries = roundup_pow_of_two(tcp_child_ehash_entries);

This is not thread safe.

You could simply perform the roundup_pow_of_two() elsewhere,
eg in tcp_set_hashinfo() (and leave the sysctl as set by the user)

> +
> +       WRITE_ONCE(*(unsigned int *)table->data, tcp_child_ehash_entries);
> +
> +       return 0;
> +}
> +
>
