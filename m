Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1FD7D37
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbfJORQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:16:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:59960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbfJORQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 13:16:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 49171AD7F;
        Tue, 15 Oct 2019 17:16:55 +0000 (UTC)
Date:   Tue, 15 Oct 2019 19:16:53 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: lan78xx and phy_state_machine
Message-ID: <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015005327.GJ19861@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, Oct 15, 2019 at 02:53:27AM +0200, Andrew Lunn wrote:
> On Mon, Oct 14, 2019 at 04:06:04PM +0200, Daniel Wagner wrote:
> > Hi,
> > 
> > I've trying to boot a RPi 3 Model B+ in 64 bit mode. While I can get
> > my configuratin booting with v5.2.20, the current kernel v5.3.6 hangs
> > when initializing the eth interface.
> > 
> > Is this a know issue? Some configuration issues?
> 
> Hi Daniel
> 
> Please could you add a WARN_ON(1); in phy_queue_state_machine() and
> post the stack dump. That might help us figure out what is going on.

I tried to get a stack dump from the WARN_ON(1). The 'make defconfig'
seems not to enable it(?). Anyway I played a bit and noticed, that
depending which additional debug config switch is enabled the
problem disappears. The boot timing is important it seems.

After the feedback I got so far, it think my setup is 'special' in
sofar I don't boot from eMMC. Instead I rely on TFTP and NFS for
rootfs:

 - kernel is configured as 'make defconfig' +

	#
	# Built in drivers
	#
	CONFIG_USB_LAN78XX=y

	#
	# Networking
	#
	CONFIG_PACKET=y
	CONFIG_UNIX=y
	CONFIG_INET=y
	CONFIG_IP_PNP=y
	CONFIG_IP_PNP_DHCP=y

	# NFS
	CONFIG_NFS_FS=y
	CONFIG_NFS_V4=y
	CONFIG_NFS_V4_1=y
	CONFIG_NFS_V4_2=y

	#
	# Debugging
	#
	CONFIG_PRINTK_TIME=y
	CONFIG_DEBUG_KERNEL=y
	CONFIG_EARLY_PRINTK=y
	CONFIG_MESSAGE_LOGLEVEL_DEFAULT=7

	# Embedded config to kernel. /proc/config.gz
	CONFIG_IKCONFIG=y
	CONFIG_IKCONFIG_PROC=y

	CONFIG_KEXEC=y

 - u-boot enables network interface, does DHCP
 - fetches a PXE image
 - PXE loads DTB, kernel and starts the kernel
 - rootfs is supposed to be provided via NFS

Could it be that the networking interface is still running (from
u-boot and PXE) when the drivers is setting it up and the workqueue is
premature kicked to work?

Anyway, I keep trying to get some trace out of it.

Thanks,
Daniel

