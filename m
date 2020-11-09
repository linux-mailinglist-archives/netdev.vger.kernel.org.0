Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E82ABF2C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731521AbgKIOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729454AbgKIOsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:48:52 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA9CC0613CF;
        Mon,  9 Nov 2020 06:48:50 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id j205so5412741lfj.6;
        Mon, 09 Nov 2020 06:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ogv65uP9gTL8ci3I542ZqRre/+Ga4aoUJREJZSIGMNk=;
        b=HBloziyxba4SnfYP0yJp2yplIGEYd7X0kTKAl8NFj6e+NgzU/JUlioL/W8DpPcHN1W
         ijREZkz+Y0tOD4GnjDVtpmCoNC8TI9iIK+nsZe3KfFQpXwPDh5Fu4EzJJMaGiKfXX61N
         V4BxhB49+7FIm5rqk8P/JCpbt0kdfVoR6WjpaQMKV7CUhQtQLLLVp80shlA0NQorUpU3
         Ip/x+ap/N1xaud4cM5qLd0Sk+VSBrWzeyZ8HchSo3aUPSYGYVMvAhltBq9tDlNn/3hY3
         oJX2CRnCNAkDNZljSIiKUnmOognoPMFwXWqy7es3KeT+tHQ388y3xGnD9/fHGQ+fFuQx
         rvcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ogv65uP9gTL8ci3I542ZqRre/+Ga4aoUJREJZSIGMNk=;
        b=hWqUgWLaGnpUe++OezINWatPiAoTmPop1IW0PPQB6TVFkIQcdxOtxx1xJl2J+KdAHr
         9D54Fx+xqDPoZCNnlhx1sXhTdjUVBBTFPSS1MydXodjJD6exKrzZLlc08X8+j/fj1VJa
         ME16zrN5z8TBwkNUfk5vHyn1p3hA8b8Q5Cr0+ueSVvaPuen9LYoKPJMjSmRLwN7to3lV
         7CA5Iiz4BaZQL49axM+BlPWA53jWR1pZEIZ71LTbY/XX3PQ0i/aFCqtfmsfD5lTdwpAE
         JLxwkYZFSk4dm+/z8SP7+Yjr+ltOzKPyCyoBPfhPbrdWHMYcz3i341Qf+W4OCYIkZKdK
         GABw==
X-Gm-Message-State: AOAM530unw0hF3o2eVhwH7U0qInw4oMCOyrAYGcvoS8JgtXUrCylePbJ
        xBjirYMKT8qGAEQ2N9AYeq84vVOEvqBpOOkyeVg=
X-Google-Smtp-Source: ABdhPJytcQQgls7bqmHCDVLke2yxHum65gv0PFZ2lUwNuQROO4U/mbjw7MRwsHbRg91kMZCZOx41kXnG8sDRrgZDwk8=
X-Received: by 2002:ac2:420a:: with SMTP id y10mr5437917lfh.388.1604933328897;
 Mon, 09 Nov 2020 06:48:48 -0800 (PST)
MIME-Version: 1.0
References: <5fa93ef0.1c69fb81.bff98.2afc@mx.google.com> <CANn89iJNYyON8khtQYzZi2LdV1ZSopGfnXB1ev9bZ2cDUdekHw@mail.gmail.com>
In-Reply-To: <CANn89iJNYyON8khtQYzZi2LdV1ZSopGfnXB1ev9bZ2cDUdekHw@mail.gmail.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Mon, 9 Nov 2020 22:48:37 +0800
Message-ID: <CADxym3bP=BRbVAnDCzmrrAyh3i=QO3gAWnUwpU==TskFY-GHYg@mail.gmail.com>
Subject: Re: [PATCH] net: tcp: ratelimit warnings in tcp_recvmsg
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 9:36 PM Eric Dumazet <edumazet@google.com> wrote:
>
> I do not think this patch is useful. That is simply code churn.
>
> Can you trigger the WARN() in the latest upstream version ?
> If yes this is a serious bug that needs urgent attention.
>
> Make sure you have backported all needed fixes into your kernel, if
> you get this warning on a non pristine kernel.

Theoretically, this WARN() shouldn't be triggered in any branches.
Somehow, it just happened in kernel v3.10. This really confused me. I
wasn't able to keep tracing it, as it is a product environment.

I notice that the codes for tcp skb receiving didn't change much
between v3.10 and the latest upstream version, and guess the latest
version can be triggered too.

If something is fixed and this WARN() won't be triggered, just ignore me.

Cheers,
Menglong Dong
