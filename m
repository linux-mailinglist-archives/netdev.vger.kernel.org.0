Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CE7269607
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgINUHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgINUHI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 16:07:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E778F208DB;
        Mon, 14 Sep 2020 20:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600114028;
        bh=5wm6iD0tAd/gSFYa2mCCIALM27wEjNCRMl0GrWewaWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hWyu9+tD230pJ+Z2AA4366nXAnn/uFBSlhE0fjG1jdOfHgWU83NcensIJRGppfsD0
         xwz+uma08mIQna1J6AoOh9UticgnxSFnbpdDDMtfTAYEvDbUbYO2uLey7MPLeoyJYR
         C55fUXY7A2dWnV5UzQxcjPlHzXVnf29UrkgSnjVI=
Date:   Mon, 14 Sep 2020 13:07:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, SW_Drivers@habana.ai,
        gregkh@linuxfoundation.org, davem@davemloft.net,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: Re: [PATCH v2 12/14] habanalabs/gaudi: Add ethtool support using
 coresight
Message-ID: <20200914130705.45d2b61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200914012413.GB3463198@lunn.ch>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
        <20200912144106.11799-13-oded.gabbay@gmail.com>
        <20200914012413.GB3463198@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 03:24:13 +0200 Andrew Lunn wrote:
> > +static void gaudi_nic_get_internal_stats(struct net_device *netdev, u64 *data)
> > +{
> > +	struct gaudi_nic_device **ptr = netdev_priv(netdev);
> > +	struct gaudi_nic_device *gaudi_nic = *ptr;
> > +	struct hl_device *hdev = gaudi_nic->hdev;
> > +	u32 port = gaudi_nic->port;
> > +	u32 num_spmus;
> > +	int i;
> > +
> > +	num_spmus = (port & 1) ? NIC_SPMU1_STATS_LEN : NIC_SPMU0_STATS_LEN;
> > +
> > +	gaudi_sample_spmu_nic(hdev, port, num_spmus, data);
> > +	data += num_spmus;
> > +
> > +	/* first entry is title */
> > +	data[0] = 0;  
> 
> You have been looking at statistics names recently. What do you think
> of this data[0]?

Highly counter-productive, users will commonly grep for statistics.
Header which says "TX stats:" is a bad idea.
