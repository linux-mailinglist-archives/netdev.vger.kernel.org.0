Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7450A515772
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353438AbiD2V5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349622AbiD2V5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:57:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177F526549;
        Fri, 29 Apr 2022 14:54:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF34B835F1;
        Fri, 29 Apr 2022 21:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D5DC385AC;
        Fri, 29 Apr 2022 21:53:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="m/dtNXZb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651269236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mn3JSI7bM+4zDYNaL/aKzg64etYHLIe8pEdP6yUDjKI=;
        b=m/dtNXZbVfkodWL1Au+zm2bUJFMYnke7DcKuQdah0MUfxHB2B1Q9ivjufyZqV2R1MqYFsc
        303lGMJRUPOPeWn5McYltn+hOtuGfNMYn1cuor0ibPqaTuNcTz34ep26ZDFUJvXCTxZKHe
        vwfE03DYmLEVAiGBOohmdyAyNES/EKo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4a149c2e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 29 Apr 2022 21:53:56 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id d12so16725707ybc.4;
        Fri, 29 Apr 2022 14:53:56 -0700 (PDT)
X-Gm-Message-State: AOAM531SKhVGuJWJ/xxRv6kRABsAb7QiYKg+ZB/QL5EghUZNnIjHE7JT
        QtlWk1rYUPiR0yqs2/TX0O0JsLn6hetFWlcSAFA=
X-Google-Smtp-Source: ABdhPJyNZroLS5iMypebjYUGTBgFUopOo4fAq7jpbTJBL+j/zs5z9L48Ho1oKqELtGbuoFWxvW4HyIKM0M+w0Ey3V5c=
X-Received: by 2002:a25:c807:0:b0:649:a5c:a21 with SMTP id y7-20020a25c807000000b006490a5c0a21mr1502634ybf.637.1651269235080;
 Fri, 29 Apr 2022 14:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9r_DbZWe4FsfebHSSf_iPctSe5S-w9bU3o8BN43raeURg@mail.gmail.com>
 <20151116203709.GA27178@oracle.com> <CAHmME9pNCqbcoqbOnx6p8poehAntyyy1jQhy=0_HjkJ8nvMQdw@mail.gmail.com>
 <1447712932.22599.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
 <YmszSXueTxYOC41G@zx2c4.com> <04f72c85-557f-d67c-c751-85be65cb015a@gmail.com>
 <YmxTo2hVwcwhdvjO@zx2c4.com> <d9854c74-c209-9ea5-6c76-8390e867521b@gmail.com>
In-Reply-To: <d9854c74-c209-9ea5-6c76-8390e867521b@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 29 Apr 2022 23:53:44 +0200
X-Gmail-Original-Message-ID: <CAHmME9qXC-4OPc5xRbC6CQJcpzb96EXzNWAist5A8momYxvVUA@mail.gmail.com>
Message-ID: <CAHmME9qXC-4OPc5xRbC6CQJcpzb96EXzNWAist5A8momYxvVUA@mail.gmail.com>
Subject: Re: Routing loops & TTL tracking with tunnel devices
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>
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

Hi Eric,

On Fri, Apr 29, 2022 at 11:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 4/29/22 14:07, Jason A. Donenfeld wrote:
>
> Hi Eric,
>
> On Fri, Apr 29, 2022 at 01:54:27PM -0700, Eric Dumazet wrote:
>
> Anyway, it'd be nice if there were a free u8 somewhere in sk_buff that I
> could use for tracking times through the stack. Other kernels have this
> but afaict Linux still does not. I looked into trying to overload some
> existing fields -- tstamp/skb_mstamp_ns or queue_mapping -- which I was
> thinking might be totally unused on TX?
>
> if skbs are stored in some internal wireguard queue, can not you use
> skb->cb[],
>
> like many other layers do ?
>
> This isn't for some internal wireguard queue. The packets get sent out
> of udp_tunnel_xmit_skb(), so they leave wireguard's queues.
>
>
> OK, where is the queue then ?
>
> dev_xmit_recursion() is supposed to catch long chains of virtual devices.

This is the long-chain-of-virtual-devices case indeed. But
dev_xmit_recursion() does not help here, since that's just a per-cpu
increment, assuming that the packet actually gets xmit'd in its
ndo_start_xmit function. But in reality, wireguard queues up the
packet, encrypts it in some worker later, and eventually transmits it
with udp_tunnel_xmit_skb(). All the while ndo_start_xmit() has long
returned. So no help from dev_xmit_recursion().

Jason
