Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4395BB13F
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIPQsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiIPQsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:48:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE38A6C3A;
        Fri, 16 Sep 2022 09:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89050B82868;
        Fri, 16 Sep 2022 16:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A2CC433C1;
        Fri, 16 Sep 2022 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663346923;
        bh=+vXVK5L4p89KIlITqarB2UspkycCjrgWVBIxqSVqJSg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=F9NHWnPKvRTk/oHjbrf4w8BlNCdDH/00/QdaSC4EbBi9iuIuIeRvciiKkFZa3t/BE
         by7Rg0ZLyJWCb7Bhxkfx5K9UPlTOQSoedD/+VlIlLDBU1u/rKIKEXNH26YdyQQT8lZ
         b232Vh0jmhSAb74LWvV/iYCuMpX6wKJsPC4/OutUgfsD7OI/ITff7SgROdC+aKue/8
         Qepx5cJ+fDM8PzH8ooq4NfUjy3icUFUxASvpm8ulTIO7qFGhws8KXDXk1vkReRqQ79
         dzoC31HgdklpA9YES5dI6bCWEsTIUpyaCn/JTJ1mGVkcYk69e1pA9a+rUk5qiMsBIJ
         o8SqxiDkwfrVA==
Message-ID: <c7ef0978-ffa3-8e67-98db-12ffd58a1e7d@kernel.org>
Date:   Fri, 16 Sep 2022 10:48:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [net-next v2 2/3] seg6: add NEXT-C-SID support for SRv6 End
 behavior
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
 <20220912171619.16943-3-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220912171619.16943-3-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 11:16 AM, Andrea Mayer wrote:
> The NEXT-C-SID mechanism described in [1] offers the possibility of
> encoding several SRv6 segments within a single 128 bit SID address. Such
> a SID address is called a Compressed SID (C-SID) container. In this way,
> the length of the SID List can be drastically reduced.
> 
> A SID instantiated with the NEXT-C-SID flavor considers an IPv6 address
> logically structured in three main blocks: i) Locator-Block; ii)
> Locator-Node Function; iii) Argument.
> 
>                         C-SID container
> +------------------------------------------------------------------+
> |     Locator-Block      |Loc-Node|            Argument            |
> |                        |Function|                                |
> +------------------------------------------------------------------+
> <--------- B -----------> <- NF -> <------------- A --------------->
> 
>    (i) The Locator-Block can be any IPv6 prefix available to the provider;
> 
>   (ii) The Locator-Node Function represents the node and the function to
>        be triggered when a packet is received on the node;
> 
>  (iii) The Argument carries the remaining C-SIDs in the current C-SID
>        container.
> 
> The NEXT-C-SID mechanism relies on the "flavors" framework defined in
> [2]. The flavors represent additional operations that can modify or
> extend a subset of the existing behaviors.
> 
> This patch introduces the support for flavors in SRv6 End behavior
> implementing the NEXT-C-SID one. An SRv6 End behavior with NEXT-C-SID
> flavor works as an End behavior but it is capable of processing the
> compressed SID List encoded in C-SID containers.
> 
> An SRv6 End behavior with NEXT-C-SID flavor can be configured to support
> user-provided Locator-Block and Locator-Node Function lengths. In this
> implementation, such lengths must be evenly divisible by 8 (i.e. must be
> byte-aligned), otherwise the kernel informs the user about invalid
> values with a meaningful error code and message through netlink_ext_ack.
> 
> If Locator-Block and/or Locator-Node Function lengths are not provided
> by the user during configuration of an SRv6 End behavior instance with
> NEXT-C-SID flavor, the kernel will choose their default values i.e.,
> 32-bit Locator-Block and 16-bit Locator-Node Function.
> 
> [1] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
> [2] - https://datatracker.ietf.org/doc/html/rfc8986
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  24 +++
>  net/ipv6/seg6_local.c           | 335 +++++++++++++++++++++++++++++++-
>  2 files changed, 356 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

