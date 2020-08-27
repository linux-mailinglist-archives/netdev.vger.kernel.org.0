Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E4F2550B2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 23:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgH0VmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 17:42:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgH0VmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 17:42:09 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6088F2075B;
        Thu, 27 Aug 2020 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598564528;
        bh=PX+OLigyMyMfPApqbwbA29AjUtwx1qPdExuneqaLX8o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SoqS2pVoB8PJxxjYoJAXMd2VVGVHXSiALKIhDfFZZZelepxhjngYDGn4SaNQN84tm
         QE3/uk3AY8P4nY0ClW3taee97KDnSDV/WL9rYJAt8yJ/ICJZ0hbj+W9olthzmdjsCr
         kbbQHohg1LYjkUI6T0mVZvq0HvcYid4z1GFbtT0k=
Date:   Thu, 27 Aug 2020 14:42:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 20:15:01 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> >
> > I find it strange that you have pfnum 0 everywhere but then different
> > controllers. =20
> There are multiple PFs, connected to different PCI RC. So device has
> same pfnum for both the PFs.
>=20
> > For MultiHost at Netronome we've used pfnum to distinguish
> > between the hosts. ASIC must have some unique identifiers for each
> > PF.=20
> Yes. there is. It is identified by a unique controller number;
> internally it is called host_number. But internal host_number is
> misleading term as multiple cables of same physical card can be
> plugged into single host. So identifying based on a unique
> (controller) number and matching that up on external cable is desired.
>=20
> > I'm not aware of any practical reason for creating PFs on one RC
> > without reinitializing all the others. =20
> I may be misunderstanding, but how is initialization is related
> multiple PFs?

If the number of PFs is static it should be possible to understand
which one is on which system.

> > I can see how having multiple controllers may make things clearer,
> > but adding another layer of IDs while the one under it is unused
> > (pfnum=3D0) feels very unnecessary. =20
> pfnum=3D0 is used today. not sure I understand your comment about being
> unused. Can you please explain?

You examples only ever have pfnum 0:

=46rom patch 2:

$ devlink port show pci/0000:00:08.0/2
pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf pfnum 0=
 vfnum 1 splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port show -jp pci/0000:00:08.0/2
{
    "port": {
        "pci/0000:00:08.0/1": {
            "type": "eth",
            "netdev": "eth7",
            "controller": 0,
            "flavour": "pcivf",
            "pfnum": 0,
            "vfnum": 1,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:00:00"
            }
        }
    }
}

=46rom earlier email:

pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0

If you never use pfnum, you can just put the controller ID there,=20
like Netronome.

> Hierarchical naming kind of make sense, but if you have other ideas
> to annotate the controller, without changing the hardware pfnum, lets
> discuss.
