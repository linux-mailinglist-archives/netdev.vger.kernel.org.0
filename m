Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E2851B6E4
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 06:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbiEEEFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 00:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiEEEFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 00:05:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7F74AE16;
        Wed,  4 May 2022 21:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F4FB82A86;
        Thu,  5 May 2022 04:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B2DC385AC;
        Thu,  5 May 2022 04:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651723302;
        bh=FYC0CvQaP+3mMgxceGHIF8Aw1uZcq1KmRRW+MxCfV2I=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mQYJIj0+JWE20dxYT8W3Z04gILiggLvIy9ppMpDnUNbXVcZp+4dGuY+9nSU7GneeK
         pEsMRCB3sqDCE6N7KgTU1hoFWcfMkcakm7q5uowHrDjiJ5+rsBNmGewvw7ieLTK+Cj
         vABJhgV8R5xdQQjM2HvszqoHDDQ9aI635h9wE+NlaWwe/8xKPAs1JxH+FSXszm/9tz
         HRIf2PcDq/+sOnlvpWMxnTInPB8vOrL7tsAQE3khHppXtdSqlLT3dBtK2Um4C6NPjC
         3dhSQKJ//JGgbMg5MSe1i4WEBo/fDaVU3wvxIU8g6ncwyyg0nwrExg8qKJXQT9Bvim
         QLq7VMqVlJwKQ==
Message-ID: <f2ccff61-bc6d-1a99-dcbd-31b4e5153097@kernel.org>
Date:   Wed, 4 May 2022 21:01:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net v3 1/2] ping: fix address binding wrt vrf
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org
References: <1238b102-f491-a917-3708-0df344015a5b@kernel.org>
 <20220504090739.21821-1-nicolas.dichtel@6wind.com>
 <20220504090739.21821-2-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220504090739.21821-2-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 2:07 AM, Nicolas Dichtel wrote:
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
> $ ip addr add 2001::1/64 dev foo
> $ ip vrf exec blue ping -c1 -I 192.168.1.1 192.168.1.2
> ping: bind: Cannot assign requested address
> $ ip vrf exec blue ping6 -c1 -I 2001::1 2001::2
> ping6: bind icmp socket: Cannot assign requested address
> 
> CC: stable@vger.kernel.org
> Fixes: 1b69c6d0ae90 ("net: Introduce L3 Master device abstraction")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  net/ipv4/ping.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

