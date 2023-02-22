Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D4969ED6A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjBVDUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBVDUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:20:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604CE199C1;
        Tue, 21 Feb 2023 19:20:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C4A2B811BC;
        Wed, 22 Feb 2023 03:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58557C433EF;
        Wed, 22 Feb 2023 03:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677036037;
        bh=uxAMREyIjBPfY9EFH8crvl1jJxPAbyNQCMLGBSehB7M=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=FN0z6PK3o+nBodMPaEltlomxzIoB5AIW/w/fQ5/3WU9lnYvlfFJtYqlkH1ZVUstKA
         YyxPhdUUtvbiDyBHw+gKjcUXwF3+llJTlGJtoyscdmuodHZEtolswrg+RwhbLhVRTG
         65o8jrRv15DfojTq/jNSo7HgLmuPNYYJuK+Swtto0LRBEE3iEmzc7eN5UDGn0ftfmv
         dFBIyx7Otexd0bVvIJ6g3m4CCwXsY2R1oF3vV2yJqbv4KDrO20hxpFrQyw2lpub0c8
         u7bqADgbnQHcx8YduWHiRjtqnv07WPKjnIFfVO08gtD4WgMIPzx83bUjJHUElcfzvT
         3c0kOfE5ct29Q==
Message-ID: <ef58e253-b035-aae8-0eb7-c3e73dd1f3c6@kernel.org>
Date:   Tue, 21 Feb 2023 20:20:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net,v3,2/2] selftests: fib_tests: Add test cases for
 IPv4/IPv6 in route notify
To:     Lu Wei <luwei32@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230222042051.325307-1-luwei32@huawei.com>
 <20230222042051.325307-3-luwei32@huawei.com>
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230222042051.325307-3-luwei32@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/23 9:20 PM, Lu Wei wrote:
> @@ -655,6 +655,99 @@ fib_nexthop_test()
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
> +		$IP link add dummy_$i type dummy
> +		$IP link set dev dummy_$i up
> +		$IP -6 address add 2001:$i::1/64 dev dummy_$i
> +	done
> +
> +	$IP -6 route add 2001::/64 \
> +                nexthop encap ip6 dst 2002::10 via 2001:10::2 dev dummy_10 \
> +                nexthop encap ip6 dst 2002::20 via 2001:20::2 dev dummy_20 \
> +                nexthop encap ip6 dst 2002::30 via 2001:30::2 dev dummy_30 \
> +                nexthop encap ip6 dst 2002::40 via 2001:40::2 dev dummy_40 \
> +                nexthop encap ip6 dst 2002::50 via 2001:50::2 dev dummy_50 \
> +                nexthop encap ip6 dst 2002::60 via 2001:60::2 dev dummy_60


I think you want the non-lwtunnel path to be first (it is the one
assumed to have the same size as the remaining paths).


> +
> +	set +e
> +
> +	$NS_EXEC ip monitor route &> errors.txt &
> +
> +	sleep 2
> +	$IP -6 route append 2001::/64 via 2001:70::2 dev dummy_70
> +
> +	err=`cat errors.txt |grep "Message too long"`
> +	if [ -z "$err" ];then
> +		ret=0
> +	else
> +		ret=1
> +	fi
> +
> +	log_test $ret 0 "ipv6 route add notify"
> +
> +	{ kill %% && wait %%; } 2>/dev/null
> +
> +	#rm errors.txt
> +
> +	cleanup &> /dev/null
> +}
> +
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
> +		$IP link add dummy_$i type dummy
> +		$IP link set dev dummy_$i up
> +		$IP address add 20.20.$i.2/24 dev dummy_$i
> +	done
> +
> +	$NS_EXEC ip monitor route &> errors.txt &
> +	sleep 2
> +
> +        $IP route add 10.0.0.0/24 \
> +                nexthop encap ip dst 192.168.10.10 via 20.20.10.1 dev dummy_10 \
> +                nexthop encap ip dst 192.168.10.20 via 20.20.20.1 dev dummy_20 \
> +                nexthop encap ip dst 192.168.10.30 via 20.20.30.1 dev dummy_30 \
> +                nexthop encap ip dst 192.168.10.40 via 20.20.40.1 dev dummy_40 \
> +                nexthop encap ip dst 192.168.10.50 via 20.20.50.1 dev dummy_50 \
> +                nexthop encap ip dst 192.168.10.60 via 20.20.60.1 dev dummy_60 \
> +                nexthop via 20.20.70.1 dev dummy_70

same here.

