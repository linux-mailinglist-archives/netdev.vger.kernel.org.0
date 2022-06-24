Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF5E5599A8
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 14:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiFXM3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 08:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiFXM3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 08:29:43 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB1D4B431
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 05:29:42 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id o79so4269392ybc.4
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 05:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2nQO6CeYq5fKHfv30czV2m4ZtSM4QjltO0wwv/dnqkA=;
        b=pj0s49K9iGzTNZ9BU6izO5Hh1ZIt1MaYN4ZXoSYBHkReYDj2fwnN13fi9Zd5giPvJ0
         /xcBXDwwmd4TSi/KCN/QhCRqkUZdkzJHxjssFmBCVQFIuNwA9l5IJd81Uc9l3QoR7LUD
         uWYCrDkdwZqKugVguoxl8F4MMqMVi5fda4NtYPorHFU2nPDyC4XyhnHLSJi8kZ12rUkg
         9rDsg4ONoPe+xVVd+Vp5XSMqh4DIQSAIsMVuIhoI78un5BOZN8Lz9FHFp3LjfsIozg3q
         Hq2eBOoOzCChEAy7W+ryEl9mdw0MKsU2NUYQ2MzjtairrsmKCibNAbAHB+DYBFo38QcJ
         +WVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2nQO6CeYq5fKHfv30czV2m4ZtSM4QjltO0wwv/dnqkA=;
        b=7OsXXNF8uhQ80dQzOjX9DwpALbI6lb39+9ExKuP7U3MboTYmvbXdqiezl4I0NIL+VP
         E8PApszP0GtZR/fVUHVh61ub6wvOtFDDAHTNI6uJVa0N2zD9U9TYH+CivsT38YCFOces
         xjUDlDBLbp6zlio067Yl4VhhgxGQhxdRrDsWW9E1zOvufp9oZGuixhYK6jt4v4lactCG
         Oft6VFX2ngO4/If/pLTm8AbBYpAs+1EvsWgrs+UwEcbYVwH0/P/8zqb/bBU2noMeDzSG
         eGXFWGmUuCDTm0VU93X+6o798iQ8YVkiuoOBgyPnnNrlxj4QsCTmnnuy/w0azb7YwpZ8
         7VXA==
X-Gm-Message-State: AJIora/29VmEq2uuNnW0ZiipDvpIEmFhmSfq7f+VCalaWzWEd1HGn6mE
        AFqQsw5g4wNiwWDG9vclisEAokq5xVKj8CPjz0BiXQ==
X-Google-Smtp-Source: AGRyM1tOZFaEaVQKL3O/4ZeAuY/ouoz02/V9pgqlyavmMkV2SFrmfg7c4zcy3rKoZgIu5wbx1OO2C2/hWFbq6g94oKM=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr15283526ybh.36.1656073781827; Fri, 24
 Jun 2022 05:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220624041217.1805512-1-niejianglei2021@163.com>
In-Reply-To: <20220624041217.1805512-1-niejianglei2021@163.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Jun 2022 14:29:30 +0200
Message-ID: <CANn89i+=8odkFV=b_krwKq2+u5S9q7KSvQ6jDCHX7gG8+LdnSw@mail.gmail.com>
Subject: Re: [PATCH] bnx2x: fix memory leak in bnx2x_tpa_stop()
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     Ariel Elior <aelior@marvell.com>, skalluru@marvell.com,
        manishc@marvell.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
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

On Fri, Jun 24, 2022 at 6:12 AM Jianglei Nie <niejianglei2021@163.com> wrote:
>
> bnx2x_tpa_stop() allocates a memory chunk from new_data with
> bnx2x_frag_alloc(). The new_data should be freed when some errors occur.
> But when "pad + len > fp->rx_buf_size" is true, bnx2x_tpa_stop() returns
> without releasing the new_data, which leads to a memory leak.
>
> We should free the new_data with bnx2x_frag_free() when "pad + len >
> fp->rx_buf_size" is true.
>
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> index 5729a5ab059d..4cbd3ba5acb9 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
> @@ -789,6 +789,7 @@ static void bnx2x_tpa_stop(struct bnx2x *bp, struct bnx2x_fastpath *fp,
>                         BNX2X_ERR("skb_put is about to fail...  pad %d  len %d  rx_buf_size %d\n",
>                                   pad, len, fp->rx_buf_size);
>                         bnx2x_panic();
> +                       bnx2x_frag_free(fp, new_data);

This will crash the host if new_data == NULL

Really, given that BNX2X_STOP_ON_ERROR is not defined, I am not sure
we really care about this ?

>                         return;
>                 }
>  #endif
> --
> 2.25.1
>
