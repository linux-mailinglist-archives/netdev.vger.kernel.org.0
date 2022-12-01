Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE5063FA96
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiLAWbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiLAWbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:31:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE39BE684;
        Thu,  1 Dec 2022 14:31:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59BED62177;
        Thu,  1 Dec 2022 22:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F68C433C1;
        Thu,  1 Dec 2022 22:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669933895;
        bh=zFj+T+nAIMyUg25iDdawyC+U8K2rLsVrPw2FPBwcqa8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=An71A+AvytWtsCceVD3N4iuwv4NYO6YtpgetxaSDT4NDM00X0DKGaMiH1HOrto6V5
         krQ84SSQIgVAQJRVQegJDHikmJV1F+FjZfNqRgjceihbRDI6Y0fobyuOg0PSjCZuCm
         A3RAax7qXR+Qht+FyZ9y5d+zCigWfnYDZgYPBNcpgWsVglTZ314t3Bq7sBmqk1TCDV
         s6QjbsXlf15AmWcD4/fYK3DMbkxRo1Mqs7JJYUWNDqygfAbMlCa1r+13bJmXkTt3Of
         ETHMrJ4H/JX4ux3PtwWKBLZ5znfOLS6lvVMXUxyuswDFSmq5MMhbD0vtUwXxGUWmQk
         1CRvVThP11CcQ==
Date:   Thu, 1 Dec 2022 14:31:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
Message-ID: <20221201143134.6bb285d8@kernel.org>
In-Reply-To: <2081d2ac-b2b5-9299-7239-dc4348ec0d0a@arista.com>
References: <20221123173859.473629-1-dima@arista.com>
        <20221123173859.473629-2-dima@arista.com>
        <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net>
        <2081d2ac-b2b5-9299-7239-dc4348ec0d0a@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Nov 2022 14:28:30 +0000 Dmitry Safonov wrote:
> > What is the plan for merging this? I'm assuming it would want to go
> > through the network tree, but as already noted earlier it depends on a
> > patch I have in tip/locking/core.
> > 
> > Now I checked, tip/locking/core is *just* that one patch, so it might be
> > possible to merge that branch and this series into the network tree and
> > note that during the pull request to Linus.  
> 
> I initially thought it has to go through tip trees because of the
> dependence, but as you say it's just one patch.
> 
> I was also asked by Jakub on v4 to wait for Eric's Ack/Review, so once I
> get a go from him, I will send all 6 patches for inclusion into -net
> tree, if that will be in time before the merge window.

Looks like we're all set on the networking side (thanks Eric!!)

Should I pull Peter's branch? Or you want to just resent a patch Peter
already queued. A bit of an unusual situation..
