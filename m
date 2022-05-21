Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976F952F778
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 04:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354333AbiEUCAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 22:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbiEUCAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 22:00:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6121915F6C6;
        Fri, 20 May 2022 19:00:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E6C61ECF;
        Sat, 21 May 2022 02:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B859C385A9;
        Sat, 21 May 2022 02:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653098429;
        bh=lASD+l4g0VxygFaghqtOSOuG8Fp0yTmMNSbT1Tkf6/0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sR/BLWRhIvrFAhzfhttDCos3C6XDIzfGPvr7vybnNmFAO05kG806HMuKcVIOEZsEn
         tqyf1gOgE3XQVJobDDKX3Oa+uw+OqaUHpcU0X6j19fkr0BsL9ZFhFb8zRe5c1n/a2o
         HrOnSUqYpcp7Hai+wDUsBeu8bE6AzlHsR9m9shGEt8A7EvpMzsdWn+dRnK2siVMVwM
         HCMLDHcdfsJ7EYuiuV/iA28FAPf6beehB6XeU7kLQbtZQrJh51zBNRK8RGOOouo87F
         3ms4/1v7KOglIdmVcrBK7BjXeB5UROKsmXPOBkowt188hfPPY6VkCVgB+JbpguXY2d
         wigWzNwBOw8qA==
Message-ID: <5f189615-8701-e2ca-d9a6-d6037f8799aa@kernel.org>
Date:   Fri, 20 May 2022 20:00:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com
References: <20220413143434.527-1-aajith@arista.com>
 <350f6a02-2975-ac1b-1c9d-ab738722a9fe@kernel.org>
 <CAOvjArTAce_68CkoUff_=Hi+mr731dsWcQdEbaev4xaMDFZNug@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CAOvjArTAce_68CkoUff_=Hi+mr731dsWcQdEbaev4xaMDFZNug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/22 1:19 AM, Arun Ajith S wrote:
> On Thu, Apr 14, 2022 at 3:37 AM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 4/13/22 8:34 AM, Arun Ajith S wrote:
>>> diff --git a/tools/testing/selftests/net/ndisc_unsolicited_na_test.py b/tools/testing/selftests/net/ndisc_unsolicited_na_test.py
>>> new file mode 100755
>>> index 000000000000..f508657ee126
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/net/ndisc_unsolicited_na_test.py
>>> @@ -0,0 +1,255 @@
>>> +#!/bin/bash
>>
>> that file name suffix should be .sh since it is a bash script; not .py
>>
>> other than that looks good to me.
>>
>> Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> Hi David,
> 
> It has been pointed out to me that I might have read RFC9131 in a
> narrower sense than what was intended.
> The behavior of adding a new entry in the neighbour cache on receiving
> a NA if none exists presently
> shouldn't be limited to unsolicited NAs like in my original patch,
> rather it should extend to all NAs.
> 
> I am quoting from the RFC below
> 
>    |  When a valid Neighbor Advertisement is received (either solicited
>    |  or unsolicited), the Neighbor Cache is searched for the target's
>    |  entry.  If no entry exists:
>    |
>    |  *  Hosts SHOULD silently discard the advertisement.  There is no
>    |     need to create an entry if none exists, since the recipient has
>    |     apparently not initiated any communication with the target.
>    |
>    |  *  Routers SHOULD create a new entry for the target address with
>    |     the link-layer address set to the Target Link-Layer Address
>    |     Option (if supplied).  The entry's reachability state MUST be
>    |     set to STALE.  If the received Neighbor Advertisement does not
>    |     contain the Target Link-Layer Address Option, the advertisement
>    |     SHOULD be silently discarded.
> 
> I want to fix this, but this would mean the sysctl name
> accept_unsolicited_na is no longer appropriate
> I see that the net-next window for 5.19 is still open and changing the
> sysctl name
> wouldn't mean changing an existing interface.
> I was thinking of renaming the sysctl to accept_untracked_na to
> highlight that we are accepting NAs even if there is
> no corresponding entry tracked in the neighbor cache.
> 
> Also, there's an error in my comment, where I say "pass up the stack"
> as we don't pass NAs up the stack.
> The comment can be updated as:
>         /* RFC 9131 updates original Neighbour Discovery RFC 4861.
>          * NAs with Target LL Address option without a corresponding
>          * entry in the neighbour cache can now create a STALE neighbour
>          * cache entry on routers.
>          *
>          *   entry accept  fwding  solicited        behaviour
>          * ------- ------  ------  ---------    ----------------------
>          * present      X       X         0     Set state to STALE
>          * present      X       X         1     Set state to REACHABLE
>          *  absent      0       X         X     Do nothing
>          *  absent      1       0         X     Do nothing
>          *  absent      1       1         X     Add a new STALE entry
>          */
> 
> In summary
> 1. accept=0 keeps original(5.18) behavior for all cases.
> 2. accept=1 changes original behavior for entry=asbent, fwding=1 case
> provided the NA had specified target link-layer address.
> 
> Please let me know what you think.
> 

Changes can be made until it is in a released kernel to users. This
feature has many weeks before it hits that level.
