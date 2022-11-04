Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCE1618DD6
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 02:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiKDB5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 21:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDB5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 21:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92DC23BC1
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 18:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 640C261FC0
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 01:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1038C433D6;
        Fri,  4 Nov 2022 01:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667527035;
        bh=SPBdREfdUBK4CplnO2cKePW8LY348sK80cxvlODGcYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MRG7Z0lEkm24oawSedJSUo+vIA6YRe6zy7HdWLrQnL7kTxxGDVM0+pwqRALgLmCVQ
         4jqdigFt+Jf3jN0wYVCaKFLmfB4Mym5w3JuqMHyHLbFDYLkgi2sbeX3F/hLFXYXLrH
         iQKHGrJyvqwxEarOm+JzM3b/3F4o8GM7jB0SJ+GWoHpj40PS+taaeo17UjHH2cLsba
         txNBAL38dqH0Hb9PJrhKu0qnotpzb0J1EmEBZpVnM8+z4RucT08KSL+i5nW5P3FSwX
         WASCODWH0WxibmvD3cA7vld+vPjr/f5BJMHk6efLGmIYcobJUi5v/5DBUhMM9lKb5W
         58eLNgh3iAP+g==
Date:   Thu, 3 Nov 2022 18:57:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     Shai Malin <smalin@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Message-ID: <20221103185713.5d2ec13b@kernel.org>
In-Reply-To: <253k04ct08y.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221026092449.5f839b36@kernel.org>
        <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221028084001.447a7c05@kernel.org>
        <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
        <20221031164744.43f8e83f@kernel.org>
        <DM6PR12MB35648F8F904D783E59B7CE01BC389@DM6PR12MB3564.namprd12.prod.outlook.com>
        <253k04ct08y.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Nov 2022 19:29:33 +0200 Aurelien Aptel wrote:
> Jakub,
> 
> We came up with 2 designs for controlling the ULP DDP capability bits
> and getting the ULP DDP statistics.
> 
> Both designs share some concepts so I'm going to talk about the common
> stuff first:
> 
> We drop the netdev->feature bit. To fully disable ULP DDP offload the
> caps will have to be set to 0x0.
> 
> In both design we replace the feature bit with a new field
> netdev->ulp_ddp_caps
> 
> struct ulp_ddp_cap {
>         bitmap caps_hw;     // what the hw supports (filled by the driver, used as reference once initialized)
>         bitmap caps_active; // what is currently set for the system, can be modified from userspace
> };
> 
> We add a new OP net_device_ops->ndo_set_ulp_caps() that drivers have
> to provide to fill netdev->ulp_ddp_caps.caps_hw.  We call it around
> the same time as when we call ndo_set_features().

Sounds good. Just to be clear - I was suggesting:

	net_device_ops->ddp_ulp_ops->set_ulp_caps()

so an extra indirection, but if you're worried about the overhead
an ndo is fine, too.

> Interfacing with userspace is where the design differs.
> 
> Design A ("netlink"):
> =====================
> 
> # Capabilities
> 
> We can expose to the users a new ethtool api using netlink.
> 
> For this we want to have a dynamic system where userspace doesn't have
> to hardcode all the caps but instead can get a list.  We implement
> something similar to what is done for features bits.
> 
> We add a table to map caps to string names
> 
> const char *ulp_ddp_cap_names[] = {
>         [ULP_DDP_NVME_TCP_XXX] = "nvme-tcp-xxx",
>         ...
> };

Right, you should be able to define your own strset (grep for
stats_std_names for an example).

> We add ETHTOOL messages to get and set ULP caps:
> 
> - ETHTOOL_MSG_ULP_CAPS_GET: get device ulp capabilities
> - ETHTOOL_MSG_ULP_CAPS_SET: set device up capabilities

ULP or DDP? Are you planning to plumb TLS thru the same ops?
Otherwise ULP on its own may be a little too generic of a name.

> The GET reply code can use ethnl_put_bitset32() which does the job of
> sending bits + their names as strings.
> 
> The SET code would apply the changes to netdev->ulp_ddp_caps.caps_active.
> 
> # Statistics
> 
> If the ETHTOOL_MSG_ULP_CAPS_GET message requests statistics (by

Would it make sense to drop the _CAPS from the name, then?
Or replace by something more general, like INFO?

We can call the bitset inside the message CAPS but the message
also carries stats and perhaps other things in the future.

> setting the header flag ETHTOOL_FLAG_STATS) the kernel will append all
> the ULP statistics of the device at the end of the reply.
> 
> Those statistics will be dynamic in the sense that they will use a new
> stringset for their names that userspace will have to fetch.
> 
> # Ethtool changes
> We will add the -u|-U|--ulp-get|--ulp-set options to ethtool.
> 
>    # query list of caps supported and their value on device $dev
>    ethtool -u|--ulp-get <dev>
> 
>    # query ULP stats of $dev
>    ethtool -u|--ulp-get --include-statistics <dev>

-I|--include-statistics ?

>    # set $cap to $val on device $dev
>    -U|--ulp-set <dev> <cap> [on|off]

Sounds good!

> Design B ("procfs")
> ===================
> 
> In this design we add a new /proc/sys/net/ulp/* hierarchy, under which
> we will add a directory per device (e.g. /proc/sys/net/ulp/eth0/) to
> configure/query ULP DDP.
> 
> # Capabilities
> 
>     # set capabilities per device
>     $ echo 0x1 > /proc/sys/net/ulp/<device>/caps
> 
> # Statistics
> 
>     # show per device stats (global and per queue)
>     # space separated values, 1 stat per line
>     $ cat /proc/sys/net/ulp/<device>/stats
>     rx_nvmeotcp_drop 0
>     rx_nvmeotcp_resync 403
>     rx_nvmeotcp_offload_packets 75614185
>     rx_nvmeotcp_offload_bytes 107016641528
>     rx_nvmeotcp_sk_add 1
>     rx_nvmeotcp_sk_add_fail 0
>     rx_nvmeotcp_sk_del 0
>     rx_nvmeotcp_ddp_setup 3327969
>     rx_nvmeotcp_ddp_setup_fail 0
>     rx_nvmeotcp_ddp_teardown 3327969
> 
> I can also suggest the existing paths:
> 
> - /sys/class/net/<device>/statistics/
> - /proc/net/stat/
> 
> Or any other path you will prefer.

Thanks for describing the options! I definitely prefer ethtool/netlink.
