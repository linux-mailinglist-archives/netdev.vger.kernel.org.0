Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D73B6E1B98
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjDNFUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjDNFUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432584EEA
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D093B6152B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 05:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE8AC433D2;
        Fri, 14 Apr 2023 05:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681449603;
        bh=AO+CK/LVs2Rq2rNrrHwDaI8MQ69cixJEm7SgURPkxWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LhgHomVvfMeWad0Q5ZYTtw3POsEdgSxYCLEKg8OtJuzQfefPIXNK29Fz8KWaSuVqQ
         bz1ilO6pT6sjWAyOEAc2bDwG715YEMY3TBNZZ3dwknAEwNcLfrtsmt1ri1WDwYSxzk
         cSAtlO8/+7unPONSflKyWotAiPXa6+I2u+GCIkOQ9FULb7r167Vd8hlfPdXb1sVl+N
         tB1+/sCGNDJN9CHXyl+kyG3sFO4GuamGWlnkyqm8xNbZR22hRwOFFfCY1QeWC+fSqA
         iNsrxBJpeL5+BVBBpkFTmjLOWgLZ3/rUp9SXmAcWEvC0lxQmK19RTEmXAcUMRnK8d4
         FzgWxGr2AOFOA==
Date:   Thu, 13 Apr 2023 22:20:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Eric Dumazet <edumazet@google.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <alexander.duyck@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next v2 1/3] net: skb: plumb napi state thru skb
 freeing paths
Message-ID: <20230413222001.78fdc9a4@kernel.org>
In-Reply-To: <dd743d1e-d8a1-58d5-5b1f-8583d0f23b9f@huawei.com>
References: <20230413042605.895677-1-kuba@kernel.org>
        <20230413042605.895677-2-kuba@kernel.org>
        <4447f0d2-dd78-573a-6d89-aa1e478ea46b@huawei.com>
        <CANn89iJkg=B0D23q_evwqjRVvm0kcNA=xvSRHVxjgeR00HgEjA@mail.gmail.com>
        <dd743d1e-d8a1-58d5-5b1f-8583d0f23b9f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 08:57:03 +0800 Yunsheng Lin wrote:
> >> Does it break the single-producer single-consumer assumption of tx queue?  
> > 
> > We do not think so.  
> 
> Then I guess it is ok to do direct recycling for page pool case as it is
> per napi?

We're talking about the tx queue or the pp cache?
Those have different producers and consumers.

> It is per cpu cache case we are using !!bugget to protect it from preemption
> while netpoll_poll_dev() is running?

This is the scenario - We are feeding the page pool cache from the
deferred pages. An IRQ comes and interrupts us half way thru. 
netpoll then tries to also feed the page pool cache. Unhappiness.

Note that netpoll is activated extremely rarely (only when something
writes to the console), and even more rarely does it actually poll
for space in the Tx queue.
