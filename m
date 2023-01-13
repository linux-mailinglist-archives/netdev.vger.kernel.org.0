Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD4066935A
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241171AbjAMJxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239638AbjAMJxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A03A7BDCD;
        Fri, 13 Jan 2023 01:49:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DAAA6112C;
        Fri, 13 Jan 2023 09:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB670C433EF;
        Fri, 13 Jan 2023 09:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673603340;
        bh=1LY5Wahlmj+cAfehHuOC3snGF6O3X/tHawwgCwx8Gfo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IGTsIaOkP5VsQOv/TdhT0y71HwxxZ0BeUQ+lv/GcI6Zg7TNUGZEu0jIQTbHOJH1bF
         rupjBUdUSBirha+/W3JKiRC1xk7xnRCJM8TiYMXH5p9SMjtikeVbnrX+5WRvGn/2Nh
         GGQUPBiaLFsI5VQkfA8hL0hsiOertllCuVVO0oEodMrZsGqNyv9dItDUk4hB4JYqI/
         i9KJ0BwhIDAOPoaumdCywvDwHEbSLVJzI9Xtl55PERCZ2w49UjuAwwGuaHIE+5Xj9m
         Rf57WBOuLhoSyqSGQ2i20AMeFM9KZYR0SmuW28jpMh+NXGs/giziNYOZx8RxWQC5vK
         jzZYCc4O7Na1A==
Message-ID: <2fc741b2-671d-8817-1d6f-511398aea9ff@kernel.org>
Date:   Fri, 13 Jan 2023 11:48:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 0/5] Add PPS support to am65-cpts driver
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, nm@ti.com, kristo@kernel.org,
        vigneshr@ti.com, nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230111114429.1297557-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Siddharth,

On 11/01/2023 13:44, Siddharth Vadapalli wrote:
> The CPTS hardware doesn't support PPS signal generation. Using the GenFx
> (periodic signal generator) function, it is possible to model a PPS signal
> followed by routing it via the time sync router to the CPTS_HWy_TS_PUSH
> (hardware time stamp) input, in order to generate timestamps at 1 second
> intervals.
> 
> This series adds driver support for enabling PPS signal generation.
> Additionally, the documentation for the am65-cpts driver is updated with
> the bindings for the "ti,pps" property, which is used to inform the
> pair [CPTS_HWy_TS_PUSH, GenFx] to the cpts driver. The PPS example is
> enabled for AM625-SK board by default, by adding the timesync_router node
> to the AM62x SoC, and configuring it for PPS in the AM625-SK board dts.
> 
> Grygorii Strashko (3):
>   dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
>   net: ethernet: ti: am65-cpts: add pps support
>   net: ethernet: ti: am65-cpts: adjust pps following ptp changes
> 
> Siddharth Vadapalli (2):
>   arm64: dts: ti: k3-am62-main: Add timesync router node
>   arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts PPS support

Device tree patches need to be sent separately. You don't need to involve
net maintainers for that.

If you introduce a new binding then that needs to be in maintainer's
tree before you can send a related device tree patch.

> 
>  .../bindings/net/ti,k3-am654-cpts.yaml        |   8 +
>  arch/arm64/boot/dts/ti/k3-am62-main.dtsi      |   9 ++
>  arch/arm64/boot/dts/ti/k3-am625-sk.dts        |  20 +++
>  drivers/net/ethernet/ti/am65-cpts.c           | 144 ++++++++++++++++--
>  4 files changed, 166 insertions(+), 15 deletions(-)
> 

cheers,
-roger
