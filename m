Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC24698C6D
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjBPFwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBPFwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:52:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5A927D6E;
        Wed, 15 Feb 2023 21:52:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BAF4B825CB;
        Thu, 16 Feb 2023 05:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F198BC433D2;
        Thu, 16 Feb 2023 05:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526732;
        bh=V7lq2YbItpQ261vpNd6FWmAFniaH4EnR1rLWQm+2gAg=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=ArQVpaKaHJG+OccAswoxQokfdEueTYHB5KN8xTDJwRZQ3wBNzcYWDpenFJoygijZe
         HYoHZ0riNt7bDyY74XeuIL4UQCP2ZV2wZwhz3CrXPzlSr7hYcTt56mooWldQdDQjwb
         JKeg6qE72/3cuvj4zaStgp5TpnSbcL7tttX3p2J7WroPDriaDkQvGKC6BoEHvUpgbK
         NYPzsRE1h5Tvqg4oFEqdZK++al9xbi9cpOElC9e6lTchGQryr5lt86ceSap32rz1Th
         EsvG4H+efZEeePrCHebXRNRXkzExV09djvSnRofDTcG/J5cMG1mHYVG5+UGVXQt0CW
         cND41x+LUZR7g==
Message-ID: <9f83dac5-ab13-e0eb-3ce0-688e95703517@kernel.org>
Date:   Wed, 15 Feb 2023 22:52:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net,v2,2/2] selftests: fib_tests: Add test cases for
 IPv4/IPv6 in route notify
Content-Language: en-US
To:     Lu Wei <luwei32@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230216042624.4069910-1-luwei32@huawei.com>
 <20230216042624.4069910-3-luwei32@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230216042624.4069910-3-luwei32@huawei.com>
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

On 2/15/23 9:26 PM, Lu Wei wrote:
> diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> index 5637b5dadabd..4e48154bd195 100755
> --- a/tools/testing/selftests/net/fib_tests.sh
> +++ b/tools/testing/selftests/net/fib_tests.sh
> @@ -9,7 +9,7 @@ ret=0
>  ksft_skip=4
>  
>  # all tests in this script. Can be overridden with -t option
> -TESTS="unregister down carrier nexthop suppress ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle ipv4_bcast_neigh"
> +TESTS="unregister down carrier nexthop suppress ipv6_notify ipv4_notify ipv6_rt ipv4_rt ipv6_addr_metric ipv4_addr_metric ipv6_route_metrics ipv4_route_metrics ipv4_route_v6_gw rp_filter ipv4_del_addr ipv4_mangle ipv6_mangle ipv4_bcast_neigh"
>  
>  VERBOSE=0
>  PAUSE_ON_FAIL=no
> @@ -655,6 +655,94 @@ fib_nexthop_test()
>  	cleanup
>  }
>  
> +fib6_notify_test()
> +{
> +	setup
> +
> +	echo
> +	echo "Fib6 info length calculation in route notify test"
> +	set -e
> +
> +	for i in 10 20 30 40 50 60 70;
> +	do
> +		$IP link add dummy$i type dummy
> +		$IP link set dev dummy$i up
> +		$IP -6 addr add 2002::$i/64 dev dummy$i
> +	done
> +
> +	for i in 10 20 30 40 50 60;
> +	do
> +		$IP -6 route append 100::/64 encap ip6 dst 2002::$i via \
> +		2002::1 dev dummy$i metric 100
> +	done

That creates a multipath route because of a quirk with IPv6. It would be
better to make this explicit by

	nexthops=
	for i in 10 20 30 40 50 60;
	do
		nexthops="$nexthops nexthop encap ip6 dst 2002::$i via 2002::1 dev
dummy$i metric 100"
	done

	$IP -6 route add 100::/64 ${nexthops}

> +
> +fib_notify_test()
> +{
> +	setup
> +
> +	echo
> +	echo "Fib4 info length calculation in route notify test"
> +
> +	set -e
> +
> +	for i in 10 20 30 40 50 60 70;
> +	do
> +		$IP link add dummy$i type dummy
> +		$IP link set dev dummy$i up
> +		$IP addr add 192.168.100.$i/24 dev dummy$i
> +	done
> +
> +	for i in 10 20 30 40 50 60;
> +	do
> +		$IP route append 10.0.0.0/24 encap ip dst 192.168.100.$i via \
> +		192.168.100.1 dev dummy$i metric 100
> +	done

With IPv4 that is not a multipath route but a series of independent
routes. Hence, doing the loop here like I showed above makes sure this
is a proper multipath route.

Thank you for adding the tests.

