Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA239528D81
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbiEPSzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiEPSy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D3F3EA93
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:54:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19914B810D6
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F06FC385AA;
        Mon, 16 May 2022 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652727295;
        bh=9UQ+bgoQZK5Hs2GxopDoMLmeQ6dZ/1I64kpMffFSyFo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N2DHmKE7tVAzvHJ9BM7QXKLZnzd78J7i6cEdtzjX44Rk4Hpb/CTYaMjvMewNb6VS9
         /X62cPYZZtpanzTK6loDd5LUtBw1xNseeT4VA52KcRD62HPDSI/qDIhIvsh5lu+5uU
         slcY+5uieh+B2B0Vd1HDTgDCLUgJ9VtcIkv3D6lKtsuGG+JRs2BetA8cmfYto6UeEk
         XbOWIEM1N0sCJFEzlQPHpdyz1Yyd1o3lMZujp1oT4geAKcxJLPAacvu2K4Tsw7hISC
         tyzB5Pl1tGZBHHyTZOtmB8sW6jhO6n9XtRfdA0p0pumPNaIlrdSS8nXQpNMTAYMp80
         IYkOObLRWpF+Q==
Date:   Mon, 16 May 2022 11:54:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: fix possible race in
 skb_attempt_defer_free()
Message-ID: <20220516115454.18fbc4e1@kernel.org>
In-Reply-To: <CANn89iJnS5Yyofudjbr7ZO5okRF67w1FRebQ71h3Bg75CA_L+Q@mail.gmail.com>
References: <20220516042456.3014395-1-eric.dumazet@gmail.com>
        <20220516042456.3014395-2-eric.dumazet@gmail.com>
        <20220516111554.5585a6b5@kernel.org>
        <CANn89iJnS5Yyofudjbr7ZO5okRF67w1FRebQ71h3Bg75CA_L+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 May 2022 11:24:40 -0700 Eric Dumazet wrote:
> On Mon, May 16, 2022 at 11:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > If I'm reading this right this is useful for backports but in net-next
> > it really is a noop? The -EBUSY would be perfectly safe to ignore?
> > Just checking.  
> 
> Not sure I understand the question.
> 
> trigger_rx_softirq() and friends were only in net-next, so there is no
> backport needed.
> 
> Are you talking of calls from net_rps_send_ipi() ?
> These are fine, because we own an atomic bit (NAPI_STATE_SCHED).

Ah, I think I get it now. It was unclear what's the problem this patch
is solving this part of the commit message really is key:

> This is a common issue with smp_call_function_single_async().
> Callers must ensure correct synchronization and serialization.

smp_call_function_single_async() does not protect its own internal state
so we need to wrap it in our own locking (of some form thereof).

Sorry for the noise.
