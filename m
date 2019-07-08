Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1267462B50
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732778AbfGHWEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:04:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732720AbfGHWEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 18:04:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z9miiomKXf52qML3qoqsbApj46v2pUerQIIeAVX63cw=; b=5SXR4M5WTOceNkTkjHywxUpRWH
        ejatCsg34IbtTyNpWAbiNPLL0mRfE8oFLd0m/ovbg+DGmpTZfGNbyu1AqnSJVfNFO1tnhTMCtrKBD
        fqw12c1IjYbrw45xlAfINHpVpBliGSmunehPQZEsQUUdOkdL65t5FwmEy1Xs0GJigKd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hkbjy-0005MB-AU; Tue, 09 Jul 2019 00:04:06 +0200
Date:   Tue, 9 Jul 2019 00:04:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190708220406.GB17857@lunn.ch>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708192532.27420-14-snelson@pensando.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ionic_get_link_ksettings(struct net_device *netdev,
> +				    struct ethtool_link_ksettings *ks)
> +{
> +	struct lif *lif = netdev_priv(netdev);
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	int copper_seen = 0;
> +
> +	ethtool_link_ksettings_zero_link_mode(ks, supported);
> +	ethtool_link_ksettings_zero_link_mode(ks, advertising);
> +
> +	switch (le16_to_cpu(idev->port_info->status.xcvr.pid)) {
> +		/* Copper */
> +	case XCVR_PID_QSFP_100G_CR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseCR4_Full);
> +		copper_seen++;
> +		break;
> +	case XCVR_PID_QSFP_40GBASE_CR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     40000baseCR4_Full);
> +		copper_seen++;
> +		break;
> +	case XCVR_PID_SFP_25GBASE_CR_S:
> +	case XCVR_PID_SFP_25GBASE_CR_L:
> +	case XCVR_PID_SFP_25GBASE_CR_N:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     25000baseCR_Full);
> +		copper_seen++;
> +		break;
> +	case XCVR_PID_SFP_10GBASE_AOC:
> +	case XCVR_PID_SFP_10GBASE_CU:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseCR_Full);
> +		copper_seen++;
> +		break;
> +
> +		/* Fibre */
> +	case XCVR_PID_QSFP_100G_SR4:
> +	case XCVR_PID_QSFP_100G_AOC:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseSR4_Full);
> +		break;
> +	case XCVR_PID_QSFP_100G_LR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseLR4_ER4_Full);
> +		break;
> +	case XCVR_PID_QSFP_100G_ER4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     100000baseLR4_ER4_Full);
> +		break;
> +	case XCVR_PID_QSFP_40GBASE_SR4:
> +	case XCVR_PID_QSFP_40GBASE_AOC:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     40000baseSR4_Full);
> +		break;
> +	case XCVR_PID_QSFP_40GBASE_LR4:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     40000baseLR4_Full);
> +		break;
> +	case XCVR_PID_SFP_25GBASE_SR:
> +	case XCVR_PID_SFP_25GBASE_AOC:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     25000baseSR_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_SR:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseSR_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_LR:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseLR_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_LRM:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseLRM_Full);
> +		break;
> +	case XCVR_PID_SFP_10GBASE_ER:
> +		ethtool_link_ksettings_add_link_mode(ks, supported,
> +						     10000baseER_Full);
> +		break;

I don't know these link modes too well. But only setting a single bit
seems odd. What i do know is that an SFP which supports 2500BaseX
should also be able to support 1000BaseX. So should a 100G SFP also
support 40G, 25G, 10G etc? The SERDES just runs a slower bitstream
over the basic bitpipe?

> +	case XCVR_PID_QSFP_100G_ACC:
> +	case XCVR_PID_QSFP_40GBASE_ER4:
> +	case XCVR_PID_SFP_25GBASE_LR:
> +	case XCVR_PID_SFP_25GBASE_ER:
> +		dev_info(lif->ionic->dev, "no decode bits for xcvr type pid=%d / 0x%x\n",
> +			 idev->port_info->status.xcvr.pid,
> +			 idev->port_info->status.xcvr.pid);
> +		break;

Why not add them?


> +	memcpy(ks->link_modes.advertising, ks->link_modes.supported,
> +	       sizeof(ks->link_modes.advertising));

bitmap_copy() would be a better way to do this. You could consider
adding a helper to ethtool.h.

       Andrew
