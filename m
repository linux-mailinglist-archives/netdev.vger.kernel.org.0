Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0785721F6
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 19:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiGLRvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 13:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiGLRvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 13:51:15 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C8E65572
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:51:14 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p129so15224927yba.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 10:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QLUHgf9KzIXPcraiR+k4Ty9Z4CvldZU8E9NjGC2ZZTY=;
        b=nsICCbfpnWGhGFvVpnkxIbVSZvvnkpRTUotAtVYWKI1sSx26VkmDjJ0VeemPB53WHv
         /rqEx7rgmwKXMBeDnZpUBd/+kIgfeosDexz1bvNlu+bRny/oOW00SLtVYNiI4xOT6j3P
         tAiVKWQXMKUZZD/wRR+8oLDbLBK20jrJr4AyfeISKrYkWHQYhnciuNQ+Q0pHsQarTe2/
         VFePISPeEBvj6A7G/7PxNP5tQLixafDT+oN9CdFHg6jtlX3A7nfLbb9aKp6eX6jUBmT9
         mDNI6ewc2NAJHJLFhDdx6EORSHeg2GDR7dg3oBoQID2pZoX/SeAfJPqx4byo/RbVUdNu
         qung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QLUHgf9KzIXPcraiR+k4Ty9Z4CvldZU8E9NjGC2ZZTY=;
        b=wrlPgy0CaWP7e3kwh3pAdGt3hfvkmQq7YHRw0mY2QwcsCwNquLY+KHvLHaPWVdh2oO
         tAB+gRHXYmFibnfIGWoaW1FD1mdeqAlnThMYCkhwHY3DivjCORvk7w6W4MvIdI84oXSK
         oc+JEg/7+SZqDOkqoYT9u/f+60R6/4t9vtDAgaO+Ripk6EP4fuAp2ATwnjgs0SxQ7GWX
         FpBYHzEUq8Zm5zeJEKNuna7RrR+EaUEf4uCZpCpNZhiYBNX33gnxv3WlvN9bmOIViYAz
         /QcTgn05fNHwMCytMiFMdO1jMk2wht5si8dmqLu5H0EHMEIkboaaw6C+iaHrYoKwupWp
         sqZw==
X-Gm-Message-State: AJIora+Lm+6T1PmXq7pO9M1p1HNADgDl977aW4cJrjMqgAGV5XwzDbtS
        yBqJeWShMChjdVKGLpweIwjoSCPNvXkG4Re9Lbb1Gg==
X-Google-Smtp-Source: AGRyM1t/BHz337RCx/pIaSjHEFt3ifvraH1+dnVJ73jZUWVGRTbfCIsnbzGKQDv7HwwSB8sTLCq+Yz5B+kFFfgQgXCQ=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr24250180ybh.36.1657648273501; Tue, 12
 Jul 2022 10:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220712173801.39550-1-kuniyu@amazon.com>
In-Reply-To: <20220712173801.39550-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 Jul 2022 19:51:02 +0200
Message-ID: <CANn89i+c5yGoVV5t34diRrita=D1X_Aj-+fXJ2pw7jusnKGL3w@mail.gmail.com>
Subject: Re: [PATCH v2 net] tcp/udp: Make early_demux back namespacified.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
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

On Tue, Jul 12, 2022 at 7:38 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> it possible to enable/disable early_demux on a per-netns basis.  Then, we
> introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> tcp and udp").  However, the .proc_handler() was wrong and actually
> disabled us from changing the behaviour in each netns.
>

>  static int proc_tfo_blackhole_detect_timeout(struct ctl_table *table,
>                                              int write, void *buffer,
>                                              size_t *lenp, loff_t *ppos)
> @@ -695,14 +640,18 @@ static struct ctl_table ipv4_net_table[] = {
>                 .data           = &init_net.ipv4.sysctl_udp_early_demux,
>                 .maxlen         = sizeof(u8),
>                 .mode           = 0644,
> -               .proc_handler   = proc_udp_early_demux
> +               .proc_handler   = proc_dou8vec_minmax,
> +               .extra1         = SYSCTL_ZERO,
> +               .extra2         = SYSCTL_ONE,

This does not belong to this patch.

It is IMO too late, some users might use:

echo 2 >/proc/sys/net/ipv4/udp_early_demux


>         },
>         {
>                 .procname       = "tcp_early_demux",
>                 .data           = &init_net.ipv4.sysctl_tcp_early_demux,
>                 .maxlen         = sizeof(u8),
>                 .mode           = 0644,
> -               .proc_handler   = proc_tcp_early_demux
> +               .proc_handler   = proc_dou8vec_minmax,
> +               .extra1         = SYSCTL_ZERO,
> +               .extra2         = SYSCTL_ONE,

Same here.

Again, fix the bug, and only the bug. Do not hide 'fixes' in an innocent patch.

There is a reason for that, we want each commit to have a clear description,
and we want to be able to revert a patch without having to think about
what needs
to be re-written.
