Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195B93290C4
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243100AbhCAUOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:14:45 -0500
Received: from p3plsmtpa06-09.prod.phx3.secureserver.net ([173.201.192.110]:42605
        "EHLO p3plsmtpa06-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242400AbhCAULG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 15:11:06 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2021 15:11:05 EST
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id GoiXlGZFlJpwyGoiYl5qCm; Mon, 01 Mar 2021 13:00:35 -0700
X-CMAE-Analysis: v=2.4 cv=O+T8ADxW c=1 sm=1 tr=0 ts=603d47e3
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=4bfsVOz7DzjSFatosxEA:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <arndb@arndb.de>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <brandon_chuang@edge-core.com>,
        <wally_wang@accton.com>, <aken_liu@edge-core.com>,
        <gulv@microsoft.com>, <jolevequ@microsoft.com>,
        <xinxliu@microsoft.com>, "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>
References: <20210215193821.3345-1-don@thebollingers.org> <YDl3f8MNWdZWeOBh@lunn.ch> <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
In-Reply-To: <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Mon, 1 Mar 2021 12:00:34 -0800
Message-ID: <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoAfArhLiozELRYA==
Content-Language: en-us
X-CMAE-Envelope: MS4xfP/eu0nQ6w59z0tUQDN5SwmEwZhy91MbjYJK7syv5imPIKqMv3NWRV6B27tBi7Jv1L6wsbhjMTB2OzJRuNb2B+kflcqaUx9dhqK/G1ynLZOONjBbhUmQ
 fXiKkZpjoijyHQOhGGV2/cVHha1tyWw6F61G0D70tuuHY0h4j+bdykwoFWxXxcLDBUtUqqOHrgGXY7LLi7au5kJ7ea3KHxVIaKWMTnFFdgPJUQP5kfgooNG/
 YlaxzKdSFpZeHlZoP3I1XS8xs4gxtj3v2mJ2AGB/y214hzAJVbuc40LuJcbv3z7CN++x0Lw5FNQpqGBc2oBBWq/L+RtuX56nhyG91Tll15vr/cnQ5Y6Lver5
 t4DMikyZ9uDe7lxy2DKF/tDJcCyHpz16xKA4HsFAI/ONLWV7hsiuI26tBIPPvWwP7pkMRMCoBj8zd8DzQ/1CsF50CYmAZ68vmJ/QFDXBcCn7DkMN/FDgPdAk
 dKtccdydLqLlIoJenj8MKLm+4Lh1f1KZVAFjOthfToE1to1Ld2DXO1OOWc8B1zIPZCNYNPj1IcW3vsy4DHxTuAJwNloYbSebcZPyJg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 6:46 PM -0800, Don Bollinger wrote:
> On Fri, Feb 26, 2021 at 2:35 PM -0800, Andrew Lunn wrote:
> > On Mon, Feb 15, 2021 at 11:38:21AM -0800, Don Bollinger wrote:
> > > optoe is an i2c based driver that supports read/write access to all
> > > the pages (tables) of MSA standard SFP and similar devices
> > > (conforming to the SFF-8472 spec), MSA standard QSFP and similar
> > > devices (conforming to the SFF-8636 spec) and CMIS and similar
> > > devices (conforming to the Common Management Interface
> Specfication).
> >
> > Hi Don
> >
> > And we have seen this code before, and the netdev Maintainers have
> > argued against it before.
> 
> Yes, though I have tried to make it more acceptable, and also more useful
to
> you...
> 
> > > These devices provide identification, operational status and control
> > > registers via an EEPROM model.  These devices support one or 3 fixed
> > > pages
> > > (128 bytes) of data, and one page that is selected via a page
> > > register on the first fixed page.  Thus the driver's main task is to
> > > map these pages onto a simple linear address space for user space
> > > management
> > applications.
> > > See the driver code for a detailed layout.
> >
> > I assume you have seen the work NVIDIA submitted last week? This idea
> > of linear pages is really restrictive and we are moving away from it.

Yes, I see at least most of it in your response in the netdev archive.  The
linear pages are really a very simple mapping, but they also provide a very
simple access model.  I can readily accommodate Moshe's addressing (i2c
addr, page, bank, offset, len).  Details below...

> > > The EEPROM data is accessible to user space and kernel consumers via
> > > the nvmem interface.
> >
> > ethtool -m ?
> 
> This is actually below ethtool.  Ethtool has to fetch the data from the
eeprom
> using an appropriate i2c interface (these are defined to be i2c devices).
And,
> to fetch the data from any but the first 256 bytes the code ethtool calls
must
> deal with the page register on the device.  This driver handles the page
> register, for both SFP and QSFP/CMIS devices.  This driver would be a
useful
> path for ethtool to use when someone decides to make that data available.
> Note for example, CMIS devices put the DOM data (per-channel Tx power,
> Rx Power, laser bias) on page 0x11.  When you want that data, you'll have
to
> go past 256 bytes and deal with the page register.
> optoe will do that for you.

To be more specific, optoe is only replacing the functionality of
drivers/net/phy/sfp.c, the functions of sfp_i2c_read() and sfp_i2c_write().
These are the routines at the very bottom of the ethtool stack that actually
execute the i2c calls to get the data.  The existing routines are very
limited, in that they don't handle pages at all.  Hence they can only reach
256 bytes of QSFP EEPROM data and 512 bytes of SFP EEPROM data.  I can
propose a shorter cleaner replacement for each of those routines which will
provide access to the rest of the data on those devices.

ALL of the ethtool stack remains unchanged, works exactly the same, and will
now provide access to more data on the EEPROMs.  We may have to remove some
range checks to allow requests to pages beyond page 0.

Note that Moshe's RFC does not include the actual access routines, the
equivalent of sfp_i2c_read/write.  That will in fact require managing pages.
Using optoe, those routines are a few lines of code to map his
addr/page/bank/offset and a call to the new sfp_i2c_read/write calls.

And, all of the i2c/EEPROM accesses go through the same code that routinely
handles the rest of the EEPROMs in the system, with all of the architectural
consolidation, i2c anomaly handling, and simplified support inherent in
sharing common code.
 
> > In the past, this code has been NACKed because it does not integrate
> > into the networking stack. Is this attempt any different?
> 
> Yes.  I have updated the driver with all the latest changes in at24.c, the
> primary eeprom driver.  That update includes use of the nvmem interface,
> which means this driver can now be called by kernel code.  I believe it
would
> be useful and easy to replace the sfp.c code that accesses the eeprom with
> nvmem calls to this driver.  By doing so, you will be able to access the
> additional pages of data on those devices.  You would also get the benefit
of
> sharing common code the other eeprom drivers.  As part of that cleanup,
the
> explicit sysfs creation of an eeprom device has been removed.
> Full disclosure, the nvmem interface creates that device now.
> 
> > Thanks
> > 	Andrew
> 
> One more point, I have been requested by the SONiC team to upstream this
> driver.  It is on their short list of kernel code that is not upstream,
and they
> want to fix that.  They are not consumers of the netdev interface, but
they
> (and other NOS providers) have a need for a driver to access the eeprom
> data.  Greg KH was involved in that request, and I related your concerns
to
> him, as well as my position that this is an eeprom driver with partners
that
> need it independent of netdev.  His response:
> 
> GKH> I can't remember the actual patch anymore, but you are right, it's
> "just"
> GKH> poking around in the EEPROM for the device, and doing what you want
> GKH> in userspace, which really should be fine.  Submit it and I'll be
> GKH> glad to
> review it
> GKH> under that type of functionality being added.
> 
> He didn't say he would override your position, but he suggested it was
> appropriate to submit it.  So, here it is.
> 
> Thus:
> 1.  There are existing NOS platforms that need and use this functionality,
> they want it in the upstream kernel.
> 2.  This driver is better than sfp.c, and could easily be plugged in to
improve
> netdev and ethtool access to SFP/QSFP/CMIS EEPROM data.
> 
> Don

