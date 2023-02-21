Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3469E17B
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 14:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbjBUNjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 08:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjBUNjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 08:39:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148DE27488;
        Tue, 21 Feb 2023 05:39:38 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id h16so17536731edz.10;
        Tue, 21 Feb 2023 05:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MS8Mfk0a+tOelm3oB4JjBFFHk2PglHZulG767Z6PHaY=;
        b=Q3Er7+9uHQR8zJ0WDGL2hpNFcJD6qIZm0tNlwM7YWUpJ7HRlOoLeXFvMKF8sBgXMzy
         gOGXwe5ga31pkXik1cy/q/8wvQHUFdgiMBScnmTZq6Vgw3zEmXtBxG56MR0zKbP7Ky84
         DBP8HITFZFd4/GPhxBlwJ8/Pvm3RXdSmkWy1TyZVUyqZagsZc2Bb6NuPyL52an78A4V+
         TGIKjqPjbFezl0mkorVSHevP18V93Uk87MKga1v7LYw2lF2Wu1ZZA6TLeLoHIykHxeSO
         z4xzZvY1u4dju+MQxl7CFKb6EwR/TGPKlLT9ctgWkMFzdKXDazzjMzjYVV7VDHMj+5Qu
         OkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MS8Mfk0a+tOelm3oB4JjBFFHk2PglHZulG767Z6PHaY=;
        b=WWqWLIGnkwBP+/GjZzM2/IIksD2wWNIx9+4ryLS84IWfLxn88zX9guFksCfImBvFqo
         Jojs3bebyRDETYO4JfqkHxn87PNpDfwnb8MsSzL8Y6OFGyAQpbFO0J2ABAHSJ2SBFJWP
         bb7WGx3F4/JR9/BbblU7Kb5yvX7Kih+kHi5rDTGUkIhcmjQlzyVwczEkgrne93dvozbh
         RGyC5a40P193lSb8N/5u3R0LYLVhoPDF2W9wDoz9kIX8A1UgQ653Dk4Ep+jP7ZFnfOOE
         Tn1T59UQnKrOaBrdDoV0TSpNhxyqq6axDemm/naSbjiU9e+9k2yXceUSklS+wsfChI/Q
         F/LQ==
X-Gm-Message-State: AO0yUKUUcdTVFDhdN57VtE5zSl5BEl+/ArDdwM5EufWyiraC1ubWTwZA
        nIJJS/y1nArW2MYRbJ5Myb+cIrA21MLGRCRMqv8=
X-Google-Smtp-Source: AK7set8EruFuzXNZ76jdL1CUpzEDNDNq50BplG8eK0lp52UdDqhNZ7MrbBmEOlVg6/3pX66eGqX7825/GcAGUWyEe74=
X-Received: by 2002:a17:906:81c8:b0:877:747f:f6e5 with SMTP id
 e8-20020a17090681c800b00877747ff6e5mr5600813ejx.11.1676986776484; Tue, 21 Feb
 2023 05:39:36 -0800 (PST)
MIME-Version: 1.0
References: <20230221110344.82818-1-kerneljasonxing@gmail.com> <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
In-Reply-To: <48429c16fdaee59867df5ef487e73d4b1bf099af.camel@redhat.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 21 Feb 2023 21:39:00 +0800
Message-ID: <CAL+tcoD8PzL4khHq44z27qSHHGkcC4YUa91E3h+ki7O0u3SshQ@mail.gmail.com>
Subject: Re: [PATCH net] udp: fix memory schedule error
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 8:27 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2023-02-21 at 19:03 +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > Quoting from the commit 7c80b038d23e ("net: fix sk_wmem_schedule()
> > and sk_rmem_schedule() errors"):
> >
> > "If sk->sk_forward_alloc is 150000, and we need to schedule 150001 bytes,
> > we want to allocate 1 byte more (rounded up to one page),
> > instead of 150001"
>
> I'm wondering if this would cause measurable (even small) performance
> regression? Specifically under high packet rate, with BH and user-space
> processing happening on different CPUs.
>
> Could you please provide the relevant performance figures?

Sure, I've done some basic tests on my machine as below.

Environment: 16 cpus, 60G memory
Server: run "iperf3 -s -p [port]" command and start 500 processes.
Client: run "iperf3 -u -c 127.0.0.1 -p [port]" command and start 500 processes.

Running such tests makes sure that the util output of every cpu is
higher than 15% which is observed through top command.

Here're some before/after numbers by using the "sar -n DEV 10 2" command.
Before: rxpck/s 2000, txpck/s 2000, rxkB/s 64054.69, txkB/s 64054.69
After: rxpck/s 2000, txpck/s 2000, rxkB/s 64054.58, txkB/s 64054.58
So I don't see much impact on the results.

In theory, I have no clue about why it could cause some regression?
Maybe the memory allocation is not that enough compared to the
original code?

Thanks,
Jason

>
> Thanks!
>
> Paolo
>
