Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE7F86693F7
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbjAMKXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240805AbjAMKWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:22:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9996C5830F;
        Fri, 13 Jan 2023 02:21:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A6EC61129;
        Fri, 13 Jan 2023 10:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47A4C433EF;
        Fri, 13 Jan 2023 10:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673605304;
        bh=QJB4bPL/qxvG2LxsovNGnWYa2fcv/xAVjbx4c/RVED0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OQ8m4D+3wF4Chb2uthGQTjVojqbZNyoIz2Ni4i2cGVW7CudPublYKRnf+S6MHLwII
         CQ7XocZJelHMgEP0dTE/0keJs7mqddkdhnaqnU+Hzn3UhbMXGZhVE3mZQC74I/007j
         JiZOocVsn40T2mctTSNOAsUg/HW93u1cl6/oC9nkaM3nBgFZkDYqZyWYjkRUxtFQwS
         VwlFQJXdlbuHimPQKmBRUdsSDfXCt5d8G2WSrX2LkvPmmEl2ItoCjaoGLo+0GKeVil
         fEmuds6/Yj+IX2ejHxxdZh8lqSUUSk7+emTULe2V2muZgQcwCYkfRP+ZLjbO7J8GHL
         eGFPjQTqhR3HA==
Message-ID: <14dfa3ac-344f-5185-fd83-06b3c9884b5c@kernel.org>
Date:   Fri, 13 Jan 2023 12:21:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 0/5] Add PPS support to am65-cpts driver
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        nm@ti.com, kristo@kernel.org, vigneshr@ti.com, nsekhar@ti.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <2fc741b2-671d-8817-1d6f-511398aea9ff@kernel.org>
 <19566370-3cf1-09fd-119f-c39c0309eb6d@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <19566370-3cf1-09fd-119f-c39c0309eb6d@ti.com>
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



On 13/01/2023 11:56, Siddharth Vadapalli wrote:
> Hello Roger,
> 
> On 13/01/23 15:18, Roger Quadros wrote:
>> Siddharth,
>>
>> On 11/01/2023 13:44, Siddharth Vadapalli wrote:
>>> The CPTS hardware doesn't support PPS signal generation. Using the GenFx
>>> (periodic signal generator) function, it is possible to model a PPS signal
>>> followed by routing it via the time sync router to the CPTS_HWy_TS_PUSH
>>> (hardware time stamp) input, in order to generate timestamps at 1 second
>>> intervals.
>>>
>>> This series adds driver support for enabling PPS signal generation.
>>> Additionally, the documentation for the am65-cpts driver is updated with
>>> the bindings for the "ti,pps" property, which is used to inform the
>>> pair [CPTS_HWy_TS_PUSH, GenFx] to the cpts driver. The PPS example is
>>> enabled for AM625-SK board by default, by adding the timesync_router node
>>> to the AM62x SoC, and configuring it for PPS in the AM625-SK board dts.
>>>
>>> Grygorii Strashko (3):
>>>   dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
>>>   net: ethernet: ti: am65-cpts: add pps support
>>>   net: ethernet: ti: am65-cpts: adjust pps following ptp changes
>>>
>>> Siddharth Vadapalli (2):
>>>   arm64: dts: ti: k3-am62-main: Add timesync router node
>>>   arm64: dts: ti: k3-am625-sk: Add cpsw3g cpts PPS support
>>
>> Device tree patches need to be sent separately. You don't need to involve
>> net maintainers for that.
>>
>> If you introduce a new binding then that needs to be in maintainer's
>> tree before you can send a related device tree patch.
> 
> Thank you for letting me know. Would I need to resend the series in order for it
> to be reviewed? I was hoping that if I get feedback for this series, I will
> implement it and post just the bindings and driver patches as the v2 series,
> dropping the device tree patches. Please let me know.

You could wait a couple of days for more comments here before spinning off a v2 ;)

cheers,
-roger
