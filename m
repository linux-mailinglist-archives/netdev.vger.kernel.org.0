Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE24059EEB2
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbiHWWKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbiHWWKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:10:13 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD822760C7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:10:04 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 6445583F69;
        Wed, 24 Aug 2022 00:10:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1661292602;
        bh=xioLIdO9TaR0ig82ucbbjXVKq4KnRk7EQ5caTcvQ06M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vsgqgUl07KZnwURSvli7ifo8MjccLdqzTAajCfBkNt6XZQcr1jktkDagEmtOgsbKr
         sI0xpj8BaI+csSGeQ4QZW8oWshAC6tiPJYWgHLQiIAA0JwCDgnUZw4KjKRCc4c+O/p
         534foeIPMq2iNe8pzVd99nP+SBsLHCBetZORyYmAbjYQK2CPToyEG5PkpMlXxyK6AL
         qnYwdc48zRB/N9DjuhJnJ7HzzspwAD0B5uxUWo6QtSV/NE3Utd5preVsz4lymIb67M
         7aUC7HdKp3zcHPcGyWiL+2qCGZ0/23gYZbVSYdkL5IUlkIibnXhm/eCeqevngPxOiS
         g4fxlXRFcRYTQ==
Message-ID: <aa962460-4c83-72f2-48e2-f5ac610176fa@denx.de>
Date:   Wed, 24 Aug 2022 00:10:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] net: dsa: microchip: Support GMII on user ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20220823104343.6141-1-marex@denx.de>
 <20220823181338.zyzv3qkd2g5oecjq@skbuf>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20220823181338.zyzv3qkd2g5oecjq@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 20:13, Vladimir Oltean wrote:
> On Tue, Aug 23, 2022 at 12:43:43PM +0200, Marek Vasut wrote:
>> The user ports on KSZ879x indicate they are of GMII interface type instead
>> of INTERNAL interface type. Add GMII into the list of supported user port
>> interfaces to avoid the following failure on probe:
>>
>> "
>> ksz8795-switch spi0.0 lan1 (uninitialized): validation of gmii with support 0000000,00000000,000062cf and advertisement 0000000,00000000,000062cf failed: -EINVAL
>> ksz8795-switch spi0.0 lan1 (uninitialized): failed to connect to PHY: -EINVAL
>> ksz8795-switch spi0.0 lan1 (uninitialized): error -22 setting up PHY for tree 0, switch 0, port 0
>> "
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> ---
>> Cc: Arun Ramadoss <arun.ramadoss@microchip.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>> Cc: Vladimir Oltean <olteanv@gmail.com>
> 
> https://lore.kernel.org/netdev/20220818143250.2797111-1-vladimir.oltean@nxp.com/

Nice, thanks !
