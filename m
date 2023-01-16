Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9245266C630
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 17:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjAPQPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 11:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjAPQPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 11:15:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5DB26595;
        Mon, 16 Jan 2023 08:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8495E6104A;
        Mon, 16 Jan 2023 16:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896FEC433D2;
        Mon, 16 Jan 2023 16:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673885351;
        bh=ur7tHORUQyrdCM/4MJ+pk0qT4B8g0aXNEadfNDhRriY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NQL8P9uvdVVmhK7QIRodTU6aesg0/i8PrQ42FrfshDqGkA/7GxErpMxdtRYqMSSUw
         EKTt18VC7nK9mY+O6BRYZjONHm8DpjKSRumqKLAF3/Lu/WA7hOhGMP45lFcuu8Zzgr
         uojIrghNTEJ2Jyx8WC9uyNO4om537OnIlnAZKJ2DtlQFFluBh7n4J06j7IJq81pMTW
         ewdqBIBt3UQFZ3d88EQak6maREC/6/tYQloSSeru2tVc0hA8fuUogETBr+RABjQI2l
         SedGfxo67w4lqFFCx2IChCBvmjiiVhzMIJAlw0M/giOwRDYSQ4Qum2yI5G89tf1Vr9
         gUxEnBf6PbHpw==
Message-ID: <0fdd9e9b-c6ac-b5c3-adb5-01a764a7b8f6@kernel.org>
Date:   Mon, 16 Jan 2023 18:09:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: ti: am65-cpts: add pps
 support
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, vigneshr@ti.com, nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230116085534.440820-1-s-vadapalli@ti.com>
 <20230116085534.440820-3-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230116085534.440820-3-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16/01/2023 10:55, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> CPTS doesn't have HW support for PPS ("pulse per second”) signal
> generation, but it can be modeled by using Time Sync Router and routing
> GenFx (periodic signal generator) output to CPTS_HWy_TS_PUSH (hardware time
> stamp) input, and configuring GenFx to generate 1sec pulses.
> 
>      +------------------------+
>      |          CPTS          |
>      |                        |
>  +--->CPTS_HW4_PUSH      GENFx+---+
>  |   |                        |   |
>  |   +------------------------+   |
>  |                                |
>  +--------------------------------+
> 
> Add corresponding support to am65-cpts driver. The DT property "ti,pps"
> has to be used to enable PPS support and configure pair
> [CPTS_HWy_TS_PUSH, GenFx].
> 
> Once enabled, PPS can be tested using ppstest tool:
>  # ./ppstest /dev/pps0
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
