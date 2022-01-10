Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D00E4899B0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiAJNRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiAJNRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:17:34 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48B4C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:17:33 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id i3so37813535ybh.11
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SdrkS9NcQFVMwIFPaCLEOK6aKVNbSMbn34Y9bgb4pag=;
        b=lEvwlwByuUMD3uXJciHODu/iQ05Ku2pUMmwyRkUSQXcaickA+CVVxaph92hRPE0DAf
         FNntAtnGeAuvwmOcyocQM3FhfFcU9r+ccmkQKJ8AUIXS9p6yl/3aRHO5lng2Vu/U25Xu
         ckDLJZKmQTT0R2jYgSX7lfxlcUxzK+CzvipAiDNm624KtjHeSr7JzWNkrV/5AjgoMlbX
         Vl5PA3TSZd5P1Xcdv9wkH46+HTmvOASwNmhtkMeYE8JeeUvwnXLV8PD42xbvyZIXtxdB
         rG1tGbSH/VaaxPSPOR16TNFNwxda6naOGBXu3rKS8OkoMHOQMjh0g7aq2vWh/sqWCmXM
         1LvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SdrkS9NcQFVMwIFPaCLEOK6aKVNbSMbn34Y9bgb4pag=;
        b=uIlGFYFWVljYy/dozU+a5wCxUlMkdj4WiBQWft7vHkrktSOH3rOTVF/DNa0EQMp6uJ
         RRAM5sl44xGlbWgDFA6xNwuDTkKQQyK0kYuei1uHTuva/IqKA3AfFofyKwUo85vWFEVn
         EOJVO0mBNM9IiYRard+lw9gjMcIYrenML7CwYLK1wiHIpginctrnH4YmHyAnL/lIA5/R
         k6r2T2odaXWoBYSQlDLzEpZ79MyVNpkhtgnnJZviXlK0ESKJlGo3TxkZ1EnZFIZULdPO
         3BBtHVPBu1yMeVaD/eyFAnd4TCytscyyxYa+xybVsOJbosxMM+iIfQts9goZBDjTT8ki
         FXxw==
X-Gm-Message-State: AOAM530ZvdZ8bm+TmVOwQYkVCkmREPNQxFC+kWj+f71EXbhbQ8j60QYa
        RJpIpBpPgqcOaQUhN/kkch2ejQa0r/TD5fQUi6q9Rw==
X-Google-Smtp-Source: ABdhPJyRLPZZUYDQ2JD9orDf6hF92q/kHpCMOJ15g1vr4/fGhOramFSrYFHRrR6jU6x+e/jKQ37P7HDxFkeYEPi1smI=
X-Received: by 2002:a25:ae4d:: with SMTP id g13mr7125851ybe.293.1641820652763;
 Mon, 10 Jan 2022 05:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20220105102737.2072844-1-eric.dumazet@gmail.com>
 <35c5d575-2586-fc77-8c71-bd4cb945f62d@nvidia.com> <CANn89iJ=z6PKMTXZpFmCXD2yS=cynHFMPh24k7M4ajBe3pDBfQ@mail.gmail.com>
In-Reply-To: <CANn89iJ=z6PKMTXZpFmCXD2yS=cynHFMPh24k7M4ajBe3pDBfQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 10 Jan 2022 05:17:21 -0800
Message-ID: <CANn89i+djJT_o8kqzqRacNs6ma3m-_xG40uttzAn2EfZAqD8Jw@mail.gmail.com>
Subject: Re: [BUG HTB offload] syzbot: C repro for b/213075475
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 5:14 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Jan 10, 2022 at 3:10 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

> > Is this the right program, by the way?
>
> Yes it is.
>
> If you look at it, you find htb string embedded in
>
>     memcpy((void*)0x20000398,
> +           "\x00\x00\x04\x00\xf1\xff\xff\xff\x00\x00\x00\x00\x08\x00\x01\x00"
> +           "\x68\x74\x62\x00\x1c\x00\x02\x00\x18\x00\x02\x00\x03",
> +           29);
>

Also embedded in this memcpy. you can find 0xFFFFFFF1 which is TC_H_INGRESS

#define TC_H_INGRESS  (0xFFFFFFF1U)
