Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F865E700B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 01:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiIVXC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 19:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiIVXCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 19:02:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442F4106F6E
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:02:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB1C6B80CA2
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 23:02:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59003C433C1;
        Thu, 22 Sep 2022 23:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663887741;
        bh=Ym+y7BpiCKVI59iFimUIcqRVCXSgNY98bA0x+v8uNVo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gGDqYeazUj53zKHcFcRkQYcPhdkDugsnDKwQMvBah3ztfolfv7k/4MUedGecdMPRZ
         H11IkGX5AxKUzYkoip4V4xEoI87S5gnwiusgm6SWUyvg2zUTF52hPq5VJkdarFj9fl
         BOjZNSqEvhqlBbnhr2FCbTdhYtO3SVVyBMtELcvzEb+kBXR62voSGXmP1z3uTmPdj2
         Breou+xHdGRfXQSamA1XgsdufYTe+iuc0Jmtv1DI4DRF3c2WW5paULfBRtSSWeCttc
         wOoqf9+zHQXq6sMx39uKekZzrd7KLz9jKc4mNhpIVTqiOK0utyf8UV9K32mEjbcDRd
         0i9u3eygBD6Sw==
Message-ID: <b8c54d29-7b38-e24f-9ea5-bbcb49e85cdd@kernel.org>
Date:   Thu, 22 Sep 2022 16:02:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [iproute2-next v2] seg6: add support for flavors in SRv6 End*
 behaviors
Content-Language: en-US
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20220912173923.595-1-paolo.lungaroni@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220912173923.595-1-paolo.lungaroni@uniroma2.it>
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

On 9/12/22 11:39 AM, Paolo Lungaroni wrote:
> As described in RFC 8986 [1], processing operations carried out by SRv6
> End, End.X and End.T (End* for short) behaviors can be modified or
> extended using the "flavors" mechanism. This patch adds the support for
> PSP,USP,USD flavors (defined in [1]) and for NEXT-C-SID flavor (defined
> in [2]) in SRv6 End* behaviors. Specifically, we add a new optional
> attribute named "flavors" that can be leveraged by the user to enable
> specific flavors while creating an SRv6 End* behavior instance.
> Multiple flavors can be specified together by separating them using
> commas.
> 
> If a specific flavor (or a combination of flavors) is not supported by the
> underlying Linux kernel, an error message is reported to the user and the
> creation of the specific behavior instance is aborted.
> 
> When the flavors attribute is omitted, the regular SRv6 End* behavior is
> performed.
> 
> Flavors such as PSP, USP and USD do not accept additional configuration
> attributes. Conversely, the NEXT-C-SID flavor can be configured to support
> user-provided Locator-Block and Locator-Node Function lengths using,
> respectively, the lblen and the nflen attributes.
> 
> Both lblen and nflen values must be evenly divisible by 8 and their sum
> must not exceed 128 bit (i.e. the C-SID container size).
> 
> If the lblen attribute is omitted, the default value chosen by the Linux
> kernel is 32-bit. If the nflen attribute is omitted, the default value
> chosen by the Linux kernel is 16-bit.
> 
> Some examples:
> ip -6 route add 2001:db8::1 encap seg6local action End flavors next-csid dev eth0
> ip -6 route add 2001:db8::2 encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0
> 
> Standard Output:
> ip -6 route show 2001:db8::2
> 2001:db8::2  encap seg6local action End flavors next-csid lblen 48 nflen 16 dev eth0 metric 1024 pref medium
> 
> JSON Output:
> ip -6 -j -p route show 2001:db8::2
> [ {
>         "dst": "2001:db8::2",
>         "encap": "seg6local",
>         "action": "End",
>         "flavors": [ "next-csid" ],
>         "lblen": 48,
>         "nflen": 16,
>         "dev": "eth0",
>         "metric": 1024,
>         "flags": [ ],
>         "pref": "medium"
> } ]
> 
> [1] - https://datatracker.ietf.org/doc/html/rfc8986
> [2] - https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
> 
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  24 +++++
>  ip/iproute.c                    |   4 +-
>  ip/iproute_lwtunnel.c           | 186 +++++++++++++++++++++++++++++++-
>  man/man8/ip-route.8.in          |  71 +++++++++++-
>  4 files changed, 281 insertions(+), 4 deletions(-)
> 

applied to iproute2-next. Thanks
