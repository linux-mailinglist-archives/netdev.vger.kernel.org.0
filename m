Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B489468FC3E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBIAzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBIAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:55:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9129E12061;
        Wed,  8 Feb 2023 16:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0rx7+t7RyydnwPzM/awlKyITvtCRFlGUQ/cgZmAC0hg=; b=chpV883E07QArx4l/XJYALIjsH
        n0YMK2nxrKP2b2wXBsH3Qx7bO3yKNHBhzsYu8rBP8Qe8zHpGT9jlvJ9Amx23awQTrjqYljU9XkfTp
        iRao/YkLmMRZEo0Htir4l9rTUNfNTE0CyIfm/OxNkrkkXh3zuJ9clM6txyz/RX0J4if8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPvDw-004S7u-So; Thu, 09 Feb 2023 01:55:40 +0100
Date:   Thu, 9 Feb 2023 01:55:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "A. Sverdlin" <alexander.sverdlin@siemens.com>
Cc:     Wei Fang <wei.fang@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Message-ID: <Y+REjDdjHkv4g45o@lunn.ch>
References: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
> +	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO) {
>  		/* fec1 uses fec0 mii_bus */
>  		if (mii_cnt && fec0_mii_bus) {
>  			fep->mii_bus = fec0_mii_bus;
>  			mii_cnt++;
>  			return 0;
>  		}
> -		return -ENOENT;

Could you not add an else clause here? return -EPROBE_DEFFER?

Basically, if fec0 has not probed, deffer the probing of fec1?

	   Andrew
