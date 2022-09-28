Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72895ED350
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiI1DMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiI1DMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:12:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2861D73F6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:12:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 883E761CF8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 03:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F29C433D6;
        Wed, 28 Sep 2022 03:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664334757;
        bh=2ikR7hGcWsI8PLJQqexojMwxQ+jxCE1HQifWZTO9Ai8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ed/nAC3YtWYi9KW/ifVDuTBIGud4HNeYtHXIVnUuPpJ4LGhnfGLBB/9pJOCUsBdC5
         OZzYE90zrqUGGzBjj/m7S6GZDjjcYR6eVoYBUQb0ro7a6SOyS9UI/GAQBuZ4/hSAZ5
         tnYtegJiASFODgr6sNBU+dZP+64nOvvApSA52ElBG5CKmnsfuecfXEfrtEvich6a6z
         5y6JJWAJnGNXSjdjIBWFdqkaXUhJMgQa7pCyto1HksQcw7jkCIUekG2UoMmf9ByUa2
         jDHsyovlxpwdSgXqclEc5gWM5TA9LMw4kkt3PTdyCPnpvZvX2Lwb5lnm5R3OU3K4Pl
         X0VCSmdHOvDww==
Message-ID: <115c54d7-87fc-2c50-bc27-ad7cdb27bb2c@kernel.org>
Date:   Tue, 27 Sep 2022 21:12:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Guillaume Nault <gnault@redhat.com>
References: <20220923042000.602250-1-liuhangbin@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220923042000.602250-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/22 9:20 PM, Hangbin Liu wrote:
> Add a new function rtnl_echo_talk() that could be used when the
> sub-component supports NLM_F_ECHO flag. With this function we can
> remove the redundant code added by commit b264b4c6568c7 ("ip: add
> NLM_F_ECHO support").
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/libnetlink.h |  4 ++++
>  include/utils.h      |  1 -
>  ip/ipaddress.c       | 24 +-----------------------
>  ip/iplink.c          | 20 +-------------------
>  ip/ipnexthop.c       | 23 +----------------------
>  ip/iproute.c         | 24 +-----------------------
>  ip/iprule.c          | 24 +-----------------------
>  lib/libnetlink.c     | 31 +++++++++++++++++++++++++++++++
>  8 files changed, 40 insertions(+), 111 deletions(-)
> 
> diff --git a/include/libnetlink.h b/include/libnetlink.h
> index a7b0f352..e9125f04 100644
> --- a/include/libnetlink.h
> +++ b/include/libnetlink.h
> @@ -44,6 +44,7 @@ struct ipstats_req {
>  };
>  
>  extern int rcvbuf;
> +extern int echo_request;
>  
>  int rtnl_open(struct rtnl_handle *rth, unsigned int subscriptions)
>  	__attribute__((warn_unused_result));
> @@ -171,6 +172,9 @@ int rtnl_dump_filter_errhndlr_nc(struct rtnl_handle *rth,
>  #define rtnl_dump_filter_errhndlr(rth, filter, farg, errhndlr, earg) \
>  	rtnl_dump_filter_errhndlr_nc(rth, filter, farg, errhndlr, earg, 0)
>  
> +int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
> +		   int (*print_info)(struct nlmsghdr *n, void *arg))
> +	__attribute__((warn_unused_result));
>  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
>  	      struct nlmsghdr **answer)
>  	__attribute__((warn_unused_result));
> diff --git a/include/utils.h b/include/utils.h
> index 2eb80b3e..eeb23a64 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -36,7 +36,6 @@ extern int max_flush_loops;
>  extern int batch_mode;
>  extern int numeric;
>  extern bool do_all;
> -extern int echo_request;
>  
>  #ifndef CONFDIR
>  #define CONFDIR		"/etc/iproute2"
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index 986cfbc3..89acfeaa 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -2422,11 +2422,6 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>  	__u32 preferred_lft = INFINITY_LIFE_TIME;
>  	__u32 valid_lft = INFINITY_LIFE_TIME;
>  	unsigned int ifa_flags = 0;
> -	struct nlmsghdr *answer;
> -	int ret;
> -
> -	if (echo_request)
> -		req.n.nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
>  
>  	while (argc > 0) {
>  		if (strcmp(*argv, "peer") == 0 ||
> @@ -2608,24 +2603,7 @@ static int ipaddr_modify(int cmd, int flags, int argc, char **argv)
>  		return -1;
>  	}
>  
> -	if (echo_request)
> -		ret = rtnl_talk(&rth, &req.n, &answer);
> -	else
> -		ret = rtnl_talk(&rth, &req.n, NULL);
> -
> -	if (ret < 0)
> -		return -2;
> -
> -	if (echo_request) {
> -		new_json_obj(json);
> -		open_json_object(NULL);
> -		print_addrinfo(answer, stdout);
> -		close_json_object();
> -		delete_json_obj();
> -		free(answer);
> -	}
> -
> -	return 0;
> +	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);

I was thinking something more like:

if (echo_request)
	return rtnl_echo_talk(&rth, &req.n, print_addrinfo);

return rtnl_talk(&rth, &req.n, NULL);


> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> index c27627fe..00feb69b 100644
> --- a/lib/libnetlink.c
> +++ b/lib/libnetlink.c
> @@ -42,7 +42,9 @@
>  #define MIN(a, b) ((a) < (b) ? (a) : (b))
>  #endif
>  
> +int json;
>  int rcvbuf = 1024 * 1024;
> +int echo_request = 0;

which means you don't need this; the json arg will need to be passed to
rtnl_echo_talk since it is owned by the commands.


>  
>  #ifdef HAVE_LIBMNL
>  #include <libmnl/libmnl.h>
> @@ -1139,6 +1141,35 @@ static int __rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
>  	return __rtnl_talk_iov(rtnl, &iov, 1, answer, show_rtnl_err, errfn);
>  }
>  
> +int rtnl_echo_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
> +		   int (*print_info)(struct nlmsghdr *n, void *arg))
> +{
> +	struct nlmsghdr *answer;
> +	int ret;
> +
> +	if (echo_request)
> +		n->nlmsg_flags |= NLM_F_ECHO | NLM_F_ACK;
> +
> +	if (echo_request)
> +		ret = rtnl_talk(rtnl, n, &answer);
> +	else
> +		ret = rtnl_talk(rtnl, n, NULL);
> +
> +	if (ret < 0)
> +		return -2;
> +
> +	if (echo_request) {
> +		new_json_obj(json);
> +		open_json_object(NULL);
> +		print_info(answer, stdout);
> +		close_json_object();
> +		delete_json_obj();
> +		free(answer);
> +	}
> +
> +	return 0;
> +}
> +
>  int rtnl_talk(struct rtnl_handle *rtnl, struct nlmsghdr *n,
>  	      struct nlmsghdr **answer)
>  {

