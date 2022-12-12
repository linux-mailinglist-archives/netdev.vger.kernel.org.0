Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6BA649AFF
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiLLJWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiLLJV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:21:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C840D50;
        Mon, 12 Dec 2022 01:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1805E60F39;
        Mon, 12 Dec 2022 09:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC63BC433D2;
        Mon, 12 Dec 2022 09:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670836861;
        bh=lC6luI6DCbVTais4yXR5+kEUwbcuUmGiAsYYh+6zc8Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=lKqCbvpPP275sYFbjwH4DF6Ydmerw6HU4eYdDcn8E1vSCj1sEV8mmt4JaoNXiyt75
         FDHm467qkI9WuOEh7qN6op7obJjyWhfDPtpBk4dKxk3NtAv/SIaRfy0AUVcinbTnZm
         PwV+xUQ3cZudkqOiG0GuO7MJfxt5/H9bkJdU8YRG6T+/48Lfbi6k7iOb2qZIoY0bmu
         TMfnoRVFtk+ucadZR9ldC7ULO5VTI1StELMdV2dnJE8/shBDtfOg24B3DwfBkfyhMe
         bN5U4VHvlTsDyWZPe6y2HA7Lh7/lPRDlu9+tRl/LV3pX+0KaR+ctoTjTIr3UeQ/6AA
         6WSN7AHzrR1PQ==
Message-ID: <f5076356-495b-c42d-e22a-7207dfb1fb3b@kernel.org>
Date:   Mon, 12 Dec 2022 11:20:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: Fix PM runtime
 leakage in am65_cpsw_nuss_ndo_slave_open()
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, s-vadapalli@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221208105534.63709-1-rogerq@kernel.org> <Y5PY1Cdp3px3vRqE@x130>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <Y5PY1Cdp3px3vRqE@x130>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/2022 02:54, Saeed Mahameed wrote:
> On 08 Dec 12:55, Roger Quadros wrote:
>> Ensure pm_runtime_put() is issued in error path.
>>
>> Reported-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> 
> 
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> 
> 
> [...]
> 
>> @@ -622,6 +623,10 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
>> error_cleanup:
>>     am65_cpsw_nuss_ndo_slave_stop(ndev);
> 
> BTW, while looking at the ndo_slave_stop() call, it seems to abort if am65_cpsw_nuss_common_stop() fails, but looking deeper at that and it seems am65_cpsw_nuss_common_stop() can never fail, so you might want to fix that.

You mean we should change it to return void and get rid of error checks on that function. Right?

> 
>>     return ret;
>> +
>> +runtime_put:
>> +    pm_runtime_put(common->dev);
>> +    return ret;
>> }
>>
>> static void am65_cpsw_nuss_rx_cleanup(void *data, dma_addr_t desc_dma)
>> -- 
>> 2.34.1
>>

cheers,
-roger
