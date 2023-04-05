Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C56D7C33
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbjDEMHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjDEMHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:07:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F85423B;
        Wed,  5 Apr 2023 05:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qWBuUdDNLTomMrWa17ue40qpTA5SPEfNQkTISsS/20Y=; b=URiP68ONioLF3PEBmrHrpCwU3N
        MkWdAfLyOLgHVH5SB0rg98qCkHgkTSjumXpkW4Q3Sb9Juv587zbcO10z9vGcNXDeqGK9ezMlgyXLd
        WjLCUCigqNKA/klnPdrYUNbJHVi4hNttRqKG0ZKr77RNMcmh1edSIhtHJgCeZ/iDfz1w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pk1uZ-009W6d-3C; Wed, 05 Apr 2023 14:06:47 +0200
Date:   Wed, 5 Apr 2023 14:06:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 03/12] net: phy: add phy_device_set_miits helper
Message-ID: <d00dab9f-7678-4ef3-be51-c31cdb9564d1@lunn.ch>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-3-7e5329f08002@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-3-7e5329f08002@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +void phy_device_set_miits(struct phy_device *phydev,
> +			  struct mii_timestamper *mii_ts)
> +{
> +	if (!phydev)
> +		return;
> +
> +	if (phydev->mii_ts) {
> +		phydev_dbg(phydev,
> +			   "MII timestamper already set -> skip set\n");
> +		return;
> +	}
> +
> +	phydev->mii_ts = mii_ts;
> +}

We tend to be less paranoid. Few, if any, other functions test that
phydev is not NULL. And the current code allows overwriting of an
existing stamper. If you think overwriting should not be allowed
return -EINVAL, and change all the callers to test for it.

> +EXPORT_SYMBOL(phy_device_set_miits);

_GPL please. The code is a bit inconsistent, but new symbols should be
EXPORT_SYMBOL_GPL.

I do however like this patch, hiding away the internals of phydev.

  Andrew
