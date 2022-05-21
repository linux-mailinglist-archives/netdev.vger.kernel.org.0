Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B31252F6C0
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242045AbiEUA01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiEUA0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:26:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907562253F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 17:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 415F1B82E26
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 00:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E019C385A9;
        Sat, 21 May 2022 00:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653092757;
        bh=1/DZWmvoYDHPTJcAGOk6LAXSXfio2WDcSEGRCHBiIDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G9YtqjKpTdex2JIUiuxja2G588CbFdovYHNtq2M9+x2+z9+7337vYH03LCKm5BV9P
         n8lgylRFWDckD8T5nupqGwrwHfVNRMUdQXcMAalm6wwgHteZH8+nj8SQX+t7bDp+xu
         qbZuGybX0RYnsHMh+m+veEftM8ayj8ti8K9ymWRymv5i58g/PB1f2C4taNZAfFDy8y
         CCOkV/fNIQUSo/Z4VH9X+3AIB0PQDN2At3+8wo/GGkSO9uA1L2+9c5bgtrWfGeeHMt
         xhXIaZfwUVqyWrleV4FMx41ifyBgCuXzFySiP/VFiB8pVwS9w+bV60SD1nzbnjVUd/
         DnQoWZhFsFWeA==
Date:   Fri, 20 May 2022 17:25:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
Message-ID: <20220520172556.1d62b899@kernel.org>
In-Reply-To: <CAMZdPi9z=OM0=yZbBu0eDvFd30efNpt3qmDHuCTj6LGJxdBTbw@mail.gmail.com>
References: <20220519074351.829774-1-william.xuanziyang@huawei.com>
        <CAMZdPi9z=OM0=yZbBu0eDvFd30efNpt3qmDHuCTj6LGJxdBTbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 09:29:12 +0200 Loic Poulain wrote:
> On Thu, 19 May 2022 at 09:26, Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
> >
> > t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> > context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> > GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
> >
> > Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
> > remove the spin_lock from t7xx_cldma_clear_rxq().
> >
> > Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> > Suggested-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>  
> 
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

Wait, you reviewed two different fixes for the same issue?
Please say something when that happens I thought both are needed :/
