Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C622754420E
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 05:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbiFIDkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 23:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbiFIDks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 23:40:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D053262E1A;
        Wed,  8 Jun 2022 20:40:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 779E861BC5;
        Thu,  9 Jun 2022 03:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCF9C34116;
        Thu,  9 Jun 2022 03:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654746045;
        bh=uOVAkZAMO898II4tmJkr10MTJAY1+0aeGcHcp56vwn0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=km9pb/UT02/HOFRHtyOFnalEoMVSCxHvuOQoqVmwe02D13ciiCzeC4Mu0/GExgYj4
         aQ4vmBAjI6KTutZcwppmKt8+kQu07F0qXTBw26q6kov6Pqdo9X9mIyYqcu+kGtl69o
         EtMlkKq+jCGJx6vAzywO9MtOx7nRA/gde+5VXjq8lTQnCqRq8AQowXXRPb2eqgJOhN
         pDB1zu5dI+cpSCvGcyhV1Wyoh4NlOdOwYp7U52e8zKCZYi7bQlGSxG+YZliPw7n3yj
         er9wJnM2epYUXQ/IFz619t1VURQ/eSHlCCa1wA9BkyMT0QdrQNBeXcrpAq9UwwrM/h
         dXocumFTRG7Ng==
Date:   Wed, 8 Jun 2022 20:40:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: phy: add remote fault support
Message-ID: <20220608204044.5a09bc59@kernel.org>
In-Reply-To: <20220608122322.772950-3-o.rempel@pengutronix.de>
References: <20220608122322.772950-1-o.rempel@pengutronix.de>
        <20220608122322.772950-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  8 Jun 2022 14:23:22 +0200 Oleksij Rempel wrote:
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 508f1149665b..94a95e60cb45 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -564,6 +564,7 @@ struct macsec_ops;
>   * @advertising: Currently advertised linkmodes
>   * @adv_old: Saved advertised while power saving for WoL
>   * @lp_advertising: Current link partner advertised linkmodes
> + * @lp_remote_fault: Current link partner advertised remote fault
>   * @eee_broken_modes: Energy efficient ethernet modes which should be prohibited
>   * @autoneg: Flag autoneg being used
>   * @link: Current link state
> @@ -646,6 +647,10 @@ struct phy_device {
>  	u8 master_slave_set;
>  	u8 master_slave_state;
>  
> +	u8 remote_fault_set;
> +	u8 remote_fault_get;
> +	u8 remote_fault_state;

./scripts/kernel-doc :

include/linux/phy.h:717: warning: Function parameter or member 'remote_fault_set' not described in 'phy_device'
include/linux/phy.h:717: warning: Function parameter or member 'remote_fault_get' not described in 'phy_device'
include/linux/phy.h:717: warning: Function parameter or member 'remote_fault_state' not described in 'phy_device'
include/uapi/linux/ethtool.h:2139: warning: Function parameter or member 'remote_fault_cfg' not described in 'ethtool_link_settings'
include/uapi/linux/ethtool.h:2139: warning: Function parameter or member 'remote_fault_state' not described in 'ethtool_link_settings'
