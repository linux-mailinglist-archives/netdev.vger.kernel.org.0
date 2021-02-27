Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B73326B30
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhB0Czm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:55:42 -0500
Received: from p3plsmtpa09-08.prod.phx3.secureserver.net ([173.201.193.237]:37066
        "EHLO p3plsmtpa09-08.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhB0Czl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 21:55:41 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 21:55:41 EST
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id FpcKl4mTzvmOLFpcLlNjVY; Fri, 26 Feb 2021 19:46:06 -0700
X-CMAE-Analysis: v=2.4 cv=I6Wg+Psg c=1 sm=1 tr=0 ts=6039b26e
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=9rYyynFDu-Sy5EvBzPcA:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <arndb@arndb.de>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <brandon_chuang@edge-core.com>,
        <wally_wang@accton.com>, <aken_liu@edge-core.com>,
        <gulv@microsoft.com>, <jolevequ@microsoft.com>,
        <xinxliu@microsoft.com>, "'netdev'" <netdev@vger.kernel.org>,
        <don@thebollingers.org>
References: <20210215193821.3345-1-don@thebollingers.org> <YDl3f8MNWdZWeOBh@lunn.ch>
In-Reply-To: <YDl3f8MNWdZWeOBh@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 26 Feb 2021 18:46:05 -0800
Message-ID: <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoqNd7BDA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfLhnB6rtrG/0pUf1SzZL2148mkVoMuVJ3y0CEPbe/WSkjxw69VaTD2tucrVxwBIuXR2SX8ZtWUpWAN4k6lfiM/siFrMbJ3JpRIp8SnhytX2bEi8X8okK
 jtqg4dakMLPqFn883HPt/ZZco0K5NByVcT8DkD5SsWciUDUnHEzFNDchKDriXiOWHWahr6UjhqEzTlFagI4hVvAI69J59tojZsW8JmaR1EkeYDgylW5s4Spa
 J4fk49KtvBnYE/I5ItzlJt3Rau3A2CzE9yKgjtBuzN62ItCHkdZTFg3FSMtfeq2C7tWuYsHJki44c/FhU1stv0NM2jwiTndee5XVtoB0rqf4BYBEGG27sMfY
 W3MtYvJdySRt/CUSftehmRklMoNJTZVt8covDriMD8/T2eVn5C4jZMOmAmNcm6WgcieO1vI8ZmUmz/qxftR93ladhlwd6zK0GAh3swI0018jl4mvokIHvOMO
 M46pKm1O2pZ+a7yGbIeup5CHjeoo6KGvzMWAWYAY31zlHljqFj7x+ovJ6PN24ED3F51tQUZHuMYXg27yiX6RJwAL/nRqGy6Juxk5VA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 2:35 PM -0800, Andrew Lunn wrote:
> On Mon, Feb 15, 2021 at 11:38:21AM -0800, Don Bollinger wrote:
> > optoe is an i2c based driver that supports read/write access to all
> > the pages (tables) of MSA standard SFP and similar devices (conforming
> > to the SFF-8472 spec), MSA standard QSFP and similar devices
> > (conforming to the SFF-8636 spec) and CMIS and similar devices
> > (conforming to the Common Management Interface Specfication).
> 
> Hi Don
> 
> Please make sure you Cc: netdev. This is networking stuff.

Will do.

> And we have seen this code before, and the netdev Maintainers have
> argued against it before.

Yes, though I have tried to make it more acceptable, and also more useful to
you...

> > These devices provide identification, operational status and control
> > registers via an EEPROM model.  These devices support one or 3 fixed
> > pages
> > (128 bytes) of data, and one page that is selected via a page register
> > on the first fixed page.  Thus the driver's main task is to map these
> > pages onto a simple linear address space for user space management
> applications.
> > See the driver code for a detailed layout.
> 
> I assume you have seen the work NVIDIA submitted last week? This idea of
> linear pages is really restrictive and we are moving away from it.

No, I haven't seen it.  I can't seem to locate anything in the past month on
LMKL from NVIDIA.  Please point me to it.

What are you using instead of mapping the pages into a linear address space?
Perhaps I can provide a different interface to call with some other mapping.

> > The EEPROM data is accessible to user space and kernel consumers via
> > the nvmem interface.
> 
> ethtool -m ?

This is actually below ethtool.  Ethtool has to fetch the data from the
eeprom using an appropriate i2c interface (these are defined to be i2c
devices).  And, to fetch the data from any but the first 256 bytes the code
ethtool calls must deal with the page register on the device.  This driver
handles the page register, for both SFP and QSFP/CMIS devices.  This driver
would be a useful path for ethtool to use when someone decides to make that
data available.  Note for example, CMIS devices put the DOM data
(per-channel Tx power, Rx Power, laser bias) on page 0x11.  When you want
that data, you'll have to go past 256 bytes and deal with the page register.
optoe will do that for you.
 
> In the past, this code has been NACKed because it does not integrate into
> the networking stack. Is this attempt any different?

Yes.  I have updated the driver with all the latest changes in at24.c, the
primary eeprom driver.  That update includes use of the nvmem interface,
which means this driver can now be called by kernel code.  I believe it
would be useful and easy to replace the sfp.c code that accesses the eeprom
with nvmem calls to this driver.  By doing so, you will be able to access
the additional pages of data on those devices.  You would also get the
benefit of sharing common code the other eeprom drivers.  As part of that
cleanup, the explicit sysfs creation of an eeprom device has been removed.
Full disclosure, the nvmem interface creates that device now.

> Thanks
> 	Andrew

One more point, I have been requested by the SONiC team to upstream this
driver.  It is on their short list of kernel code that is not upstream, and
they want to fix that.  They are not consumers of the netdev interface, but
they (and other NOS providers) have a need for a driver to access the eeprom
data.  Greg KH was involved in that request, and I related your concerns to
him, as well as my position that this is an eeprom driver with partners that
need it independent of netdev.  His response:

GKH> I can't remember the actual patch anymore, but you are right, it's
"just"
GKH> poking around in the EEPROM for the device, and doing what you want in 
GKH> userspace, which really should be fine.  Submit it and I'll be glad to
review it
GKH> under that type of functionality being added.

He didn't say he would override your position, but he suggested it was
appropriate to submit it.  So, here it is.

Thus:
1.  There are existing NOS platforms that need and use this functionality,
they want it in the upstream kernel.
2.  This driver is better than sfp.c, and could easily be plugged in to
improve netdev and ethtool access to SFP/QSFP/CMIS EEPROM data.

Don

