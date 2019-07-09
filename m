Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1878E62FE2
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 07:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfGIFPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 01:15:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725832AbfGIFPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 01:15:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D12B2ACE1;
        Tue,  9 Jul 2019 05:15:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 3F47AE0E06; Tue,  9 Jul 2019 07:15:01 +0200 (CEST)
Date:   Tue, 9 Jul 2019 07:15:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH v3 net-next 13/19] ionic: Add initial ethtool support
Message-ID: <20190709051501.GA16610@unicorn.suse.cz>
References: <20190708192532.27420-1-snelson@pensando.io>
 <20190708192532.27420-14-snelson@pensando.io>
 <20190708220406.GB17857@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708220406.GB17857@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 12:04:06AM +0200, Andrew Lunn wrote:
> > +static int ionic_get_link_ksettings(struct net_device *netdev,
> > +				    struct ethtool_link_ksettings *ks)
> > +{
> > +	struct lif *lif = netdev_priv(netdev);
> > +	struct ionic_dev *idev = &lif->ionic->idev;
> > +	int copper_seen = 0;
> > +
> > +	ethtool_link_ksettings_zero_link_mode(ks, supported);
> > +	ethtool_link_ksettings_zero_link_mode(ks, advertising);
> > +
> > +	switch (le16_to_cpu(idev->port_info->status.xcvr.pid)) {
> > +		/* Copper */
> > +	case XCVR_PID_QSFP_100G_CR4:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     100000baseCR4_Full);
> > +		copper_seen++;
> > +		break;
> > +	case XCVR_PID_QSFP_40GBASE_CR4:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     40000baseCR4_Full);
> > +		copper_seen++;
> > +		break;
> > +	case XCVR_PID_SFP_25GBASE_CR_S:
> > +	case XCVR_PID_SFP_25GBASE_CR_L:
> > +	case XCVR_PID_SFP_25GBASE_CR_N:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     25000baseCR_Full);
> > +		copper_seen++;
> > +		break;
> > +	case XCVR_PID_SFP_10GBASE_AOC:
> > +	case XCVR_PID_SFP_10GBASE_CU:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     10000baseCR_Full);
> > +		copper_seen++;
> > +		break;
> > +
> > +		/* Fibre */
> > +	case XCVR_PID_QSFP_100G_SR4:
> > +	case XCVR_PID_QSFP_100G_AOC:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     100000baseSR4_Full);
> > +		break;
> > +	case XCVR_PID_QSFP_100G_LR4:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     100000baseLR4_ER4_Full);
> > +		break;
> > +	case XCVR_PID_QSFP_100G_ER4:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     100000baseLR4_ER4_Full);
> > +		break;
> > +	case XCVR_PID_QSFP_40GBASE_SR4:
> > +	case XCVR_PID_QSFP_40GBASE_AOC:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     40000baseSR4_Full);
> > +		break;
> > +	case XCVR_PID_QSFP_40GBASE_LR4:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     40000baseLR4_Full);
> > +		break;
> > +	case XCVR_PID_SFP_25GBASE_SR:
> > +	case XCVR_PID_SFP_25GBASE_AOC:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     25000baseSR_Full);
> > +		break;
> > +	case XCVR_PID_SFP_10GBASE_SR:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     10000baseSR_Full);
> > +		break;
> > +	case XCVR_PID_SFP_10GBASE_LR:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     10000baseLR_Full);
> > +		break;
> > +	case XCVR_PID_SFP_10GBASE_LRM:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     10000baseLRM_Full);
> > +		break;
> > +	case XCVR_PID_SFP_10GBASE_ER:
> > +		ethtool_link_ksettings_add_link_mode(ks, supported,
> > +						     10000baseER_Full);
> > +		break;
> 
> I don't know these link modes too well. But only setting a single bit
> seems odd. What i do know is that an SFP which supports 2500BaseX
> should also be able to support 1000BaseX. So should a 100G SFP also
> support 40G, 25G, 10G etc? The SERDES just runs a slower bitstream
> over the basic bitpipe?
> 
> > +	case XCVR_PID_QSFP_100G_ACC:
> > +	case XCVR_PID_QSFP_40GBASE_ER4:
> > +	case XCVR_PID_SFP_25GBASE_LR:
> > +	case XCVR_PID_SFP_25GBASE_ER:
> > +		dev_info(lif->ionic->dev, "no decode bits for xcvr type pid=%d / 0x%x\n",
> > +			 idev->port_info->status.xcvr.pid,
> > +			 idev->port_info->status.xcvr.pid);
> > +		break;
> 
> Why not add them?
> 
> 
> > +	memcpy(ks->link_modes.advertising, ks->link_modes.supported,
> > +	       sizeof(ks->link_modes.advertising));
> 
> bitmap_copy() would be a better way to do this. You could consider
> adding a helper to ethtool.h.

Also, there is no need to zero initialize ks->link_modes.advertising
above if it's going to be rewritten here anyway.

Michal
