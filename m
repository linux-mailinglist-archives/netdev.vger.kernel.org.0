Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E911D465101
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhLAPOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:14:44 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:54580 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238309AbhLAPOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:14:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A56B8CE1DBB
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 15:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61557C53FAD;
        Wed,  1 Dec 2021 15:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638371479;
        bh=e+YUkANC9l7YU0WiJsJ+o9hBLVYJbgs9jx43oJCS8rg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MAjglna98//jI3OxRBN9Ea0ELZH7Lso+l5y+S6jlevM9V1Ur017WY7TH+f0mj6CQB
         hD0YfBjn7pIShY4gltb6DFOZ7pUkVo1/xxK9jDM7/+XVVSrJI44RrM0Zf69mhp9Yd4
         PnRrGvvYovic6Dh4Ih+JqZ7toA0IFKl8H1fMjMtxMxZ9XoSq1QwoXfYD34D7yrp5Qr
         bxdEyChVMvwZibNgYvPUFOxxEoxbYq+A/u+biqMi3khIMwJmktH4gc8iRMc58531z2
         MuMRzah6A2Qqq3e+sSR1HHySgG5+KNHZltOT2qM9k7fotiojakcZGXEzWiinhU5Cla
         RnijzsWcyQfUA==
Date:   Wed, 1 Dec 2021 07:11:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <20211201071118.749a3ed4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YacAstl+brTqgAu8@Laptop-X1>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
        <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YacAstl+brTqgAu8@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 12:57:22 +0800 Hangbin Liu wrote:
> On Tue, Nov 30, 2021 at 07:19:56AM -0800, Jakub Kicinski wrote:
> > On Tue, 30 Nov 2021 15:09:32 +0800 Hangbin Liu wrote:  
> > > We have VLAN PTP support(via get_ts_info) on kernel, and bond support(by
> > > getting active interface via netlink message) on userspace tool linuxptp.
> > > But there are always some users who want to use PTP with VLAN over bond,
> > > which is not able to do with the current implementation.
> > > 
> > > This patch passed get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
> > > with bond mode active-backup/tlb/alb. With this users could get kernel native
> > > bond or VLAN over bond PTP support.
> > > 
> > > Test with ptp4l and it works with VLAN over bond after this patch:
> > > ]# ptp4l -m -i bond0.23
> > > ptp4l[53377.141]: selected /dev/ptp4 as PTP clock
> > > ptp4l[53377.142]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
> > > ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> > > ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> > > ptp4l[53384.127]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
> > > ptp4l[53384.127]: selected local clock e41d2d.fffe.123db0 as best master
> > > ptp4l[53384.127]: port 1: assuming the grand master role  
> > 
> > Does the Ethernet spec say something about PTP over bond/LACP?  
> 
> bond_option_active_slave_get_rcu() only supports bond mode active-backup/tlb/alb.
> With LACP mode _no_ active interface returns and we will use software
> timestamping.

I understand that, I was asking about guidance from LACP as there is 
no IEEE standard for the other modes to my knowledge.

> But you remind me that we should return -EOPNOTSUPP when there is no real_dev
> for bond_eth_ioctl(). I will send a fixup later.
> 
> > What happens during failover? Presumably the user space daemon will
> > start getting HW stamps based on a different PHC than it's disciplining?  
> 
> linuxptp will switch to new active interface's PHC device when there is a
> bonding failover by filtering netlink message on pure bond.
> 
> But for VLAN over bond I need to figure out how to get the bond failover
> message on VLAN interface and update the new PHC device.

Yeah, there should be some form of well understood indication in the
uAPI telling the user space daemon that the PHC may get swapped on the
interface, and a reliable notification which indicates PHC change.
There is a number of user space daemons out there, fixing linuxptp does
not mean other user space won't be broken/surprised/angry.

What notification is linuxptp listening on, SETLINK?
