Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0FA698C98
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBPGHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBPGHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:07:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012422727;
        Wed, 15 Feb 2023 22:07:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A662BB825BC;
        Thu, 16 Feb 2023 06:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E705DC433D2;
        Thu, 16 Feb 2023 06:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527669;
        bh=2Qv9noaxQsKR0qp3QewYbZT9r7oAe6fTW7m9I/7yqb8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=B7QpSKAeWgTmNbn1RQqxVzb9uJ+/abh484nfJv72Y2uYX0lqEdr1Ur131xwv1EZi9
         pr0lN55Gm0rslDJRWgJCZGJpFIGNvHgyxutFR20l87Sgx5FujfHCk0NaZo9cUnvjhu
         WACWLrOykmlHpoSULYLUh1paq9dqcP8GJ+tKmv7MZDiBnEW1Z44ZUaxU80OmRAt4HJ
         PQYbUxofn7CxxGGI/C0S0iCX9dpJwBVMG0/7Ma8wlwI4qHr8YrXMQkCCDbB1NdqifB
         GrKrWXJex/Pj9jR4XuCPoYu48aQel+pebQIkEO1Z9nkHJdWlheQk1zlrNVgZx6VfpU
         yg4Z3M6qO/XWg==
Message-ID: <2975663a-4cf9-b7cd-7509-9f48f815a56e@kernel.org>
Date:   Wed, 15 Feb 2023 23:07:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [net-next 2/3] seg6: add PSP flavor support for SRv6 End behavior
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
 <20230215134659.7613-3-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230215134659.7613-3-andrea.mayer@uniroma2.it>
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

On 2/15/23 6:46 AM, Andrea Mayer wrote:
> The "flavors" framework defined in RFC8986 [1] represents additional
> operations that can modify or extend a subset of existing behaviors such as
> SRv6 End, End.X and End.T. We report these flavors hereafter:
>  - Penultimate Segment Pop (PSP);
>  - Ultimate Segment Pop (USP);
>  - Ultimate Segment Decapsulation (USD).
> 
> Depending on how the Segment Routing Header (SRH) has to be handled, an
> SRv6 End* behavior can support these flavors either individually or in
> combinations.
> In this patch, we only consider the PSP flavor for the SRv6 End behavior.
> 
> A PSP enabled SRv6 End behavior is used by the Source/Ingress SR node
> (i.e., the one applying the SRv6 Policy) when it needs to instruct the
> penultimate SR Endpoint node listed in the SID List (carried by the SRH) to
> remove the SRH from the IPv6 header.
> 
> Specifically, a PSP enabled SRv6 End behavior processes the SRH by:
>    i) decreasing the Segment Left (SL) from 1 to 0;
>   ii) copying the Last Segment IDentifier (SID) into the IPv6 Destination
>       Address (DA);
>  iii) removing (i.e., popping) the outer SRH from the extension headers
>       following the IPv6 header.
> 
> It is important to note that PSP operation (steps i, ii, iii) takes place
> only at a penultimate SR Segment Endpoint node (i.e., when the SL=1) and
> does not happen at non-penultimate Endpoint nodes. Indeed, when a SID of
> PSP flavor is processed at a non-penultimate SR Segment Endpoint node, the
> PSP operation is not performed because it would not be possible to decrease
> the SL from 1 to 0.
> 
>                                                  SL=2 SL=1 SL=0
>                                                    |    |    |
> For example, given the SRv6 policy (SID List := <  X,   Y,   Z  >):
>  - a PSP enabled SRv6 End behavior bound to SID "Y" will apply the PSP
>    operation as Segment Left (SL) is 1, corresponding to the Penultimate
>    Segment of the SID List;
>  - a PSP enabled SRv6 End behavior bound to SID "X" will *NOT* apply the
>    PSP operation as the Segment Left is 2. This behavior instance will
>    apply the "standard" End packet processing, ignoring the configured PSP
>    flavor at all.
> 
> [1] - RFC8986: https://datatracker.ietf.org/doc/html/rfc8986
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 336 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 333 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


