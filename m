Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291046887F7
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBBUFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjBBUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:05:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F687265A
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:05:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 083BEB827D6
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 20:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77D3C433D2;
        Thu,  2 Feb 2023 20:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675368310;
        bh=3tFfugzE9JUSN7xTI4BxQnpa2ed7ShkiCnIRST1oKr8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gFMfRZhD2Ta/nIKRMbqe0rPBOo3zvZMv5awW2fTaU3lFjDknVB2FkafzRLcTrilFk
         9/o3uY6ts4QrnCO17ljBxIvnol3rvens17CtXHdIqy+4XsO261vc8KGfWsuETmUrKr
         aHIDwV34vTupDVSCFjfS+xueEZUjma0uw4FkX4T8NiweOcfyvGQRboVPsLX9o0Fu1c
         26dszA5qT50ljUEuDEPmbQJCg5FxfHHN80a9UJfqMrapX/a8loOd+YxV+7nFBpgVti
         zMNC0TWzVtGSauVBiHafwI7t0QPUqf9HdMWNMPzwhhdRaP2E9ESvnyC7dg3BEOrXa9
         M9ZpcELflSvng==
Message-ID: <6140c2ff-6012-cd02-3e88-9651999de18b@kernel.org>
Date:   Thu, 2 Feb 2023 22:05:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v5 net-next 14/17] net/sched: taprio: only calculate gate
 mask per TXQ for igc, stmmac and tsnep
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Pekka Varis <p-varis@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>
References: <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-15-vladimir.oltean@nxp.com>
 <20230202003621.2679603-1-vladimir.oltean@nxp.com>
 <20230202003621.2679603-15-vladimir.oltean@nxp.com>
 <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
 <8fb9048b-059c-f965-8cfc-e5fd480481b8@kernel.org>
 <20230202123146.paegzm3rwi3ithmy@skbuf>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230202123146.paegzm3rwi3ithmy@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 02/02/2023 14:31, Vladimir Oltean wrote:
> Hi Roger,
> 
> On Thu, Feb 02, 2023 at 10:04:53AM +0200, Roger Quadros wrote:
>> Here is some documentation for this driver with usage example
>> https://software-dl.ti.com/processor-sdk-linux/esd/AM65X/08_02_00_02/exports/docs/linux/Foundational_Components/Kernel/Kernel_Drivers/Network/CPSW2g.html#enhancements-for-scheduled-traffic-est-offload
>>
>> It looks like it is suggesting to create a TXQ for each TC?
>> I'm not sure if this patch will break that usage example. 
> 
> It won't break that example, because there is only one TXQ per TC,
> and the TXQ indices are exactly equal to the TC indices.
> 
> #Where num_tc is same as number of queues = 3, map, maps 16 priorities to one of 3 TCs, queues specify the
> #Queue associated with each TC, TC0 - One queue @0, TC1 - One queue @1 and TC2 - One queue @2
> tc qdisc replace dev eth0 parent root handle 100 taprio \
>    num_tc 3 \
>    map 0 0 1 2 0 0 0 0 0 0 0 0 0 0 0 0 \
>    queues 1@0 1@1 1@2 \
>    base-time 0000 \
>    sched-entry S 4 125000 \
>    sched-entry S 2 125000 \
>    sched-entry S 1 250000 \
>    flags 2
> 
> The question is if the driver works in fact with other queue configurations than that.
> If it doesn't, then this patch set could serve as a good first step for
> the driver to receive the mqprio queue configuration, and NACK invalid
> TC:TXQ mappings.
> 
>> Here is explanation of fetch_allow register from TRM [1] 12.2.1.4.6.8.4 Enhanced Scheduled Traffic Fetch Values
>>
>> "When a fetch allow bit is set, the corresponding priority is enabled to begin packet transmission on an
>> allowed priority subject to rate limiting. The actual packet transmission on the wire may carry over into the
>> next fetch count and is the reason for the wire clear time in the fetch zero allow.
>> When a fetch allow bit is cleared, the corresponding priority is not enabled to transmit for the fetch count time."
>>
>> I can try to do some tests and confirm if it still works in a few days.
> 
> If you prefer, I can respin the patch set, with am65-cpsw kept with a
> gate mask per TXQ, and you can look into it when it's most convenient to you.

This is better for me. Thanks. :)

cheers,
-roger
