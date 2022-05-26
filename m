Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D846534A0A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 06:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345188AbiEZE4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 00:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiEZE4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 00:56:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EE231521;
        Wed, 25 May 2022 21:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1B6CB81EDB;
        Thu, 26 May 2022 04:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C54C385A9;
        Thu, 26 May 2022 04:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653540991;
        bh=eMWGf6YQZwVtz6sJdLIaXTUS8haKJNRTcyODdPa4mTk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKDSDx/2Dhb1sa6+eRCOoFWNKPeusTj3ghalsNu6SpHa0ZXXOmPzO42N1OGlWxiI6
         EqgwBwAma4IQmjFOcqRmcZUl9INyEpyC9dBIQyB+l9KIkX7uTjKoTwiyD5urMATgol
         2g8mx/TgG8R+QscL+kX6qf3JqEPUpDu41Qy46IsFrUs5IXW63ynsugZ/rrXBU+uGWs
         D2H+ozZVyxmQ8ITHi5sPByIKS6QLgUXxZvQuoINJWmTh82ohVyOcvqyQIMz+QYLTha
         681vyMRp5i1XeWzyMWRrlRKIH44kcAeP+TM74v+VAfr3++2CMUW+YUoNQbPB+iRy1l
         lNSFdaWDjcodA==
Date:   Wed, 25 May 2022 21:56:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Sit Michael Wei Hong <michael.wei.hong.sit@intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net-next 1/1] net: phy: dp83867: retrigger SGMII AN when
 link change
Message-ID: <20220525215629.69af5bf5@kernel.org>
In-Reply-To: <20220526013714.4119839-1-tee.min.tan@linux.intel.com>
References: <20220526013714.4119839-1-tee.min.tan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 09:37:14 +0800 Tan Tee Min wrote:
> There is a limitation in TI DP83867 PHY device where SGMII AN is only
> triggered once after the device is booted up. Even after the PHY TPI is
> down and up again, SGMII AN is not triggered and hence no new in-band
> message from PHY to MAC side SGMII.
> 
> This could cause an issue during power up, when PHY is up prior to MAC.
> At this condition, once MAC side SGMII is up, MAC side SGMII wouldn`t
> receive new in-band message from TI PHY with correct link status, speed
> and duplex info.
> 
> As suggested by TI, implemented a SW solution here to retrigger SGMII
> Auto-Neg whenever there is a link change.

Thanks, sounds like this bug has always been in the driver so we should
add:

Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")

Is that right? Getting a workaround like this into stable eventually
seems like a good idea so Fixes tag will help.
