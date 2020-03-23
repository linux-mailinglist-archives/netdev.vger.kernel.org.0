Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D72418FDAC
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 20:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgCWTbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 15:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgCWTbV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 15:31:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A705E2051A;
        Mon, 23 Mar 2020 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584991880;
        bh=EvMTD1ctaPI8UBmxPLOjmxlcoNnRXTfNop+t9WgNrYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TjIhyzyin4B2CMGMEgJikYbCchFhuWhGioQeohE1ivP2OYTZRNuS5qDHtt/A3byWf
         unz1r/ydcr+VRObRJEFbE2hpkKVAedCFtmXsJx8ebKbZK8+jrrdxw/DCcB4su30Yob
         xU+HQybfLcI6i8aBvEi3CCBPIs0C/Ppli/MlvY9s=
Date:   Mon, 23 Mar 2020 12:31:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Message-ID: <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <997dbf25-a3e1-168c-c756-b33e79e7c51e@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
        <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
        <20200320073555.GE11304@nanopsycho.orion>
        <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
        <997dbf25-a3e1-168c-c756-b33e79e7c51e@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Mar 2020 09:07:30 +0000 Parav Pandit wrote:
> > I see so you want the creation to be controlled by the same entity that
> > controls the eswitch..
> > 
> > To me the creation should be on the side that actually needs/will use
> > the new port. And if it's not eswitch manager then eswitch manager
> > needs to ack it.
> >  
> 
> There are few reasons to create them on eswitch manager system as below.
> 
> 1. Creation and deletion on one system and synchronizing it with eswitch
> system requires multiple back-n-forth calls between two systems.
> 
> 2. When this happens, system where its created, doesn't know when is the
> right time to provision to a VM or to a application.
> udev/systemd/Network Manager and others such software might already
> start initializing it doing DHCP but its switch side is not yet ready.

Networking software can deal with link down..

> So it is desired to make sure that once device is fully
> ready/configured, its activated.
> 
> 3. Additionally it doesn't follow mirror sequence during deletion when
> created on host.

Why so? Surely host needs to request deletion, otherwise container
given only an SF could be cut off?

> 4. eswitch administrator simply doesn't have direct access to the system
> where this device is used. So it just cannot be created there by eswitch
> administrator.

Right, that is the point. It's the host admin that wants the new
entity, so if possible it'd be better if they could just ask for it 
via devlink rather than some cloud API. Not that I'm completely opposed
to a cloud API - just seems unnecessary here.
