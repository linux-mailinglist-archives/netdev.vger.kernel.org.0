Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282A62ED30E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbhAGOwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:52:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726165AbhAGOwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 09:52:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxWdW-00Ggmn-JW; Thu, 07 Jan 2021 15:51:38 +0100
Date:   Thu, 7 Jan 2021 15:51:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Xu Yilun <yilun.xu@intel.com>, arnd@arndb.de, lee.jones@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trix@redhat.com, lgoncalv@redhat.com, hao.wu@intel.com,
        matthew.gerlach@intel.com, russell.h.weight@intel.com
Subject: Re: [RESEND PATCH 2/2] misc: add support for retimers interfaces on
 Intel MAX 10 BMC
Message-ID: <X/cf+o1tuYre1JzU@lunn.ch>
References: <1609999628-12748-1-git-send-email-yilun.xu@intel.com>
 <1609999628-12748-3-git-send-email-yilun.xu@intel.com>
 <X/bTtBUevX5IBPUl@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/bTtBUevX5IBPUl@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:26:12AM +0100, Greg KH wrote:
> On Thu, Jan 07, 2021 at 02:07:08PM +0800, Xu Yilun wrote:
> > This driver supports the ethernet retimers (C827) for the Intel PAC
> > (Programmable Acceleration Card) N3000, which is a FPGA based Smart NIC.
> > 
> > C827 is an Intel(R) Ethernet serdes transceiver chip that supports
> > up to 100G transfer. On Intel PAC N3000 there are 2 C827 chips
> > managed by the Intel MAX 10 BMC firmware. They are configured in 4 ports
> > 10G/25G retimer mode. Host could query their link states and firmware
> > version information via retimer interfaces (Shared registers) on Intel
> > MAX 10 BMC. The driver creates sysfs interfaces for users to query these
> > information.
> 
> Networking people, please look at this sysfs file:
> 
> > +What:		/sys/bus/platform/devices/n3000bmc-retimer.*.auto/link_statusX
> > +Date:		Jan 2021
> > +KernelVersion:	5.12
> > +Contact:	Xu Yilun <yilun.xu@intel.com>
> > +Description:	Read only. Returns the status of each line side link. "1" for
> > +		link up, "0" for link down.
> > +		Format: "%u".
> 
> as I need your approval to add it because it is not the "normal" way for
> link status to be exported to userspace.

Hi Greg

Correct, this is not going to be acceptable.

The whole architecture needs to cleanly fit into the phylink model for
controlling the SFP and the retimer.

I'm guessing Intel needs to rewrite portions of the BMC firmware to
either transparently pass through access to the SFP socket and the
retimer for phylink and a C827 specific driver, or add a high level
API which a MAC driver can use, and completely hide away these PHY
details from Linux, which is what many of the Intel Ethernet drivers
do.

       Andrew
