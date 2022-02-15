Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DFA4B75B1
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbiBOQqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:46:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBOQqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:46:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D540F1019EA
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 08:46:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F7C2B81B83
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23412C340EB;
        Tue, 15 Feb 2022 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644943578;
        bh=eOEt5OqJnhSnOG2P62Y1jkQyaA78kA5bGwmj6wUabt8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ofgFiNmtuAv3BGe7jKK8FKpXGf35GHPr7wRxMXzaXPttX3p4OCVFRSItCtEqaZM+R
         TRYrKAfzQID9X497QZpypA2N/6Gm1s84+gOKmhKIOw4nAQcSsLnGcFkjxVS1DTVUD0
         haPVRBYyv/LhqWUEs665EMht92JKFPv5WzczUMp3m5NjM3PqqfF/WojVIzYGpg1sLT
         s8oJqKBWW5YvnjrmaYG8AU4/alit8AN5RFzxOclEOMujWXTA7HSodzJMIz8We0SCyv
         p3xffhmaadXB4lh4lbFrV1FcJ5weTH81VUvvSl+3zuy30s37dRerXUOGjervmN9H8i
         lLFRqZnzvCNng==
Message-ID: <b4a22e7a-7566-372f-6fe6-1e293f523c76@kernel.org>
Date:   Tue, 15 Feb 2022 09:46:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v3 net-next 1/1] net: Add new protocol attribute to IP
 addresses
Content-Language: en-US
To:     Jacques de Laval <Jacques.De.Laval@westermo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org
References: <20220214155906.906381-1-Jacques.De.Laval@westermo.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220214155906.906381-1-Jacques.De.Laval@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/22 8:59 AM, Jacques de Laval wrote:
> This patch adds a new protocol attribute to IPv4 and IPv6 addresses.
> Inspiration was taken from the protocol attribute of routes. User space
> applications like iproute2 can set/get the protocol with the Netlink API.
> 
> The attribute is stored as an 8-bit unsigned integer.
> 
> The protocol attribute is set by kernel for these categories:
> 
> - IPv4 and IPv6 loopback addresses
> - IPv6 addresses generated from router announcements
> - IPv6 link local addresses
> 
> User space may pass custom protocols, not defined by the kernel.
> 
> Grouping addresses on their origin is useful in scenarios where you want
> to distinguish between addresses based on who added them, e.g. kernel
> vs. user space.
> 
> Tagging addresses with a string label is an existing feature that could be
> used as a solution. Unfortunately the max length of a label is
> 15 characters, and for compatibility reasons the label must be prefixed
> with the name of the device followed by a colon. Since device names also
> have a max length of 15 characters, only -1 characters is guaranteed to be
> available for any origin tag, which is not that much.
> 
> A reference implementation of user space setting and getting protocols
> is available for iproute2:
> 
> https://github.com/westermo/iproute2/commit/9a6ea18bd79f47f293e5edc7780f315ea42ff540
> 
> Signed-off-by: Jacques de Laval <Jacques.De.Laval@westermo.com>
> 
> ---
> v1 -> v2:
>   - Move ifa_prot to existing holes in structs (David)
>   - Change __u8 to u8 (Jakub)
>   - Define and use constants for addresses set by kernel (David)
> v2 -> v3:
>   - Document userspace attribute in comment (David)
>   - Fix comment formatting (David)
>   - Don't set IFAPROT_KERNEL_LO in inet_set_ifa, could be userspace
>     initiated (David)
>   - Only set protocol attribute if specified (David)
> ---
>  include/linux/inetdevice.h   |  1 +
>  include/net/addrconf.h       |  2 ++
>  include/net/if_inet6.h       |  2 ++
>  include/uapi/linux/if_addr.h |  9 ++++++++-
>  net/ipv4/devinet.c           |  7 +++++++
>  net/ipv6/addrconf.c          | 27 +++++++++++++++++++++------
>  6 files changed, 41 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

