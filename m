Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB32646528
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiLGXdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiLGXc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:32:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138114A06E;
        Wed,  7 Dec 2022 15:32:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F8F661CC3;
        Wed,  7 Dec 2022 23:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985E0C433D7;
        Wed,  7 Dec 2022 23:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670455978;
        bh=9V/tSj1MC6haUX53CF4MlWlMbZ+0XTqLnjv/nyTLL8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sJlnj21TtG54j5DG8cjvXLBtINBst4m1ZaqvJpLF56n6b3JG2EfsC/daKoGk6Pvun
         IjuN2XscB7twKTDl5Pid1opkH5o7N9GP437h0AyFsAgHCfnMnLL4AjCCM1FGbHAvNP
         BIlV1LDUdbdjqXGbV+6+rKDxMGgrYYN9QEC8OUg5v2i+g6IRc0LBCjy5/LQY8yq5aX
         j24IGjQfPbcK7MUfyA+F+Ih1cZ1+xZ0sEWb6ukNu6o77V3dz3xEm7ZUii7nmAt76bl
         q2/GLEXTYNIICeO3uBTMhcZ0wBGvJzb7fXIP4qKyImCErSDSGWmIlSIW+pH0U8a59r
         kJ17tArTMU7pw==
Date:   Wed, 7 Dec 2022 15:32:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <edumazet@google.com>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tedheadster@gmail.com>
Subject: Re: [PATCH linux-next] net: record times of netdev_budget exhausted
Message-ID: <20221207153256.6c0ec51a@kernel.org>
In-Reply-To: <202212072030084707211@zte.com.cn>
References: <CANn89iKqb64sLT2r+2YrpDyMfZ8T6z2Ygtby-ruVNNYvniaV0g@mail.gmail.com>
        <202212072030084707211@zte.com.cn>
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

On Wed, 7 Dec 2022 20:30:08 +0800 (CST) yang.yang29@zte.com.cn wrote:
> > Presumably, modern tracing techniques can let you do what you want
> > without adding new counters.  
> 
> By the way, should we add a tracepoint likes trace_napi_poll() to make
> it easier? Something likes:
>         if (unlikely(budget <= 0 ||
>                  time_after_eq(jiffies, time_limit))) {
>             sd->time_squeeze++;
> +            trace_napi_poll(budget, jiffies, time_limit);
>             break;
>         }

In my experience - no this is not useful.

Sorry if this is too direct, but it seems to me like you're trying hard
to find something useful to do in this area without a clear use case. 
We have coding tasks which would definitely be useful and which nobody
has time to accomplish. Please ask if you're trying to find something
to do.
