Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C296BB7CE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjCOPaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCOPaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C76F1B2C0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2639461DA7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26952C433EF;
        Wed, 15 Mar 2023 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678894220;
        bh=3M8r3TM/8uc3G5L7HYjfAyHAm/KaW5odh9ZchirwAQY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=hoRDj5pWxoDd++56TT0x/iZ6FdEkhBkHuflFp0MA5TkOU8Unvdwo8auWxLdxjiI1d
         J3nwG+cUtMpfJHmaAtFE7eNnWRG/aYOizcIFAhbtvD0kwt7yOG1Vnnp20QUlBtibTg
         XJRdm7Kdqmi4Jwkq3CiYAWr+AEO0wlCcXPVuYE8dXxiEqXp9YSNTOsnZWIr02P4Jeb
         E5CTFLAhVcLCrEArcA38c+Xk2PGrRACybHsG/e/pKHnWmeIBu7+1THvo4Oe0Jt9ejo
         8HUVV6ldsY9tYboz9wfF6cqALrnc0LpkNO/GO3/z1xkWDxEE4BsWGJykj/0zpjsxd9
         y5rvvHnqSJdfw==
Message-ID: <419ac17f-ac4f-25bc-62d1-ddf05562764a@kernel.org>
Date:   Wed, 15 Mar 2023 09:30:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net] ipv4: Fix incorrect table ID in IOCTL path
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mark.tomlinson@alliedtelesis.co.nz,
        gaoxingwang1@huawei.com, mlxsw@nvidia.com
References: <20230315124009.4015212-1-idosch@nvidia.com>
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230315124009.4015212-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 6:40 AM, Ido Schimmel wrote:
> Commit f96a3d74554d ("ipv4: Fix incorrect route flushing when source
> address is deleted") started to take the table ID field in the FIB info
> structure into account when determining if two structures are identical
> or not. This field is initialized using the 'fc_table' field in the
> route configuration structure, which is not set when adding a route via
> IOCTL.
> 
> The above can result in user space being able to install two identical
> routes that only differ in the table ID field of their associated FIB
> info.
> 
> Fix by initializing the table ID field in the route configuration
> structure in the IOCTL path.
> 
> Before the fix:
> 
>  # ip route add default via 192.0.2.2
>  # route add default gw 192.0.2.2
>  # ip -4 r show default
>  # default via 192.0.2.2 dev dummy10
>  # default via 192.0.2.2 dev dummy10
> 
> After the fix:
> 
>  # ip route add default via 192.0.2.2
>  # route add default gw 192.0.2.2
>  SIOCADDRT: File exists
>  # ip -4 r show default
>  default via 192.0.2.2 dev dummy10
> 
> Audited the code paths to ensure there are no other paths that do not
> properly initialize the route configuration structure when installing a
> route.
> 
> Fixes: 5a56a0b3a45d ("net: Don't delete routes in different VRFs")
> Fixes: f96a3d74554d ("ipv4: Fix incorrect route flushing when source address is deleted")
> Reported-by: gaoxingwang <gaoxingwang1@huawei.com>
> Link: https://lore.kernel.org/netdev/20230314144159.2354729-1-gaoxingwang1@huawei.com/
> Tested-by: gaoxingwang <gaoxingwang1@huawei.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/fib_frontend.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


