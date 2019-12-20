Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE3512797A
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfLTKik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:38:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:57840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfLTKik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 05:38:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7198BB20D;
        Fri, 20 Dec 2019 10:38:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 01F7BE008B; Fri, 20 Dec 2019 11:38:37 +0100 (CET)
Date:   Fri, 20 Dec 2019 11:38:37 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Cris Forno <cforno12@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Subject: Re: [PATCH, net-next, v3, 1/2] ethtool: Factored out similar ethtool
 link settings for virtual devices to core
Message-ID: <20191220103837.GF21614@unicorn.suse.cz>
References: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com>
 <20191219205410.5961-2-cforno12@linux.vnet.ibm.com>
 <20191220101831.GF24174@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220101831.GF24174@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 11:18:31AM +0100, Andrew Lunn wrote:
> On Thu, Dec 19, 2019 at 02:54:09PM -0600, Cris Forno wrote:
> > @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
> >  	return 0;
> >  }
> >  
> > +/* Check if the user is trying to change anything besides speed/duplex */
> > +static bool
> > +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> > +{
> > +	struct ethtool_link_ksettings diff1 = *cmd;
> > +	struct ethtool_link_ksettings diff2 = {};
> 
> Hi Cris
> 
> These are not the best of names. How about request and valid?
> 
> > +
> > +	/* cmd is always set so we need to clear it, validate the port type
> > +	 * and also without autonegotiation we can ignore advertising
> > +	 */
> > +	diff1.base.speed = 0;
> > +	diff2.base.port = PORT_OTHER;
> > +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> > +	diff1.base.duplex = 0;
> > +	diff1.base.cmd = 0;
> > +	diff1.base.link_mode_masks_nwords = 0;
> > +
> > +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
> 
> linkmode_equal()
> 
> > +		bitmap_empty(diff1.link_modes.supported,
> > +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> 
> linkmode_empty()
> 
> 	Andrew

Please note that this series was sent to netdev mailing list twice and
there is also some discussion at the other copy (both are marked "v3").
I didn't check if the two submissions are identical, though.

Michal
