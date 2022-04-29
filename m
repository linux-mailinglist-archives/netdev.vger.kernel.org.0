Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15A4514D09
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377409AbiD2OfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377425AbiD2Oex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:34:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5B1A6E24;
        Fri, 29 Apr 2022 07:31:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B761860B15;
        Fri, 29 Apr 2022 14:31:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B1EC385A4;
        Fri, 29 Apr 2022 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651242694;
        bh=CWUzOtMAtybDxhiq6X4Ml4sC7Vxi6rh8OhBl7RWHB3Q=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=houkluulPYeEjoL+4Ik1Vx+WGespqT4lRuNjpGkHpFVjVPuaok5gbib2fjPZ3Ytmr
         +ofSqaVaClKniY0uUIYynNB+1jKXYHdysUS8KmO3PAlC9iFI8aA36DmAVOuxxZ9woh
         D+UkC9yRaxLjr3D8d6R0P3tXqnnDrdrpsjDi9AGddfa+buWw2meGWgl91wPQImdUr5
         /b3XbKnJtXUXDDeXVbZ6YDeY5xXAHbHIDLNKuhYGbxOksA31Ua4M7vbqHNNu9sznEj
         Pc4gOQhYZuAK40UcMH1Hm98MYqxp4qEWuJbwckkXxW6DnbTAvmHjHc1X9Rx12AEQnH
         HRGYQi2Wp2EYQ==
Message-ID: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
Date:   Fri, 29 Apr 2022 08:31:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH net v2] ping: fix address binding wrt vrf
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org
References: <20220429075659.9967-1-nicolas.dichtel@6wind.com>
 <20220429082021.10294-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220429082021.10294-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/22 2:20 AM, Nicolas Dichtel wrote:
> When ping_group_range is updated, 'ping' uses the DGRAM ICMP socket,
> instead of an IP raw socket. In this case, 'ping' is unable to bind its
> socket to a local address owned by a vrflite.
> 
> Before the patch:
> $ sysctl -w net.ipv4.ping_group_range='0  2147483647'
> $ ip link add blue type vrf table 10
> $ ip link add foo type dummy
> $ ip link set foo master blue
> $ ip link set foo up
> $ ip addr add 192.168.1.1/24 dev foo
> $ ip vrf exec blue ping -c1 -I 192.168.1.1 192.168.1.2
> ping: bind: Cannot assign requested address
> 
> CC: stable@vger.kernel.org
> Fixes: 1b69c6d0ae90 ("net: Introduce L3 Master device abstraction")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
> 
> v1 -> v2:
>  add the tag "Cc: stable@vger.kernel.org" for correct stable submission
> 
>  net/ipv4/ping.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

please add a test case to fcnal-test.sh. Does ipv6 work ok?

