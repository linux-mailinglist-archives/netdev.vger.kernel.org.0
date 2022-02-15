Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7F14B7708
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbiBOR1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:27:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbiBOR1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:27:44 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165EA140FD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:27:34 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id j12so36033381ybh.8
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 09:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aLaWiu1JFL8ml5eOPFlgSjkRJzbN2Qiow7Vm2dhjtxQ=;
        b=fELzMEYkNiNP8URDJm/NJ8Shk3PS6AjtEj2+S5K7htmvoEZy1Xl7zMNPIrdk8wH7QB
         zN0V5DNXpI7lk+8MgRyyHPmnZ3zw55gOiXr/kWIW2kr7ttw/pZ3J/4znYZm23y5c30/b
         H9l8vmLh9jrqfNFoSyALXPBN8wM2Nky0My0qZVVsDSqBLLoWZk/Bi/Jn86RlhsUv7CBh
         lfp4nrtPPAfvWR3dQsGklpEUjRW9ZeO0I8J2255xa0lvhJAtv6hDnFDtHBCo3FjU3TmX
         eq9/ufQYtFYxJfOuGlO4hZmwnfeCFZ99wN+qavbBQQPiSjJjaNVVhZGlMxxBAyVNL5FN
         ELPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aLaWiu1JFL8ml5eOPFlgSjkRJzbN2Qiow7Vm2dhjtxQ=;
        b=ny1vqGiQHFU0s8TvCazgpKlrLu7ApmbfG5UjezvmLDDUVxAEy5VIZz7zTODMgAAi6l
         gdQsijBmYon/BEUY7twcEbHs5T6cZrqmTRcNOV77GHewY/FPlgetwj8wkoIfx93K1aa3
         c5auVvJFcCU4jCTGw1tBw9gqijp13M86iBjqCsNGyRu/n5Cyr55Z8v+hpz5hRcGHOtZT
         UPOdK3Mt9RdcnWB+OCiypgxepQAvXm+hl437R+5D4NePLJ3FJ3qISqOKVnDOMShNiyuz
         5Fwo3wYORHQA0uIB/iRcMmEoOWoSl8bSssMDpPklzDYbh6DQ9eVdoUJfg+eGnWd8919c
         VAKA==
X-Gm-Message-State: AOAM531XWJi2taNpFLr2YbzlP1HRJnh+RbXKaItIMgxUlWgLPasZuY9m
        E0XKdQ8Jr2GKnktnud7HN/tLO/sjOOkUej+o9Jh7IHFPp0ETBrph
X-Google-Smtp-Source: ABdhPJz4NOmVzX5UE/6Fjrn97iLKTV+R0r9Gt9E27K8jPEZZXRv3N8g0OSWYzAWurnf8jLN+cPHLMp8zBVz7DOgBAmQ=
X-Received: by 2002:a81:a841:: with SMTP id f62mr4816962ywh.255.1644946052978;
 Tue, 15 Feb 2022 09:27:32 -0800 (PST)
MIME-Version: 1.0
References: <20220214203434.838623-1-eric.dumazet@gmail.com>
 <YgsE30gfoQkruTYS@pop-os.localdomain> <CANn89i+2KYH+DKrNPttbmrvx992P+ufgo=QWyvr1Ku6b=1BY0Q@mail.gmail.com>
In-Reply-To: <CANn89i+2KYH+DKrNPttbmrvx992P+ufgo=QWyvr1Ku6b=1BY0Q@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 09:27:21 -0800
Message-ID: <CANn89iJDWUE5mTSuWQaHO0SfyXLTso5Cp=rYzRGwWoZC_gHmmg@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: limit TC_ACT_REPEAT loops
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        syzbot <syzkaller@googlegroups.com>
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

On Mon, Feb 14, 2022 at 5:54 PM Eric Dumazet <edumazet@google.com> wrote:
>
> > > +             repeat_ttl = 10;
> >
> > Not sure if there is any use case of repeat action with 10+ repeats...
> > Use a sufficiently larger one to be 100% safe?
>
> I have no idea of what the practical limit would be ?
>
> 100, 1000, time limit ?

Jamal, you already gave your Ack, but Cong is concerned about the 10 limit.

What should I used for v2 ?

Honestly I fail to see a valid reason for TC_ACT_REPEAT more than few times,
but I have no idea of what real world actions using REPEAT look like.

Thanks.
