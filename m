Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA66E6268B1
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 10:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234751AbiKLJw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 04:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiKLJwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 04:52:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C554A12AA0
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 01:52:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B394B8070D
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 09:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3145C433C1;
        Sat, 12 Nov 2022 09:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668246772;
        bh=2kPa/ZuiFB8gSGUG16/GG8STK8RCPwk8XcTJpsGLJVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cz2GG8EQsV4dQg3z/o7zcGb8T1vwou2eFe7buLDiJSgfQEmt938q5aCABu8QXAUn4
         ifxyhd9co3TnXRzJgR2AE0ZpBCN4Ho3IDZ2QAh41x7cXojWSFJRmb3Q3bJ47KEwEEl
         INB6no0fCPB8ZUlM7exwyvsyRxJI/iy0I61wR/dDLY0BHCql/DOQ9DS49RxX80z7QG
         iQHRAAzFIZmsvwmZdLueQfV0EPBcKqQCTReMlXJCUEHRiScevvRhMTLrV25U9P7hWu
         G6JaF1HZbPI38IuYFr2qBSKeqz5E7pZ1SjjUdx6MlMMEOIet3qjfMtJrlsaKPcfvd3
         +PJie3upCCxYw==
Date:   Sat, 12 Nov 2022 01:52:47 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        David Thompson <davthompson@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        cai.huoqing@linux.dev, brgl@bgdev.pl, limings@nvidia.com,
        chenhao288@hisilicon.com, huangguangbin2@huawei.com,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: Re: [PATCH net-next v2 3/4] mlxbf_gige: add BlueField-3 Serdes
 configuration
Message-ID: <Y29s74Qt6z56lcLB@x130.lan>
References: <20221109224752.17664-1-davthompson@nvidia.com>
 <20221109224752.17664-4-davthompson@nvidia.com>
 <Y2z9u4qCsLmx507g@lunn.ch>
 <20221111213418.6ad3b8e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221111213418.6ad3b8e7@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11 Nov 21:34, Jakub Kicinski wrote:
>On Thu, 10 Nov 2022 14:33:47 +0100 Andrew Lunn wrote:
>> On Wed, Nov 09, 2022 at 05:47:51PM -0500, David Thompson wrote:
>> > The BlueField-3 out-of-band Ethernet interface requires
>> > SerDes configuration. There are two aspects to this:
>> >
>> > Configuration of PLL:
>> >     1) Initialize UPHY registers to values dependent on p1clk clock
>> >     2) Load PLL best known values via the gateway register
>> >     3) Set the fuses to tune up the SerDes voltage
>> >     4) Lock the PLL
>> >     5) Get the lanes out of functional reset.
>> >     6) Configure the UPHY microcontroller via gateway reads/writes
>> >
>> > Configuration of lanes:
>> >     1) Configure and open TX lanes
>> >     2) Configure and open RX lanes
>>
>> I still don't like all these black magic tables in the driver.
>>
>> But lets see what others say.
>
>Well, the patch was marked as Changes Requested so it seems that DaveM
>concurs :) (I'm slightly desensitized to those tables because they
>happen in WiFi relatively often.)
>
>The recommendation is to come up with a format for a binary file, load
>it via FW loader and then parse in the kernel?

By FW loader you mean request_firmware() functionality ?

I am not advocating for black magic tables of course :), but how do we
avoid them if request_firmware() will be an overkill to configure such a
simple device? Express such data in a developer friendly c structures
with somewhat sensible field names?

>
>We did have a recommendation against parsing FW files in the kernel at
>some point, too, but perhaps this is simple enough to pass.
>
>Should this be shared infra? The problem is fairly common.

Infrastructure to parse vendor Firmware ? we can't get vendors to agree on
ethtool interface, you want them to agree on one firmware format :)?

BTW i don't think the issue here is firmware at all, this is device
specific config space.

