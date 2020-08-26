Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A732538E1
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 22:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHZUHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 16:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbgHZUHu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 16:07:50 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F2E2078D;
        Wed, 26 Aug 2020 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598472469;
        bh=fNlsxJKW6gXAc9anSV73RBlBWdYpuu7d8WBE26l1mLY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=abR1FftW3x9co4IFNGcc0HDS3+VKOks9ZiTe+qlSqAvWWUaJIn8+IZjcRi7N2lqZ2
         3MJgDnIVU/mt6aHB1YcUVJYdD/21HB1cKv0q3ZnW21yBkIikH1+1GNmWN6Cjf8AShk
         sTYuCDg5dx3bA2ioibj4QiAwYFBFdIg0Lo84iSXQ=
Date:   Wed, 26 Aug 2020 13:07:47 -0700
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
Message-ID: <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
In-Reply-To: <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Aug 2020 04:27:35 +0000 Parav Pandit wrote:
> > On Tue, 25 Aug 2020 16:58:38 +0300 Parav Pandit wrote:  
> > > A devlink port may be for a controller consist of PCI device.
> > > A devlink instance holds ports of two types of controllers.
> > > (1) controller discovered on same system where eswitch resides This is
> > > the case where PCI PF/VF of a controller and devlink eswitch instance
> > > both are located on a single system.
> > > (2) controller located on other system.
> > > This is the case where a controller is located in one system and its
> > > devlink eswitch ports are located in a different system. In this case
> > > devlink instance of the eswitch only have access to ports of the
> > > controller.
> > >
> > > When a devlink eswitch instance serves the devlink ports of both
> > > controllers together, PCI PF/VF numbers may overlap.
> > > Due to this a unique phys_port_name cannot be constructed.  
> > 
> > This description is clear as mud to me. Is it just me? Can someone understand
> > this?  
> 
> I would like to improve this description.
> Do you have an input to describe these two different controllers,
> each has same PF and VF numbers?

Not yet, I'm just trying to figure out how things come together.

Are some VFs of the same PF under one controller and other ones under 
a different controller? 

> $ devlink port show looks like below without a controller annotation.
> pci/0000:00:08.0/0: type eth netdev eth5 flavour physical
> pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0

How can you have two PF 0? Aaah - by controller you mean hardware IP,
not whoever is controlling the switching! So the chip has multiple HW
controllers, each of which can have multiple PFs?

Definitely please make that more clear.

Why is @controller_num not under PCI port attrs, but a separate field
without even a mention of PCI? Are some of the controllers a different
bus?
