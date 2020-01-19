Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79849141BF0
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 05:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgASEND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 23:13:03 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:38089 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgASENB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 23:13:01 -0500
Received: by mail-yw1-f65.google.com with SMTP id 10so16348114ywv.5
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 20:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C7kwDUUX9HD9wSkfaoKeD3WRZW/s6UPYxiemMWHJ45U=;
        b=tjtC/NACNgMyo6oo9eX2ad4ILNzVGudp5hF/L98rHBtCr2bd5dYus1cWqO12H0uM6q
         KBX/+QMEaPrHKka+C3Z860CGmL41ND3umn0BSVxMtvwQeOXeAQM2TliwA11Cn3i/TjIh
         r7aiggrcso2mPxQ3FmDWm+kUXOz6P/uTDzuAcua5rKTc5IT730vIef4U4tsMq2hEOS4r
         nF5t5/ZfxrKIFZvoMpqroN6X3afTfuiCP0NdkmtoBML+ASrhW9mnj1lixObmrSXww4x7
         7z+pAiATf7H2mskTyZH8iW4VfzXPGz5Z3JTYuAr6fUJsDxICzHyjf51j8T/2BsFfF6dA
         RwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C7kwDUUX9HD9wSkfaoKeD3WRZW/s6UPYxiemMWHJ45U=;
        b=RmrzSuDWoTfDuUBO8nejoSTeVsv7PO1zSZaxBEYGcES7GCCw2pHOJT54Z15uQl5y0z
         rgfA1jIsP9vt/HwOuGNlvnCFyAIDkgQi53X3iYwYc1b1Vxk3I746Q7ZSkCDSdgoGtuq5
         zVXdACKmQZCo7sPcpevk4KaQRPf197URLuPauHnJxnu4Cstu5yRzXNzrDLBWbbkR60AB
         TOPrpZMpEiARyOjrbftKbY0L8LLAep6TxVHtjU3aalcWLP3f4UE+MKcLpgHr8Jnw4c6L
         bf9hizVffPItQGdicwkkXL5+UcVgEexhiQbywW9YaiMTw01Ko+f81x0DBxqZNiJzd6ZS
         kfTw==
X-Gm-Message-State: APjAAAUB+Y1lP2QFAMJhzN5mRrdfy0wlaNH8QH4fctoW9ELdGdJDFpEE
        B7WrTcLpa/FGT9c7vmT3RXir56lB5fK5U7F662SJbg==
X-Google-Smtp-Source: APXvYqyUm8wguI77GuCgx8360mBn3xDD68lwGlicFJXcgrr763x7PUEPMlv4eHLsqUY8sNUHM739YumAG1T6UFrqtns=
X-Received: by 2002:a81:3845:: with SMTP id f66mr38141320ywa.220.1579407180395;
 Sat, 18 Jan 2020 20:13:00 -0800 (PST)
MIME-Version: 1.0
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net> <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com> <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net> <5fd55696-e46c-4269-c106-79782efb0dd8@hisilicon.com>
In-Reply-To: <5fd55696-e46c-4269-c106-79782efb0dd8@hisilicon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 18 Jan 2020 20:12:48 -0800
Message-ID: <CANn89iJ02iFxGibdqO+YWVYX4q4J=W9vv7HOpMVqNK-qZvHcQw@mail.gmail.com>
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, jinyuqi@huawei.com,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 18, 2020 at 7:47 PM Shaokun Zhang
<zhangshaokun@hisilicon.com> wrote:
>

> We have used the atomic_add_return[1], but it makes the UBSAN unhappy followed
> by the comment.
> It seems that Eric also agreed to do it if some comments are added. I will do
> it later.
>
> Thanks,
> Shaokun
>
> [1] https://lkml.org/lkml/2019/7/26/217
>

In case you have missed it, we needed a proper analysis.
My feedback was quite simple :

<quote>
Have you first checked that current UBSAN versions will not complain anymore ?
</quote>

You never did this work, never replied to my question, and months
later you come back
with a convoluted patch while we simply can proceed with a revert now
we are sure that linux kernels are compiled with the proper option.

As mentioned yesterday, no need for a comment.
Instead the changelog should be explaining why the revert is now safe.
