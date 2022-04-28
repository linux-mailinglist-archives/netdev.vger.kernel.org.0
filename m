Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324B4513F32
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353304AbiD1XuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353408AbiD1XuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:50:14 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC764BB93
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:46:57 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e12so11727568ybc.11
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 16:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WzsyeoZuR/+AizXPDALf+momgOKq6N7Ur7HVZ09Aw38=;
        b=sZ4FhHYvxGZ3LoihpjjlfS6nCWhp3SPb/TWbMtl8r+ou10JhzQdXhNlfz3yiE9QhEF
         g4RZNpaPuZjtb9byMPZ6n73J/lHq0WKV/24diIi11wDk1pep/ZhPnXLo7t+HEz73xgzV
         2AbVI9lfF4ViD3Df4SezIAIIr6ruiVBo+tZk6ByTYBFmPBidWXMCyymM/gLsM6DwPyNN
         iDvC0Xblh9vmHZV4+T9ax/6m0/xKVVySON+u8iUH7c1TcQMFM8Jq2NsloGzCX7byJM/d
         GoLtDAQeCCN1WlmRDYhBaqDU7B+e+Z1jOij0QSiwbl6tgFnIPw3iEPqeTPaewpZtn7At
         sSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WzsyeoZuR/+AizXPDALf+momgOKq6N7Ur7HVZ09Aw38=;
        b=Fr35heQrQ6C+aiXKnupckQKwbMOJoef2fAxwsiqblTXuSrQkdCFZMWbq0R0tx6l0IK
         e0S/EZD7+JqRAjHnWfjV5D6qMBVlV5IynVj300f20Ni50bmcwoneyXAWyWMVQB83aPhX
         e1JmniihGw3gkb2Q2Ws/F7V//+AbVh6+P9UVyh3235aBMsE8raMq9j1BOP7+P7wrMV1u
         hfFmIZGaaoka7M7Yksy/Q+bFXRnjDTJvpjoq8D54e28k90nw7qL2JVqpRY15v+/lISuO
         9WI9ZOazqqP6JCgkgP94xiVKc/+JT45FGpsGV8oAP1JlWwsc7Ak8v/9pKhjMwnQNVPrg
         8ixA==
X-Gm-Message-State: AOAM531SixemPVccrJisHKA9p189goSbN+S007CSS4TrPEw88jc1ksFC
        Z0k1f+cbZ4tE93WvbsdjqIjmHuVTQpCruNX/NSD3cw==
X-Google-Smtp-Source: ABdhPJxHAtN9J3tog3bdeCnrk904zf8PGhQACkHsuo3fvZL12o0iNia/piaaKmPTW8TEeBYR2S8FJNc1fpiDuWbPj4M=
X-Received: by 2002:a25:ea48:0:b0:644:e2e5:309 with SMTP id
 o8-20020a25ea48000000b00644e2e50309mr33472225ybe.407.1651189616598; Thu, 28
 Apr 2022 16:46:56 -0700 (PDT)
MIME-Version: 1.0
References: <2975a359-2422-71dc-db6b-9e4f369cae77@kernel.dk>
 <CANn89i+RPsrGb1Xgs5GnpAwxgdjnZEASPW0BimTD7GxnFU2sVw@mail.gmail.com> <CADVnQymVud=+D7WCZXJCQvhWnzXYhGSxePvEH+SCuuDDK6VoWg@mail.gmail.com>
In-Reply-To: <CADVnQymVud=+D7WCZXJCQvhWnzXYhGSxePvEH+SCuuDDK6VoWg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Apr 2022 16:46:45 -0700
Message-ID: <CANn89iK=HgD65J7ReBPQd4LLLkOD_B-e9TrrDmStAL1WpdYhmg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: pass back data left in socket after receive
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
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

On Thu, Apr 28, 2022 at 4:41 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Apr 28, 2022 at 7:23 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Thu, Apr 28, 2022 at 4:13 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >
> > > This is currently done for CMSG_INQ, add an ability to do so via struct
> > > msghdr as well and have CMSG_INQ use that too. If the caller sets
> > > msghdr->msg_get_inq, then we'll pass back the hint in msghdr->msg_inq.
> > >
> > > Rearrange struct msghdr a bit so we can add this member while shrinking
> > > it at the same time. On a 64-bit build, it was 96 bytes before this
> > > change and 88 bytes afterwards.
> > >
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > ---
> >
> >
> > SGTM, thanks.
> >
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
>
> The patch seems to add an extra branch or two to the recvmsg() fast
> path even for the common application use case that does not use any of
> these INQ features.
>
> To avoid imposing one of these new extra branches for the common case
> where the INQ features are not used, what do folks think about
> structuring it something like the following:
>
>                if (msg->msg_get_inq) {
>                        msg->msg_inq = tcp_inq_hint(sk);
>                        if (cmsg_flags & TCP_CMSG_INQ)
>                                put_cmsg(msg, SOL_TCP, TCP_CM_INQ,
>                                         sizeof(msg->msg_inq),
>                                         &msg->msg_inq);
>                 }

Sure thing.

Note that the prior test would not take this path anyway (unless
someone requests TS)

if ((cmsg_flags || msg->msg_get_inq) ....
