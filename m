Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4B9158C43
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 10:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgBKJ7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 04:59:51 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:60433 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKJ7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 04:59:51 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 69e62a04
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 09:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=z+xzTYIx52HdTTXC1S+sHLaqpJ8=; b=2Hzgsr
        R9HLUqsAdsoUVAMLvWvSaz/ppXwFwyYIPzg2TlRz6NR/20cmfQypaPeaLZVgD9O8
        zhgKV7j6pr0L0FHbTh3sAjlx9B32AZnL6NmO9jDWIHy1xpiiD+nMTEnBuStJwu4E
        kq++2rHx3jY+iMAfYGVfMmRdbAQdPY8rPANnkehOHxMlL5O3GdUgZ9pjfayDcA0N
        Y7AurFj2Mc5D6itadCbXlEmODuKC2fASQw+AWig3zvpCl+c5IGiO2Er4nFM+kSP/
        oc1PDsLq0UnAWLjAz1ggeDptVK4RZjMBrQaXjmLkADZ4a8ryujKh7TXTLm7F99LA
        g86j0ig0Kz0PahoA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a0eb861f (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 09:58:07 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id v19so12205188oic.12
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 01:59:49 -0800 (PST)
X-Gm-Message-State: APjAAAV1NDkOO9Cc7f2DS7wZXamyUBgcDcHFFnjkaE5hRnPEhNmHZxTg
        JbNXzMbWah4/0AozTFpXyxYrnNMm3wZ4ZtgN/yg=
X-Google-Smtp-Source: APXvYqxWEjj2Uok/48lVZVTZi/03i7PTGXubSRFhPszCoxk4INEbD+ELZt+G+RdYEwNccs4y2hPgHHtt6axubxM0RNg=
X-Received: by 2002:aca:2109:: with SMTP id 9mr2189132oiz.119.1581415188709;
 Tue, 11 Feb 2020 01:59:48 -0800 (PST)
MIME-Version: 1.0
References: <20200210141423.173790-1-Jason@zx2c4.com> <20200210141423.173790-2-Jason@zx2c4.com>
 <CAHmME9pa+x_i2b1HJi0Y8+bwn3wFBkM5Mm3bpVaH5z=H=2WJPw@mail.gmail.com>
 <20200210213259.GI2991@breakpoint.cc> <CAHmME9qQ=E1L0XVe=i714AMdpMJQs3zPz=XVKW9Ck6TvGu_Hew@mail.gmail.com>
 <20200210222614.GJ2991@breakpoint.cc>
In-Reply-To: <20200210222614.GJ2991@breakpoint.cc>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 11 Feb 2020 10:59:37 +0100
X-Gmail-Original-Message-ID: <CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com>
Message-ID: <CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com>
Subject: Re: [PATCH v2 net 1/5] icmp: introduce helper for NAT'd source
 address in network device context
To:     Florian Westphal <fw@strlen.de>
Cc:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 11:33 PM Florian Westphal <fw@strlen.de> wrote:
> I think this is a bit too conservative, f.e. i don't see how
> ndo-called skbs could be shared (tx path needs to be able to change skb
> list pointers)?

Are you *sure* about that? Dave - do you know?

I'm asking with *asterisks* because I see a few drivers in tree that
do call skb_share_check from their ndo_start_xmit function. If this
makes no sense and isn't needed, then I'll send a cleanup series for
these. And, I'll remove it from icmp_ndo_send for v3, replacing it
with a `if (WARN_ON(skb_shared(skb_in))) return;`.

Thanks,
Jason
