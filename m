Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA545EFA4E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiI2QV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiI2QUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:20:35 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0062715D
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:19:47 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-3539c6f39d7so19362757b3.12
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=cZG4VxDd4FzBz/EOsma58nLK/qNyK8iWP/Ncqazkjcw=;
        b=ia066oiLFSG4ooKCn0+TTOISUXJotPk/M95/srhxi0SdL8NN7xhHIKFtRLyHlrm9Lo
         uZY3gmvTBrjkGxQMUqJj4fhop8hYpmzqmQFxAwsuvvR7iNaES//9VjNYrRYuLNnmf+LI
         XcJi5TwxeuHSWkICh7IYBPrGWzP99gXAW1BGZtOTADuV0wFI6YA4aI5XU2E3t6l21MRE
         zy3qMaUGKRJ+rybVBZTtZikfGa5WoHeNt48sTKhqzehvu89Ts9mCNce7cZTB1W77OLIN
         A13pB32QJzEN02VrcxMuUj10iTRUgyj8KN88XdAzgd8nAe+AbujfvW7UKbLLiRlw3888
         lLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cZG4VxDd4FzBz/EOsma58nLK/qNyK8iWP/Ncqazkjcw=;
        b=gsjCuok3WgUiGskvz0owSiTG3anOuT/xyKXJ13ao34GBV2/b1acCAmG9+R8ypVGrSa
         FkNOz1Sr39dwgazcaBnQJiRiU+m29aPwTYMrJejeVdgkaO6G+4QoGtrLsQaN/wFt/Wxn
         694Bdk2U+UloHGV6hWlSmLo4MJR9s5VpR/F61MBbuwbgRPVgYA//QpOZHw+0QGHaiSSb
         hP7qm6fBO7zGlg+4yWZmcD7Ceaw79irrij7QXVRv6ko3HkmC2gxZkl2PQNfhntnD4Xle
         49YvG+THTCaqxuTfMSwV1QRNy6t8nUAM21gGqlOcDKn1Gg5swE0cFEflpLzkVRaywFPj
         lExQ==
X-Gm-Message-State: ACrzQf0t2OwZeTuo4zFMg4gNCVcu7jkyaRnaSN97kSWW4wc2Psc6VQrm
        U+MG7GufrjkhqG4SCKF8R3SbF7xXPN2wmxRSLvkgNg==
X-Google-Smtp-Source: AMsMyM7k11Sfaya3SVmICF2kDIBihBAwUGo68c0f5VKKse+QC+PKe9le7kM/4m4rVpLmvfJ9+Vzew1v/JoSp1yy6fNg=
X-Received: by 2002:a81:6756:0:b0:345:525e:38 with SMTP id b83-20020a816756000000b00345525e0038mr4057628ywc.47.1664468386499;
 Thu, 29 Sep 2022 09:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220928221514.27350-1-yepeilin.cs@gmail.com>
In-Reply-To: <20220928221514.27350-1-yepeilin.cs@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 29 Sep 2022 09:19:34 -0700
Message-ID: <CANn89iKJpWK9hWLPhfCYNcVUPucpgTf7s_aYv4uiQ=xocmE5WA@mail.gmail.com>
Subject: Re: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 3:15 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> and ->saved_data_ready() call sites.  For example:
>
> <...>
>   cat-7011    [005] .....    92.018695: sk_data_ready: family=16 protocol=17 func=sock_def_readable
>   cat-7012    [005] .....    93.612922: sk_data_ready: family=16 protocol=16 func=sock_def_readable
>   cat-7013    [005] .....    94.653854: sk_data_ready: family=16 protocol=16 func=sock_def_readable
> <...>
>
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

I will not comment on if/why these tracepoints are useful, only on the
way you did this work.

I would rather split this in two parts.

First patch adding and using a common helper.

static inline void sock_data_ready(struct sock *sk)
{
     sk->sk_data_ready(sk);
}

s/sk->sk_data_ready(sk)/sock_data_ready(sk)/


Second patch adding the tracing point once in the helper ?

Alternatively, why not add the tracepoint directly in the called
functions (we have few of them),
instead of all call points ?
