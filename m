Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930F1269155
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgINQVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgINQU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 12:20:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0582A206A4;
        Mon, 14 Sep 2020 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600100455;
        bh=dHkhjmB66cl/3hzkvEQ91AT+wAWRkdRIJ131+nT3zC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q667pWUnOAM2qw6/iORGQOeauzGa7Y4lQ0D9YuiQsab2Gd3wWipsAIaW4QVLCJhpm
         bcX0CouaEMfM+34TumGyjXtiliT8sUJ+YU4AQJjH/3U01KPWbQ1tTBfRJuR6hMRYio
         29gwWhsRnhM+8JJ1d93GDJcqF/7F/vluo+BcGPGw=
Date:   Mon, 14 Sep 2020 09:20:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Michael Chan <michael.chan@broadcom.com>, tariqt@nvidia.com,
        saeedm@nvidia.com, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 7/8] ixgbe: add pause frame stats
Message-ID: <20200914092053.5e0fd9f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200913091414.GA3208846@shredder>
References: <20200911195258.1048468-1-kuba@kernel.org>
        <20200911195258.1048468-8-kuba@kernel.org>
        <CAKgT0UccY586mhxRjf+W5gKZdhDMOCXW=p+reEivPnqyFryUbQ@mail.gmail.com>
        <20200911151343.25fbbdec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200913091414.GA3208846@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Sep 2020 12:14:14 +0300 Ido Schimmel wrote:
> On Fri, Sep 11, 2020 at 03:13:43PM -0700, Jakub Kicinski wrote:
> > On Fri, 11 Sep 2020 14:12:50 -0700 Alexander Duyck wrote:  
> > > On Fri, Sep 11, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > @@ -3546,6 +3556,7 @@ static const struct ethtool_ops ixgbe_ethtool_ops = {
> > > >         .set_eeprom             = ixgbe_set_eeprom,
> > > >         .get_ringparam          = ixgbe_get_ringparam,
> > > >         .set_ringparam          = ixgbe_set_ringparam,
> > > > +       .get_pause_stats        = ixgbe_get_pause_stats,
> > > >         .get_pauseparam         = ixgbe_get_pauseparam,
> > > >         .set_pauseparam         = ixgbe_set_pauseparam,
> > > >         .get_msglevel           = ixgbe_get_msglevel,    
> > > 
> > > So the count for this is simpler in igb than it is for ixgbe. I'm
> > > assuming you want just standard link flow control frames. If so then
> > > this patch is correct. Otherwise if you are wanting to capture
> > > priority flow control data then those are a seperate array of stats
> > > prefixed with a "p" instead of an "l". Otherwise this looks fine to
> > > me.  
> > 
> > That's my interpretation, although I haven't found any place the
> > standard would address this directly. Non-PFC pause has a different
> > opcode, so I'm reasonably certain this makes sense.
> > 
> > BTW I'm not entirely clear on what "global PFC pause" is either.
> > 
> > Maybe someone can clarify? Mellanox folks?  
> 
> I checked IEEE 802.1Qaz and could not find anything relevant. My only
> guess is that it might be a PFC frame with all the priorities set.
> 
> Where did you see it?

I think I saw it in MLX5 and I thought it's something
implementation-specific. But then I noticed 802.1-2018 
has a ieee8021PfcGlobalReqdGroup group.
