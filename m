Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF896159EE
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 04:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiKBDVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 23:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKBDVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 23:21:15 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63C024F39
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 20:21:14 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3321c2a8d4cso154686387b3.5
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 20:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vCsXjpdMMRoGUvKIUTXljWl9GImVRLSfCa0f71QeyFQ=;
        b=Z4HTuPcapdLhdDwvltEk1FvrDKWgMPA2qKGW5E81DhiGQNe98meShl8re9yyiS0aON
         dWE5eAtxBefP7RL8ZTHezKr+zLAiRjk1+6h05VqEoRn0Tf552PqdPoFK/ptBePWQ4xKi
         A+OLIIeKX7ANdWcscAtZIbPjYknTUaeAI6LLxlmi6tEUYG9etn63vkvSSi32Dxt0X1dT
         zJ/h0+KFPaU9vDasg/xeV+ldHZxF6kpal0x6l1glOElmMtrMoQhtauwe6Pg3t4/9L/x+
         PQIpBHv1j2RiZImR1cBC1hoEu9qBKVIUdn/5UtpL/zB1t5YVvL++IxcSIXhagwtkV7aG
         L5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vCsXjpdMMRoGUvKIUTXljWl9GImVRLSfCa0f71QeyFQ=;
        b=5SFqzie0Idfm0xu0DKZl7D6czB1eRezGv+hc5MVMC40+TjQ/IxsmdOYmDWb8/h3gyq
         DfpEv5FDo7u0Q2dsg3oQNPjrAaJ1p6EJxwVlc9QIwlmTa/q087VKOd/ClJKx40PK38Rn
         amH4aYmh46VW1IihS6S6DmxsQbpEzVW8PqlCoRuFmI42cJpkzW9uv2QEcuIcZRnlvyBL
         mUu5Bk8DqNVmnoLjSesZbL49Z+mlSKjH32Q3mA/abM2X9wHqWQwdvRoaOsbVAjLF92/i
         2RmNfs8q/klOW7aVGVrjNtHDpbsH8bmkqWPvoudwoChpX2Kb6vRy5YOMO11x5qLpgSnD
         WH/A==
X-Gm-Message-State: ACrzQf2xgNuo2oODjeej45Bqb4N6v5rpzyppncyVIKRy0SGGNBqlQlUN
        J+KGknagwF2gMMc2dfLzXTRpPnnQbWpk2ISbS4TDHcEsu/c=
X-Google-Smtp-Source: AMsMyM4l3/dv81+ikK9NpmJjI6/tOQ/jLyTCuRfYFJcaGNbAY6ufrwWcBZtjOZxAM8EmNmx04xshe9ERyCvkDvdXImk=
X-Received: by 2002:a81:ad09:0:b0:370:5b7:bef2 with SMTP id
 l9-20020a81ad09000000b0037005b7bef2mr21553658ywh.47.1667359273707; Tue, 01
 Nov 2022 20:21:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221102020610.351330-1-shaozhengchao@huawei.com>
In-Reply-To: <20221102020610.351330-1-shaozhengchao@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 1 Nov 2022 20:21:02 -0700
Message-ID: <CANn89iL3b2JjhsGXtP+nH7aYLOEQLVjZoh3NkxOrQxetMw0tdA@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix WARNING in ip6_route_net_exit_late()
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, dlezcano@fr.ibm.com, benjamin.thery@bull.net,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Tue, Nov 1, 2022 at 6:59 PM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> During the initialization of ip6_route_net_init_late(), if file
> ipv6_route or rt6_stats fails to be created, the initialization is
> successful by default. Therefore, the ipv6_route or rt6_stats file
> doesn't be found during the remove in ip6_route_net_exit_late(). It
> will cause WRNING.

>
> Fixes: cdb1876192db ("[NETNS][IPV6] route6 - create route6 proc files for the namespace")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/ipv6/route.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
