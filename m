Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0A732F378
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 20:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCETHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 14:07:31 -0500
Received: from p3plsmtpa12-01.prod.phx3.secureserver.net ([68.178.252.230]:50798
        "EHLO p3plsmtpa12-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhCETHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 14:07:11 -0500
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id IFn2lgGNiU8CmIFn4lgJac; Fri, 05 Mar 2021 12:07:10 -0700
X-CMAE-Analysis: v=2.4 cv=Y+Y9DjSN c=1 sm=1 tr=0 ts=6042815e
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Q5wZSigpbg05Vq6hFFoA:9 a=CjuIK1q_8ugA:10
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <arndb@arndb.de>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <brandon_chuang@edge-core.com>,
        <wally_wang@accton.com>, <aken_liu@edge-core.com>,
        <gulv@microsoft.com>, <jolevequ@microsoft.com>,
        <xinxliu@microsoft.com>, "'netdev'" <netdev@vger.kernel.org>,
        "'Moshe Shemesh'" <moshe@nvidia.com>, <don@thebollingers.org>
References: <20210215193821.3345-1-don@thebollingers.org> <YDl3f8MNWdZWeOBh@lunn.ch> <000901d70cb2$b2848420$178d8c60$@thebollingers.org> <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org> <YD1ScQ+w8+1H//Y+@lunn.ch>
In-Reply-To: <YD1ScQ+w8+1H//Y+@lunn.ch>
Subject: RE: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS EEPROMS
Date:   Fri, 5 Mar 2021 11:07:08 -0800
Message-ID: <003901d711f2$be2f55d0$3a8e0170$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQKX2ThEytgxSBCv+zte4L/P7xUGAgJF1IfoAfArhLgBgnHheQD1wSRRqL6viIA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfJguuAmuQnkPThJUpad+hujYXnRFL1pxw7HU3AbZbVXS185IF5ZGxysc22ky8+grtpUf7ckzSNxfLvLOu0F9wIhC30MRSRYpTqfa5dIYnmbqswpmAuTr
 IeuMIK0PYA51Bqel7rdaxThnVgAcbgFq74TkKEy0eRxQn2vWSgYapLA9rHoAPEHYabdP2XKTrUM0jS3ucnYmajwE1mvOfr7b4nY1iPzJMEaI6QgNEPH3HI6w
 mQOHcpfJlJ71HK22WWjewxsvyntW83b1VeR4T7QCaglgQR5v8tRRqhDwahPYNSpjCa+XNCpI/CVNtVseNV6pStVvK28X6A3NNMERVEZ5z1DOx1a1S5hiRmCj
 6q3CcbJnodQuuvkdcBu+tmqD2cJ/rSgetCzr8NJkX5xvZ/LNxruH7fIwBY9vmECPQc2la1ginOPa726cd4ZWs7eblxIo3zstPBI2F2WuQt9WIkVvvK7NeZWO
 czfN9tJ+eeKuQHVaadDN7tDiqUsKTvpaV94F1kwERw47pBLD0NDEFGnTsFgWIen40HfXjeUUGHAD4eU+PP7qVfHvKfXQuM7TSiC+93eYaEdkvRCMLuirxaRG
 crY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 12:46 PM-0800, Andrew Lunn wrote:
> > To be more specific, optoe is only replacing the functionality of
> > drivers/net/phy/sfp.c, the functions of sfp_i2c_read() and
sfp_i2c_write().
> > These are the routines at the very bottom of the ethtool stack that
> > actually execute the i2c calls to get the data.  The existing routines
> > are very limited, in that they don't handle pages at all.  Hence they
> > can only reach
> > 256 bytes of QSFP EEPROM data and 512 bytes of SFP EEPROM data.  I can
> > propose a shorter cleaner replacement for each of those routines which
> > will provide access to the rest of the data on those devices.
> 
> drivers/net/phy/sfp.c is not the only code making use of this KAPI.
> Any MAC driver can implement the ethtool op calls for reading SFP memory.
> The MAC driver can either directly reply because it has the SFP hidden
> behind firmware, or it can call into the sfp.c code, because Linux is
driving the
> SFP.

OK, I have checked with my partners, including NOS vendors and switch
platform vendors.  They are not using the netdev framework, they are
basically not using kernel networking for managing the networking through
tens to over a hundred network ports at 10G to 400G speeds.  The kernel is
not the source of truth regarding the state of network devices.  I know
netdev *could* manage these systems, and that you are working toward that
goal, that is not the approach they are taking nor the direction they are
heading.  I am not disparaging netdev, I respect and value the contribution
to linux networking.  It's all good.  It just isn't the direction my
partners are going at this time.

You have described this architecture in the past as a 'bootloader'.  In fact
Linux is the operating system running on those switches.  It is not
temporary (eg loading the real OS and going away).  It is allocating memory,
dispatching processes and threads, handling interrupts, hosting docker
containers, and running the proprietary network APIs that manage the
networks.  In this architecture, the optical modules are managed by the OS,
through drivers.  The network APIs interact through these drivers.  For much
of the configuration data, there are configuration files that match up
device hardware (e.g. Low Power Mode GPIO lines and Tx disable lines) and
i2c buses (through layers of i2c muxes) with switch ports as seen by the
switch silicon.  Network management software (user space apps) is
responsible for enabling, configuring and monitoring optical modules to
match the config files.  Kernel drivers provide the access to the GPIO lines
and the EEPROM control registers.

Notably, in this architecture, there are actually NO kernel consumers of the
module EEPROM data.  The version of optoe that is in production in these NOS
and switch environments does not even have an entry point callable by the
kernel.  All of the consumers are accessing the data via the sysfs file in
/sys/bus/i2c/devices/*.   I have closely modeled the updated version of
optoe on the at24 driver (drivers/misc/eeprom/at24.c).  Thus, the KAPI is
actually the same as used by other eeprom drivers.  It is an eeprom, it is
accessed by the nvmem interfaces, in both kernel and user space.

My primary motivation for creating optoe is to consolidate a bunch of
different implementations by different vendors, to add page support which
most implementations lacked, to extend the reach to all of the architected
pages (the standards describe them as proprietary, not forbidden), to
provide write access, and to enable CMIS devices.  Those goals apply to the
netdev/netlink environment as well.  I added the kernel access via nvmem to
facilitate adoption in your network stack, to achieve the same goals
(standardization and improvement of access to module EEPROMs).

> 
> Moshe is working on the Mellonox MAC drivers. As you say, the current
sfp.c

I love Moshe's KAPI, and am reviewing and commenting on it to ensure its
success.

> code is very limited. But once Moshe code is merged, i will do the work
> needed to extend sfp.c to fully support the KAPI. It will then work for
many
> more MAC drivers, those using phylink.

One piece of that work could be to replace the contents of
drivers/net/phy/sfp.c, functions sfp_i2c_read() and sfp_i2c_write() with
nvmem calls to optoe.  That would be an easy change, and provide all of the
features of optoe (pages, access to all of the EEPROM, write support, CMIS),
without writing and maintaining that i2c access code.  The actual i2c calls
would be handled by the same code that is supporting at24.

It is plausible that platform vendors would choose not to implement their
own version of these functions if the generic sfp_i2c_read/write worked for
them.   Fewer implementations of the same code, with more capability in the
common implementation, is obviously beneficial.

> For me, the KAPI is the important thing, and less so how the
implementation
> underneath works. Ideally, we want one KAPI for accessing SFP EEPROMs.
> Up until now, that KAPI is the ethtool IOCTL.
> But that KAPI is now showing its age, and it causing us problems. So we
need
> to replace that KAPI. ethtool has recently moved to using netlink
messages.
> So any replacement should be based on netlink. The whole network stack is
> pretty much controlled via netlink. So you will find it very difficult to
argue for
> any other form of KAPI within the netdev community. Since optoe's KAPI is
> not netlink based, it is very unlikely to be accepted.
> 
> But netlink is much more flexible than the older IOCTL interface.
> Please work with us to ensure this new KAPI can work with your use cases.

I accept all your points from the netdev/netlink perspective.  To that end,
I offer optoe as an upgrade to the default implementation of
sfp_i2c_read/write.

I also have partners using a different architecture, for whom a
netdev/netlink based solution would not be useful.  These partners have been
using a sysfs based approach to module EEPROMs and have no motivation to
change that.  This version of optoe is using the standard eeprom access
method (nvmem) to provide this access.

Acknowledging your objections, I nonetheless request that optoe be accepted
into upstream as an eeprom driver in drivers/misc/eeprom.  It is a
legitimate driver, with a legitimate user community, which deserves the
benefits of being managed as a legitimate part of the linux kernel.

> 
>      Andrew

Don

