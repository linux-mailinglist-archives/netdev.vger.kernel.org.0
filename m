Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0579E3FC06D
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 03:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239234AbhHaBTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 21:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhHaBTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 21:19:39 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B37C061575;
        Mon, 30 Aug 2021 18:18:45 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id c6so450540pjv.1;
        Mon, 30 Aug 2021 18:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rgye6ewHm6HCg5kzBVqjYYpCyOH+GvvYlr8Oahz1qN8=;
        b=nLJmqPzlSbDHOmsbCF9Av3nX7cBJwZJlA5pP0NbMSNLomonTEPR5IUDgPY5uv4wSL/
         /m2Trag4jYSVdRCO2q2wGaZjLU3ysro0jVygyMNAMwQzMjKuNZigF+1GMQ4ePMFsbd+B
         GUZGlQHIaFTBvzQTHHTDaiV6+wXgZqQDK9DvSH2ZAeWydIXG2hWjFCSPJ1OBmWjd4GR4
         LrWicnZQBuRC7KfXdvGg23TxBuCpVmL2egQRw/77zTuwQwjmVYDy+f/rCXdI7AGgIiY7
         AHYihJlhPDx3IN5Q1xmG8Ie/HI+99hEUJH7dv9Hb2WA4rw3Q0Mr6jgb+2UkOWfMxQmfk
         DSFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rgye6ewHm6HCg5kzBVqjYYpCyOH+GvvYlr8Oahz1qN8=;
        b=MxAnQS2uAcWiy7fTxkoB7YNnbZGNUIcajw41OpD9GiMsLIU0kr0tfUWncEzhzO6Gno
         mzdj3hLKK45Vzg/XyFE2Srilh6yNB5vxxpr6kD9PF//myToDwteERKi653zaDIx1P7TX
         0j8Jhuq57qzTTpUb64j5o4tLH7X/fyCzCmf9Lo6kL/RtvtlwXWL929Kmh0245Rk3ritx
         9mFq2d1f5YbgrOt9/e4JrxeOmotKOwqC9pl67ZI3p5beZnFhZuGePj4vibu/lFWQBAxZ
         Dc8bkjcfKTBwRA7meFEkDKnonUQJFkP/e7/aZZ7f8R2q8lvCw1N5XwERkItuhUiV0hOG
         LRpg==
X-Gm-Message-State: AOAM531hbxdVSRCqzoUsW0N7tpZcpD0ySduIzgBry3imJat+FoqblsS9
        4hrPOOQFXAjkwW5mkHa2KIikYSfacym18RxNgcuR6J6urqI=
X-Google-Smtp-Source: ABdhPJx+Wf9hfBNQTxhhCnftf+BNVzp7cZ+qrjogAxu8Vy8b71+5GzWdJ987Vao4gvIuI437mci1a0BgCj03IUG26jU=
X-Received: by 2002:a17:902:70c6:b029:12c:c0f3:605c with SMTP id
 l6-20020a17090270c6b029012cc0f3605cmr2196970plt.70.1630372724905; Mon, 30 Aug
 2021 18:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn> <20210830110551.730c34c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210830110551.730c34c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 30 Aug 2021 18:18:33 -0700
Message-ID: <CAM_iQpUtAfUX4WQUps6yTGGxuXKYUnTFTnaCxEgKaHDke8z49Q@mail.gmail.com>
Subject: Re: [PATCH] net: sched: Fix qdisc_rate_table refcount leak when get
 tcf_block failed
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:05 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 29 Aug 2021 23:58:01 +0800 Xiyu Yang wrote:
> > The reference counting issue happens in one exception handling path of
> > cbq_change_class(). When failing to get tcf_block, the function forgets
> > to decrease the refcount of "rtab" increased by qdisc_put_rtab(),
> > causing a refcount leak.
> >
> > Fix this issue by jumping to "failure" label when get tcf_block failed.
> >
> > Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
>
> Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")

Reviewed-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
