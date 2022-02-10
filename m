Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D374B152E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245682AbiBJSXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:23:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245677AbiBJSXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:23:21 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C63BCED
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:23:22 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id c188so8411537iof.6
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dAMVeP+RrHny3xSC7eHQLJIyFnrRwFhwNujG08bdq0E=;
        b=M5PnKCW9+uPpbU0ZInspy36qX6Hr5eUta2KPtl9IDkwMX/baYPN8m4KPhAIDqdJPgS
         Qv1h1IAkjMz8RexKRczaPQCupnoCLnjhryD8l+K+dX1q8HzzpSEqNRhIKOAkQDl1Xx0C
         B6Vw1/+QA4pBcJTsuY8hRUsOj1KZ+W9xoqxms=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dAMVeP+RrHny3xSC7eHQLJIyFnrRwFhwNujG08bdq0E=;
        b=tVR6YReJVQZf5O9R5XTEKHeCTSBcx4Nm/7htAWSGDuias6Ur1n1AuJkz56DdDeaa8d
         WkYxpfkKZorh/wEuwMBl4+t5p+10oY3fDqs9iBkGlvQYyL2eB6FBePpmpNPAyCCUU8sX
         wh7/B+ub/WxeXjA3jZ5w3/Z7U404BNurz3QR+YH1iKx+nLJ2zKhHTq8a7n/A8uAHbKRN
         jwqim9Uh7kimMwa//82OtjDKBe9VoQSebBaCPxAOW5p/oZ+m+De3LHnMwRr+8Jdgl9it
         nwnsOd5ScvRAo4n8nHAnVn/K8PjFM/Ua3pDNMUM9MI/KAKjo7kFKamhmEsrshoWIokL8
         8d0A==
X-Gm-Message-State: AOAM533fO2ZngNKX6CuhbyCGxisfshCDyRhh555lTgiC99nw5FeVTBiU
        ZKOUsl0fAV3v96v+Cr5e7RM5Fvot8AfmdQ==
X-Google-Smtp-Source: ABdhPJwJnXeUxnhpTMbDRQY1GX7bzgZcf78+wvrzSAYmKNWHs1PwHZLTvOfxG8s3ZncQQdgXsZ3yvg==
X-Received: by 2002:a05:6638:268b:: with SMTP id o11mr4893658jat.117.1644517402063;
        Thu, 10 Feb 2022 10:23:22 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id b6sm11895639ioz.43.2022.02.10.10.23.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 10:23:21 -0800 (PST)
Subject: Re: [PATCH net-next] ipv6: Reject routes configurations that specify
 dsfield (tos)
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7bbeba35-17a7-f8ba-0587-4bb1c9b6721e@linuxfoundation.org>
Date:   Thu, 10 Feb 2022 11:23:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <51234fd156acbe2161e928631cdc3d74b00002a7.1644505353.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/22 8:08 AM, Guillaume Nault wrote:
> The ->rtm_tos option is normally used to route packets based on both
> the destination address and the DS field. However it's ignored for
> IPv6 routes. Setting ->rtm_tos for IPv6 is thus invalid as the route
> is going to work only on the destination address anyway, so it won't
> behave as specified.
> 
> Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
> The same problem exists for ->rtm_scope. I'm working only on ->rtm_tos
> here because IPv4 recently started to validate this option too (as part
> of the DSCP/ECN clarification effort).
> I'll give this patch some soak time, then send another one for
> rejecting ->rtm_scope in IPv6 routes if nobody complains.
> 
>   net/ipv6/route.c                         |  6 ++++++
>   tools/testing/selftests/net/fib_tests.sh | 13 +++++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index f4884cda13b9..dd98a11fbdb6 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5009,6 +5009,12 @@ static int rtm_to_fib6_config(struct sk_buff *skb, struct nlmsghdr *nlh,
>   	err = -EINVAL;
>   	rtm = nlmsg_data(nlh);
>   
> +	if (rtm->rtm_tos) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Invalid dsfield (tos): option not available for IPv6");

Is this an expected failure on ipv6, in which case should this test report
pass? Should it print "failed as expected" or is returning fail from errout
is what should happen?

> +		goto errout;
> +	}
> +
>   	*cfg = (struct fib6_config){
>   		.fc_table = rtm->rtm_table,
>   		.fc_dst_len = rtm->rtm_dst_len,
> diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
> index bb73235976b3..e2690cc42da3 100755
> --- a/tools/testing/selftests/net/fib_tests.sh
> +++ b/tools/testing/selftests/net/fib_tests.sh
> @@ -988,12 +988,25 @@ ipv6_rt_replace()
>   	ipv6_rt_replace_mpath
>   }
>   
> +ipv6_rt_dsfield()
> +{
> +	echo
> +	echo "IPv6 route with dsfield tests"
> +
> +	run_cmd "$IP -6 route flush 2001:db8:102::/64"
> +
> +	# IPv6 doesn't support routing based on dsfield
> +	run_cmd "$IP -6 route add 2001:db8:102::/64 dsfield 0x04 via 2001:db8:101::2"
> +	log_test $? 2 "Reject route with dsfield"
> +}
> +
>   ipv6_route_test()
>   {
>   	route_setup
>   
>   	ipv6_rt_add
>   	ipv6_rt_replace
> +	ipv6_rt_dsfield
>   
>   	route_cleanup
>   }
> 

With the above comment addressed or explained.

Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
