Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309A5694769
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjBMNtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjBMNs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:48:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F191C5A3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 05:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=88gtzcjCsr4aMhZN4scFoBwMj+fc/vZRnfNAqSByV4E=; b=d1687svjReT09lPxihwY/CFBd6
        51VRa1yE67vECTvAKq8MCtKsR9UgiRoznLrlSpIrjlIgNf3vU8NRojy1o351JFSdzRLUw/9In+hmn
        ib/jkx/lZPfvcMMVIzRLpfclz4xP7xGSaeSS/X/t5M0G3m8W39JQr53IWey8J4Yrql+w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRZC9-004qLd-IT; Mon, 13 Feb 2023 14:48:37 +0100
Date:   Mon, 13 Feb 2023 14:48:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next] net: wangxun: Add base ethtool ops.
Message-ID: <Y+o/tViZOC6htfqS@lunn.ch>
References: <20230213080949.52370-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213080949.52370-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -633,6 +633,7 @@ struct wx {
>  	bool adapter_stopped;
>  	u16 tpid[8];
>  	char eeprom_id[32];
> +	char driver_name[32];

> +	strscpy(wx->driver_name, ngbe_driver_name, sizeof(wx->driver_name));

You don't need a copy of the driver name, a pointer to
ngbe_driver_name would be sufficient.

> +	wx_set_ethtool_ops(netdev);

Since you can using phylib, there are a number of other ethtool ops
you can implement for free using phylib code.

phy_ethtool_nway_reset()
phy_ethtool_set_wol()
phy_ethtool_get_wol()
phy_ethtool_set_eee()
phy_ethtool_get_eee()

etc. Take a look at drivers/net/phy/phy.c and other MAC drivers.

     Andrew

