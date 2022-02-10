Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1CA94B0311
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiBJCIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:08:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiBJCIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:08:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C735F52;
        Wed,  9 Feb 2022 18:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CB6AB8237D;
        Thu, 10 Feb 2022 02:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75905C340ED;
        Thu, 10 Feb 2022 02:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644458781;
        bh=fAh2X+kAgBzPTZ6RgHDL8gTwRpxG0YfihVGEOE17ZDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TfoiDVHcL+PqasAsLl7TW5YwawF7477ZNjwGEQZHJIqCrY9IlkCuClf/J7AYM0qou
         EZL1TMQxB/g4htar/APBoHYyL84P8lFOPCc8MkUb3iJLkB0p+JKmeKrqFel+zbtaFE
         WFnR/6p7LPNDwF5W7T49km3nBrawAlXWEI7CO+Wpu/mMzffgvqbYYmb1M9WaZKMvqY
         hZ1MJHZShq28LbhHAwL/lRMel5732FC2IuNECt9nfnVfXNknMPP/yjV+SLLu43HUQm
         44TYrcvHPotTNHT4gIGFkn/HVJm1sQtRuQ63fstFuxt3vMIYomQY3iegOgtmNUAHHp
         MIhET2qU4TJFw==
Date:   Wed, 9 Feb 2022 18:06:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next] net: lan966x: Fix when CONFIG_IPV6 is not set
Message-ID: <20220209180620.3699bf25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgPHjxpo0N4ND1ch@lunn.ch>
References: <20220209101823.1270489-1-horatiu.vultur@microchip.com>
        <YgPHjxpo0N4ND1ch@lunn.ch>
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

On Wed, 9 Feb 2022 14:54:23 +0100 Andrew Lunn wrote:
> On Wed, Feb 09, 2022 at 11:18:23AM +0100, Horatiu Vultur wrote:
> > When CONFIG_IPV6 is not set, then the compilation of the lan966x driver

compilation or linking?

> > fails with the following error:
> > 
> > drivers/net/ethernet/microchip/lan966x/lan966x_main.c:444: undefined
> > reference to `ipv6_mc_check_mld'
> > 
> > The fix consists in adding #ifdef around this code.  
> 
> It might be better to add a stub function for when IPv6 is
> disabled. We try to avoid #if in C code.

If it's linking we can do:

 	if (IS_ENABLED(CONFIG_IPV6) &&
	    skb->protocol == htons(ETH_P_IPV6) &&
 	    ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr) &&
 	    !ipv6_mc_check_mld(skb))
 		return false;

But beware that IPV6 can be a module, you may need a Kconfig dependency.
