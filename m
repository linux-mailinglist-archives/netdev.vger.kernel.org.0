Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF774681B6
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354486AbhLDBMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:12:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:23065 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354451AbhLDBMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 20:12:13 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="236896175"
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="236896175"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 17:08:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,286,1631602800"; 
   d="scan'208";a="513933977"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 03 Dec 2021 17:08:46 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1B418jwt022775;
        Sat, 4 Dec 2021 01:08:45 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Hayes Wang <hayeswang@realtek.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH 0/4] r8169: support dash
Date:   Sat,  4 Dec 2021 02:08:29 +0100
Message-Id: <20211204010829.7796-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com> <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <918d75ea873a453ab2ba588a35d66ab6@realtek.com> <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <d3a1e1c469844aa697d6d315c9549eda@realtek.com> <20211203070410.1b4abc4d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 3 Dec 2021 07:04:10 -0800

> On Fri, 3 Dec 2021 07:57:08 +0000 Hayes Wang wrote:
> > Jakub Kicinski <kuba@kernel.org>
> > > I'm not sure how relevant it will be to you but this is the
> > > documentation we have:
> > > 
> > > https://www.kernel.org/doc/html/latest/networking/devlink/index.html
> > > https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.ht
> > > ml
> > > 
> > > You'll need to add a generic parameter (define + a short description)
> > > like 325e0d0aa683 ("devlink: Add 'enable_iwarp' generic device param")
> > > 
> > > In terms of driver changes I think the most relevant example to you
> > > will be:
> > > 
> > > drivers/net/ethernet/ti/cpsw_new.c
> > > 
> > > You need to call devlink_alloc(), devlink_register and
> > > devlink_params_register() (and the inverse functions).  
> > 
> > I have studied the devlink briefly.
> > 
> > However, I find some problems. First, our
> > settings are dependent on the design of
> > both the hardware and firmware. That is,
> > I don't think the others need to do the
> > settings as the same as us. The devlink
> > seems to let everyone could use the same
> > command to do the same setting. However,
> > most of our settings are useless for the
> > other devices.
> > 
> > Second, according to the design of our
> > CMAC, the application has to read and
> > write data with variable length from/to
> > the firmware. Each custom has his own
> > requests. Therefore, our customs would
> > get different firmware with different
> > behavior. Only the application and the
> > firmware know how to communicate with
> > each other. The driver only passes the
> > data between them. Like the Ethernet
> > driver, it doesn't need to know the
> > contend of the packet. I could implement
> > the CMAC through sysfs, but I don't
> > know how to do by devlink.
> > 
> > In brief, CMAC is our major method to
> > configure the firmware and get response
> > from the firmware. Except for certain information,
> > the other settings are not standard and useless
> > for the other vendors.
> > 
> > Is the devlink the only method I could use?
> > Actually, we use IOCTL now. We wish to
> > convert it to sysfs for upstream driver.
> 
> Ah, I've only spotted the enable/disable knob in the patch. 
> If you're exchanging arbitrary binary data with the FW we 
> can't help you. It's not going to fly upstream.

Uhm. I'm not saying sysfs is a proper way to do that, not at all,
buuut...
We have a ton of different subsystems providing a communication
channel between userspace and HW/FW. Chardevices all over the
tree, highly used rpmsg for remoteproc, uio. We have register
dump in Ethtool, as well as get/set for EEPROM, I'd count them
as well.
So it probably isn't a bad idea to provide some standard API for
network drivers to talk to HW/FW from userspace, like get/set or
rx/tx (when having enough caps for sure)? It could be Devlink ops
or Ethtool ops, the latter fits more to me.

Al
