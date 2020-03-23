Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381E818FCF7
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgCWSqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:46:01 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37493 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727272AbgCWSqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:46:01 -0400
Received: by mail-yb1-f194.google.com with SMTP id f17so7681284ybp.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZD7/ATruuR8NRvdfBN7+Qi9sh7ywUUPfAO2yyzLIz1E=;
        b=kvfXmaOwoZFGrOh5aIUvAhTBITelayYfPkSLj1cRrvga94U8gaH693Py6Vo/ajX4Q1
         9SwZZA2arAeuJE7ZjjIhlJlG4fYIr/KtnJ/i+HFNrlwcelTOYajzoHFGNAuT/OY23gsA
         yqk7TP2umuK5l/+P+IeCqqGJDJDkMn0pAkRqvz/VHDzeQjZn++d6tHWxC53L+cgjOyAF
         X7gokJAZENM+xW82kmIID+8i+KfximdguGF6G/73QgQD/EAEhllf9muwVv74xqOTSKjY
         iGiJvE9CgrWZ8Htnzd91hy1JeFozaq5y0jkLBysGRMmIwZiATvN2nDMS3Eb7ZzkYlo+e
         IjgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZD7/ATruuR8NRvdfBN7+Qi9sh7ywUUPfAO2yyzLIz1E=;
        b=pY7hJ+IPA6Sc1s/la4fTz0VjmCP+IXZh0ZQ2PdQtf8/aVWYdRIRsAJQ/1QcAse12fu
         5pU6OHJ+rbAPRjLDap48Mbmh34yVPD2ZUXIP0j9pOxHSVbHWheufFhIPbS+CDT0XDlYb
         DHPJTY3gdeOte4VO5f/EBO3C2SZiUmfbGyHKLeRs4If9lu33dyQPtEzOp0ctNwd53P7u
         I0a5m5OH3Xtz38ILCrRfNmQZ3SrIQoc/UyiJcM+cBXJvkvNK+fimkdTIR/213YNSVFLQ
         0tEt1t7v5QlrhUO0V5SZkJx6KIxINHzQq8MYfq0vSqJurZ/I1D19DebwI9olgMEGgLsG
         EcCA==
X-Gm-Message-State: ANhLgQ1vNwEagEfnpdCLwpMcOVDvAv5B0pDrMALM2IPOPkbrX9ZFXcb9
        qKiM3wd7IbsGgp36jc3tt4qeCyt0My2o2VT4dKRDeg==
X-Google-Smtp-Source: ADFU+vvBrruOh4WIZciJ6/BEzpsNg721CBLrFVfaFXtvnnk1x2jc6X3b6gzNPONGIUjhpi99zU2HV6CCIwxvjG34syg=
X-Received: by 2002:a25:6cc5:: with SMTP id h188mr34935921ybc.520.1584989159878;
 Mon, 23 Mar 2020 11:45:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200323181814.87661-1-kuniyu@amazon.co.jp> <20200323181814.87661-2-kuniyu@amazon.co.jp>
In-Reply-To: <20200323181814.87661-2-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Mar 2020 11:45:48 -0700
Message-ID: <CANn89iJzxqF8j6uUO9BqmMY0tVh+intVj-v-tygXc_8r6-wjkg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] tcp/dccp: Move initialisation of refcounted
 into if block.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dccp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        osa-contribution-log@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 11:18 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> The refcounted is initialised at most three times.
>
>   - __inet_lookup_skb() sets it true.
>   - skb_steal_sock() is false and __inet_lookup() sets it true.
>   - __inet_lookup_established() is false and __inet_lookup() sets it false.
>
> We do not need to initialise refcounted again and again, so we should do
> it just before return.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---

Well, I do not believe this patch (and the following one) makes things
more readable.

I doubt setting a boolean in a register or a stack variable has any cost,
I prefer letting the compiler optimize this.

The ehash lookup cost is at least 2 or 3 cache lines, this is the
major contribution.
