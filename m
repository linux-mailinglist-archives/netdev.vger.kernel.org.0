Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEF05405F6
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347001AbiFGRce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347876AbiFGRbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:31:20 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF9410A63B
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:28:40 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-30fdbe7467cso148272677b3.1
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7rYLYDe80leH68JeXvH0gMR/2Fmm2d87F6uzTt2pDIM=;
        b=HYlFKKTCVa93BZYhT6TxJ+x/USTpqJ/7Br94kTb9fWRan1dSpVoztuo1fRWt1T2KCH
         1nU2eNJzrBr2D5nnRP28LbTPlSCUw9H6nzMwsDGoQALupB1swupdNFxFltBegYWSVQrC
         qlOJ+aUvtGgyT7oz2n+nfdLhkcbWCfI0X7G4ib83LbaRm+figmlx8wymkW1JkBDFSxMJ
         4afp6SCGn/O69V2UEoPnZoh98FXuOhYb658C/8ZWF4HMnO2aOt0YvDW4flgHbW3m2vyR
         Zzyf8lCPIof03dKksgOZadwpduhXQWXQ1gcLQkHofbMIrkFytzc7+/mjhel3KMJdnds3
         ZexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rYLYDe80leH68JeXvH0gMR/2Fmm2d87F6uzTt2pDIM=;
        b=ZIxazkDo/mzHL6MJ1udR2Jzvw7jTFA3wXM8siHRulgE2yt+gXWnM2+hFRLO+dXjToH
         2zkeXYFh4a6x94iYSlZkn0RzCuqN8vgZ1yzdwg1UM8P2Wigo/ZwggBK/9OlK1Yck3jAo
         uysQBDllmi7zbNYygXr2px78L4bb+YFGfDSlxTD3sji4xI/jKQChjSiEKnlO1bRHde6h
         IV7z0mmrDx3+AGZa8NgCGxmZSTF4otvlOehmSTyTbbRbpgCLwzqcXYaOEluXklqotmpl
         1OhAX4H1Ea1EN01dzi2Dah5CMYmsR7d4YBtx7tO00md4x/4paH4ZvsLytz9AyY/zMVnn
         1q0g==
X-Gm-Message-State: AOAM530z59YEjAsau1nvQ7TYYHUUsf1qldHwh7op1dwn9BILR1paDAS2
        rk92oHl35fsJoEYi4n6Xqk8Aj0IjeYLmMFX/K+DqajTiQQzESvtR
X-Google-Smtp-Source: ABdhPJwhe6eTXmsaYuozzlw5/bcPNSakjdg8PilLKL1XuLwlc3FBrHJdRi2+PAGvz5p/+mSNyQPuI/0hQmwPHWTyxiY=
X-Received: by 2002:a81:b401:0:b0:300:2e86:e7e5 with SMTP id
 h1-20020a81b401000000b003002e86e7e5mr31623346ywi.467.1654622919171; Tue, 07
 Jun 2022 10:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220607161627.25035-1-xiaohuizhang@ruc.edu.cn>
In-Reply-To: <20220607161627.25035-1-xiaohuizhang@ruc.edu.cn>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Jun 2022 10:28:27 -0700
Message-ID: <CANn89iLwEFrb7q2ifqRxc2nvi_-YOwQpdFf0X1N5AH_wSSZ48Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] l2tp: fix possible use-after-free
To:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Tom Parkin <tparkin@katalix.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Tue, Jun 7, 2022 at 9:16 AM Xiaohui Zhang <xiaohuizhang@ruc.edu.cn> wrote:
>
> We detected a suspected bug with our code clone detection tool.
>
> Similar to the handling of l2tp_tunnel_get in commit a622b40035d1
> ("l2ip: fix possible use-after-free"), we thought a patch might
> be needed here as well.
>
> Before taking a refcount on a rcu protected structure,
> we need to make sure the refcount is not zero.
>
> Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
> ---
>  net/l2tp/l2tp_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index b759fbd09b65..c5de6d4e0818 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -273,8 +273,8 @@ struct l2tp_session *l2tp_session_get(const struct net *net, u32 session_id)
>
>         rcu_read_lock_bh();
>         hlist_for_each_entry_rcu(session, session_list, global_hlist)
> -               if (session->session_id == session_id) {
> -                       l2tp_session_inc_refcount(session);
> +               if (session->session_id == session_id &&
> +                   refcount_inc_not_zero(&session->ref_count)) {
>                         rcu_read_unlock_bh();
>
>                         return session;
> --
> 2.17.1
>

Please fix all bugs in a single patch.

net/l2tp/l2tp_core.c contains four suspect calls to l2tp_session_inc_refcount()
