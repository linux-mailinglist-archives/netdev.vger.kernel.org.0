Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A447B5E6FDD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 00:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiIVWmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 18:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiIVWmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 18:42:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFE3105D7D
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 15:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BAFC62D68
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 22:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8044C433D6;
        Thu, 22 Sep 2022 22:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663886520;
        bh=qfXpOkzMcqsY6dDNkmG/T0Wjwou6IaHcuod2328WmCw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rjCLtfLifSYRilta0Z2z1YIeEkmyJ61z4/1V9AUcsewLLuFepNzy6YoisEdJYz+Oo
         A7bnR7bDeQ3z5dIkpVOJuoMhPdeT5ztL2d6v/jGmC92Xa63zU6W5UKK8jDWkZ6a7Kd
         YxktIB3J3HvKMbGqi2c0igdfcqTrb2HCzXec7PurRq9Kh0W9j58HRF154vC+4RdKTU
         R5CHEI0KgvobSeAvX/+ZNzc4JYa3afgwJWJJ317Hwc9gzuXjwogyTkbvNSDhTv+qO2
         XYej7W6RmFxLl5IiKlKPNzzGAp3vuhzhSgOALmVy4fnhZBhOHwteqGbyKWfNwks8YR
         K5Nesn5OOcQOw==
Message-ID: <f39ce7bb-edea-0325-1bc4-408ce9a410a5@kernel.org>
Date:   Thu, 22 Sep 2022 15:41:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v3 iproute2-next] ip link: add sub-command to view and
 change DSA conduit interface
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220922220655.2183524-1-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220922220655.2183524-1-vladimir.oltean@nxp.com>
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

On 9/22/22 4:06 PM, Vladimir Oltean wrote:
> Support the "dsa" kind of rtnl_link_ops exported by the kernel, and
> export reads/writes to IFLA_DSA_MASTER.
> 
> Examples:
> 
> $ ip link set swp0 type dsa conduit eth1
> 
> $ ip -d link show dev swp0
>     (...)
>     dsa conduit eth0
> 
> $ ip -d -j link show swp0
> [
> 	{
> 		"link": "eth1",
> 		"linkinfo": {
> 			"info_kind": "dsa",
> 			"info_data": {
> 				"conduit": "eth1"
> 			}
> 		},
> 	}
> ]
> 
> Note that by construction and as shown in the example, the IFLA_LINK
> reported by a DSA user port is identical to what is reported through
> IFLA_DSA_MASTER. However IFLA_LINK is not writable, and overloading its
> meaning to make it writable would clash with other users of IFLA_LINK
> (vlan etc) for which writing this property does not make sense.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2:
> - update man page
> v2->v3:
> - update main ip-link help text to print the new 'dsa' link type
> - rename the 'master' keyword to 'conduit' and keep 'master' as a
>   fallback
> - to avoid using the 'DSA master' term in the man page, stop explaining
>   which interfaces are eligible for this operation, and just refer to
>   the kernel documentation. Note that since the support was added in
>   net-next, the htmldocs have not been regenerated yet.
> 
>  include/uapi/linux/if_link.h | 10 ++++++
>  ip/Makefile                  |  2 +-
>  ip/iplink.c                  |  2 +-
>  ip/iplink_dsa.c              | 68 ++++++++++++++++++++++++++++++++++++
>  man/man8/ip-link.8.in        | 35 +++++++++++++++++++
>  5 files changed, 115 insertions(+), 2 deletions(-)
>  create mode 100644 ip/iplink_dsa.c
> 

LGTM.

