Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E82E05F5
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 07:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgLVGOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 01:14:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgLVGOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 01:14:07 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C56AC0613D6;
        Mon, 21 Dec 2020 22:13:27 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id p12so5541464qvj.13;
        Mon, 21 Dec 2020 22:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7wb5VtdufCwOz31lMm71cppG/BIQULhNFkKIAClQoAk=;
        b=GETCxh4rtSWYDy51oM9tjkbdR4CHz6y5kpRkMZ42XgRc2YpW6yFInGNlq9Eu/DYVrL
         voYvEDZ8+llf6njmfVHFj5P6Ut9y4qecbnU9+NIozICvazkOSK4MqDg3Y12cLZ+cbNq6
         rfVL0w46e5Dkb9vsQ1LU6C6Q+/vw5DTkz2v3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wb5VtdufCwOz31lMm71cppG/BIQULhNFkKIAClQoAk=;
        b=pJJpzCYXjlywDCOxBvgY/kegEAOEHQlWPRaM5DdUl6OpKq/7uRKP8y4xgILMBihLIg
         Qq1sGs5x6QqN1GcD7YiXIlHl8jsSLmVfqjtV2MMsvEqsRjZ4l1jKuSWPjDVaYJLKnpik
         AL9gLsjIGbu9WmuAbaephMVMVpSPtOSl7wDPrK58WrEmxEIQE8mRK584wV0C5J7KIOP7
         Sbi3s1TEgUYYmuokysKxs7NsZelr2h65gWJGOtfnG67atP8wXJ7oI6bshaeqe3bnFd+c
         9tEI1If9pyOVN8lbnJOOHgTEp/bQWv7Y9bnE49ojZ2GJBDN5RRFn84C7VToVGCa2ebt3
         Zf6Q==
X-Gm-Message-State: AOAM533swPea37a/dmJsiYfxceaJuZlYp4noluDg8Sc1VPWBUOSx3ASw
        S9hwYV/Wer/0IgNzMTGrW8vEMJClTqFp1bj72Nc=
X-Google-Smtp-Source: ABdhPJwbjhU+YCBC2Mm9YIY3cpWyvRTwGsIKnPLIkE2RD/yjTtgl6fUaMv2uEHxAl95LexUArLaU9iLU9qaSrKuPR7o=
X-Received: by 2002:a0c:b20d:: with SMTP id x13mr20757880qvd.18.1608617606420;
 Mon, 21 Dec 2020 22:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20201220123957.1694-1-wangzhiqiang.bj@bytedance.com>
In-Reply-To: <20201220123957.1694-1-wangzhiqiang.bj@bytedance.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 22 Dec 2020 06:13:14 +0000
Message-ID: <CACPK8XexOmUOdGmHCYVXVgA0z5m99XCAbixcgODSoUSRNCY+zA@mail.gmail.com>
Subject: Re: [PATCH] net/ncsi: Use real net-device for response handler
To:     John Wang <wangzhiqiang.bj@bytedance.com>
Cc:     xuxiaohan@bytedance.com,
        =?UTF-8?B?6YOB6Zu3?= <yulei.sh@bytedance.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Dec 2020 at 12:40, John Wang <wangzhiqiang.bj@bytedance.com> wrote:
>
> When aggregating ncsi interfaces and dedicated interfaces to bond
> interfaces, the ncsi response handler will use the wrong net device to
> find ncsi_dev, so that the ncsi interface will not work properly.
> Here, we use the net device registered to packet_type to fix it.
>
> Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>

Can you show me how to reproduce this?

I don't know the ncsi or net code well enough to know if this is the
correct fix. If you are confident it is correct then I have no
objections.

Cheers,

Joel

> ---
>  net/ncsi/ncsi-rsp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index a94bb59793f0..60ae32682904 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -1120,7 +1120,7 @@ int ncsi_rcv_rsp(struct sk_buff *skb, struct net_device *dev,
>         int payload, i, ret;
>
>         /* Find the NCSI device */
> -       nd = ncsi_find_dev(dev);
> +       nd = ncsi_find_dev(pt->dev);
>         ndp = nd ? TO_NCSI_DEV_PRIV(nd) : NULL;
>         if (!ndp)
>                 return -ENODEV;
> --
> 2.25.1
>
