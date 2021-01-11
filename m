Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E64C2F1D3E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389957AbhAKR5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389680AbhAKR5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 12:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 390842250E;
        Mon, 11 Jan 2021 17:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610387825;
        bh=g8ITqx20hC590Ccgvms6AlIykxHhOKi+2OQ+CcRzcLA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L5dbiukay0PTaxLk4ossTQtT+p4qhSBwPDosgoAYG+GSVykEnNvgQSUDEUIzh/ovv
         BAABOdd9NxbBgHJD9plt+DODt65gx0P/4e/lhzXh3qfkFLObDM4RCpG3kXY4OteABn
         7DhOgPhrY925EjpeKSf+NeMTBjE7Km/4zJbeGEjHnoRghU5bRzk6oHZHlarzq8angS
         2AN2+NvJIWyQpUUzDLOmgjiaIJJQmkatBPAhb/EZ3yFjeweXcK1J7huQZ7uVoXgfmI
         axk0nZK+E+nCzU+ix7RwrL1t+3cxpuUWa4/twpNrw6Ad7Pp2i9cek7O3OAcLVgWFpQ
         1iDXP/KVi2ZVw==
Date:   Mon, 11 Jan 2021 09:57:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Danielle Ratson <danieller@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next repost v2 1/7] ethtool: Extend link modes
 settings uAPI with lanes
Message-ID: <20210111095704.2f8622c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR12MB451691B3A3E6EE51B87AD75FD8AB0@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210106130622.2110387-1-danieller@mellanox.com>
        <20210106130622.2110387-2-danieller@mellanox.com>
        <20210107163504.55018c73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR12MB451691B3A3E6EE51B87AD75FD8AB0@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 14:00:20 +0000 Danielle Ratson wrote:
> > > @@ -420,6 +423,7 @@ struct ethtool_pause_stats {
> > >   * of the generic netdev features interface.
> > >   */
> > >  struct ethtool_ops {
> > > +	u32     capabilities;  
> > 
> > An appropriately named bitfield seems better. Alternatively maybe let the driver specify which lane counts it can accept?  
> 
> Not sure what did you mean, can you please explain?

-	u32     capabilities;  
+	u32	cap_link_lanes_supported:1;

or

-	u32     capabilities;  
+	u8	max_link_lanes;

		if (!lsettings->autoneg &&
-		    !(dev->ethtool_ops->capabilities & ETHTOOL_CAP_LINK_LANES_SUPPORTED)) {
+		    dev->ethtool_ops->max_link_lanes < req_lanes) {
			NL_SET_ERR_MSG_ATTR(info->extack,
					    tb[ETHTOOL_A_LINKMODES_LANES],
+					    dev->ethtool_ops->max_link_lanes ?
+					    "device does not support this many lanes" :
					    "lanes configuration not supported by device");
			return -EOPNOTSUPP;
