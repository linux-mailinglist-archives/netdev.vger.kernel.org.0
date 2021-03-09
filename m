Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A56332DB6
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCISAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCISA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:00:27 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C869C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 10:00:27 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id n17so3429316plc.7
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 10:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7TQ040wzDNd2aycFNEuLXBa4mUNaIYvfCpS8YkBZ3M=;
        b=Ht+o6mjSdv/GBRPUw0wX4591Ai8WumuqS68azcZwi6NXQKIAy3YlIUthKgHdXMiJb1
         /7dCWubH34a6W7vA2foF16yyiVp772sgAj1ujkeCnvKDMy6MfJz5nGOZdF8YEqzp2e2u
         ZhemzzpaYT/PpsrlOqr1Q7NP2YdPLGAmJTAoaKbMQImv1AJtBf0sH5DMB61qUGAvcjSy
         FSvcE+SIFeD0mVXI75KY7l/pScq5v9CBpQx4owJchwHHM6ARYGD8FKSXAS6oFtsrKQPl
         /B8Jk+rInnyZEYCQVvMgH1xPCTzxOu3/AI2c6mXxfYT1Ibzy4HSlZqOY1vGm5lGnupD0
         8LTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7TQ040wzDNd2aycFNEuLXBa4mUNaIYvfCpS8YkBZ3M=;
        b=jFu+xCNhQ1q7QCoAQ1/wLGlMrRehc0SqsbxjoTEXJivkPraIsXWKOheub9Y9iYos61
         IVJNqdMwmkzGJ8qTD/ALjq3vxlolh7PGW6acVr0/kLECPcdFAxWxGjGoZrgoOAh4kosK
         AIicwuO6xWAR/P3nc9zAuMSoTgdm3/UthHzuZR4WSN+rJR11r5AnTR3h7NoN1npSIhYs
         J3o47T8h67wo0cRbU47yV5Uooq9M1n5VQMtFdCfP/RnQJ9eOVHWjp488OfJSxgs0YOX4
         piyxJp/jM1SvbKAefTONb/c8O+PTdkCcQabjuFkgP0BdUoo3OCBGWdPEPrlr4dNv1kvR
         ly/w==
X-Gm-Message-State: AOAM5313XivZfdw3e7SgVfmAyWV7jb3CWXskuSB+6wk+LwADmUoHhpkH
        THZ7U8ZwJ41g+323qW8BzWt42gJ49WEJJaMt6BI=
X-Google-Smtp-Source: ABdhPJwEMYwqNb6hKbc5XiAhvZFJQY9ixvqvkaUNnWycH7FU13wfAO5096zRZoWDQe3lGvn4XfMW+sJwavMclZbj9+o=
X-Received: by 2002:a17:90a:8b16:: with SMTP id y22mr5700191pjn.191.1615312826992;
 Tue, 09 Mar 2021 10:00:26 -0800 (PST)
MIME-Version: 1.0
References: <20210309034736.8656-1-zhudi21@huawei.com> <07afbd8d9a76f3c0f0a0eb01759118a0c9e966a3.camel@redhat.com>
 <672f06766f2d49ecbb573037b3cb445a@huawei.com>
In-Reply-To: <672f06766f2d49ecbb573037b3cb445a@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 9 Mar 2021 10:00:15 -0800
Message-ID: <CAM_iQpVcuxoczPrtfZd4yXhTrStb5KVA08P_6WTu7MCoQe4vsw@mail.gmail.com>
Subject: Re: [PATCH] net/sched: act_pedit: fix a NULL pointer deref in tcf_pedit_init
To:     "zhudi (J)" <zhudi21@huawei.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Chenxiang (EulerOS)" <rose.chen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 3:24 AM zhudi (J) <zhudi21@huawei.com> wrote:
>
> Yes, you are right.  I didn't notice your code submission(commit-id is f67169fef8dbcc1a) in 2019
> and the kernel we tested is a bit old. Normally,  your code submission can avoid this bug.

Please do not submit patches for the latest kernel unless you test it.

Thanks.
