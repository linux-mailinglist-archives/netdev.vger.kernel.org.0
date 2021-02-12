Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59C0319CF5
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 12:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhBLK7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 05:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhBLK7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 05:59:50 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA360C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 02:58:54 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id p21so12459765lfu.11
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 02:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aCdl6xS/yVJp5Nl7mhEYBP6S5Y+b/9q9qCwgCmlGQQE=;
        b=Nd7D08C6QZXWVMkUKkcBrBPmPLJ8Y9A5p66s4YYeO/KTmwpLyUnfNViVHreZxOYt8f
         16Mwfe20mTpDdjMeNttWSo95sPFFGTsu9b9YKUUnTuClYDXEGativjGB7D82W7oyfQ8u
         wRt7xbuzJWyziuaaUSSvE1BQNaHaLzMCGGNVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aCdl6xS/yVJp5Nl7mhEYBP6S5Y+b/9q9qCwgCmlGQQE=;
        b=gBqwe5BMevgLJECNl/t+6hYi8aATHSjyOp55/jVp/jFKnw8+l/ih3ED7EQXmJsXLYv
         LPCQ7gvGiSAHUhel+h0sL2zgx6ixetNv5lqpQuFau7kn4QVDrlsUkQ1ZyTKMMTm/6VjM
         l8FdfLK1QkcLS50Gyk0HY+FrQy2vzmIi20eIWRl/Xk4lAALbqvmBGScgGf7mvlwAZ9Ht
         OCiv7p1ys+uBjoNSwM5J8KbJsMypC/pOWMbFAhbzIEUzKmm8h4FD6ucVoeTTPK35eCyd
         sk1Qbc+BI2zhlGZuwfUgYHrct8+PY4i3inMvOj2RetnoSPJ7yoX8uSlZlLmvnFQ+3xxB
         QjIQ==
X-Gm-Message-State: AOAM530ghHyIqkhG+zOwB14PFebI2ypHUr5CFHYH7pKo/myHnFywS277
        Hfjl/sW1QDHiXEWy0GbX7ItWVUfiLqOtg4V6aMibbQ==
X-Google-Smtp-Source: ABdhPJyjtQBACFtEed271bZN/M1Ef3JGWDwWO+HQflqG73mqOtcxmBfewpTme7AHwhpdOwDFK/MzF8btczQdpqj2TUA=
X-Received: by 2002:ac2:58f8:: with SMTP id v24mr1318891lfo.56.1613127533108;
 Fri, 12 Feb 2021 02:58:53 -0800 (PST)
MIME-Version: 1.0
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com> <20210210022136.146528-5-xiyou.wangcong@gmail.com>
In-Reply-To: <20210210022136.146528-5-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 12 Feb 2021 10:58:42 +0000
Message-ID: <CACAyw99ErxrTShKNeP+6kr9oj3Bw9BBZ8pe34pSGEueJmWOb5Q@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 4/5] skmsg: use skb ext instead of TCP_SKB_CB
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 at 02:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> does not work for any other non-TCP protocols. We can move them to
> skb ext instead of playing with skb cb, which is harder to make
> correct.

Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
