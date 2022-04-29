Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA67514E35
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377939AbiD2Owd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377932AbiD2Ow3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:52:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAABA8898;
        Fri, 29 Apr 2022 07:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3B4CCE32AB;
        Fri, 29 Apr 2022 14:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B387C385A4;
        Fri, 29 Apr 2022 14:49:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="M8F8RPlr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651243746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5kY/+HKQBdEE0OK2pw/26od2YREsYrBdJoXKkFBM3wg=;
        b=M8F8RPlrmla90D9ds6+HP7EXyc1/aZdxybcOycx50xrVs2vuyX2wehLYW4ple+XbG+Exaw
        8t0nw/oR69S1R2jZa5oQyrJa3VyhOgLAMNJg/9TSImCKLz3pnQTC52LkoMA1FJ1+aaXAFe
        RLUAAEM/8o3z3lprv+4qCcUtn/8jKTU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 358250f3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 14:49:05 +0000 (UTC)
Received: by mail-yb1-f172.google.com with SMTP id d12so14888949ybc.4;
        Fri, 29 Apr 2022 07:49:05 -0700 (PDT)
X-Gm-Message-State: AOAM530xo3Q8A9xkK3hDjMlpj6lZz04Yldnet8AFf5pxILdJLSzSks65
        uQX0bGyds/96mQlALH+pvNdyICWne/191nRR86o=
X-Google-Smtp-Source: ABdhPJyfEG/vnw/eTywo3qhWhBaxQxGzbo0e51Bq7f5mB+qsLSibc7sIgvNROq6WTrUNcOxp6TPY6YaQpbyjnqMxFrM=
X-Received: by 2002:a5b:8c5:0:b0:648:d88b:3dd5 with SMTP id
 w5-20020a5b08c5000000b00648d88b3dd5mr12370317ybq.267.1651243744309; Fri, 29
 Apr 2022 07:49:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220428124001.7428-1-w@1wt.eu> <20220428124001.7428-4-w@1wt.eu>
In-Reply-To: <20220428124001.7428-4-w@1wt.eu>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 29 Apr 2022 16:48:52 +0200
X-Gmail-Original-Message-ID: <CAHmME9pYj85hCS0=37+XsaJSgNXoJ96N6TdiJ9TWBYTXQx0LAA@mail.gmail.com>
Message-ID: <CAHmME9pYj85hCS0=37+XsaJSgNXoJ96N6TdiJ9TWBYTXQx0LAA@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/7] tcp: resalt the secret every 10 seconds
To:     Willy Tarreau <w@1wt.eu>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 2:40 PM Willy Tarreau <w@1wt.eu> wrote:
> @@ -101,10 +103,12 @@ u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
>                 struct in6_addr saddr;
>                 struct in6_addr daddr;
>                 __be16 dport;
> +               unsigned int timeseed;

Also, does the struct packing (or lack thereof) lead to problems here?
Uninitialized bytes might not make a stable hash.
