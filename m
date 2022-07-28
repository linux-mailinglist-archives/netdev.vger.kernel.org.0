Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B5258445D
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiG1QuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiG1QuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:50:15 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A082B12AB1
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:50:13 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-31f443e276fso25863547b3.1
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 09:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mPytlbJJGMaQF78YCynLHt6AjHItpBAvAqieRoTXM5Q=;
        b=T6PAGuINvD6CjTjJlBIpH0owhZZWCZomjM/7pcnf3eapDdfzYsHG6KJyLb4Efg2HD9
         Mwg0tN1naghn9Xg2ij5dQG7CK1jidBRBqkhpN7qqXkpGLuEY8x7k1B4lmIHqxsWcKAtm
         3wZipPBDG0nNeDOoBhb6WHJemQNOADEqXUDUmtbEwYyqkm62PVYVYctobr5nFkBaWfZW
         DW1HS4Tc66HaZJsk4cPQCJcDdFibB3yo6XAB/fvVwu69NgklByLvx8U2nFYFNTHd+geE
         8gCtxAOJ3fhYGo9azYwLAxlxgYQMZn14ImcWFLlOrbdAKjt3tu+HzwQWVBkLV8mFqkff
         9UYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mPytlbJJGMaQF78YCynLHt6AjHItpBAvAqieRoTXM5Q=;
        b=z9/pRQEZnd3qlj4rexvY6wHU/5H9U5bzbPiepRhc+h9k+qT9965ZXzgVbl3MGfSOuC
         4fr8j6yTt77II93pT5UNV1BlEV6u+oWs4W9Pj2pWGSaRzTRvs43x31LbYHj/OepDIEOu
         E6UZDzcZ35vAjaJ9LH1Zx8rMgARZj7dj4t+5qSRe53W6ZpDBVVP3D57FZN/V4yvDz55v
         dpbODxCPqRNMBz5hHkN/0azn9MEW39PzphRDDOYf8Jcy4fpqyXuh6E3UrxwSN/PKNRSE
         0e9Fn8UI6viSZdkRPm9ZMUGmQ2oN7H8I9P9ilmkZNGJio4TM0XW0kjVYkMHJRbhkBwxz
         klyg==
X-Gm-Message-State: AJIora/ULT6Z8Tli8hrxpNQQh8zsI+Gg8scS2/9qsbPqfr6Gwo2EG6sT
        NXdITXuEWemUqXOIE6nuOOFg/mU4aZqDHxu67ckOmg==
X-Google-Smtp-Source: AGRyM1vJh00SJhFnRK/3Rb/7ZpKryt98GzfVMvVIdrvaNw8lTqcHlZmzdjfQerBmyaaGShvyTB/OhCXV+RO33cg41QY=
X-Received: by 2002:a05:690c:831:b0:322:1402:d950 with SMTP id
 by17-20020a05690c083100b003221402d950mr4874291ywb.255.1659027012625; Thu, 28
 Jul 2022 09:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220728012220.46918-1-kuniyu@amazon.com>
In-Reply-To: <20220728012220.46918-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 28 Jul 2022 18:50:01 +0200
Message-ID: <CANn89i+fRjiD91PZ1cXkhUingdr8p6nXdkTS=NVXSRK3zqjDxw@mail.gmail.com>
Subject: Re: [PATCH v2 net] net: ping6: Fix memleak in ipv6_renew_options().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ayushman Dutta <ayudutta@amazon.com>,
        netdev <netdev@vger.kernel.org>,
        syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 3:22 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> When we close ping6 sockets, some resources are left unfreed because
> pingv6_prot is missing sk->sk_prot->destroy().  As reported by
> syzbot [0], just three syscalls leak 96 bytes and easily cause OOM.
>

>
> Fixes: 6d0bfe226116 ("net: ipv6: Add IPv6 support to the ping socket.")
> Reported-by: syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com
> Reported-by: Ayushman Dutta <ayudutta@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v2:
>   - Remove ip6_flush_pending_frames() (Jakub Kicinski)

Nice catch, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
