Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0774DE189
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbiCRTAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 15:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233921AbiCRTAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 15:00:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E978D24F293
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 11:59:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C1CB823E1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 18:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A5AC340ED;
        Fri, 18 Mar 2022 18:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647629966;
        bh=ItVksmYMyfWlkYtvOXNIQ2ZPVnHXF/gX8FDtoNefrSo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p7RQneJmIilWrd5poTLKe+aOzgwuPb88e7vQyyV8HP8EVgTRHxgJX8PUmF6cVMw0M
         WjXB4lRP26H+I/+a66xkdw7ECPcTXGCmcQT/apjVwg9lU2I1FkHyLT54ro9OQH8U6A
         2boesM33g6wKSf6y5gXo22HXzCmrUiNE39i3/rPFTwaiqWkhwxht/bVrZSPUeI14xn
         6z1MrUq1/XmtAj5EpNQ3wXTXZ+Oe3e+6klsQ73KorFT3cnC7/Uo0vRU8qlriTjWOM6
         LnEU8+PcE043E3CqQ3WO/bTO/6hN+3iQG6HIZLZFTXT3zJUwLf1Y/nMg+M1juiIT1H
         uYX0vVRavTphQ==
Date:   Fri, 18 Mar 2022 11:59:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH net-next] net: Add lockdep asserts to
 ____napi_schedule().
Message-ID: <20220318115920.71470819@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHmME9oHFzL6CYVh8nLGkNKOkMeWi2gmxs_f7S8PATWwc6uQsw@mail.gmail.com>
References: <YitkzkjU5zng7jAM@linutronix.de>
        <YjPlAyly8FQhPJjT@zx2c4.com>
        <YjRlkBYBGEolfzd9@linutronix.de>
        <CAHmME9oHFzL6CYVh8nLGkNKOkMeWi2gmxs_f7S8PATWwc6uQsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 12:19:45 -0600 Jason A. Donenfeld wrote:
> > In your case it is "okay" since that ptr_ring_consume_bh() will do BH
> > disable/enable which forces the softirq to run. It is not obvious.  
> 
> In that case, isn't the lockdep assertion you added wrong and should
> be reverted? If correct code is hitting it, something seems wrong...

FWIW I'd lean towards revert as well, I can't think of a simple
fix that won't require work arounds in callers.
