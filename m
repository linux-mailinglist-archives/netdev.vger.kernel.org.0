Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4DF54F4EA
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381550AbiFQKIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241506AbiFQKIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:08:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4136E7678
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 03:08:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC80D61D41
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 10:08:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04759C3411B;
        Fri, 17 Jun 2022 10:08:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="C9HPv/0+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655460498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Y2Wd4fft12vfWGI3rTHWYLgSUwPJOPtjcV76VBfuEM=;
        b=C9HPv/0+Fp0HWh8/NREjljoNnzbN3ADdO1ZU8GqMEI97Y775YvhBMqrs7+BQeWTYts1rog
        swORyfuFYMJDkiF29wNKrKmbi71U/MgAc09yHwos38ji08ezZnPIbZAd/xT0z0N3gFCDQk
        KnsbpUSkH+0JE8+N5jkYJdnYUPJqBOo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fc2c262a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 17 Jun 2022 10:08:17 +0000 (UTC)
Date:   Fri, 17 Jun 2022 12:08:14 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next 2/2] tcp: fix possible freeze in tx path
 under memory pressure
Message-ID: <YqxSa9Ir1TUZs4zd@zx2c4.com>
References: <20220614171734.1103875-1-eric.dumazet@gmail.com>
 <20220614171734.1103875-3-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220614171734.1103875-3-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jun 14, 2022 at 10:17:34AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Blamed commit only dealt with applications issuing small writes.
> 
> Issue here is that we allow to force memory schedule for the sk_buff
> allocation, but we have no guarantee that sendmsg() is able to
> copy some payload in it.
> 
> In this patch, I make sure the socket can use up to tcp_wmem[0] bytes.
> 
> For example, if we consider tcp_wmem[0] = 4096 (default on x86),
> and initial skb->truesize being 1280, tcp_sendmsg() is able to
> copy up to 2816 bytes under memory pressure.
> 
> Before this patch a sendmsg() sending more than 2816 bytes
> would either block forever (if persistent memory pressure),
> or return -EAGAIN.
> 
> For bigger MTU networks, it is advised to increase tcp_wmem[0]
> to avoid sending too small packets.
> 
> v2: deal with zero copy paths.

I think this might have gotten double applied:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=849b425cd091e1804af964b771761cfbefbafb43
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f54755f6a11accb2db5ef17f8f75aad0875aefdc

and now net-next builds are broken:

../../../../../../../../net/ipv4/tcp.c:971:12: error: redefinition of ‘tcp_wmem_schedule’
  971 | static int tcp_wmem_schedule(struct sock *sk, int copy)                                |            ^~~~~~~~~~~~~~~~~
../../../../../../../../net/ipv4/tcp.c:954:12: note: previous definition of ‘tcp_wmem_schedule’ with type ‘int(struct sock *, int)’
  954 | static int tcp_wmem_schedule(struct sock *sk, int copy)                                |            ^~~~~~~~~~~~~~~~~
../../../../../../../../net/ipv4/tcp.c:954:12: warning: ‘tcp_wmem_schedule’ defined but not used [-Wunused-function]                                                              make[5]: *** [/home/wgci/tmp/2813390.12234/tmp.0PMBO65tGf/scripts/Makefile.build:249: net
/ipv4/tcp.o] Error 1                                                                     make[4]: *** [/home/wgci/tmp/2813390.12234/tmp.0PMBO65tGf/scripts/Makefile.build:466: net/ipv4] Error 2
make[4]: *** Waiting for unfinished jobs....

Jason
