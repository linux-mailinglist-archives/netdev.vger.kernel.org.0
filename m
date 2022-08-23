Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC21259CF84
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiHWDXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbiHWDVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:21:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C094F6B7;
        Mon, 22 Aug 2022 20:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81653B81A3C;
        Tue, 23 Aug 2022 03:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FBDC433C1;
        Tue, 23 Aug 2022 03:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661224909;
        bh=X+GY03DvST5lCekYMlbLK5jb7NiHhf7jss5pLH4Au9Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nSDpvTsP/j/CzGFuvZ2lZaYdC03zZmU+EzrNaiPL5JO5KCtJyNt1FgoFbw2Eb1hkd
         Q2a3wXcd/zbo+yU64plX0V3QDot4/NBNSHPnSOfoKe1w2ES4gUnFi+V7cnrYia5HqT
         hESxDk/LGzl7lLGxJphtpKv3hb2ADE/xWRFvpT6bQvSmJOhicUtgOtUJQ/0PoozHr3
         6iYw10IJTdz0cttt8XbQXRVB0X76/IOCgD6gCVjtgNqpncRjQk+PICfT4qgMmvyDbr
         2PTa0oEcCnPspplB+kMsK+RgjxS0gvetMNrVi6SNsZpwKASJ7mIRZw3WIwMxjMiQpl
         JF3W9rRrql7Ig==
Date:   Mon, 22 Aug 2022 20:21:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4.4] net: phy: Add driver for Motorcomm yt8521 gigabit
 ethernet phy
Message-ID: <20220822202147.4be904de@kernel.org>
In-Reply-To: <20220817112554.383-1-Frank.Sae@motor-comm.com>
References: <20220817112554.383-1-Frank.Sae@motor-comm.com>
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

On Wed, 17 Aug 2022 19:25:54 +0800 Frank wrote:
> +static int yt8521_fiber_config_aneg(struct phy_device *phydev)
> +{
> +	int err, changed;
> +	u16 adv;
> +
> +	if (phydev->autoneg != AUTONEG_ENABLE)
> +		return yt8521_fiber_setup_forced(phydev);
> +
> +	err =  ytphy_modify_ext_with_lock(phydev, YTPHY_MISC_CONFIG_REG,
> +					  YTPHY_MCR_FIBER_SPEED_MASK,
> +					  YTPHY_MCR_FIBER_1000BX);
> +	if (err < 0)
> +		return err;
> +
> +	/* enable Fiber auto sensing */
> +	err =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
> +					  0, YT8521_LTCR_EN_AUTOSEN);
> +	if (err < 0)
> +		return err;
> +
> +	/* Setup fiber advertisement */
> +	adv = ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
> +	      ADVERTISE_1000XPSE_ASYM;

Is it okay to ignore phydev->advertising and always set the same mask?

> +	err = phy_modify_changed(phydev, MII_ADVERTISE,
> +				 ADVERTISE_1000XHALF | ADVERTISE_1000XFULL |
> +				 ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM,
> +				 adv);
