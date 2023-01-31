Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322A9683224
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjAaQD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAaQDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:03:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D364B181;
        Tue, 31 Jan 2023 08:03:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A8861593;
        Tue, 31 Jan 2023 16:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C49FC4339B;
        Tue, 31 Jan 2023 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675181026;
        bh=UX+yQLDq7VrhLvnZlMtmwzCmWD7VUrxQjpb7+3bLHuc=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=lyf2vcod5dIuTiaP82FMDWgf3IeIMm4bdNaJ+E3zPfjNv9D6Snum5QTOT+wxRKf3j
         8OlAzlD7u3/AIwHTJv/JERzSEDesjStlIbze5Zhb8d1Nfz/u8GX8t9V9n7tydivF8Q
         r9tS/zHI+6POZ1TLBLKbUYuc3F06c/XuiMyyG/CU9JVQWNGVAlZEAzNARL1+7zbO58
         KZO/3S5wX02sb4GCoSvCCoxRYMCsT8mss8QsCj18CJKYozPl9V6hzD0KBeByEGvfo7
         lkgubQKkpfeF+0SkbqRhbjQlbvYMXrkS/xxZabKd+Eqagn5U9BkPRyLUEKff7PAn2c
         72e2QyCrw0nGQ==
Message-ID: <91aab3d6-1167-fc19-4bbf-f679de1418c5@kernel.org>
Date:   Tue, 31 Jan 2023 09:03:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v5 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Content-Language: en-US
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, pabeni@redhat.com,
        edumazet@google.com, kuba@kernel.org, a@unstable.cc,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230131034646.237671-1-Thomas.Winter@alliedtelesis.co.nz>
 <20230131034646.237671-2-Thomas.Winter@alliedtelesis.co.nz>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230131034646.237671-2-Thomas.Winter@alliedtelesis.co.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 8:46 PM, Thomas Winter wrote:
> For our point-to-point GRE tunnels, they have IN6_ADDR_GEN_MODE_NONE
> when they are created then we set IN6_ADDR_GEN_MODE_EUI64 when they
> come up to generate the IPv6 link local address for the interface.
> Recently we found that they were no longer generating IPv6 addresses.
> This issue would also have affected SIT tunnels.
> 
> Commit e5dd729460ca changed the code path so that GRE tunnels
> generate an IPv6 address based on the tunnel source address.
> It also changed the code path so GRE tunnels don't call addrconf_addr_gen
> in addrconf_dev_config which is called by addrconf_sysctl_addr_gen_mode
> when the IN6_ADDR_GEN_MODE is changed.
> 
> This patch aims to fix this issue by moving the code in addrconf_notify
> which calls the addr gen for GRE and SIT into a separate function
> and calling it in the places that expect the IPv6 address to be
> generated.
> 
> The previous addrconf_dev_config is renamed to addrconf_eth_config
> since it only expected eth type interfaces and follows the
> addrconf_gre/sit_config format.
> 
> A part of this changes means that the loopback address will be
> attempted to be configured when changing addr_gen_mode for lo.
> This should not be a problem because the address should exist anyway
> and if does already exist then no error is produced.
> 
> Fixes: e5dd729460ca ("ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL address")
> Signed-off-by: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
> ---
>  net/ipv6/addrconf.c | 49 +++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 22 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


