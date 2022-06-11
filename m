Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1525477A7
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 23:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiFKVOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 17:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiFKVOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 17:14:05 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04DE956381
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 14:14:04 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l4so1203421pgh.13
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 14:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWER0SmUvIBwwDkFXZrRAKPa8TTx7S/dE6hpiPQkDY8=;
        b=qVi46tCNjyARGo+PR6oEGL6fJTFRLoVtdWAf8RrUdb+50s+TsxYl80HYYbrkLKqRGt
         8BdE5OlQJNRO5o/Kbz/4IQnRJrnTCBKlfEPwD6OywzQqJaUSDV+tpiQNAvDHZT7vqg8W
         rIvENv31VJClLkhJ0wJhzS+jZIPvyFNwZlpbewuRWSNMkt5nQaDNUU4UMCBxObWln6CQ
         C5nL3IEpjwintmp+1WL6jA0vVlOILtjblA3zHM2JNmUTNcHZ4mg0qI8Ti63/4iWSnMsd
         hppXTlzzWXrqEZvUrBETBtniB2XDyZtHacYMj55OUcpYCwgi6EOKBTHy9dIZ+GefCQVK
         OjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWER0SmUvIBwwDkFXZrRAKPa8TTx7S/dE6hpiPQkDY8=;
        b=YPhfjcH/dCx6/msPmz2wgV0OmDE4FY7+AcI2wQPypEMLLCt+LTckM6nd70alJhjoRD
         cozEaFpUdv+OWlKPuC04JcGihZdXJsCLV7Z6WIUMfQL1b1vwlbGOyJclJNxaEZCD5gxj
         ryohBQjO2PvNTZrv9eT12dxnIN1XBDGXbJVQrqypgYYroS7w0gxaa0aKT2vqmoM3qaya
         Eqq0MAlizN35O3iKH6mXbjm3at8khfBdNxgyzpchG4zk54gQm6R/rav+j/6GaEg4SGd2
         ubAOecQ7ZUcFRkR+HJtDA/e6YolOQOaqpnOImkmSaQMMsmQB+aC4+aoUeDVZySg/PGSg
         iJRw==
X-Gm-Message-State: AOAM532k1m2uwAUAQgbSp/699GlkNfzVFIrpai/Cx/1iqOpZqqt6uAsm
        K+T3W1/eLr87Tg08YPzYiMr+8o+bfBFLgTIopJ+j0A==
X-Google-Smtp-Source: ABdhPJwVqIfgANpYsFiUS2mbBK3SK+f7e1Fy9D8BZ5Lej/mPw5hmP81zmy8NeNfqsKU0+6oCAXrpAhzHOdECDaPU1T0=
X-Received: by 2002:a05:6a00:889:b0:510:91e6:6463 with SMTP id
 q9-20020a056a00088900b0051091e66463mr52628892pfj.58.1654982043255; Sat, 11
 Jun 2022 14:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220611033016.3697610-1-eric.dumazet@gmail.com>
In-Reply-To: <20220611033016.3697610-1-eric.dumazet@gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sat, 11 Jun 2022 14:13:52 -0700
Message-ID: <CALvZod55M7Dnjp0HWJem4k4NLkptbSY+=fkA1Nie=mZ8cD2Fng@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: sk_forced_mem_schedule() optimization
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
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

On Fri, Jun 10, 2022 at 8:30 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> sk_memory_allocated_add() has three callers, and returns
> to them @memory_allocated.
>
> sk_forced_mem_schedule() is one of them, and ignores
> the returned value.
>
> Change sk_memory_allocated_add() to return void.
>
> Change sock_reserve_memory() and __sk_mem_raise_allocated()
> to call sk_memory_allocated().
>
> This removes one cache line miss [1] for RPC workloads,
> as first skbs in TCP write queue and receive queue go through
> sk_forced_mem_schedule().
>
> [1] Cache line holding tcp_memory_allocated.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
