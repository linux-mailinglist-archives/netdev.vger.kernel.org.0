Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C104EE5BD
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 03:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbiDABg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 21:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243803AbiDABg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 21:36:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCC32414F9
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 18:35:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C17BBB8227A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 01:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D27C340ED;
        Fri,  1 Apr 2022 01:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648776908;
        bh=A49PFHqTstynKA1a4Pg4Q2vwZgmudSepShnesGoR97w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SdifgBw6B1UeqJpzqST5LJWyZjzwNcY017WW3K1Dkua2zC+BCMdMT4quLXzus62+f
         cUzNmawE0ps60QaY8QlLDJOmPMSRktZm5adSPpuHteHWXDDI3fIrJJqd/5n1aRkUz2
         EicLDGnXinOBvApGgxUXy08NUhLIbakzJ+l3u6f+kfJ+LXreKT3JJ6rZKOM/gnN+JY
         6EPsxsA9bKOUhNDbZ0+MzMP9c42rad496Evje5C8fkjzzqhFtcB6zS+ei05yH8x5QG
         Rwv84ivAUeSqECy5kWSt0ih/c0KqSf7xUY+SHdcDjvPS4BXgnrDqUVJgDA90HPK+fu
         mkqxGBibqI8Ww==
Message-ID: <5bd7ae86-8676-ffa9-d422-7557461721ad@kernel.org>
Date:   Thu, 31 Mar 2022 19:35:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net 2/2] selftests: net: add delete nexthop route warning
 test
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     donaldsharp72@gmail.com, philippe.guibert@outlook.com,
        kuba@kernel.org, davem@davemloft.net, idosch@idosch.org
References: <20220331154615.108214-1-razor@blackwall.org>
 <20220331154615.108214-3-razor@blackwall.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220331154615.108214-3-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/22 9:46 AM, Nikolay Aleksandrov wrote:
> Add a test which causes a WARNING on kernels which treat a
> nexthop route like a normal route when comparing for deletion and a
> device is specified. That is, a route is found but we hit a warning while
> matching it. The warning is from fib_info_nh() in include/net/nexthop.h
> because we run it on a fib_info with nexthop object. The call chain is:
>  inet_rtm_delroute -> fib_table_delete -> fib_nh_match (called with a
> nexthop fib_info and also with fc_oif set thus calling fib_info_nh on
> the fib_info and triggering the warning).
> 
> Repro steps:
>  $ ip nexthop add id 12 via 172.16.1.3 dev veth1
>  $ ip route add 172.16.101.1/32 nhid 12
>  $ ip route delete 172.16.101.1/32 dev veth1
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  tools/testing/selftests/net/fib_nexthops.sh | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
> index d444ee6aa3cb..371e3e0c91b7 100755
> --- a/tools/testing/selftests/net/fib_nexthops.sh
> +++ b/tools/testing/selftests/net/fib_nexthops.sh
> @@ -1208,6 +1208,19 @@ ipv4_fcnal()
>  	set +e
>  	check_nexthop "dev veth1" ""
>  	log_test $? 0 "Nexthops removed on admin down"
> +
> +	# nexthop route delete warning
> +	run_cmd "$IP li set dev veth1 up"
> +	run_cmd "$IP nexthop add id 12 via 172.16.1.3 dev veth1"
> +	out1=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
> +	run_cmd "$IP route add 172.16.101.1/32 nhid 12"
> +	run_cmd "$IP route delete 172.16.101.1/32 dev veth1"
> +	out2=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
> +	[ $out1 -eq $out2 ]
> +	rc=$?
> +	log_test $rc 0 "Delete nexthop route warning"
> +	run_cmd "$IP ip route delete 172.16.101.1/32 nhid 12"
> +	run_cmd "$IP ip nexthop del id 12"
>  }
>  
>  ipv4_grp_fcnal()

Reviewed-by: David Ahern <dsahern@kernel.org>

