Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2AC32DB70
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 21:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbhCDUvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 15:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238693AbhCDUvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 15:51:02 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7735C061574;
        Thu,  4 Mar 2021 12:50:22 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z5so3999630plg.3;
        Thu, 04 Mar 2021 12:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nQR76nEKRwImSbpknXBAkPnCcRjHjuCtw+g6ieOUiMU=;
        b=fnURJyD1+RQGEJkpq5+GNw1nH27VkZ7dk5ePc2DCUwvxO0ZhL7SufgUKqVzI4igp0z
         dJghKyR7qV1zdw1d/cSfSaPFqwOO10mh6eud0YmB9XTx2YWc1zqidytjRd/yzByJJFAe
         hvBd4T2qKfJQS/5ueeKyP62seAV998NlgOqE9WMGFw40ujnkK/pzEjqo2CTJ8stDI7wW
         CuSAX16bmlV0akTw8Kgp5WU/Oe1R3E+uOVHmXekgRV4k26iqZOlJ0HJN5N484DEAl46F
         6t7gZu13iStRaKs/83XH6S81ztSzM/EiTfQtxz9+Bfb3RMxUvHBTo4BwDLtmkFaGpTcK
         RMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nQR76nEKRwImSbpknXBAkPnCcRjHjuCtw+g6ieOUiMU=;
        b=P7U6NUUZ40qkzPUhfH0bxKPvZEMjQjpbHlF6lOYqpPDe/aOA7WUzkFnOYmbg0k3BOF
         4S7omyuXzG1GpP8iILGed90EqxfcwdNaMhPiQhwfmX4MYkOerjgigFoh4tVweGuh2LmU
         CBuXDPDOBHDf23JGxLZOYb3g5XIT5Tmb3fi+RE9E/MDafECR4efv+1fZi+KrNyEjzL4G
         EgI8sPqTYchrbKsMF1Ptz1h6fP1rDfc8Ge63Mthu2/JaKBtyb4UXltJBJaknEal4RXce
         wRF9wDtxCeHb8E8aKWoPTscIIMYIViSzEbc6K7Q/VmG/MndWCdUwH4t15CT3iB7A/mnd
         y1Qg==
X-Gm-Message-State: AOAM532psEtoahb/G/tWSg56i+Q8+JOfpE2ZTo0UokffqhH6h5Qd0QXU
        Z9PQu65UGLm+beIgz5+1Eig/zaxYNs9+3QsQeJE=
X-Google-Smtp-Source: ABdhPJyjai1bP1CWf/fqbpbPk1Kj8GpoRphVOCQX07vyopsTZMXh6Ddbm+zkwQI0BIPWymSonWpmt1SBG/RlYa4Wg4I=
X-Received: by 2002:a17:90a:8594:: with SMTP id m20mr6350792pjn.215.1614891022280;
 Thu, 04 Mar 2021 12:50:22 -0800 (PST)
MIME-Version: 1.0
References: <20210304144317.78065-1-mheyne@amazon.de>
In-Reply-To: <20210304144317.78065-1-mheyne@amazon.de>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 4 Mar 2021 12:50:10 -0800
Message-ID: <CAM_iQpWv2qhqmn_kcpO5i=Y8qpTFGoZe7HAVJ5NEGKrjuS0QQQ@mail.gmail.com>
Subject: Re: [PATCH] net: sched: avoid duplicates in classes dump
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 6:44 AM Maximilian Heyne <mheyne@amazon.de> wrote:
>
> This is a follow up of commit ea3274695353 ("net: sched: avoid
> duplicates in qdisc dump") which has fixed the issue only for the qdisc
> dump.
>
> The duplicate printing also occurs when dumping the classes via
>   tc class show dev eth0
>
> Fixes: 59cc1f61f09c ("net: sched: convert qdisc linked list to hashtable")
> Signed-off-by: Maximilian Heyne <mheyne@amazon.de>

Seems reasonable. If you can show the difference of tc class dump
before and after this patch in your changelog, it would be helpful to
understand the bug here.

Thanks.
