Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE57A500178
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 00:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiDMWDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 18:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiDMWDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 18:03:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C9321E0A;
        Wed, 13 Apr 2022 15:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A542061F6B;
        Wed, 13 Apr 2022 22:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0821C385A6;
        Wed, 13 Apr 2022 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649887249;
        bh=oM28rtasZyQEQBuedcg9Oc0qIzsKosXpfXOn6THm218=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=KxK8rXO9S3OXuvicMvvv4+11GHYPJDrsjhXxtM1j7ZTKbLS5XIx+7RIlvHsOnmTW2
         b9EqOcDbynCWuQQgAXZaHB4fjL/S/R1fmcUHshNVvkq/WdouAg5IPxvjDgkVezL0K0
         fL4mzvQRXa5W3aM+a1m5MAXx3IXXpHqJ//lFmkphNyKth30gGjZH0E7xHCXVXqk1Rk
         PvpCT+Xc4ZXvoiqbpgyyEm5CCg63/aAw5zySpg9fohwseyD7eO5fxgcXTwDvUbPA1+
         V4GToQCQSqjdw8P5nJ/8TiZclowgDpriSS31sbXNudfGw3/FSVeReq/F1xQ/V/Qle+
         3w+6Dz3dVQ6zw==
Message-ID: <17769a5b-9569-18ee-d1c0-c8971a42c709@kernel.org>
Date:   Wed, 13 Apr 2022 16:00:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v3] net/ipv6: Introduce accept_unsolicited_na
 knob to implement router-side changes for RFC9131
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        prestwoj@gmail.com, gilligan@arista.com, noureddine@arista.com,
        gk@arista.com
References: <20220413143434.527-1-aajith@arista.com>
 <5a92f5cd-9af4-4228-dc44-b0c363f30e18@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <5a92f5cd-9af4-4228-dc44-b0c363f30e18@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 3:22 PM, Eric Dumazet wrote:
> 
> On 4/13/22 07:34, Arun Ajith S wrote:
>> Add a new neighbour cache entry in STALE state for routers on receiving
>> an unsolicited (gratuitous) neighbour advertisement with
>> target link-layer-address option specified.
>> This is similar to the arp_accept configuration for IPv4.
>> A new sysctl endpoint is created to turn on this behaviour:
>> /proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.
> 
> 
> Do we really need to expose this to /proc/sys, for every interface added
> in the host ?
> 
> /proc files creations/deletion cost a lot in environments
> adding/deleting netns very often.

agree with the general intent (along with the increasing memory costs).
I do think this case should be done as a /proc/sys entry for consistency
with both ARP and existing related NA settings.

> 
> I would prefer using NETLINK attributes, a single recvmsg() syscall can
> fetch/set hundreds of them.

What do you have in mind here? A link attribute managed through `ip link
set`?

