Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86714B9634
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 04:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiBQDAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 22:00:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiBQDAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 22:00:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2CD1FFF46;
        Wed, 16 Feb 2022 18:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E4161D00;
        Thu, 17 Feb 2022 02:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AF0C004E1;
        Thu, 17 Feb 2022 02:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645066792;
        bh=Cc8p4juRyZDLDiYHYoHlaCKkmOjUBJrr6ymTfTTrnJw=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=oTA2x1m/1tJy/0RO1pN30NJa2BJkYMh2+KKMBKb1RwI/36S8e7LFjr4cNM021ZjLH
         rrHPNICPqWSAYYOTpTZx0MN3UuCUGdqTVOnYlO2LxFqkOTRQjRtlJo5jKoL1vdyhuz
         EdJpo9K/NzhCRDGu96UxhRlCUDYofEMAeXkFI10rCODhdq1mb/y+HsydVx9J8xod5N
         lISmjXwtlOqdPHYFGZHJl/flAwwv26jxJX1NsM1eLJRwa4fWq98mH7tgia0DdM1TRy
         +bUzGU61/pEWnf95B0p4saetWhWzaAG4JPlTsEdOUQ8A3ICnTpU7hSm/vpss90L4iT
         oWCBf8lCv7wuw==
Message-ID: <bcc98227-b99f-5b2f-1745-922c13fe6089@kernel.org>
Date:   Wed, 16 Feb 2022 19:59:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Content-Language: en-US
To:     "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <SJ0PR11MB51207CBDB5145A89B8A0A15393359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51202FA2365341740048A64593359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209200786235187572EE0D93359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/22 3:36 AM, Xiao, Jiguang wrote:
> Hello,
> 
> I found a counter in the kernel(5.10.49) that did not follow the RFC4293
> specification. The test steps are as follows:
> 
>  
> 
> Topology:
> 
>   |VM 1| ------ |linux| ------ |VM 2|
> 
>  
> 
> Steps:
> 
> 1. Verify that “VM1” is reachable from “VM 2” and vice versa using ping6
> command.
> 
> 2. On “linux” node, in proper fib, remove default route to NW address
> which “VM 2” resides in. This way, the packet won’t be forwarded by
> “linux” due to no route pointing to destination address of “VM 2”.
> 
> 3. Collect the corresponding SNMP counters from “linux” node.
> 
> 4. Verify that there is no connectivity from “VM 1” to “VM 2” using
> ping6 command.
> 
> 5. Check the counters again.
> 
>  
> 
> The test results:
> 
> The counter “ip6InNoRoutes” in “/proc/net/dev_snmp6/” has not increased
> accordingly. In my test environment, it was always zero.
> 
>  
> 
> My question is :
> 
> Within RFC4293, “ipSystemStatsInNoRoutes” is defined as follows:
> 
>   “The number of input IP datagrams discarded because no route could be
> found to transmit them to their destination.”
> 
> Does this version of the kernel comply with the RFC4293 specification?
> 
>  

I see that counter incrementing. Look at the fib6 tracepoints and see
what the lookups are returning:

perf record -e fib6:* -a
<run test>
Ctrl-C
perf script
