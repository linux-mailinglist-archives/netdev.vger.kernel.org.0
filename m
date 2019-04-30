Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86455F09F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfD3Gis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:38:48 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42285 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfD3Gis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 02:38:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id w25so6563029pfi.9;
        Mon, 29 Apr 2019 23:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3XMsoBOZ0a13a6v6/opVGPc6Lyc003bautbs6jqRIj8=;
        b=ZPU5G3fWXsWhHsBr0Po4QQUyx1Zy+IemAsyWEin4IIj4cbwdBhkdNUWXpnAGlHu7kL
         PTOWHQPnczmNqpCbft/LYoNnWno1RkuXMorlIrWox1GKxxi5igBYsDhkA+udHyNn7hCI
         G1tyB46vH/IiZuz7pN25/Y24Wcgh1FTpcknRM1ZlFX5o2FCuvaMEIObcEX1KjQYrGUro
         GAvR02hXHLFwWuVWh8l4BYGFdUqGLrlE+ZYowBdUaU2FdJf9hnQUXRLS7FjXK1xIzNfk
         i/L8VxnxMDoeHwrvIjRFua97YcVaOXphTba6NQ1OAWSrub5ptSgPbgkNvPxxIxDrcPhj
         tygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3XMsoBOZ0a13a6v6/opVGPc6Lyc003bautbs6jqRIj8=;
        b=IQ7kPwOuIV4a51OdmuQlmomBDCh01YjoXz6AUV7WUGWw2L6fZgi+yTdC4xX2DnYPQ3
         +ig70gG6Ji4f+XhdqaGmRVe3mIR1igshYZzAHY52yRXiqPbainyFsM6fSrH2FH+DII8t
         +Uhs8GKLBWJ6xAIkK5mXXxQEqNIoEICTMHXDpk4C0jByQzB1tv8tSquMF7McGLP7JBrJ
         fO8kvhzssdaKnQg5xfkR18TsUhcNy8CtHW3Gds4OhcF0ypQU4oXSnemerH8wg2JRqafP
         9KurEx82aS4Si6kaBYRq4Jh9+pqSoEjPhBVZEn0DIy/kiUpPWXlAvUFhknNQLOUsXADF
         87PQ==
X-Gm-Message-State: APjAAAXWur5RkbyTUdDBYSj4ow0sS5MBcZUjaMsG7gTX1ucP7BLDmvlN
        uJ8D6fU7nSAHrhcWlWSh4+pW6wHzG8Qkvh1NA0TJZA8H
X-Google-Smtp-Source: APXvYqzga9+pMQDyzP03aL6EshmtcvBzFNg/W/jaOgNsEwyiW8gXVA3eOl0yNSsQiTRquRKUhMS5vJ3LYePN4ox2j+A=
X-Received: by 2002:a63:af0a:: with SMTP id w10mr64252879pge.67.1556606327746;
 Mon, 29 Apr 2019 23:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190417164944.1462-1-avagin@gmail.com> <20190422083813.jadafdr5mpwda2fe@salvia>
In-Reply-To: <20190422083813.jadafdr5mpwda2fe@salvia>
From:   Dexuan-Linux Cui <dexuan.linux@gmail.com>
Date:   Mon, 29 Apr 2019 23:38:36 -0700
Message-ID: <CAA42JLbgEBMmzYTBtDyVh7iBQ7QDvzOwo47BRfYEssEE3QKzfg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: fix nf_l4proto_log_invalid to log invalid packets
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Andrei Vagin <avagin@gmail.com>, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 22, 2019 at 1:40 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Apr 17, 2019 at 09:49:44AM -0700, Andrei Vagin wrote:
> > It doesn't log a packet if sysctl_log_invalid isn't equal to protonum
> > OR sysctl_log_invalid isn't equal to IPPROTO_RAW. This sentence is
> > always true. I believe we need to replace OR to AND.
>
> Applied, thanks.

I also happened to find this bug today.
I almost can not believe I'm the second guy to notice the issue -- the
bug has been there for 1 year and a half...

Anyway, I'm glad to see that Andrei fixed it!

-- Dexuan
