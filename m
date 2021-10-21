Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB3B4367A0
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhJUQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhJUQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:27:07 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFB1C061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:24:51 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id q189so654092ybq.1
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQIpZKLssOO9b/P7MZ0E3pN8wbu2MWXeqcMiWye18wM=;
        b=ZVdTfoZTwyQYED1Q5xE9yPde2uJZfN3yXOJAlUN8FNOkU9LPPo053ZShDLFkhv3KqO
         2eP/a/iWAPJj2ICYeb8K0P3Js89Mdu3k0qpJG9QJe4O6FpU1oecoU4+lupWo1FfcjlPd
         h+FUh0QPHnFNpb+a4zvXmNLirI9aVYOkvvAuYvzRQZnOEYBEryeUZToPA1FR8/QidYKA
         qmPGbNs7k3GfecsbChoy3cIYWWXxe80Hzgl6qZQswncCXyBc6uCpI7UTdYyDDcuCP7h/
         jp77kjLPVwfKFojB8Qh/ZK5f+g5s1SKUk/5RqF760KLkgMBphBSmlJ5l7VMEwwalv+wz
         4hrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQIpZKLssOO9b/P7MZ0E3pN8wbu2MWXeqcMiWye18wM=;
        b=FSYax6NEv5xtmDJkqwt/YjZG8BlPz77aN0spJ7xisraWNDT2U9w4sNY/2ndRNUzjcg
         PEvorKzSk2GH9coIytIDgJ+fuIBONuViRhc+SwL8uxK31wNsdul5cYdAAOSYuBgHxxcx
         Pui4RG459vdLi8BsWYGTyEpMPA/HBFj2YiS0sw/+dH6q9uC/sYodILmnPqivPoyHffcb
         Q3V4yz8RpgAi2LayA495RTonMqWZJjJvUch4WVDHBMn4HzWVVRiD1LMsYPsl4MNEPuij
         LSNcv0NFmGeAQTkSD6GWTWP04sEtViSsFuKoabZHsG5EqTmnCHWP1VN0GM/CClTKFV/s
         /InA==
X-Gm-Message-State: AOAM531qxEp9dK/yr+cXrpCPKOyDIaRVk3F4CInuYxhkTaiKnZfrC9vq
        v4nwXqSXI8ffUmvQpwioTXAtS9gIi2O0LL1AYxv2mQ==
X-Google-Smtp-Source: ABdhPJxomg4kp5mjEzEusK9TK8ZChvwFO5qHUvXDeztxfXTOyescyct22CcVYsyU5fMdDGl7LqFE0tkJHbnyb+SYsy0=
X-Received: by 2002:a25:918e:: with SMTP id w14mr7236123ybl.225.1634833490713;
 Thu, 21 Oct 2021 09:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211021162253.333616-1-eric.dumazet@gmail.com> <20211021162253.333616-2-eric.dumazet@gmail.com>
In-Reply-To: <20211021162253.333616-2-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Oct 2021 09:24:39 -0700
Message-ID: <CANn89iKM-hs5O3v5B+Rzx+gyt2g6GeQGAFmn7+sz34KtDUbHNw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in qdisc_run_begin()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 9:23 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
> __QDISC_STATE_RUNNING and should return true if the bit was not set.
>
> test_and_set_bit() returns old bit value, therefore we need to invert.
>
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---

Please disregard, I have accidentally resent this already merged patch.
