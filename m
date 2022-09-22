Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97FC5E7025
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 01:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiIVXRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 19:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiIVXRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 19:17:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB261138EE
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E9DD61590
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 23:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A1DC433C1;
        Thu, 22 Sep 2022 23:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663888628;
        bh=HcPAYrm1LEaADnC7WHOnCiJ2QbLIY65G6EPyA6tGvAw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YzxMBpvpb3X0qUbsCh0nq4xtOb9M2OY3HeO3IC1AFkbUNF7+xafHGSUW5GY4HZjbQ
         3EmIN3LUveN6gRCp9GlxEbF+l6wlavrsAgO9IBa8h/7xfHzDgHJY8JINKgjTjjqjqO
         HhMaCZrdgix2DyiwoDRbhfcUJ3VHoPmFwjcytcYOSkzy/lw+io3WsZ8qDhJCdo0UDs
         tJX0kisL+Th16XJKXsOYbS/kc9irWB3NfDSoZh803ZqsVKhVnmwkfUHaoczYbOHLaQ
         tu/IRkRJeg8dqEhZhEwpXrMtkFOOUwIPZ8g/IXGwoQRN9H1DbqA9nG5KuIVt6Pa/ZQ
         nLmmZNmRzhoVw==
Message-ID: <fba2ec25-d15c-8c1a-32f8-d20d81c1f1cb@kernel.org>
Date:   Thu, 22 Sep 2022 16:17:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next 1/1] ip: add NLM_F_ECHO support
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>
References: <20220916033428.400131-1-liuhangbin@gmail.com>
 <20220916033428.400131-2-liuhangbin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220916033428.400131-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/22 9:34 PM, Hangbin Liu wrote:
> When user space configures the kernel with netlink messages, it can set the
> NLM_F_ECHO flag to request the kernel to send the applied configuration back
> to the caller. This allows user space to retrieve configuration information
> that are filled by the kernel (either because these parameters can only be
> set by the kernel or because user space let the kernel choose a default
> value).
> 
> NLM_F_ACK is also supplied incase the kernel doesn't support NLM_F_ECHO
> and we will wait for the reply forever. Just like the update in
> iplink.c, which I plan to post a patch to kernel later.
> 
> A new parameter -echo is added when user want to get feedback from kernel.
> e.g.
> 
>   # ip -echo addr add 192.168.0.1/24 dev eth1
>   3: eth1    inet 192.168.0.1/24 scope global eth1
>          valid_lft forever preferred_lft forever
>   # ip -j -p -echo addr del 192.168.0.1/24 dev eth1
>   [ {
>           "deleted": true,
>           "index": 3,
>           "dev": "eth1",
>           "family": "inet",
>           "local": "192.168.0.1",
>           "prefixlen": 24,
>           "scope": "global",
>           "label": "eth1",
>           "valid_life_time": 4294967295,
>           "preferred_life_time": 4294967295
>       } ]
> 
> Suggested-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/utils.h |  1 +
>  ip/ip.c         |  3 +++
>  ip/ipaddress.c  | 23 +++++++++++++++++++++--
>  ip/iplink.c     | 20 +++++++++++++++++++-
>  ip/ipnexthop.c  | 21 ++++++++++++++++++++-
>  ip/iproute.c    | 21 ++++++++++++++++++++-
>  ip/iprule.c     | 21 ++++++++++++++++++++-
>  man/man8/ip.8   |  4 ++++
>  8 files changed, 108 insertions(+), 6 deletions(-)
> 

> @@ -2416,6 +2416,11 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>  	__u32 preferred_lft = INFINITY_LIFE_TIME;
>  	__u32 valid_lft = INFINITY_LIFE_TIME;
>  	unsigned int ifa_flags = 0;
> +	struct nlmsghdr *answer;
> +	int ret;
> +
> +	if (echo_request)
> +		req.n.nlmsg_flags |= NLM_F_ECHO|NLM_F_ACK;

fixed the spacing on the flags (all locations) and applied to iproute2-next.


>  
>  	while (argc > 0) {
>  		if (strcmp(*argv, "peer") == 0 ||
> @@ -2597,9 +2602,23 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>  		return -1;
>  	}
>  
> -	if (rtnl_talk(&rth, &req.n, NULL) < 0)
> +	if (echo_request)
> +		ret = rtnl_talk(&rth, &req.n, &answer);
> +	else
> +		ret = rtnl_talk(&rth, &req.n, NULL);
> +
> +	if (ret < 0)
>  		return -2;
>  
> +	if (echo_request) {
> +		new_json_obj(json);
> +		open_json_object(NULL);
> +		print_addrinfo(answer, stdout);
> +		close_json_object();
> +		delete_json_obj();
> +		free(answer);
> +	}

That list is redundant. I think it can be turned into a util function
that takes an the print function as an input argument.


