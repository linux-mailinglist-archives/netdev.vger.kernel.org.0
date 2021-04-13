Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E33E35E95D
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 00:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348715AbhDMW5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 18:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348713AbhDMW5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 18:57:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B150C613B1;
        Tue, 13 Apr 2021 22:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618354634;
        bh=apHHQHhWsHrrXlsqtSt9ANq1CWQOkdhbJAEesF5qFgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J39/r2MuW289zSgC1q/4y+KFGMweUY6jvk7xs63oqHSWxJn/KMyMZCaxWS/M8xiCt
         3NhZgDCBrcC3k8nonL9X5Q517mQqYf8ZVomT1zNN8ZHR7ue1F0GIgFQ1BEm7mVkDwR
         hQGQFd0rn+HzRzXgqUipboG6a4ueHM8v7DYsI1bBOmehBN5VUkwgmdNI010ATmihlN
         wL0oo2vcc6jMHwAWqpoLS9/ddANPpdmWMByCEbL9VAlFK791dhtgt78ZNbjAKXv4Eu
         cFGOHmKSFukj1uUXnRz6wdb7lxQ+U51chmquU3bwRY3VgDhdkJchzJyQzJi4vgToTo
         eXX2DxVYVwWmw==
Date:   Tue, 13 Apr 2021 15:57:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: Re: [net-next 01/16] net/mlx5: E-Switch, let user to enable disable
 metadata
Message-ID: <20210413155712.48d97d95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8b3e437e15bfd7f063b41b17ea32311d084a92bc.camel@kernel.org>
References: <20210413193006.21650-1-saeed@kernel.org>
        <20210413193006.21650-2-saeed@kernel.org>
        <20210413132142.0e2d1752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8b3e437e15bfd7f063b41b17ea32311d084a92bc.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 15:40:24 -0700 Saeed Mahameed wrote:
> > > Hence, allow user to disable metadata using driver specific devlink
> > > parameter.
> > >=20
> > > Example to show and disable metadata before changing eswitch mode:
> > > $ devlink dev param show pci/0000:06:00.0 name esw_port_metadata
> > > pci/0000:06:00.0:
> > > =C2=A0 name esw_port_metadata type driver-specific
> > > =C2=A0=C2=A0=C2=A0 values:
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cmode runtime value true
> > >=20
> > > $ devlink dev param set pci/0000:06:00.0 \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 name esw_port_=
metadata value false cmode runtime
> > >=20
> > > $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev =20
> >=20
> > Is this something that only gets enabled when device is put into
> > switchdev mode? That needs to be clarified in the documentation IMO=20
> > to give peace of mind to all users who don't enable switchdev. =20
>=20
> Currently this is always enabled when switchdev is turned on, it
> affects the whole operation mode of the FDB and the offloaded flows so
> it can't be dynamic, it must be decided before user enables switchdev,
> it is needed only to allow LAG use cases, hence we add a disable knob
> for those who don't want LAG and could use some more packet rate.
>=20
> Some documentation was pushed as part of this patch:
> please let me know if it needs improvement. (maybe we should add the
> benefit of packet rate ?)

Right, I didn't see the info on when the performance impact is felt=20
in the documentation either.

AFAIU we have 3 categories of users:
1 - those who use esw|roce + LAG etc and therefore must leave this
    enabled;
2 - those who don't use LAG but use switchdev so they can turn it off;
3 - those who don't use switchdev or RoCE..

While the documentation should be clear for 1 and 2, group 3 does not
know (a) if they will be impacted; or (b) may not even know what kind=20
of stacked devices documentation is referring to.
