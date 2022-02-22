Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C224BFE3A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 17:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbiBVQN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 11:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbiBVQN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 11:13:56 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724EA165C33;
        Tue, 22 Feb 2022 08:13:30 -0800 (PST)
Date:   Tue, 22 Feb 2022 17:13:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645546408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YhcmEsclrus/SSxzTfb+KX5HUaM8qNI+s5zOBCI+RqU=;
        b=h1Or7OdsITsOrHavCBKVGK4Jw4yU9/DP8aZ4vE6k6IKc03V+EG+nENBBQ0LjOuMYHW7xbV
        FFxNIGwC9PMHN+nYGQQd4ZRK3+qLkbKsx7J3Y0CLYt/Ghrtj5EOjhDbNeahGNOnw97F2il
        ljjeOMnbT63QtepMYN8NYkIP4qzOpM+9Hs+ZLQoLBWMnIgJPPMbtYQSkmzMDMxGp+F49Mx
        nqcy9HGE7OWQ/QePKbEc/3WovsjQkJb+1FBuXYgKoL9Ux8mfJ8WIUwjcfokDcD2rDGJQ0y
        ZH/vhj2Qz1Ut5otnUvRzOBGcaHRC9Z9aTwdlqvgm8aLtYKzq6Ukt/wBPR16aLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645546408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YhcmEsclrus/SSxzTfb+KX5HUaM8qNI+s5zOBCI+RqU=;
        b=e0dQQzmDdcMpykO0yE8PATaDHIYrNB+vrCU88aymBH/CHZRYtnyM5/T+usiAzQ2KMmZa8H
        LLVE0dQSz57AcXAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <YhULprI8YK7YxFo9@linutronix.de>
References: <20220211233839.2280731-1-bigeasy@linutronix.de>
 <20220211233839.2280731-3-bigeasy@linutronix.de>
 <CGME20220216085613eucas1p1d33aca0243a3671ed0798055fc65dc54@eucas1p1.samsung.com>
 <da6abfe2-dafd-4aa1-adca-472137423ba4@samsung.com>
 <alpine.DEB.2.22.394.2202221622570.372449@ramsan.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.22.394.2202221622570.372449@ramsan.of.borg>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-22 16:30:37 [+0100], Geert Uytterhoeven wrote:
> 	Hi Sebastian,

Hi Geert,

> Similar on rbtx4927 (CONFIG_NE2000=y), where I'm getting a slightly
> different warning:

Based on the backtrace the patch in
   https://lore.kernel.org/all/Yg05duINKBqvnxUc@linutronix.de/

should fix it, right?

Sebastian
