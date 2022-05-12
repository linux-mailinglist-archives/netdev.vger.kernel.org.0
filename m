Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B234652570E
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 23:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358729AbiELVcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 17:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358743AbiELVcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 17:32:02 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B120F74A
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:32:01 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i38so12066146ybj.13
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 14:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qP8x7MUO3Uu37I6lovdAXd3voCCKfRiLq82HFRhMPMs=;
        b=Kplc09E4S/2dbuxcXjM62BKCcgoUDUa3W6vtuOLIK+pmB60FnSLrqgZFHHcXsrROHz
         0ftSTKDMuLcwioiSk/jyrRtd3aYiH0CFysLg06dQS1x6v7XwC1QVBUmuYS4m/cCt2QGm
         Z99AeZbhMuOeU3i4+v3+ETnSyv8MdvnZWxck8Ig1RAl7SSfsFoOScsMPeaZm9pTUoW0M
         A0Qigywdfgl0/AlJEEPTKEUYjCWn8rjocrJo45QUFBdV0Vc6zxIbJiK4DMtVNxvEU0Xx
         m1TP3ZzWFpl9tlk5z3USjv8ThN7ozhK8XhpqTHZJqgPPtBHS6F7geiDW6SoUkNj+ooB4
         KL1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qP8x7MUO3Uu37I6lovdAXd3voCCKfRiLq82HFRhMPMs=;
        b=b1pGaYnRUEjUEWaywIcnmywn6G1oqndcZt1xOn559EupWRVT6jdHF6uGX7ABHXma48
         LkjLPpM88AG8gQHYuYMPvRulYpJkP9Jk14Pli4iuvPtcyK0otrUgK9roTpVOqw7W1/wD
         jHGgv1SzuHtgsQtkKs5DqgfZBKEfxGcFQEZGbERE8n6GCfZN0FwCtF5YlOKSFj0Rc/9I
         p29E+D2E9iY5YF2YT9/iCAnVTKpNV5q3ZG8B3zgq3c2P2K+D57idttuPnBYZDH75AHuo
         C6hSnGrztJTCjh+OWlZS6m8/P8J9O8VFpe6PLTUDSUVY3bIG9v7PFiB75Mn0ZZG4KZXO
         1N/w==
X-Gm-Message-State: AOAM532oa0I7DVrxsyRsWPH2gTomkNSN0BpCEMfNNUYnxNuXSVt1Jksy
        d3AzewuF1AFZFqDgY4lUV5atEVrjR9y/5FpyvNbjWg==
X-Google-Smtp-Source: ABdhPJwC7glJ4rfuuAy9qZ2O1j2dwGqNFULn699DHOnGq4mz/2+NODz6siqEBR/m4hd8zL0aFMd//xboRFIMLbXNSCs=
X-Received: by 2002:a05:6902:1007:b0:649:7745:d393 with SMTP id
 w7-20020a056902100700b006497745d393mr1846772ybt.407.1652391119968; Thu, 12
 May 2022 14:31:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220512103322.380405-1-liujian56@huawei.com> <CANn89iJ7Lo7NNi4TrpKsaxzFrcVXdgbyopqTRQEveSzsDL7CFA@mail.gmail.com>
 <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
In-Reply-To: <CANpmjNPRB-4f3tUZjycpFVsDBAK_GEW-vxDbTZti+gtJaEx2iw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 12 May 2022 14:31:48 -0700
Message-ID: <CANn89iKJ+9=ug79V_bd8LSsLaSu0VLtzZdDLC87rcvQ6UYieHQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
To:     Marco Elver <elver@google.com>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Liu Jian <liujian56@huawei.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 2:18 PM Marco Elver <elver@google.com> wrote:

>
> I guess the question is, is it the norm that per_cpu() retrieves data
> that can legally be modified concurrently, or not. If not, and in most
> cases it's a bug, the annotations should be here.
>
> Paul, was there any guidance/documentation on this, but I fail to find
> it right now? (access-marking.txt doesn't say much about per-CPU
> data.)

Normally, whenever we add a READ_ONCE(), we are supposed to add a comment.

We could make an exception for per_cpu_once(), because the comment
would be centralized
at per_cpu_once() definition.

We will be stuck with READ_ONCE() in places we are using
per_cpu_ptr(), for example
in dev_fetch_sw_netstats()

diff --git a/net/core/dev.c b/net/core/dev.c
index 1461c2d9dec8099a9a2d43a704b4c6cb0375f480..b66470291d7b7e6c33161093d71e40587f9ed838
100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10381,10 +10381,13 @@ void dev_fetch_sw_netstats(struct
rtnl_link_stats64 *s,
                stats = per_cpu_ptr(netstats, cpu);
                do {
                        start = u64_stats_fetch_begin_irq(&stats->syncp);
-                       tmp.rx_packets = stats->rx_packets;
-                       tmp.rx_bytes   = stats->rx_bytes;
-                       tmp.tx_packets = stats->tx_packets;
-                       tmp.tx_bytes   = stats->tx_bytes;
+                       /* These values can change under us.
+                        * READ_ONCE() pair with too many write sides...
+                        */
+                       tmp.rx_packets = READ_ONCE(stats->rx_packets);
+                       tmp.rx_bytes   = READ_ONCE(stats->rx_bytes);
+                       tmp.tx_packets = READ_ONCE(stats->tx_packets);
+                       tmp.tx_bytes   = READ_ONCE(stats->tx_bytes);
                } while (u64_stats_fetch_retry_irq(&stats->syncp, start));

                s->rx_packets += tmp.rx_packets;
