Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8BE5AB5B6
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiIBPwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237322AbiIBPwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:52:04 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE5E21254
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 08:43:19 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 11so3748564ybu.0
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 08:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=muJcJek/qJin6SE1cDfVZCiOzJRrsAG0GRyTkhFku90=;
        b=dMZrKujoZPQ3uZWpAJdfytQXosFVeKJQV3yxnJq9YF1KnKWaIgDDM7an4Wk92yRYCH
         qxjU6Ah3m6yKtfX+NY8WKqj501LGdxTBUTMVhINfxjxLRkMid+EC/Z835bL4gp8NDx8s
         gxQJJDdkv21Bu1/kvOsSxlCWHGt8+bSm2WbW7E3+la+l63WcSUotJNyqJbqb1U8aguRu
         Aa43HyjPqwvA7LXIsbQabqLNX+1h6FTGIoQu8p4MQXte8nZxSkZwc6zvpE4bLQaHqRHZ
         0su3aIXcHh/sWcncF3xwBxk3SpXtZ2NVRTpSbgXNcITC2HMxXZ3fCJRKSroWFXsNp58G
         TzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=muJcJek/qJin6SE1cDfVZCiOzJRrsAG0GRyTkhFku90=;
        b=G+E3DkScuKjhxI60oPmuHWg7mfqhnCK5qC5QvfMamFeazYHai1mE/qX7jRK+SX9uCG
         uaac3SWp9xy+H1FeO0sANlHlVZ8z/Y04zKV842o6EFcfY5awwkk+DxKxJTdEXq3vrHq/
         XTR8dAzHA6gZ2sRcm8OoyKUAhBAf9+He2JCuPxguHNbYv6RimFOxCcyIyoi49HdU2isq
         F8uxP/EQKOLMyL64i406h5w8JwvpYL0mPBTHJJ3GTYO7I/qAo6/fmRw7Eofzr9zjpzf2
         47lYkXm0UwWzxiYqbTnY+5jDUHvexmve+/Irj1GHjs2qprC/AQsdkSvxx/XIeZwpNHbf
         +tTw==
X-Gm-Message-State: ACgBeo0lKGsU55aNt1XZ8XWsDKgzTPRKKXrSikxp6r++A/LnromuO66M
        qKUKnX9xIII1xt377XdogOz2OCOglCWAoqedxyB0mA==
X-Google-Smtp-Source: AA6agR5MmXuMTNv1P8Cq6QstY0NKPRJD8m+pPpYYIzBgEq7zfb2wZ7HJXqf9nogxbJWKKf1kci05awDxUB4LkMhuYIE=
X-Received: by 2002:a25:415:0:b0:696:814:7c77 with SMTP id 21-20020a250415000000b0069608147c77mr23564025ybe.36.1662133398148;
 Fri, 02 Sep 2022 08:43:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220902141715.1038615-1-imagedong@tencent.com>
In-Reply-To: <20220902141715.1038615-1-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 2 Sep 2022 08:43:07 -0700
Message-ID: <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Hao Peng <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, robh@kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
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

On Fri, Sep 2, 2022 at 7:18 AM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> As Eric reported, the 'reason' field is not presented when trace the
> kfree_skb event by perf:
>
> $ perf record -e skb:kfree_skb -a sleep 10
> $ perf script
>   ip_defrag 14605 [021]   221.614303:   skb:kfree_skb:
>   skbaddr=0xffff9d2851242700 protocol=34525 location=0xffffffffa39346b1
>   reason:
>
> The cause seems to be passing kernel address directly to TP_printk(),
> which is not right. As the enum 'skb_drop_reason' is not exported to
> user space through TRACE_DEFINE_ENUM(), perf can't get the drop reason
> string from the 'reason' field, which is a number.
>
> Therefore, we introduce the macro DEFINE_DROP_REASON(), which is used
> to define the trace enum by TRACE_DEFINE_ENUM(). With the help of
> DEFINE_DROP_REASON(), now we can remove the auto-generate that we
> introduced in the commit ec43908dd556
> ("net: skb: use auto-generation to convert skb drop reason to string"),
> and define the string array 'drop_reasons'.
>
> Hmmmm...now we come back to the situation that have to maintain drop
> reasons in both enum skb_drop_reason and DEFINE_DROP_REASON. But they
> are both in dropreason.h, which makes it easier.
>
> After this commit, now the format of kfree_skb is like this:
>
> $ cat /tracing/events/skb/kfree_skb/format
> name: kfree_skb
> ID: 1524
> format:
>         field:unsigned short common_type;       offset:0;       size:2; signed:0;
>         field:unsigned char common_flags;       offset:2;       size:1; signed:0;
>         field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
>         field:int common_pid;   offset:4;       size:4; signed:1;
>
>         field:void * skbaddr;   offset:8;       size:8; signed:0;
>         field:void * location;  offset:16;      size:8; signed:0;
>         field:unsigned short protocol;  offset:24;      size:2; signed:0;
>         field:enum skb_drop_reason reason;      offset:28;      size:4; signed:0;
>
> print fmt: "skbaddr=%p protocol=%u location=%p reason: %s", REC->skbaddr, REC->protocol, REC->location, __print_symbolic(REC->reason, { 1, "NOT_SPECIFIED" }, { 2, "NO_SOCKET" } ......
>
> Reported-by: Eric Dumazet <edumazet@google.com>

Note that I also provided the sha1 of the faulty patch.

You should add a corresponding Fixes: tag, to help both humans and bots.

This would also hint that this patch should target net tree, not net-next ?

> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v2:
> - undef FN/FNe after use it (Jakub Kicinski)

I would love some feedback from Steven :)
