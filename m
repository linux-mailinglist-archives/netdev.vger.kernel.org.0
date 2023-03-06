Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C966AC207
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCFN7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFN7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:59:44 -0500
Received: from tygrys.net (poczta.tygrys.net [213.108.112.254])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970A623DBA
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 05:59:43 -0800 (PST)
Received: from [10.44.222.153] (unknown [192.168.0.142])
        by tygrys.net (Postfix) with ESMTPSA id CF1E040E31A2;
        Mon,  6 Mar 2023 14:59:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nowatel.com;
        s=default; t=1678111180;
        bh=KEv32HqzfIqcZkLaNSiyaKwBDtzj4M9/ikVAnKix8ng=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To;
        b=SPLlgQ1vUsEU/8B7O5eH3oeN9gnwC8pJtdT8VpjlS24IcJs1dZJ7O5ghIs/8kzvAm
         wh471g9kXRlD1oHHKmlESyRPdGwGMV9iRXGuqSyxinLhiMW+S9orrccN2pnK2WK744
         22vfem4JaYVM89PrDEagE6/J9lMRx9n+e66RkWwE=
Message-ID: <425d50fa-9915-6eb7-609c-0e6a5373870a@nowatel.com>
Date:   Mon, 6 Mar 2023 14:59:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: htb offload on vlan (mlx5)
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <dccaf6ea-f0f8-8749-6b59-fb83d9c60d68@nowatel.com>
 <ZAWz+iSrxfLnXX+N@mail.gmail.com>
Content-Language: en-GB
From:   =?UTF-8?Q?Stanis=c5=82aw_Czech?= <s.czech@nowatel.com>
Organization: Nowatel Sp. z o.o.
In-Reply-To: <ZAWz+iSrxfLnXX+N@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

06.03.2023  10:35, Maxim Mikityanskiy wrote:
> That's expected, vlan_features doesn't contain NETIF_F_HW_TC, and I
> think that's the case for all drivers. Regarding HTB offload, I don't
> think the current implementation in mlx5e can be easily modified to
> support being attached to a VLAN only, because the current
> implementation relies on objects created globally in the NIC.
>
> CCed Nvidia folks in case they have more comments.
>

Thank you for you answer Maxim... I tried to use SR IOV and use the HTB 
offload functionality on the VF
but it's not possible either:

ethtool -K enp1s0np0 hw-tc-offload  on
echo 7 > /sys/class/infiniband/mlx5_0/device/mlx5_num_vfs
ethtool -K enp1s0f7v6 hw-tc-offload  on

ip l s dev enp1s0np0 name eth0
ip l s dev eth0 vf 6 vlan 4

and I see in
ethtool -k eth0
hw-tc-offload: on

but still:
Error: mlx5_core: Missing QoS capabilities. Try disabling SRIOV or use a 
supported device.

So I guess there is no way to use HTB offloading anywhere else than on 
the PF device itself...

Anyway, maybe using multiple VFS to support multiple VLANs (single VF 
for single vlan) would
be more efficent than simple vlans on PF interface (regarding qdisc lock 
problem) ?
I would like to utilize more CPU cores as the vlans on a single PF 
interface use only a single
cpu core ( the 100% ksoftirqd problem)

Could this be some workaround?


Greetings,
*Stanisław Czech*

