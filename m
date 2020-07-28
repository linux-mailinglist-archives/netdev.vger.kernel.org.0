Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89BB2311E5
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732473AbgG1SpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:45:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729448AbgG1SpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:45:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B750820786;
        Tue, 28 Jul 2020 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595961900;
        bh=5tbj+hAVjho60oeEwljnJ+APM3Uveef3Va4ZlUZpzCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKLmlgDs50tDV9dXoUSKpyX6mRb1SoCJNEWVZ285hT2zy1H2Bb5Q6GMcNzm3nNFQW
         h8dxuZVStJ3p0u5sjg84QYm3Uvg1xs9J/ZRdaNUa7fgtV6E7w4BmTFd8jme5mHuxq9
         Gvh987Ho59sxlnG8Yr/v8SfKSNhsLSYkXXmNNLag=
Date:   Tue, 28 Jul 2020 11:44:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-2-git-send-email-moshe@mellanox.com>
        <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200728135808.GC2207@nanopsycho>
        <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 09:47:00 -0700 Jacob Keller wrote:
> On 7/28/2020 6:58 AM, Jiri Pirko wrote:
> > But this is needed to maintain the existing behaviour which is different
> > for different drivers.
>=20
> Which drivers behave differently here?

I think Jiri refers to mlxsw vs mlx5.

mlxsw loads firmware on probe, by default at least. So reloading the
driver implies a FW reset. NIC drivers OTOH don't generally load FW
so they didn't reset FW.

Now since we're redefining the API from "do a reload so that driverinit
params are applied" (or "so that all netdevs get spawned in a new
netns") to "do a reset of depth X" we have to change the paradigm.

What I was trying to suggest is that we should not have to re-define
the API like this.

=46rom user perspective what's important is what the reset achieves (and
perhaps how destructive it is). We can define the reset levels as:

$ devlink dev reload pci/0000:82:00.0 net-ns-respawn
$ devlink dev reload pci/0000:82:00.0 driver-param-init
$ devlink dev reload pci/0000:82:00.0 fw-activate

combining should be possible when user wants multiple things to happen:

$ devlink dev reload pci/0000:82:00.0 fw-activate driver-param-init


Then we have the use case of a "live reset" which is slightly
under-defined right now IMHO, but we can extend it as:

$ devlink dev reload pci/0000:82:00.0 fw-activate --live


We can also add the "reset level" specifier - for the cases where
device is misbehaving:

$ devlink dev reload pci/0000:82:00.0 level [driver|fw|hardware]


But I don't think that we can go from the current reload command
cleanly to just a level reset. The driver-specific default is a bad
smell which indicates we're changing semantics from what user wants=20
to what the reset depth is. Our semantics with the patch as it stands
are in fact:
 - if you want to load new params or change netns, don't pass the level
   - the "driver default" workaround dictates the right reset level for
   param init;
 - if you want to activate new firmware - select the reset level you'd
   like from the reset level options.
