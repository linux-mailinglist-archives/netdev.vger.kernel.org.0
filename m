Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39A64FA0FB
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 03:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237635AbiDIBUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 21:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDIBUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 21:20:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430C56398;
        Fri,  8 Apr 2022 18:18:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 96EF3CE2E75;
        Sat,  9 Apr 2022 01:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F209FC385A3;
        Sat,  9 Apr 2022 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649467085;
        bh=JDgbXu1r/B28ewr+7REvw/NDIWKfigmu2Yr8qTLopwE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oMkqk95vMf9qSSqPS3B6245igexQ2zmPBPLB2m/ASzh3TnC6e4FjjA+Jn+8DQ3kNy
         uXLRF6CHxMJGvVRpdGvHaoK/XcFqUKJY08D8oEzl16F5fSK7EV2aUFKljDvjwIirCk
         0K3Z71zNI50eW88wneZHvjHpHNA3RlsHNDoOHDmX4vPM7sA7t8goyEyf3an446d6aB
         RXj0DXXd+Yr9kib8b0UBkLRerzelf8JykaOP4v7UQiRv8Dvw+bpa115QX0agKjkxgq
         0O6rpNjYX77A9i4KJ4QAwL0AJSB3CzvS+xxW4/hyqkTiKlKhKLjQBQQL6vqSmCA7Hz
         Zs492SPJefBHA==
Message-ID: <d7a85a29-0d7f-b5e2-c908-4aa9f89bb476@kernel.org>
Date:   Fri, 8 Apr 2022 19:18:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        prestwoj@gmail.com, gilligan@arista.com, noureddine@arista.com,
        gk@arista.com
References: <20220407074428.1623-1-aajith@arista.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220407074428.1623-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 1:44 AM, Arun Ajith S wrote:
> Add a new neighbour cache entry in STALE state for routers on receiving
> an unsolicited (gratuitous) neighbour advertisement with
> target link-layer-address option specified.
> This is similar to the arp_accept configuration for IPv4.
> A new sysctl endpoint is created to turn on this behaviour:
> /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
> 
> Signed-off-by: Arun Ajith S <aajith@arista.com>
> Tested-by: Arun Ajith S <aajith@arista.com>

you don't need the Tested-by line since you wrote the patch; you are
expected to test it.


> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 1afc4c024981..1b4d278d0454 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -5587,6 +5587,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
>  	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
>  	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
>  	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
> +	array[DEVCONF_ACCEPT_UNSOLICITED_NA] = cnf->accept_unsolicited_na;
>  }
>  
>  static inline size_t inet6_ifla6_size(void)
> @@ -7037,6 +7038,13 @@ static const struct ctl_table addrconf_sysctl[] = {
>  		.extra1		= (void *)SYSCTL_ZERO,
>  		.extra2		= (void *)SYSCTL_ONE,
>  	},
> +	{
> +		.procname	= "accept_unsolicited_na",
> +		.data		= &ipv6_devconf.accept_unsolicited_na,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,
> +	},

I realize drop_unsolicited_na does not have limits, but this is a new
sysctl - add the upper and lower bounds via extra1 and extra2 arguments.



also, please add test cases under tools/testing/selftests/net. You can
use fib_tests.sh as a template. mausezahn is already used in a number of
tests; it should be able to create the NA packets. Be sure to cover
combinations of drop and accept settings.
