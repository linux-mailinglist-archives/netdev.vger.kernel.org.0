Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951B43292A0
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbhCAUtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 15:49:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240983AbhCAUqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 15:46:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lGpQ9-008zyD-9S; Mon, 01 Mar 2021 21:45:37 +0100
Date:   Mon, 1 Mar 2021 21:45:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     arndb@arndb.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, brandon_chuang@edge-core.com,
        wally_wang@accton.com, aken_liu@edge-core.com, gulv@microsoft.com,
        jolevequ@microsoft.com, xinxliu@microsoft.com,
        'netdev' <netdev@vger.kernel.org>,
        'Moshe Shemesh' <moshe@nvidia.com>
Subject: Re: [PATCH v2] eeprom/optoe: driver to read/write SFP/QSFP/CMIS
 EEPROMS
Message-ID: <YD1ScQ+w8+1H//Y+@lunn.ch>
References: <20210215193821.3345-1-don@thebollingers.org>
 <YDl3f8MNWdZWeOBh@lunn.ch>
 <000901d70cb2$b2848420$178d8c60$@thebollingers.org>
 <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004f01d70ed5$8bb64480$a322cd80$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> To be more specific, optoe is only replacing the functionality of
> drivers/net/phy/sfp.c, the functions of sfp_i2c_read() and sfp_i2c_write().
> These are the routines at the very bottom of the ethtool stack that actually
> execute the i2c calls to get the data.  The existing routines are very
> limited, in that they don't handle pages at all.  Hence they can only reach
> 256 bytes of QSFP EEPROM data and 512 bytes of SFP EEPROM data.  I can
> propose a shorter cleaner replacement for each of those routines which will
> provide access to the rest of the data on those devices.

drivers/net/phy/sfp.c is not the only code making use of this KAPI.
Any MAC driver can implement the ethtool op calls for reading SFP
memory. The MAC driver can either directly reply because it has the
SFP hidden behind firmware, or it can call into the sfp.c code,
because Linux is driving the SFP.

Moshe is working on the Mellonox MAC drivers. As you say, the current
sfp.c code is very limited. But once Moshe code is merged, i will do
the work needed to extend sfp.c to fully support the KAPI. It will
then work for many more MAC drivers, those using phylink.

For me, the KAPI is the important thing, and less so how the
implementation underneath works. Ideally, we want one KAPI for
accessing SFP EEPROMs. Up until now, that KAPI is the ethtool IOCTL.
But that KAPI is now showing its age, and it causing us problems. So
we need to replace that KAPI. ethtool has recently moved to using
netlink messages. So any replacement should be based on netlink. The
whole network stack is pretty much controlled via netlink. So you will
find it very difficult to argue for any other form of KAPI within the
netdev community. Since optoe's KAPI is not netlink based, it is very
unlikely to be accepted.

But netlink is much more flexible than the older IOCTL interface.
Please work with us to ensure this new KAPI can work with your use
cases.

     Andrew

