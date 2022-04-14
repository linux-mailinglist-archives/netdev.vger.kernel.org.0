Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E8850031C
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 02:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiDNAou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 20:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiDNAot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 20:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4847D2251B
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 17:42:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDA1C613DC
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C65BC385A6;
        Thu, 14 Apr 2022 00:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649896946;
        bh=8lYIYTMcMRpADQYVwwEbTQ7w7xq7gDAawhUe2eXrNFo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=V9J3P/MYXS5MyBbY7MTCPsrfE3nENIideBDr+z1NaP1bcBCdbI3rgl5AU0FWbmsLZ
         62EnjksFq+LNx4NUgcKoemXlmZv8EmHHOxnTPP1I+62tLeAZw//HUYCtw8T9CFBHIe
         Xjzn4NWjVlQ4eY0G9WRzvMmR17iTAnF78k+Mwr1KzmT5JQIND3vvBajDHYMbRFLwmO
         lNodux6lTYtTYALdmZYoqdOA1g4qIOqgxJMAOLVNXYymjK3WSLJapuNHblHxwjOcR9
         ECdhgOhZnf68tHU/+aHapN3TtclDep2M8NkIjdAdN/7R/L6o7n4lRkO9p0kl1zHvE0
         ztYWtas8r600Q==
Message-ID: <97774474-65a3-fa45-e0b9-8db6c748da28@kernel.org>
Date:   Wed, 13 Apr 2022 18:42:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v4 05/12] net: rtnetlink: add bulk delete support
 flag
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220413105202.2616106-1-razor@blackwall.org>
 <20220413105202.2616106-6-razor@blackwall.org> <Yla8wj7khYxpwxan@shredder>
 <e43b5033-d350-fc81-71be-de3e1053c72a@blackwall.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <e43b5033-d350-fc81-71be-de3e1053c72a@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 6:21 AM, Nikolay Aleksandrov wrote:
>> If a buggy user space application is sending messages with NLM_F_BULK
>> set (unintentionally), will it break on newer kernel? I couldn't find
>> where the kernel was validating that reserved flags are not used (I
>> suspect it doesn't).
> 
> Correct, it doesn't.
> 
>>
>> Assuming the above is correct and of interest, maybe just emit a warning
>> via extack and drop the goto? Alternatively, we can see if anyone
>> complains which might never happen
>>
> 
> TBH I prefer to error out on an unsupported flag, but I get the problem. These
> weren't validated before and we start checking now. The problem is that we'll
> return an extack without an error, but the delete might also remove something.
> Hrm.. perhaps we can rephrase the error in that case (since it becomes a warning
> in iproute2 terms):
>  "NLM_F_BULK flag is set but bulk delete operation is not supported"
> So it will warn the user it has an unsupported flag.
> 
> WDYT ?
> 
> IMO we should bite the bullet and keep the error though. :)
> 

I agree. The check across the board for BULK flag on any DELETE requests
should tell us pretty quick if someone is setting that flag when it
should not be.
