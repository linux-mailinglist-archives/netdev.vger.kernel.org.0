Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3E145C726
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356402AbhKXOY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356224AbhKXOX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 09:23:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 952E760C4A;
        Wed, 24 Nov 2021 14:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637763649;
        bh=ZK5hLPbqayxa6gRPA6zcdPGEVURCBGw6eQFZC/zUNpg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kixh/WXYCD9r1R+/rTLxxZvBEUIF8v6gVCIcPC8no3H/2PX9AsM5DF0HPTuN0iP/2
         tQ0X7Nr72eQ68JbGH6huojfOLzqIkBTHyzwVbEzw2Dkh8tsyjNBMgVTVF+a4NgeqP+
         0nJSftz5RGAuLqbe0vUZxADqD0SV+eVkmSpEWJuT1MyUt6J7urcx5xHSFHD1xmAwHo
         a4ZxbTN3B28LUpGG9aEBE1up60Ihn0VDNcdrE7qbXvZQqMmjIG8L1Int87Vem6Rp7V
         Ksyuk2rL8+K2CGzCltz4c/KfwFYPgHPcgjZWac1FIXHmY1ZkmOjWqw/9ssHt614M/a
         Mmx03/AQzWSXQ==
Date:   Wed, 24 Nov 2021 06:20:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frode Nordahl <frode.nordahl@canonical.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net] netdevsim: Fix physical port index
Message-ID: <20211124062048.48652ea4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124081106.1768660-1-frode.nordahl@canonical.com>
References: <20211124081106.1768660-1-frode.nordahl@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:11:06 +0100 Frode Nordahl wrote:
> At present when a netdevsim device is added, the first physical
> port will have an index of 1.  This behavior differ from what any
> real hardware driver would do, which would start the index at 0.
> 
> When using netdevsim to test the devlink-port interface this
> behavior becomes a problem because the provided data is incorrect.
> 
> Example:
> $ sudo modprobe netdevsim
> $ sudo sh -c 'echo "10 1" > /sys/bus/netdevsim/new_device'
> $ sudo sh -c 'echo 4 > /sys/class/net/eni10np1/device/sriov_numvfs'
> $ sudo devlink dev eswitch set netdevsim/netdevsim10 mode switchdev
> $ devlink port show
> netdevsim/netdevsim10/0: type eth netdev eni10np1 flavour physical port 1
> netdevsim/netdevsim10/128: type eth netdev eni10npf0vf0 flavour pcivf pfnum 0 vfnum 0
> netdevsim/netdevsim10/129: type eth netdev eni10npf0vf1 flavour pcivf pfnum 0 vfnum 1
> netdevsim/netdevsim10/130: type eth netdev eni10npf0vf2 flavour pcivf pfnum 0 vfnum 2
> netdevsim/netdevsim10/131: type eth netdev eni10npf0vf3 flavour pcivf pfnum 0 vfnum 3
> 
> With this patch applied you would instead get:
> $ sudo modprobe netdevsim
> $ sudo sh -c 'echo "10 1" > /sys/bus/netdevsim/new_device'
> $ sudo sh -c 'echo 4 > /sys/class/net/eni10np0/device/sriov_numvfs'
> $ sudo devlink dev eswitch set netdevsim/netdevsim10 mode switchdev
> $ devlink port show
> netdevsim/netdevsim10/0: type eth netdev eni10np0 flavour physical port 0
> netdevsim/netdevsim10/128: type eth netdev eni10npf0vf0 flavour pcivf pfnum 0 vfnum 0
> netdevsim/netdevsim10/129: type eth netdev eni10npf0vf1 flavour pcivf pfnum 0 vfnum 1
> netdevsim/netdevsim10/130: type eth netdev eni10npf0vf2 flavour pcivf pfnum 0 vfnum 2
> netdevsim/netdevsim10/131: type eth netdev eni10npf0vf3 flavour pcivf pfnum 0 vfnum 3
> 
> The above more accurately resembles what a real system would look
> like.
> 
> Fixes: 8320d1459127 ("netdevsim: implement dev probe/remove skeleton with port initialization")
> Signed-off-by: Frode Nordahl <frode.nordahl@canonical.com>

Why do you care about the port ID starting at 0? It's not guaranteed.
The device can use any encoding scheme to assign IDs, user space should
make no assumptions here.

Please use get_maintainers to CC all the relevant people.
