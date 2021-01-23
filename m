Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2347301316
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 05:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbhAWEw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 23:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbhAWEw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 23:52:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC47923A74;
        Sat, 23 Jan 2021 04:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611377537;
        bh=x+YKr2pJDFBMDMn6j1g8rJRdj8rsvVujG6jZukHgGVo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=erQNg+ra/WEMUN39gfOTos8+1kAoL7zQiWM6iJ0Bq8q/HGqyE9IhI3S6RaAFl267C
         uXIv12+xubLrdIasoU9GBCcVmSTmhN2vYxrGs7h66CwGhJWgkHLbRtgtlwL8D45E4U
         0sCs9ToEKZJ93jeNSJv4iWu0w5hmlElYQ/ieFtjp7/VL9LWXFlsI2jHXub/VuSK6HH
         +7ZrxfL/nY1PLp+ClbsRfMZB9rm5RXfJDdjsCZ7cwB+K+FFuIwMvXQZOk0tAra88IG
         q5XecVJDS4qBnwDvcxvhQBqx6x090aWTDKrxUrNlzh+dpgMbm1ZLOwAp7f/QzUnRJZ
         mWarLW97VyzPg==
Date:   Fri, 22 Jan 2021 20:52:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v6 net-next 07/10] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210122205216.7f1e05f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121160131.2364236-8-olteanv@gmail.com>
References: <20210121160131.2364236-1-olteanv@gmail.com>
        <20210121160131.2364236-8-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 18:01:28 +0200 Vladimir Oltean wrote:
> +/* Since the dsa/tagging sysfs device attribute is per master, the assumption
> + * is that all DSA switches within a tree share the same tagger, otherwise
> + * they would have formed disjoint trees (different "dsa,member" values).
> + */
> +int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
> +			      struct net_device *master,
> +			      const struct dsa_device_ops *tag_ops,
> +			      const struct dsa_device_ops *old_tag_ops)
> +{
> +	struct dsa_notifier_tag_proto_info info;
> +	struct dsa_port *dp;
> +	int err;
> +
> +	/* At the moment we don't allow changing the tag protocol under
> +	 * traffic. May revisit in the future.
> +	 */
> +	if (master->flags & IFF_UP)
> +		return -EBUSY;

But you're not holding rtnl_lock at this point, this check is advisory
at best.

> +	list_for_each_entry(dp, &dst->ports, list) {

What protects this iteration? All sysfs guarantees you is that  
struct net_device *master itself will not disappear.

Could you explain the locking expectations a bit?

> +		if (!dsa_is_user_port(dp->ds, dp->index))
> +			continue;
> +
> +		if (dp->slave->flags & IFF_UP)
> +			return -EBUSY;
> +	}
> +
> +	mutex_lock(&dst->tagger_lock);
> +
> +	info.tag_ops = old_tag_ops;
> +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_DEL, &info);
> +	if (err)
> +		return err;
> +
> +	info.tag_ops = tag_ops;
> +	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);
> +	if (err)
> +		goto out_unwind_tagger;
> +
> +	mutex_unlock(&dst->tagger_lock);
> +
> +	return 0;
> +
> +out_unwind_tagger:
> +	info.tag_ops = old_tag_ops;
> +	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_SET, &info);
> +	mutex_unlock(&dst->tagger_lock);
> +	return err;
> +}
