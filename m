Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DCE10DC68
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 06:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfK3FRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 00:17:41 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45066 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbfK3FRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 00:17:41 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so15454628pgg.12
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 21:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5m9jY+RahNxoHgaKCVhsFZ2k1J4lEnDmwGZm9lODaXU=;
        b=DoOmrPzAJxSs8hTmvQT7tyx+k9w86+rMaWZp3Wc2w2xRS1NLwQwWk7I9XzVcxUeWop
         ytU5MKLPmifIQCtBeGEMh1nbqMP0BIiEpdKLRZm4f4fGKh956Lu83ha/ALDpzyekHApc
         GVqBMKSWfWnaYB/6kV6nT+ER51O02qyMeAR3RIXzsr3lBZx2TDnd6ACtYdvSDWNuyWCr
         PqlVGArux8vDyOGo4d/TMAhpBSC9PH6sTzmu4LI26AYmzMogXPr30ReSbYGAL1bXMph9
         D5RFXxedghvyYTeRozppywNTY1Yd3e6jEDhMH0Ci0faygzA/Z27gCBP3OohXEl+364qo
         tULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5m9jY+RahNxoHgaKCVhsFZ2k1J4lEnDmwGZm9lODaXU=;
        b=tPfpaON8QkvqxeSl6TygbhgVj0gKs373dt+zMU2zvHCHPWZmpBpH6M3nX7RHQ4GXSY
         VfaE5uxV6DdB3yO0HJeLPWG1qdso8iVawEOh0aPvqJ1JjG9Q2MKHF/ZsE9LDWqii/giK
         yZmwIt/cCUrmQrPtDMOG+yH8jr7ifzQU/Ksgnc3z/raPYLRR9dGAD2XK2rGj0n1lEjmS
         oeyAppuXt6aT+UcNH7mPF345ll8Om2mzVb6iBUneVSET3XZCOUG82wQ82M+yiaU5mUm5
         M3bBBIzK7g/wBUZ6KtmfEysmn5/NY511Bj1PTHkDln/rxUtE90LvDsBA6wm7wZ/LpBUt
         rDOQ==
X-Gm-Message-State: APjAAAVS1Bnok3lPfwgKjGTMoAftkJ/lnxotVKBw5rGquMCnAuu2PixJ
        p/3vZPdTaBznhZuFnccJQTsHyvw+bbdRi14SgKQ=
X-Google-Smtp-Source: APXvYqz2YyEQbVdlsLYCWdPO6zsQKns+6cXEq3uSdaIrSG/mFcVdQVLRGLna3HmLzsfiK7qpBt2AdwHAKRK3bcDVPPE=
X-Received: by 2002:aa7:96ef:: with SMTP id i15mr59324478pfq.242.1575091059050;
 Fri, 29 Nov 2019 21:17:39 -0800 (PST)
MIME-Version: 1.0
References: <20191128062909.84666-1-dust.li@linux.alibaba.com>
In-Reply-To: <20191128062909.84666-1-dust.li@linux.alibaba.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 Nov 2019 21:17:27 -0800
Message-ID: <CAM_iQpWQDhJGYMDg9n8JyrWUdbYPPrBVWmaqKCvex28E50eUgw@mail.gmail.com>
Subject: Re: [PATCH] net: sched: fix `tc -s class show` no bstats on class
 with nolock subqueues
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 10:29 PM Dust Li <dust.li@linux.alibaba.com> wrote:
>
> When a classful qdisc's child qdisc has set the flag
> TCQ_F_CPUSTATS (pfifo_fast for example), the child qdisc's
> cpu_bstats should be passed to gnet_stats_copy_basic(),
> but many classful qdisc didn't do that. As a result,
> `tc -s class show dev DEV` always return 0 for bytes and
> packets in this case.
>
> Pass the child qdisc's cpu_bstats to gnet_stats_copy_basic()
> to fix this issue.
>
> The qstats also has this problem, but it has been fixed
> in 5dd431b6b9 ("net: sched: introduce and use qstats read...")
> and bstats still remains buggy.
>
> Fixes: 22e0f8b9322c ("net: sched: make bstats per cpu and estimator RCU safe")
> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
