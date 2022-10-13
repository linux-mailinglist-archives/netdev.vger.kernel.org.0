Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D455FE107
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiJMSXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbiJMSXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:23:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D1F17C573;
        Thu, 13 Oct 2022 11:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0843B81E1B;
        Thu, 13 Oct 2022 18:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57965C433C1;
        Thu, 13 Oct 2022 18:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665684960;
        bh=LZk23UAFJwZJIWKNLhyALMYapgUsPfOmRti557QqG80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DPQ+Tfyju6cHx5rC6s5ILFmn9/Cnt7fntoKg6XDvvgH35hcXpXpgvvRcaXs7jDVlk
         NVIXu7ZSwR939eEBC/J95PjUKosTzfHlgl1g079Cnid7Bs6ghpc/OGDwBFnZr22EFO
         V1WboxSnQIyr7dgD1WhQWcncOiwRsA1nTjNlmBHwol3P8UQWU851a603apk7flJhc1
         rVqgg7WpltxcNy5M/vYV0SIJrGADpZklz88hBmNd8xETc5nZ/0hr6Hin8BTo8PqFvm
         vT3tfxVWOyMKE0nRM88vQYjnnDtZNVh03rDV3Ytd1/j0IhxOXStBkxT9fW7Kn1Ta0w
         kKfMNJpRhljOQ==
Date:   Thu, 13 Oct 2022 14:15:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 11/77] net: dsa: all DSA masters must be down
 when changing the tagging protocol
Message-ID: <Y0hV36EMAvOOm79K@sashalap>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-11-sashal@kernel.org>
 <20221010115430.kloc3urkycsbyele@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221010115430.kloc3urkycsbyele@skbuf>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 02:54:30PM +0300, Vladimir Oltean wrote:
>On Sun, Oct 09, 2022 at 06:06:48PM -0400, Sasha Levin wrote:
>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> [ Upstream commit f41ec1fd1c20e2a4e60a4ab8490b3e63423c0a8a ]
>>
>> The fact that the tagging protocol is set and queried from the
>> /sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
>> the single CPU port days which isn't aging very well now that DSA can
>> have more than a single CPU port. This is because the tagging protocol
>> is a switch property, yet in the presence of multiple CPU ports it can
>> be queried and set from multiple sysfs files, all of which are handled
>> by the same implementation.
>>
>> The current logic ensures that the net device whose sysfs file we're
>> changing the tagging protocol through must be down. That net device is
>> the DSA master, and this is fine for single DSA master / CPU port setups.
>>
>> But exactly because the tagging protocol is per switch [ tree, in fact ]
>> and not per DSA master, this isn't fine any longer with multiple CPU
>> ports, and we must iterate through the tree and find all DSA masters,
>> and make sure that all of them are down.
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>Not needed for stable kernels, please drop, thanks.

Ack, I'll drop this and the rest of the patches you've pointed out,
thanks!

-- 
Thanks,
Sasha
