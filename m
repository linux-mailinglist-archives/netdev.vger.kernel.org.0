Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8E2690A5B
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjBINfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjBINex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:34:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32095FB50;
        Thu,  9 Feb 2023 05:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1515B8212D;
        Thu,  9 Feb 2023 13:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370A5C433D2;
        Thu,  9 Feb 2023 13:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675949629;
        bh=oVN64FqEr+efwuF26PEuL8gATG0G1/6rAPqudX6DOdg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CZExgqAzn+K1qkk9d5dSa5leUc0ZpST/jwUncEouLhp7NN/J8uHtK5XCuwmh9lZaK
         /HsOXM9rEQ7YBP/RoKFPqIOj2XGZO3B5vauogtdxL+/TVBeWsDyVZCwuaKyrDteVaj
         5XPQf1vrk6PQG8MkGsAFlNhRvTVXcaJ3EMUPRuV0Qj4lYnKnvFaNMrYxWpz4nlXg4c
         SAq54i6sK1Gc2Wx4gdQuZ3o8cNBp5hEBZOBW52yn08M4an9CiJq3xZYtwkiBj8c9xA
         2H8QgkOgarYPlRbkgF7/ZX3hsKFobItG58MevfAKuQSxrurSKR5VwaejAguXrQCusf
         i7rBN5w4ThlOw==
Message-ID: <8f8039d1-e344-ff84-a503-a944b0df6e58@kernel.org>
Date:   Thu, 9 Feb 2023 15:33:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: Add RX DMA Channel
 Teardown Quirk
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
References: <20230209084432.189222-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230209084432.189222-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/02/2023 10:44, Siddharth Vadapalli wrote:
> In TI's AM62x/AM64x SoCs, successful teardown of RX DMA Channel raises an
> interrupt. The process of servicing this interrupt involves flushing all
> pending RX DMA descriptors and clearing the teardown completion marker
> (TDCM). The am65_cpsw_nuss_rx_packets() function invoked from the RX
> NAPI callback services the interrupt. Thus, it is necessary to wait for
> this handler to run, drain all packets and clear TDCM, before calling
> napi_disable() in am65_cpsw_nuss_common_stop() function post channel
> teardown. If napi_disable() executes before ensuring that TDCM is
> cleared, the TDCM remains set when the interfaces are down, resulting in
> an interrupt storm when the interfaces are brought up again.
> 
> Since the interrupt raised to indicate the RX DMA Channel teardown is
> specific to the AM62x and AM64x SoCs, add a quirk for it.
> 
> Fixes: 4f7cce272403 ("net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g")
> Co-developed-by: Vignesh Raghavendra <vigneshr@ti.com>
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
