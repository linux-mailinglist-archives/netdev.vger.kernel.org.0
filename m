Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8454F7503
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 06:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbiDGE7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 00:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbiDGE7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 00:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F257D1C42C2
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 21:57:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D89761ACE
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 04:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29A1C385A4;
        Thu,  7 Apr 2022 04:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649307461;
        bh=dO8nfqMElDpxxeYXv/bKtudvj05VsLdiN32cRO8bkms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oH6YOgPnyl5CYaJtoeB1GvwSIpzAhbyOPzc1r8DXrYbAbfTLZY3NJnM+pQEwOHoWy
         0eNy+qQD9ntslIoiMBspUg9V9yQFPP22cmoJIua9dG4SOPi+D3t46RlnGyCajDXFTH
         oswLnYSv3/OZTl4X7MlAnHavJrk1//jDPTps9HPSOcRm6BLQj/oorkmgQnLlCEygLK
         Qi0EnwWTuw7r0VZUPJopXtiyzZYLHyiRz48Vu7fjaswK3fTJzm0VNEG04IkwecZrVb
         wFCaO1V7DAujrY8csoi4IGlv0F4CAVjPvw+COlrOWeOu3oA4dHZI1uvt+sZhpwPxkL
         qWdd+Khe/7JsA==
Date:   Wed, 6 Apr 2022 21:57:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: phy: micrel: ksz9031/ksz9131: add cabletest
 support
Message-ID: <20220406215740.24bfd957@kernel.org>
In-Reply-To: <20220407020812.1095295-1-marex@denx.de>
References: <20220407020812.1095295-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Apr 2022 04:08:12 +0200 Marek Vasut wrote:
> Add cable test support for Micrel KSZ9x31 PHYs.
> 
> Tested on i.MX8M Mini with KSZ9131RNX in 100/Full mode with pairs shuffled
> before magnetics:
> (note: Cable test started/completed messages are omitted)
> 
>   mx8mm-ksz9131-a-d-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code Short within Pair
>   Pair B, fault length: 0.80m
>   Pair C code Short within Pair
>   Pair C, fault length: 0.80m
>   Pair D code OK
> 
>   mx8mm-ksz9131-a-b-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code OK
>   Pair C code Short within Pair
>   Pair C, fault length: 0.00m
>   Pair D code Short within Pair
>   Pair D, fault length: 0.00m
> 
> Tested on R8A77951 Salvator-XS with KSZ9031RNX and all four pairs connected:
> (note: Cable test started/completed messages are omitted)
> 
>   r8a7795-ksz9031-all-connected$ ethtool --cable-test eth0
>   Pair A code OK
>   Pair B code OK
>   Pair C code OK
>   Pair D code OK
> 
> The CTRL1000 CTL1000_ENABLE_MASTER and CTL1000_AS_MASTER bits are not
> restored by calling phy_init_hw(), they must be manually cached in
> ksz9x31_cable_test_start() and restored at the end of
> ksz9x31_cable_test_get_status().
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

It does not apply completely cleanly to net-next, could you rebase?
