Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF51658EC39
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiHJMoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJMoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:44:01 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45CD584EDB
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:44:01 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id x5so3355932qtv.9
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 05:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=AvF0ld53YIJm/pBBN06AYvHNPuB0U4czPfcumd2gMLE=;
        b=aT4O114xLtGoLzyVGwX920yaHd8DL8uhrCm1IcIu2kv6sKrJINLi5Y1SEa7phS31cp
         Mp1bo6C1NmwDSd/5dQNdkkf3b+iE0/C2GQsorOFA2VA4J0V7infA6q8ES28OfaS10PBI
         beT8T+6WQ+2GM+xhSTpUuhI2NLvx5jedpZsakoVjFjosOzZlnwBS17/QRCJxqxkWzCdl
         z3YLZjdFOhkjVBewsA97xopv1dtUzW7HHruTwiN9TzHHM58IQRV4NwZ5TTYHshbk72va
         3VNA5kZ59I/NdGQQaKU+c9s2eYkhNo5osKCrveDTlITT56LuulO5e9dRJX30yJUV6o7R
         Kevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=AvF0ld53YIJm/pBBN06AYvHNPuB0U4czPfcumd2gMLE=;
        b=2veZrZ8NAtMWSmWc/rlIOwVfkSPmSgXP9KHYKDOOzXPfCupqfrgokR3iskCpnfm/ck
         BK2IUR5HNE9xnOq81skNeJDpDuia98v2s2C9GDfHOnRrCwqROBEwsKgnhp7EI0NDLjI7
         BjqMe71nKT7EGb4CdBeVVEkG62ol6dO+Cd0HcHZIiUQgDPxWlW5FiuHlsy7vHhAkeVNs
         D0pg9qpy77kb1xC1fcTQjo259xrqLtaOegahjavG/83MN0YkMBd+JGxw2oY7rfmUVr6W
         vZP3YR4lX2zWTxndHfvXs7NzWt6E05CvIU0hGRjcMjSi2zYI55C6EAvN5jPo4Gi1azxc
         y4sw==
X-Gm-Message-State: ACgBeo2lbanEgHLYm526y+s8RuZ+9zPWwU3vR7KmKnou7QNRPdA6Yg8h
        /pEziArtB/Q9J33ChNJYeqedThFx2Ua59qVDIpJG1g==
X-Google-Smtp-Source: AA6agR5r9ZcarTd+JxlgKjeNemprNXlpaQlz44ZI2m2BtbWl8maVPUO1tfGSLyzHsa05f3LaNVlOdbY4+TmYHuX6tEs=
X-Received: by 2002:a05:622a:1984:b0:342:ea3d:696e with SMTP id
 u4-20020a05622a198400b00342ea3d696emr17244054qtc.7.1660135440294; Wed, 10 Aug
 2022 05:44:00 -0700 (PDT)
MIME-Version: 1.0
References: <1660117763-38322-1-git-send-email-liyonglong@chinatelecom.cn>
In-Reply-To: <1660117763-38322-1-git-send-email-liyonglong@chinatelecom.cn>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 10 Aug 2022 08:43:44 -0400
Message-ID: <CADVnQym47_uqqKWkGnu7hA+vhHjvURMmTdd0Xx6z8m_mspwFJw@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: adjust rcvbuff according copied rate of user space
To:     Yonglong Li <liyonglong@chinatelecom.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        ycheng@google.com, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 3:49 AM Yonglong Li <liyonglong@chinatelecom.cn> wrote:
>
> every time data is copied to user space tcp_rcv_space_adjust is called.
> current It adjust rcvbuff by the length of data copied to user space.
> If the interval of user space copy data from socket is not stable, the
> length of data copied to user space will not exactly show the speed of
> copying data from rcvbuff.
> so in tcp_rcv_space_adjust it is more reasonable to adjust rcvbuff by
> copied rate (length of copied data/interval)instead of copied data len
>
> I tested this patch in simulation environment by Mininet:
> with 80~120ms RTT / 1% loss link, 100 runs
> of (netperf -t TCP_STREAM -l 5), and got an average throughput
> of 17715 Kbit instead of 17703 Kbit.
> with 80~120ms RTT without loss link, 100 runs of (netperf -t
> TCP_STREAM -l 5), and got an average throughput of 18272 Kbit
> instead of 18248 Kbit.

So with 1% emulated loss that's a 0.06% throughput improvement and
without emulated loss that's a 0.13% improvement. That sounds like it
may well be statistical noise, particularly given that we would expect
the steady-state impact of this change to be negligible.

IMHO these results do not justify the added complexity and state.

best regards,
neal
