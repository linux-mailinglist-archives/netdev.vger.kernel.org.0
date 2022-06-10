Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1FF546096
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 10:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344115AbiFJI4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 04:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237516AbiFJI4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 04:56:41 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A03271A8D
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:56:38 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id k2so6552478ybj.3
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 01:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XH02qxttNt5dNPWDoERvNepSgpr1P+EkVPWfaAbgETY=;
        b=tUWPVWhq26Egy5stSWqG3nEuB6M2CjvgLS+AKR9dzCYugVMqezBhPBxFLanSli7hDQ
         OBDQZKOAkEby39w28pgo3gEKoFaEXzTSSYTfRJwcX7X5VNm2C0tL7oEyDq0uYv2m8zFd
         4lJo/wQHp0u5uthqP5rAcYh6HcIZ2j2ng4yqM2mQ+tSNaCy3JZmIbQ/mp4sBh/qTgJxm
         MKiD7nrswDfsUllIyFu7rQ3ZCgUWduTFSLyfB0q6FU1fLWo58Tw86uWCeR6SuY3yMF2q
         YTc+1gvKyUybI9brhua6UnGYNzicYj/VVBrgG0EkmzxunuLqnsqf/vKo3lhs0afxWRAP
         7FwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XH02qxttNt5dNPWDoERvNepSgpr1P+EkVPWfaAbgETY=;
        b=yVFf4WliVTgl/Rv/M0c0ix5WQL3zNRBGfExNUkHCGky568a3pjc2HrMCn9ieHH86CI
         CwIPY8Xry8yIZ6C6rLQS6Lph9uggw2b4w6Hsol+L0jARiVZYQ5JHFkdaBQQlMH850Pn3
         9k/NcK3gqNO3uwkkbsFt5UtRz0npJB+bZohej5GiU57K6+ArUaiXYtVTGfyKv3m4ogcI
         AzVKE3QBXu9GJcbToKd5TKajVfDUSuKvdoLYmMaCHsG7yBjQzisyVRkWq5pfOHFV6Q7M
         ExaTP6LI1IzmfUs9ZpAq3Xk1a13b+ZSSULm1pgNlC5IjoXXZepvJlR7mMEu2L/p7l3x+
         eW7g==
X-Gm-Message-State: AOAM533k/EYRWxc+zcM0tbq9e6UZnsClnmgHwwFmxYYVdsrb9gunQCJN
        /N/Kb0Z+PKTmexE6TaxixAJZQ6y7VIEyz0l64iWTrg==
X-Google-Smtp-Source: ABdhPJy8G7dOXekHHRngvCtxNNuKXgXcLUmdDaUiLmGJoOQQfZfP8sloC2J6L/K2DIkJFw4PqxjoLhrYRMIvmUPSSg0=
X-Received: by 2002:a25:aa32:0:b0:65c:af6a:3502 with SMTP id
 s47-20020a25aa32000000b0065caf6a3502mr43818525ybi.598.1654851397036; Fri, 10
 Jun 2022 01:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220610034204.67901-1-imagedong@tencent.com> <20220610034204.67901-6-imagedong@tencent.com>
In-Reply-To: <20220610034204.67901-6-imagedong@tencent.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jun 2022 01:56:25 -0700
Message-ID: <CANn89i+NV1DgxaQbqPu2o0Du-94gDkM8DUrX_DK7=AGqvvPKdg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/9] net: tcp: make tcp_rcv_state_process()
 return drop reason
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
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

On Thu, Jun 9, 2022 at 8:45 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> For now, the return value of tcp_rcv_state_process() is treated as bool.
> Therefore, we can make it return the reasons of the skb drops.
>
> Meanwhile, the return value of tcp_child_process() comes from
> tcp_rcv_state_process(), make it drop reasons by the way.
>
> The new drop reason SKB_DROP_REASON_TCP_LINGER is added for skb dropping
> out of TCP linger.
>
> Reviewed-by: Jiang Biao <benbjiang@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> v3:
> - instead SKB_DROP_REASON_TCP_ABORTONDATA with SKB_DROP_REASON_TCP_LINGER
> ---
>  include/net/dropreason.h |  6 ++++++
>  include/net/tcp.h        |  8 +++++---
>  net/ipv4/tcp_input.c     | 36 ++++++++++++++++++++----------------
>  net/ipv4/tcp_ipv4.c      | 20 +++++++++++++-------
>  net/ipv4/tcp_minisocks.c | 11 ++++++-----
>  net/ipv6/tcp_ipv6.c      | 19 ++++++++++++-------
>  6 files changed, 62 insertions(+), 38 deletions(-)
>

I am sorry, this patch is too invasive, and will make future bug fix
backports a real nightmare.
