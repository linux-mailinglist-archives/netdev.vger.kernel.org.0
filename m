Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048584E4145
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbiCVO3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237932AbiCVO3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:29:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A264551C
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:26:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4187F616AD
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 14:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B56DC340EC;
        Tue, 22 Mar 2022 14:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647959209;
        bh=zBQ4E4P3hIoYQ8qCKtP/IYm362ZQgQYJYDhjDgO3JSc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=c0tv83SgLj1ZF+x6+u+b/3l1KpFLMYhUiAiMAu3tfumNkn2fsjjeKgEvCCvtTKtQg
         aR9hOYKBIazjIBO9hWEjVvCcdYpMBpZH7xMo5ZTk7RzmEDjUJopmTA7hWQBJ4FIiay
         SQZ7GAAsIPsTv4ZphN4b8pFpx+H8eW1gSKqD0zO/Iem2wg/7B38dNPa4eEBOEfW/wg
         WYm5OYXrEbnXWNqnFXMyWOHlCivhr94Azp4n4kSV9Va1lTeXypfLUwVMAboqMNFlaE
         jk0RdYvfTbPpRF90DkRHwuMeCZPoJfv/kChak+4Rsydr3lUTfj/rZk9RpRj9gt1Guu
         7/V3V/euRqvDA==
Message-ID: <0b0b61a1-e46d-6134-0151-913b324f056a@kernel.org>
Date:   Tue, 22 Mar 2022 08:26:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] net: Add l3mdev index to flow struct and avoid
 oif reset for port devices
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        greearb@candelatech.com
References: <20220314204551.16369-1-dsahern@kernel.org>
 <YjmVZzwE3XY750v6@shredder>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <YjmVZzwE3XY750v6@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/22 3:22 AM, Ido Schimmel wrote:
> On Mon, Mar 14, 2022 at 02:45:51PM -0600, David Ahern wrote:
>> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
>> index 2af2b99e0bea..fb0e49c36c2e 100644
>> --- a/net/ipv4/fib_trie.c
>> +++ b/net/ipv4/fib_trie.c
>> @@ -1429,11 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
>>  	    !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
>>  		return false;
>>  
>> -	if (!(flp->flowi4_flags & FLOWI_FLAG_SKIP_NH_OIF)) {
>> -		if (flp->flowi4_oif &&
>> -		    flp->flowi4_oif != nhc->nhc_oif)
>> -			return false;
>> -	}
>> +	if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
>> +		return false;
> 
> David, we have several test cases that are failing which I have tracked
> down to this patch.
> 
> Before the patch, if the original output interface was enslaved to a
> VRF, the output interface in the flow struct would be updated to the VRF
> and the 'FLOWI_FLAG_SKIP_NH_OIF' flag would be set, causing the above
> check to be skipped.
> 
> After the patch, the check is no longer skipped, as original output
> interface is retained and the flag was removed.
> 
> This breaks scenarios where a GRE tunnel specifies a dummy device
> enslaved to a VRF as its physical device. The purpose of this
> configuration is to redirect the underlay lookup to the table associated
> with the VRF to which the dummy device is enslaved to. The check fails
> because 'flp->flowi4_oif' points to the dummy device, whereas
> 'nhc->nhc_oif' points to the interface via which the encapsulated packet
> should egress.
> 
> Skipping the check when an l3mdev was set seems to solve the problem:
> 
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index fb0e49c36c2e..cf1164e05d92 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -1429,7 +1429,8 @@ bool fib_lookup_good_nhc(const struct fib_nh_common *nhc, int fib_flags,
>             !(fib_flags & FIB_LOOKUP_IGNORE_LINKSTATE))
>                 return false;
>  
> -       if (flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
> +       if (!flp->flowi4_l3mdev &&
> +           flp->flowi4_oif && flp->flowi4_oif != nhc->nhc_oif)
>                 return false;
>  
>         return true;
> 
> AFAICT, this scenario does not break with ip6gre/ip6gretap tunnels
> because 'RT6_LOOKUP_F_IFACE' is not set in
> ip6_route_output_flags_noref() in this case.
> 
> WDYT? I plan to test this patch in our regression, but I'm not sure if I
> missed other cases that might remain broken.

one of the requests with VRF has been to bind a socket to a port device
and expect the lookup to enforce use of that egress port (e.g.,
multipath). Switching the oif to the VRF device and then ignoring the
oif check was making that check too flexible for that use case.

What's the callchain for this failure? Perhaps the
FLOWI_FLAG_SKIP_NH_OIF needs to be kept for this particular use case.
