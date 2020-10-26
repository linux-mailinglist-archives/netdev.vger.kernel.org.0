Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9354C299577
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 19:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790008AbgJZSfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 14:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789893AbgJZSfy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 14:35:54 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688292076A;
        Mon, 26 Oct 2020 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603737354;
        bh=lD2nhIglV/vA5k/ZCAjBHhi+Ake+rB+Lp1+U0V2o4MU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZYxBH0VLlX/nUUSYKcUn1ax+2Ju+milofyjgY0bd2LeXa8B/eTL/VzEJHizx9+o3B
         rDp98UnKSSrgfDobT6mFzmx+lPeJmtKHjVHpp6nmQ4jORVPkK4+2MEGFKm2tWsWUss
         KopKkKKdoigYFSPWU9hEavlKcdr49sEa56nveNpk=
Date:   Mon, 26 Oct 2020 11:35:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, mdf@kernel.org,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        linux-fpga@vger.kernel.org, netdev@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com
Subject: Re: [RFC PATCH 1/6] docs: networking: add the document for DFL
 Ether  Group driver
Message-ID: <20201026113552.78e7a2b4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026173803.GA10743@yilunxu-OptiPlex-7050>
References: <1603442745-13085-1-git-send-email-yilun.xu@intel.com>
        <1603442745-13085-2-git-send-email-yilun.xu@intel.com>
        <20201023153731.GC718124@lunn.ch>
        <20201026085246.GC25281@yilunxu-OptiPlex-7050>
        <20201026130001.GC836546@lunn.ch>
        <20201026173803.GA10743@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 01:38:04 +0800 Xu Yilun wrote:
> > > The line/host side Ether Group is not the terminal of the network dat=
a stream.
> > > Eth1 will not paticipate in the network data exchange to host.
> > >=20
> > > The main purposes for eth1 are:
> > > 1. For users to monitor the network statistics on Line Side, and by c=
omparing the
> > > statistics between eth0 & eth1, users could get some knowledge of how=
 the User
> > > logic is taking function.
> > >=20
> > > 2. Get the link state of the front panel. The XL710 is now connected =
to
> > > Host Side of the FPGA and the its link state would be always on. So to
> > > check the link state of the front panel, we need to query eth1. =20
> >=20
> > This is very non-intuitive. We try to avoid this in the kernel and the
> > API to userspace. Ethernet switches are always modelled as
> > accelerators for what the Linux network stack can already do. You
> > configure an Ethernet switch port in just the same way configure any
> > other netdev. You add an IP address to the switch port, you get the
> > Ethernet statistics from the switch port, routing protocols use the
> > switch port.
> >=20
> > You design needs to be the same. All configuration needs to happen via
> > eth1.
> >=20
> > Please look at the DSA architecture. What you have here is very
> > similar to a two port DSA switch. In DSA terminology, we would call
> > eth0 the master interface.  It needs to be up, but otherwise the user
> > does not configure it. eth1 is the slave interface. It is the user
> > facing interface of the switch. All configuration happens on this
> > interface. Linux can also send/receive packets on this netdev. The
> > slave TX function forwards the frame to the master interface netdev,
> > via a DSA tagger. Frames which eth0 receive are passed through the
> > tagger and then passed to the slave interface.
> >=20
> > All the infrastructure you need is already in place. Please use
> > it. I'm not saying you need to write a DSA driver, but you should make
> > use of the same ideas and low level hooks in the network stack which
> > DSA uses. =20
>=20
> I did some investigation about the DSA, and actually I wrote a
> experimental DSA driver. It works and almost meets my need, I can make
> configuration, run pktgen on slave inf.
>=20
> A main concern for dsa is the wiring from slave inf to master inf depends
> on the user logic. If FPGA users want to make their own user logic, they
> may need a new driver. But our original design for the FPGA is, kernel
> drivers support the fundamental parts - FPGA FIU (where Ether Group is in)
> & other peripherals on board, and userspace direct I/O access for User
> logic. Then FPGA user don't have to write & compile a driver for their
> user logic change.
> It seems not that case for netdev. The user logic is a part of the whole
> functionality of the netdev, we cannot split part of the hardware
> component to userspace and the rest in kernel. I really need to
> reconsider this.

This is obviously on purpose. Your design as it stands will not fly
upstream, sorry.

=46rom netdev perspective the user should not care how many hardware
blocks are in the pipeline, and on which piece of silicon. You have=20
a 2 port (modulo port splitting) card, there should be 2 netdevs, and
the link config and forwarding should be configured through those.

Please let folks at Intel know that we don't like the "SDK in user
space with reuse [/abuse] of parts of netdev infra" architecture.
This is a second of those we see in a short time. Kernel is not a
library for your SDK to use.=20
