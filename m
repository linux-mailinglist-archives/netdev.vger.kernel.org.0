Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9696552F73D
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 03:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354287AbiEUBBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 21:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354240AbiEUBBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 21:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F16532EA
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 18:01:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D411FB82E70
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 01:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40173C34113;
        Sat, 21 May 2022 01:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653094872;
        bh=Ryxe2ZZrchcHMLxEHjbPWYfiG2EoSxWIr+UlZcCmo8c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A0EwjmYuSPJ0TN8mnoGH9SbzuI7zzIGqBE2B5tlkbET3b/JaInnHmKmu4DNvN3gRX
         yjJMaoejHE+Zq2q1H4b4JAH6OxMoA7WWXaUHUeao9NR01k8akhi1EfZLWCH/vGdN+R
         vFvrT63X6tmIkvUSpWFHxpTON95jtt+1qgEXH+F2L7wKQwqIFrfw4IgOFBMphHdAVz
         ndjDdxwYHvgKskOz418aFJDoiZjlXtDPODjjJ2ajpR2WZFGX8Ur3sTxGMYPT6UhY91
         V55qJBay54fGFFawhyW2SAinLaYjrt/IYjDseQiFW7wcOPMMiZjXRX8ReqglqsUmHD
         dk3Rp1TT7Kw4w==
Date:   Fri, 20 May 2022 18:01:11 -0700
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
Message-ID: <20220520180111.7e9b2b84@kernel.org>
In-Reply-To: <20220520172556.1d62b899@kernel.org>
References: <20220519074351.829774-1-william.xuanziyang@huawei.com>
        <CAMZdPi9z=OM0=yZbBu0eDvFd30efNpt3qmDHuCTj6LGJxdBTbw@mail.gmail.com>
        <20220520172556.1d62b899@kernel.org>
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

On Fri, 20 May 2022 17:25:56 -0700 Jakub Kicinski wrote:
> On Thu, 19 May 2022 09:29:12 +0200 Loic Poulain wrote:
> > On Thu, 19 May 2022 at 09:26, Ziyang Xuan <william.xuanziyang@huawei.com> wrote:  
> > >
> > > t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> > > context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> > > GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
> > >
> > > Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
> > > remove the spin_lock from t7xx_cldma_clear_rxq().
> > >
> > > Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> > > Suggested-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > > Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>    
> > 
> > Reviewed-by: Loic Poulain <loic.poulain@linaro.org>  
> 
> Wait, you reviewed two different fixes for the same issue?
> Please say something when that happens I thought both are needed :/

FWIW I pushed out the other one before I realized (they both apply
without conflicts so I thought they fixed different issues)
If this one is preferred please respin and squash a revert of
9ee152ee3ee3 into it.
