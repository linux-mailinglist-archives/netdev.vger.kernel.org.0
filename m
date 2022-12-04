Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79EAA641DE0
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 17:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiLDQZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 11:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDQZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 11:25:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B576412D22
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 08:25:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55C0E60EC3
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 16:25:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AADC433C1;
        Sun,  4 Dec 2022 16:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670171128;
        bh=tiuYiG6dtYpiH2agMOsSA3Wplqyl91xi2mSiDgcFYJQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZdxryGUDWGEULnMJf4o80yYXheBveXd2rXEOChRioarAMLJd16n/gi643kX3nILuZ
         PDgWtJRj59ZOGKONWl9f3kQXA9yO2alZHAA7hOfYqFqM0fbbxYHsJVSjvQIleE6RF/
         t2zN6whZAx5kGqh5TNPrf4RThPpI0coWjy7QLoxA5+i+oK6LuniSJlg7ioJXAOJqw5
         cHHRcs01A2oSNAGKntejAAUHP+nfQ1Mqs8f9IByy4NXAmuQ9qkzL+/QFsaKNGLbpzB
         o7ESUjgo22QnBPrsKaRkJmKAMR6qjYKFzdMfLp+MJh5knMYfjjdq8knaUENqwRXq+W
         AkMvf4vCteGJQ==
Message-ID: <9cf8605c-96e3-9d94-4c11-7a6c4cdf9e2a@kernel.org>
Date:   Sun, 4 Dec 2022 09:25:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net 1/2] ipv4: Fix incorrect route flushing when source
 address is deleted
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mark.tomlinson@alliedtelesis.co.nz,
        sharpd@nvidia.com, mlxsw@nvidia.com
References: <20221204075045.3780097-1-idosch@nvidia.com>
 <20221204075045.3780097-2-idosch@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221204075045.3780097-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/22 12:50 AM, Ido Schimmel wrote:
> Cited commit added the table ID to the FIB info structure, but did not
> prevent structures with different table IDs from being consolidated.
> This can lead to routes being flushed from a VRF when an address is
> deleted from a different VRF.
> 
> Fix by taking the table ID into account when looking for a matching FIB
> info. This is already done for FIB info structures backed by a nexthop
> object in fib_find_info_nh().
> 
> Add test cases that fail before the fix:
> 
>  # ./fib_tests.sh -t ipv4_del_addr
> 
>  IPv4 delete address route tests
>      Regular FIB info
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Identical FIB info with different table ID
>      TEST: Route removed from VRF when source address deleted            [FAIL]
>      TEST: Route in default VRF not removed                              [ OK ]
>  RTNETLINK answers: File exists
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [FAIL]
> 
>  Tests passed:   6
>  Tests failed:   2
> 
> And pass after:
> 
>  # ./fib_tests.sh -t ipv4_del_addr
> 
>  IPv4 delete address route tests
>      Regular FIB info
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
>      Identical FIB info with different table ID
>      TEST: Route removed from VRF when source address deleted            [ OK ]
>      TEST: Route in default VRF not removed                              [ OK ]
>      TEST: Route removed in default VRF when source address deleted      [ OK ]
>      TEST: Route in VRF is not removed by address delete                 [ OK ]
> 
>  Tests passed:   8
>  Tests failed:   0
> 
> Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_semantics.c                 |  1 +
>  tools/testing/selftests/net/fib_tests.sh | 27 ++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


