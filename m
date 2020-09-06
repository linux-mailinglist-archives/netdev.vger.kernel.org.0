Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEFF25EF2D
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgIFQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 12:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgIFQqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 12:46:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239C72080A;
        Sun,  6 Sep 2020 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599410797;
        bh=Pf2gGRnypVRxvc5eB4TGfMqisBShHxPj/L8kU3tI4LE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iXZiBgx/YezoOXNHLU94NowEV3Zs70VWmPO6hfglv/h+51dPAYPqxCUqGuM4lWvqX
         sEbF5DdBDui0wBP8mBoYb4JKJfABOLkW7NRTeoFl9hol/qH6Op/S+oViH9wsYVCOv4
         7J5QpSAsTvXNg+LZnw+Dm8OoByhBjhLQ9ULgtAVw=
Date:   Sun, 6 Sep 2020 09:46:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200906094635.367ed5f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43229A748C15AB08C233A792DC2B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
        <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200902080011.GI3794@nanopsycho.orion>
        <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200903055439.GA2997@nanopsycho.orion>
        <20200903123123.7e6025ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200904084321.GG2997@nanopsycho.orion>
        <BY5PR12MB43229A748C15AB08C233A792DC2B0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Sep 2020 03:08:45 +0000 Parav Pandit wrote:
> > >3) local:   { "controller ID": x }
> > >   remote1: { "controller ID": y, "external": true }
> > >   remote1: { "controller ID": z, "external": true }
> > >
> > >We don't have to put the controller ID in the name for local ports, but
> > >the attribute should be reported. AFAIU name was your main concern, no?  
> > 
> > Okay. Sounds fine. Let's put the controller number there for all ports.
> > ctrlnum X external true
> > ctrlnum Y external false
> > 
> > if (!external)
> > 	ignore the ctrlnum when generating the name
> >   
> 
> Putting little more realistic example for Jakub's and your suggestion below.
> 
> Below is the output for 3 controllers. ( 2 external + 1 local )
> Each external controller consist of 2 PCI PFs for a external host via single PCIe cable.
> Each local controller consist of 1 PCI PF.
> 
> $ devlink port show
> pci/0000:00:08.0/0: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 cnum 0 external false
> pci/0000:00:08.0/1: type eth netdev enp0s8f0_c1pf0 flavour pcipf pfnum 0 cnum 1 external true
> pci/0000:00:08.1/1: type eth netdev enp0s8f1_c1pf1 flavour pcipf pfnum 1 cnum 1 external true
> 
> Looks ok?

Yup, looks good, thanks.
