Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7F12761D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 08:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLTHEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 02:04:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:41840 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727167AbfLTHEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 02:04:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1EFA9AD85;
        Fri, 20 Dec 2019 07:04:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 5402AE008B; Fri, 20 Dec 2019 08:04:18 +0100 (CET)
Date:   Fri, 20 Dec 2019 08:04:18 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        Cris Forno <cforno12@linux.vnet.ibm.com>, mst@redhat.com,
        jasowang@redhat.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH, net-next, v3, 1/2] Three virtual devices (ibmveth,
 virtio_net, and netvsc) all have similar code to set/get link settings and
 validate ethtool command. To eliminate duplication of code, it is factored
 out into core/ethtool.c.
Message-ID: <20191220070418.GE21614@unicorn.suse.cz>
References: <20191219194057.4208-1-cforno12@linux.vnet.ibm.com>
 <20191219194057.4208-2-cforno12@linux.vnet.ibm.com>
 <20191219223603.GC21614@unicorn.suse.cz>
 <bac064bd-fba1-e453-7754-022ea6a191f2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bac064bd-fba1-e453-7754-022ea6a191f2@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 07:26:14PM -0600, Thomas Falcon wrote:
> On 12/19/19 4:36 PM, Michal Kubecek wrote:
> > On Thu, Dec 19, 2019 at 01:40:56PM -0600, Cris Forno wrote:
[...]
> > > @@ -579,6 +579,32 @@ static int load_link_ksettings_from_user(struct ethtool_link_ksettings *to,
> > >   	return 0;
> > >   }
> > > +/* Check if the user is trying to change anything besides speed/duplex */
> > > +static bool
> > > +ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> > > +{
> > > +	struct ethtool_link_ksettings diff1 = *cmd;
> > > +	struct ethtool_link_ksettings diff2 = {};
> > > +
> > > +	/* cmd is always set so we need to clear it, validate the port type
> > > +	 * and also without autonegotiation we can ignore advertising
> > > +	 */
> > > +	diff1.base.speed = 0;
> > > +	diff2.base.port = PORT_OTHER;
> > > +	ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> > > +	diff1.base.duplex = 0;
> > > +	diff1.base.cmd = 0;
> > > +	diff1.base.link_mode_masks_nwords = 0;
> > > +
> > > +	return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
> > > +		bitmap_empty(diff1.link_modes.supported,
> > > +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> > > +		bitmap_empty(diff1.link_modes.advertising,
> > > +			     __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> > Isn't this condition always true? You zeroed the advertising bitmap
> > above. Could you just omit this part and clearing of advertising above?
> > 
> > > +		bitmap_empty(diff1.link_modes.lp_advertising,
> > > +			     __ETHTOOL_LINK_MODE_MASK_NBITS);
> > > +}
> > Another idea: instead of zeroing parts of diff1, you could copy these
> > members from *cmd to diff2 and compare cmd->base with diff2.base. You
> > could then drop diff1. And you wouldn't even need whole struct
> > ethtool_link_ksettings for diff2 as you only compare embedded struct
> > ethtool_link_settings (and check two bitmaps in cmd->link_modes).
> 
> If I understand your suggestion correctly, then the validate function might
> look something like this?
> 
> /* Check if the user is trying to change anything besides speed/duplex */
> static bool
> ethtool_virtdev_validate_cmd(const struct ethtool_link_ksettings *cmd)
> {
>     struct ethtool_link_settings base2 = {};
> 
>     base2.speed = cmd->base.speed;
>     base2.port = PORT_OTHER;
>     base2.duplex = cmd->base.duplex;
>     base2.cmd = cmd->base.cmd;
>     base2.link_mode_masks_nwords = cmd->base.link_mode_masks_nwords;
> 
>     return !memcmp(&base2, cmd->base, sizeof(base2)) &&
>         bitmap_empty(cmd->link_modes.supported,
>                  __ETHTOOL_LINK_MODE_MASK_NBITS) &&
>         bitmap_empty(cmd->link_modes.lp_advertising,
>                  __ETHTOOL_LINK_MODE_MASK_NBITS);
> }

Yes, that is what I wanted to suggest (the second argument of memcmp()
should be "&cmd->base", I think).

Michal
