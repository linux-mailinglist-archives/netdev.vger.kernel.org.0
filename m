Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD7598A3A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344764AbiHRRQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344939AbiHRRQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:16:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778FFD6307;
        Thu, 18 Aug 2022 10:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE985B8203A;
        Thu, 18 Aug 2022 17:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06933C433D6;
        Thu, 18 Aug 2022 17:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660842587;
        bh=X/mzeR/Hc1T7Mm4M+QCP88igzJY+5Z5jIMLSgCc/aNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IjDMjn6dusOsplNQVuak1CIKAleHvck0KLlOabTaUIDzwUrSy/8zwz9BUzHIhf5Ia
         fHDIfTZsv85UApg86VFDYEnKKHpfW57AaHpPFBTxh89RGAmtruV0+ajHW1WkIPY+U8
         OVz3PTnqkZXmjkeEi4BGFtxhWlzU+Pvy4RgHt5pmMVWcIUQlFuRan/mJqmeprPYF5K
         IxI2IaucrfyOb7BhjYYMCGoKsbzC7hUG9KowaRpBoCR7Vb3l1Uxw6xYU9b6Gp3V6oJ
         Y+XjJbPQ1BF9QHzxx0tzZzABG1VFBDN/19LoFrwJbwUQPlLquXbGy3PGDAoTvojgcU
         s5V1DkjWdFnag==
Date:   Thu, 18 Aug 2022 10:09:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     miguel.ojeda.sandonis@gmail.com, ojeda@kernel.org,
        ndesaulniers@google.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: skb: prevent the split of
 kfree_skb_reason() by gcc
Message-ID: <20220818100946.6ad96b06@kernel.org>
In-Reply-To: <20220816032846.2579217-1-imagedong@tencent.com>
References: <20220816032846.2579217-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 11:28:46 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Sometimes, gcc will optimize the function by spliting it to two or
> more functions. In this case, kfree_skb_reason() is splited to
> kfree_skb_reason and kfree_skb_reason.part.0. However, the
> function/tracepoint trace_kfree_skb() in it needs the return address
> of kfree_skb_reason().
> 
> This split makes the call chains becomes:
>   kfree_skb_reason() -> kfree_skb_reason.part.0 -> trace_kfree_skb()
> 
> which makes the return address that passed to trace_kfree_skb() be
> kfree_skb().
> 
> Therefore, prevent this kind of optimization to kfree_skb_reason() by
> making the optimize level to "O1". I think these should be better
> method instead of this "O1", but I can't figure it out......
> 
> This optimization CAN happen, which depend on the behavior of gcc.
> I'm not able to reproduce it in the latest kernel code, but it happens
> in my kernel of version 5.4.119. Maybe the latest code already do someting
> that prevent this happen?
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Sorry for a late and possibly off-topic chime in, is the compiler
splitting it because it thinks that skb_unref() is going to return 
true? I don't think that's the likely case, so maybe we're better 
off wrapping that skb_unref() in unlikely()?
