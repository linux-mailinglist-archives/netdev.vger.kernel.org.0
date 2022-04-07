Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64BF4F7D59
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244601AbiDGK6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244598AbiDGK6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:58:30 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928D2C31D7
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 03:56:29 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E4DFA8301E;
        Thu,  7 Apr 2022 12:56:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1649328988;
        bh=5QJISr+UFMup7PWqk5jLUOPOOCmaZcbJG/90QT49mck=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=AJYNs3BrU6makr3AvpAq81SxfiUy4mRAzgVFQU5UoZoF5cJ99f7tsxCfsDfb67LQb
         AVFgiXvWWG8RUM8lbQUHeB/svpSIRjHUEAhDCPkCK70HkzmTP0rGrL5otWpMJXNw93
         0R+xvKbqMnqvTaBH5WfGHsBfFpwwJTpTcnRcJGY+GePuixXp9UuxnF7EE0pKd5pPCp
         ugXrxj/yIUkBMEV0RcLy1E/GxcJK84dI38AVSm0Uf6oUs6blGGBde/0vE+EZ3j8hiB
         xrzawRr2NghMrcmqpMnuXvL30Z2dQP5WqP6K7+KOjI/djf46zrUttogrsY0T1ClGBN
         HVA+DnkBPvL6A==
Message-ID: <57ef40a8-c74d-aafa-f49c-27e722254587@denx.de>
Date:   Thu, 7 Apr 2022 12:56:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: phy: micrel: ksz9031/ksz9131: add cabletest
 support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220407020812.1095295-1-marex@denx.de>
 <20220406215740.24bfd957@kernel.org>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20220406215740.24bfd957@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 06:57, Jakub Kicinski wrote:
> On Thu,  7 Apr 2022 04:08:12 +0200 Marek Vasut wrote:
>> Add cable test support for Micrel KSZ9x31 PHYs.
>>
>> Tested on i.MX8M Mini with KSZ9131RNX in 100/Full mode with pairs shuffled
>> before magnetics:
>> (note: Cable test started/completed messages are omitted)
>>
>>    mx8mm-ksz9131-a-d-connected$ ethtool --cable-test eth0
>>    Pair A code OK
>>    Pair B code Short within Pair
>>    Pair B, fault length: 0.80m
>>    Pair C code Short within Pair
>>    Pair C, fault length: 0.80m
>>    Pair D code OK
>>
>>    mx8mm-ksz9131-a-b-connected$ ethtool --cable-test eth0
>>    Pair A code OK
>>    Pair B code OK
>>    Pair C code Short within Pair
>>    Pair C, fault length: 0.00m
>>    Pair D code Short within Pair
>>    Pair D, fault length: 0.00m
>>
>> Tested on R8A77951 Salvator-XS with KSZ9031RNX and all four pairs connected:
>> (note: Cable test started/completed messages are omitted)
>>
>>    r8a7795-ksz9031-all-connected$ ethtool --cable-test eth0
>>    Pair A code OK
>>    Pair B code OK
>>    Pair C code OK
>>    Pair D code OK
>>
>> The CTRL1000 CTL1000_ENABLE_MASTER and CTL1000_AS_MASTER bits are not
>> restored by calling phy_init_hw(), they must be manually cached in
>> ksz9x31_cable_test_start() and restored at the end of
>> ksz9x31_cable_test_get_status().
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> It does not apply completely cleanly to net-next, could you rebase?

Done, v3 is out.
