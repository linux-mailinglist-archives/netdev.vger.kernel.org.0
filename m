Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90279590DBE
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 10:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbiHLIvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 04:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237685AbiHLIu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 04:50:59 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE66EA50EC;
        Fri, 12 Aug 2022 01:50:58 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id d187so347744iof.4;
        Fri, 12 Aug 2022 01:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=b6/KbIVIDTaUyaV//iHuuYUs3+XV8ludk3GKB+bRhdQ=;
        b=BaUpRQq651RplbQkaUvXUnXrccegTKoLTKdy8SjV1oB0eHdoftLiL3eiuuLt+WUOj1
         PuQP1EG7zrQxAiVmjHdlXDhARX/xITJg/oR9fHZ1O1Tdb2JJpplf5YJywjbYxZadMyHB
         U9tOjN8nrGTS1l8qkcRypr59cjqhSGun7xNXtafyzBNB0/pmeqfDc83MUS9wMr0Icodn
         TkLs4+uactRkBeMxEalimtK2XAsYoRELlryTHa4woUhQXtM3NTNFGBKagW2QdELXemJU
         MI28IoUB1vECMVszkey6rpmejHLA6MVEuayeXNXqRwmlkJWAgGAcqIbZYrh0JHSqpC8C
         9pBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=b6/KbIVIDTaUyaV//iHuuYUs3+XV8ludk3GKB+bRhdQ=;
        b=s/HmXrniNj8dAuAqfqhfQz3CdwOBpVVCcF/BqegDrdeGHD7Co9AffPsne1irhztLkN
         +6yyf55KOIVlD2lsFVdyRaUgoZTdNqc/GSCghGCzbxK5cWaPgMZrN1wwjjAWS0Zcmr8P
         LSdBIQTEgfc4N2h27pnTEPhxPxODU6oxsbS1ygh44qgD6KtztZGl72RvuQgd3L0qcJIt
         zQawJYFpQadqRlkQI0heAxmmnFSZHt4V+tkpoko0ucOHcp3HXRJKOHd24wG9yyUz23+A
         hIvIN3X9tzmes1RPhwLa7dO+C3cRfg5goe/GRvWDiqG+uPId/HrnfQsxc0mxWwVp2IMZ
         3qVw==
X-Gm-Message-State: ACgBeo1W6JG+KbT+x00ALbZn+tAv2r51FRZQN2ufYeUx04ULREkdN4ay
        qe9PhWCqfaCHqpUH7AC92RNM7OSCl9sYfNgh0Sc=
X-Google-Smtp-Source: AA6agR7g9fP251B4QtpYGgSc200C3FCiNg41oVwZHr15DGY3rfR1fXJQMV/wf+IuAfOF13mbK/S6VN+f6nZl5iBaM68=
X-Received: by 2002:a05:6602:224a:b0:681:2125:a85b with SMTP id
 o10-20020a056602224a00b006812125a85bmr1250018ioo.44.1660294258364; Fri, 12
 Aug 2022 01:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220812025015.316609-1-imagedong@tencent.com>
In-Reply-To: <20220812025015.316609-1-imagedong@tencent.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri, 12 Aug 2022 10:50:47 +0200
Message-ID: <CANiq72kgF-UAzvUVTgg9mh9RZ6sYwVxGpERzvCkueh1z2PeqTg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 4:50 AM <menglong8.dong@gmail.com> wrote:
>
>  #define __noreturn                      __attribute__((__noreturn__))
>
> +#define __nofnsplit                     __attribute__((__optimize__("O1")))

This is still in the wrong place...

Also, from what the bot says, Clang does not support it. I took a
look, and that seems to be the case. ICC doesn't, either. Thus you
would need to guard it and also add the docs as needed, like the other
attributes.

(Not saying that solving the issue with the attribute is a good idea,
but if you really wanted to add one, it should be done properly)

Cheers,
Miguel
