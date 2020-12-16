Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEB32DB82C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgLPBCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgLPBCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:02:03 -0500
Date:   Tue, 15 Dec 2020 17:00:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608080457;
        bh=OJMslagCM3BtDsI4qwSdOMGqTWumk6XWgbXpw3Zb/E0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=lG6XgrhGIVZRZYFjUPghJT0v8y/zAZ6dTpoOnBYOVP2W2IxYU9TyzNqITV/masjkx
         XAXqQhhaA7CMM4Z4ZcEEKpZbZyku01JAisK1UErjbAYcsF6qAAVzPwoG27SCeIWAD9
         d1XKNVeuMI0+1m2yKN81qDYt9KG53uGsBQlyHbmo92aszKQaVTHDKcZnlCI+I5i6Ey
         Xhe4oVVEDKfP27MUjDKIkiB976ZAoX9/U6ADSp9OngxthnPB4dXWbmCkRsFOswDDgU
         CuCmg7xW18Sw72YDseFuDx2mjCq1P4iTB/EWS3je6qFg9JTR0eD3hlMXnvx4yjMFss
         RjR2bgW/WHKUg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 14/15] devlink: Extend devlink port documentation
 for subfunctions
Message-ID: <20201215170056.6a952e9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-15-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-15-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:57 -0800 Saeed Mahameed wrote:
> +Subfunctions are lightweight functions that has parent PCI function on which
> +it is deployed. Subfunctions are created and deployed in unit of 1. Unlike
> +SRIOV VFs, they don't require their own PCI virtual function. They communicate
> +with the hardware through the parent PCI function. Subfunctions can possibly
> +scale better.
> +
> +To use a subfunction, 3 steps setup sequence is followed.
> +(1) create - create a subfunction;
> +(2) configure - configure subfunction attributes;
> +(3) deploy - deploy the subfunction;
> +
> +Subfunction management is done using devlink port user interface.
> +User performs setup on the subfunction management device.
> +
> +(1) Create
> +----------
> +A subfunction is created using a devlink port interface. User adds the
> +subfunction by adding a devlink port of subfunction flavour. The devlink
> +kernel code calls down to subfunction management driver (devlink op) and asks
> +it to create a subfunction devlink port. Driver then instantiates the
> +subfunction port and any associated objects such as health reporters and
> +representor netdevice.
> +
> +(2) Configure
> +-------------
> +Subfunction devlink port is created but it is not active yet. That means the
> +entities are created on devlink side, the e-switch port representor is created,
> +but the subfunction device itself it not created. User might use e-switch port
> +representor to do settings, putting it into bridge, adding TC rules, etc. User
> +might as well configure the hardware address (such as MAC address) of the
> +subfunction while subfunction is inactive.
> +
> +(3) Deploy
> +----------
> +Once subfunction is configured, user must activate it to use it. Upon
> +activation, subfunction management driver asks the subfunction management
> +device to instantiate the actual subfunction device on particular PCI function.
> +A subfunction device is created on the :ref:`Documentation/driver-api/auxiliary_bus.rst <auxiliary_bus>`. At this point matching
> +subfunction driver binds to the subfunction's auxiliary device.
> +
> +Terms and Definitions
> +=====================
> +
> +.. list-table:: Terms and Definitions
> +   :widths: 22 90
> +
> +   * - Term
> +     - Definitions
> +   * - ``PCI device``
> +     - A physical PCI device having one or more PCI bus consists of one or
> +       more PCI controllers.
> +   * - ``PCI controller``
> +     -  A controller consists of potentially multiple physical functions,
> +        virtual functions and subfunctions.
> +   * - ``Port function``
> +     -  An object to manage the function of a port.
> +   * - ``Subfunction``
> +     -  A lightweight function that has parent PCI function on which it is
> +        deployed.
> +   * - ``Subfunction device``
> +     -  A bus device of the subfunction, usually on a auxiliary bus.
> +   * - ``Subfunction driver``
> +     -  A device driver for the subfunction auxiliary device.
> +   * - ``Subfunction management device``
> +     -  A PCI physical function that supports subfunction management.
> +   * - ``Subfunction management driver``
> +     -  A device driver for PCI physical function that supports
> +        subfunction management using devlink port interface.
> +   * - ``Subfunction host driver``
> +     -  A device driver for PCI physical function that host subfunction
> +        devices. In most cases it is same as subfunction management driver. When
> +        subfunction is used on external controller, subfunction management and
> +        host drivers are different.

Would be great if someone from Mellanox could proof read this before we
spend cycles on correcting spelling in public review.
