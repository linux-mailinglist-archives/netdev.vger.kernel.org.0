Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A8821A80C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgGITr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:47:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbgGITr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 15:47:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 676F8206DF;
        Thu,  9 Jul 2020 19:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594324048;
        bh=C5ana5LfqOWJvsD7+OcP3yJAnwQvBLsOeTo6wVE3rz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MVZEuNyoJWJSuvckScZEXqtxh+frHPDlnu7H3NNeFMeNmBegkOfEaT9UNV6rZGN3H
         ZlNnpWe4ElDz8j76JuLhXea4xFgyR3dmVoRcGN/NGxvql7ECc2ckaQaiR2q7O529n5
         MeT2TjCo/idMJa5Hu3uHOPIphDMrvEJ9z8LrMIU0=
Date:   Thu, 9 Jul 2020 12:47:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        "David Miller" <davem@davemloft.net>, <saeedm@mellanox.com>,
        <mkubecek@suse.cz>, <linux-pci@vger.kernel.org>,
        <netdev@vger.kernel.org>, <tariqt@mellanox.com>,
        <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed
 ordering
Message-ID: <20200709124726.24315b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709182011.GQ23676@nvidia.com>
References: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
        <20200708231630.GA472767@bjorn-Precision-5520>
        <20200708232602.GO23676@nvidia.com>
        <20200709173550.skza6igm72xrkw4w@bsd-mbp.dhcp.thefacebook.com>
        <20200709182011.GQ23676@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jul 2020 15:20:11 -0300 Jason Gunthorpe wrote:
> >     2) having the driver set RO on the transactions it initiates, which
> >        are honored iff the PCI bit is set.
> >
> > It seems that in addition to the PCI core changes, there still is a need
> > for driver controls?  Unless the driver always enables RO if it's capable?  
> 
> I think the PCI spec imagined that when the config space RO bit was
> enabled the PCI device would just start using RO packets, in an
> appropriate and device specific way.
> 
> So the fine grained control in #2 is something done extra by some
> devices.
> 
> IMHO if the driver knows it is functionally correct with RO then it
> should enable it fully on the device when the config space bit is set.
> 
> I'm not sure there is a reason to allow users to finely tune RO, at
> least I haven't heard of cases where RO is a degredation depending on
> workload.
> 
> If some platform doesn't work when RO is turned on then it should be
> globally black listed like is already done in some cases.
> 
> If the devices has bugs and uses RO wrong, or the driver has bugs and
> is only stable with !RO and Intel, then the driver shouldn't turn it
> on at all.
> 
> In all of these cases it is not a user tunable.
> 
> Development and testing reasons, like 'is my crash from a RO bug?' to
> tune should be met by the device global setpci, I think.

+1
