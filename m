Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E6A5865C8
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 09:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiHAHj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 03:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiHAHj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 03:39:56 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CC83A4B9
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 00:39:55 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-322b5199358so98197867b3.6
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 00:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vHIykyLvd6f/vI4jbUUO3a4zPL7C9Qy030k/HGI3QR8=;
        b=IzvkpUPqGhLR2x64sOpNzhx05QBU04U/kI2Zkzb8P4fcJymeCACqITBeRoJ0wiwAbV
         MvXO+YZF5bTVx+mslP+kCcmFKUZCUZNgtfVmY7LQfkjEo1jYmPuWQnUYpxhsRryOdgG+
         H6BX3VizEwSUDMRbMFs15dBWaO2Rgmtxl2GnkubJL2W/BQw1579weOCIh0OcOYUQ1cW2
         GCW3G86xMHiSQ/dBBFbEalOMhtujTspQtmVDlIE54CeUqfepbXNSx28Cj9ZltCo7V3eg
         Bmnpp8CfcIdzqh5eGscBo/Y/QHON7S2RRjp/v9kXxx3wZY8SkIR8jMDtRVruZPL9pO8o
         bRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vHIykyLvd6f/vI4jbUUO3a4zPL7C9Qy030k/HGI3QR8=;
        b=S1iSHyftAZrQ9l2L6qD1n18uUTFfntnxijDtQwhU5H/QWpUJz87Nr35Ca++zmGq7BU
         WPHUdDYAbeHzFNpU5nclO2RD0o8OaLMZtlwoKdJd+jWIu78AMA9pzZRxxgLe4QSF+DwF
         h1cMz59BTGAVzo76U2lVFoLNRBo6EQnf043IjZk7I8IO6qQTvEhut4/cxJv+uyKhDChe
         MMJe4JCTO0Vo3rcpGQ+6hwzytBnzDUv5G7t2IeSAMGG7f13QtRR4rIF4gfCL3WYeQyxK
         G+JXB2faKzxMtuggyWYK8jU9qc5OQ+1twtEC2nUi5BVzm18Tsb15P7mdsqK5OrEL1bU3
         33MQ==
X-Gm-Message-State: ACgBeo2/CdWEfSTcRrQx6g0A2WhRa836qw2gLpaRN8zyMhFA2FmVyD/K
        +i3nwaAhceSoSPNSkY5QSYun2ITYr4Vk/w96jUG8Pw==
X-Google-Smtp-Source: AA6agR54FQDvDk2cUJiphMuBqarL+YBJ92zgG+C+Os80jl/++zwVizWKT7O8HdZ1s31pWFOuLHIp9k7TXw5aoqoZaMY=
X-Received: by 2002:a81:1204:0:b0:322:7000:4ecb with SMTP id
 4-20020a811204000000b0032270004ecbmr11925883yws.47.1659339594367; Mon, 01 Aug
 2022 00:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <de516124-ffd7-d159-2848-00c65a8573a8@ya.ru> <411a78f9aedc13cfba3ebf7790281f6c7046a172.camel@redhat.com>
 <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
In-Reply-To: <37a0d4e5-0d40-ba8d-dd4e-5056c2c8e84d@ya.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 1 Aug 2022 09:39:43 +0200
Message-ID: <CANn89iJzB6TJ7HLg6Njp494p4gFo5n=4u2D4JT3qE3nNH7autg@mail.gmail.com>
Subject: Re: [PATCH] net: skb content must be visible for lockless skb_peek()
 and its variations
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
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

On Mon, Aug 1, 2022 at 9:00 AM Kirill Tkhai <tkhai@ya.ru> wrote:
>
> On 01.08.2022 09:52, Paolo Abeni wrote:
> > On Sun, 2022-07-31 at 23:39 +0300, Kirill Tkhai wrote:
> >> From: Kirill Tkhai <tkhai@ya.ru>
> >>
> >> Currently, there are no barriers, and skb->xxx update may become invisible on cpu2.
> >> In the below example var2 may point to intial_val0 instead of expected var1:
> >>
> >> [cpu1]                                       [cpu2]
> >> skb->xxx = initial_val0;
> >> ...
> >> skb->xxx = var1;                     skb = READ_ONCE(prev_skb->next);
> >> <no barrier>                         <no barrier>
> >> WRITE_ONCE(prev_skb->next, skb);     var2 = skb->xxx;
> >>
> >> This patch adds barriers and fixes the problem. Note, that __skb_peek() is not patched,
> >> since it's a lowlevel function, and a caller has to understand the things it does (and
> >> also __skb_peek() is used under queue lock in some places).
> >>
> >> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> >> ---
> >> Hi, David, Eric and other developers,
> >>
> >> picking unix sockets code I found this problem,
> >
> > Could you please report exactly how/where the problem maifests (e.g.
> > the involved call paths/time sequence)?
>
> I didn't get why call paths in the patch description are not enough for you. Please, explain
> what you want.
>
> >> and for me it looks like it exists. If there
> >> are arguments that everything is OK and it's expected, please, explain.
> >
> > I don't see why such barriers are needed for the locked peek/tail
> > variants, as the spin_lock pair implies a full memory barrier.
>
> This is for lockless skb_peek() calls and the patch is called in that way :). For locked skb_peek()
> this is not needed. I'm not sure we need separate skb_peek() and skb_peek_lockless(). Do we?

We prefer explicit _lockless variants to document the precise points
they are needed.

A new helper (and its initial usage) will clearly point to the problem
you saw in af_unix.

BTW, smp_mb__after_spinlock() in your patch does not really make sense to me.
Please add in your changelog the precise issue you are seeing.
