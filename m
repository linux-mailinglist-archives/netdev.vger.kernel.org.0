Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6517AAE505
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbfIJIAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:00:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:49310 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727205AbfIJIAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 04:00:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8C39B672;
        Tue, 10 Sep 2019 08:00:14 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 2E4FEE03B1; Tue, 10 Sep 2019 10:00:14 +0200 (CEST)
Date:   Tue, 10 Sep 2019 10:00:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com, andrew@lunn.ch
Subject: Re: [PATCH v3 1/2] ethtool: implement Energy Detect Powerdown
 support via phy-tunable
Message-ID: <20190910080014.GC24779@unicorn.suse.cz>
References: <20190909131251.3634-1-alexandru.ardelean@analog.com>
 <20190909131251.3634-2-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190909131251.3634-2-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 04:12:50PM +0300, Alexandru Ardelean wrote:
> The `phy_tunable_id` has been named `ETHTOOL_PHY_EDPD` since it looks like
> this feature is common across other PHYs (like EEE), and defining
> `ETHTOOL_PHY_ENERGY_DETECT_POWER_DOWN` seems too long.
> 
> The way EDPD works, is that the RX block is put to a lower power mode,
> except for link-pulse detection circuits. The TX block is also put to low
> power mode, but the PHY wakes-up periodically to send link pulses, to avoid
> lock-ups in case the other side is also in EDPD mode.
> 
> Currently, there are 2 PHY drivers that look like they could use this new
> PHY tunable feature: the `adin` && `micrel` PHYs.
> 
> The ADIN's datasheet mentions that TX pulses are at intervals of 1 second
> default each, and they can be disabled. For the Micrel KSZ9031 PHY, the
> datasheet does not mention whether they can be disabled, but mentions that
> they can modified.
> 
> The way this change is structured, is similar to the PHY tunable downshift
> control:
> * a `ETHTOOL_PHY_EDPD_DFLT_TX_INTERVAL` value is exposed to cover a default
>   TX interval; some PHYs could specify a certain value that makes sense
> * `ETHTOOL_PHY_EDPD_NO_TX` would disable TX when EDPD is enabled
> * `ETHTOOL_PHY_EDPD_DISABLE` will disable EDPD
> 
> This should allow PHYs to:
> * enable EDPD and not enable TX pulses (interval would be 0)
> * enable EDPD and configure TX pulse interval; note that TX interval units
>   would be PHY specific; we could consider `seconds` as units, but it could
>   happen that some PHYs would be prefer milliseconds as a unit;
>   a maximum of 65533 units should be sufficient

Sorry for missing the discussion on previous version but I don't really
like the idea of leaving the choice of units to PHY. Both for manual
setting and system configuration, it would be IMHO much more convenient
to have the interpretation universal for all NICs.

Seconds as units seem too coarse and maximum of ~18 hours way too big.
Milliseconds would be more practical from granularity point of view,
would maximum of ~65 seconds be sufficient?

Michal Kubecek

> * disable EDPD
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
