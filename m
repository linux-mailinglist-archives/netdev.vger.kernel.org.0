Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F76254D20
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 20:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgH0ScW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 14:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgH0ScT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 14:32:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42372080C;
        Thu, 27 Aug 2020 18:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598553139;
        bh=kbw64wa4DLwkfhM5cC2OdeTmsKynbyzCuJVeZCgvIuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SBoRr/TU8yWV9z7AsnL32bTAwRCsslFBSpVGd36HCjiEF3inw0xmwInBUmx1NZwDm
         sp76kmaev9ih2ZqdSoqjL6wyTOOIoY8T7voXkKQNCh/L3mJiV+xdp24rejh0N0w7Ob
         9sX97f2hjVjyBv2bBnbQ8u2DwLdoQJQ2V6fr/wB8=
Date:   Thu, 27 Aug 2020 11:32:16 -0700
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
Message-ID: <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Aug 2020 04:31:43 +0000 Parav Pandit wrote:
> > > $ devlink port show looks like below without a controller annotation.
> > > pci/0000:00:08.0/0: type eth netdev eth5 flavour physical
> > > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> > > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0  
> > 
> > How can you have two PF 0? Aaah - by controller you mean hardware IP, not
> > whoever is controlling the switching! So the chip has multiple HW controllers,
> > each of which can have multiple PFs?
> >   
> Hardware IP is one. This IP is plugged into two PCI root complexes.
> One is eswitch PF, this PF has its own VFs/SFs.
> Other PF(s) plugged into an second PCI Root complex serving the server system.
> So you are right there are multiple PFs.

I find it strange that you have pfnum 0 everywhere but then different
controllers. For MultiHost at Netronome we've used pfnum to distinguish
between the hosts. ASIC must have some unique identifiers for each PF.

I'm not aware of any practical reason for creating PFs on one RC
without reinitializing all the others.

I can see how having multiple controllers may make things clearer, but
adding another layer of IDs while the one under it is unused (pfnum=0)
feels very unnecessary.

> Both the PFs have same PCI BDF.

BDFs are irrelevant.
