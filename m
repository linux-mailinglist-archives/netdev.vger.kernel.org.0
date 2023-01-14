Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4366AB50
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjANMSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjANMSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:18:02 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753966E8C
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:18:00 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id u9so58057748ejo.0
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q9YuksUftZM7Mr4U6pqPjOciGDwe5IYDlYl6UJ9PPnk=;
        b=synd+Iggo1DQo5udzPz0uQKpvVSlRqvBUZi2YQV/McwbYALis2UlgTDQDUR6izBCC2
         l1bZPDxHIVWe9BlDJugSUyRI2tB8w+sHRdISa8ozgnxqwNFMCIzMgif57A4S+wEYoIRn
         sBDlRAINr7z8unXoQgqiE3xTPECg3H1Zt6zBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9YuksUftZM7Mr4U6pqPjOciGDwe5IYDlYl6UJ9PPnk=;
        b=2mhO4uDmUb1dC4CfRWlUeCSe6merERXLlezSx7X2MM2uPFs/p1yo62/pAuNXW+EIV0
         66vFHkA9Uk7PtBd+4wf0Hn0DJ9A732InWX5qINR3IxUUHa7K7N0tteMSMZM1La9ybC0a
         2pv/7RvPYyKVhsBeS8gy9vv36C+2VOQI/3uWvMtBu8MX4W2ARskUgaU4WoBZqQBr8wuB
         M6Jl3MtzPycXjU+NgDB3xKgxvD4uDxAOEf65Qke06mEfRaHulukoWpgnO7weDKK821+V
         YoaKQYelBB0uZcNPI9n+gKxfkbCsqzoC6e3CKxiEGK3g4ZIZjO8iItBL7IzJneS/ti+q
         6U9A==
X-Gm-Message-State: AFqh2koIfDqj0wrS8LJxlCalt11WPGEE+AUfScGaiy83V7H5+nJ5ds4+
        lXrrXEZrbtCRzRn7FCdtThD/j3McE1n4TZjeqtioKQ==
X-Google-Smtp-Source: AMrXdXvOei0aOBB3VZW2CgQOSb70AyAl1/B9kFZ6iYcyI2Yi7BxLttLgs8zTqS4nD1yrRe//DV3jMt5l4sDPgo+VyYc=
X-Received: by 2002:a17:906:3186:b0:84c:4d1:5e9a with SMTP id
 6-20020a170906318600b0084c04d15e9amr4237385ejy.297.1673698678984; Sat, 14 Jan
 2023 04:17:58 -0800 (PST)
MIME-Version: 1.0
References: <20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it>
 <CANn89iJekPT_HsJ6vfQf=Vk8AXqgQjoU=FscBHGVSRcvdfaKDA@mail.gmail.com>
In-Reply-To: <CANn89iJekPT_HsJ6vfQf=Vk8AXqgQjoU=FscBHGVSRcvdfaKDA@mail.gmail.com>
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 14 Jan 2023 13:17:48 +0100
Message-ID: <CAEih1qWQf1JK4vbdzcTb1yXADxTV4+AqtJkvnK1T895obUTtOQ@mail.gmail.com>
Subject: Re: [PATCH v2] inet: fix fast path in __inet_hash_connect()
To:     Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Jan 2023 at 13:16, Eric Dumazet <edumazet@google.com> wrote:
> 1) Given this path was never really used, we have no coverage.
>
> 2) Given that we do not check inet_ehash_nolisten() return code here.

It seems there are a bunch of call sites where inet_ehash_nolisten() return
code is not checked, thus I didn't think of it to be a problem.

>
> I would recommend _not_ adding the Fixes: tag, and target net-next tree
>
> In fact, I would remove this dead code, and reduce complexity.
>

This makes a lot of sense. I can post a v3 patch completely removing
the fast path.

However, this patch's v1 was already reviewed by
Kuniyuki Iwashima <kuniyu@amazon.com>, v2 is a nit, if posting a v3
I think I should remove the Reviewed-by: since it would completely
change the patch, but what is the preferred fix?

Best regards,
Pietro
