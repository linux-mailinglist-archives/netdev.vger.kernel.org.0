Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B791376EC
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgAJTZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:25:09 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45643 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgAJTZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:25:08 -0500
Received: by mail-pl1-f193.google.com with SMTP id b22so1193282pls.12;
        Fri, 10 Jan 2020 11:25:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:cc:cc:subject
         :references:in-reply-to;
        bh=rVjFJSZgYfwxd0ySOgaQC60qQaj+Ws9nxhRykM3F1Ag=;
        b=CCJV2pmFHDJ1SToYG+HxexvYfdL2OFuF1mT2WjnepvsKA2G/hktpR6Nm+DskVeiF4l
         bW0ilTai+tnwrU+Z/8dREkJgy1iagtGqtqDTu9aHQqTH3eTzy0biiObvCvs0AcqQBtfX
         GvQzGhtijQYIYGr4Bt+T0wmowRR8zjy9SGc8bQsGSIHPvHqwobjXrI2GTyrWmNYH8AUF
         p2zIpKtJK9uuw6tdhD/Q6UePCdpUWj3z7E8hMTBa8/au1Tzq8hirQhDtDVq5wvvZSd+A
         /lFWMcRohbdWtHhcNOFnjQ9x8Sq5SHXxk4mKtRGaBtZmP0jlfxfpQmiIrnqkdTOqmuzl
         0FkA==
X-Gm-Message-State: APjAAAVrNYhQosjRBSzR1pdqx4NqN8i/OZ9Z3izG0yhqnP/4AiJ7yFF8
        4eTG69/ra7L9uH915CGrdkA=
X-Google-Smtp-Source: APXvYqwDhPleO43/H97xRN8wtcII2V3+c4x5AL6mOOFE0V3NrpWQ4LVohdn2juS6VtXW6TOJgjqXgg==
X-Received: by 2002:a17:90a:330f:: with SMTP id m15mr6651319pjb.24.1578684307426;
        Fri, 10 Jan 2020 11:25:07 -0800 (PST)
Received: from localhost (MIPS-TECHNO.ear1.SanJose1.Level3.net. [4.15.122.74])
        by smtp.gmail.com with ESMTPSA id p18sm9543200pjo.3.2020.01.10.11.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 11:25:06 -0800 (PST)
Message-ID: <5e18cf92.1c69fb81.8a8f4.d024@mx.google.com>
Date:   Fri, 10 Jan 2020 11:25:06 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
CC:     Paul Burton <paulburton@kernel.org>
CC:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
CC:     linux-mips@vger.kernel.org
Subject: Re: [PATCH v12 0/3] Use MFD framework for SGI IOC3 drivers
References:  <20200109103430.12057-1-tbogendoerfer@suse.de>
In-Reply-To:  <20200109103430.12057-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Thomas Bogendoerfer wrote:
> SGI IOC3 ASIC includes support for ethernet, PS2 keyboard/mouse,
> NIC (number in a can), GPIO and a byte  bus. By attaching a
> SuperIO chip to it, it also supports serial lines and a parallel
> port. The chip is used on a variety of SGI systems with different
> configurations. This patchset moves code out of the network driver,
> which doesn't belong there, into its new place a MFD driver and
> specific platform drivers for the different subfunctions.
> 
> Changes in v12:
>  - added support for mapping all PCI interrupts as ioc3 uses INTB,
>    if both ethernet and superio is used
> 
> Changes in v11:
>  - dropped accepted patches out of the series
>  - moved byte swapping patch first in series
>  - added ip30 system board support
> 
> Changes in v10:
>  - generation of fake subdevice ID had vendor and device ID swapped
> 
> Changes in v9:
>  - remove generated MFD devices, when driver is removed or in case
>    of a mfd device setup error
>  - remove irq domain, if setup of mfd devices failed
>  - pci_iounmap on exit/error cases
>  - added irq domain unmap function
> 
> Changes in v8:
>  - Re-worked comments in drivers/mfd/ioc3.c
>  - Added select CRC16 to ioc3-eth.c
>  - Patches 1 and 2 are already taken to mips-next, but
>    for completeness of the series they are still included.
>    What's missing to get the remaining 3 patches via the MIPS
>    tree is an ack from a network maintainer
> 
> Changes in v7:
>  - added patch to enable ethernet phy for Origin 200 systems
>  - depend on 64bit for ioc3 mfd driver
> 
> Changes in v6:
>  - dropped patches accepted for v5.4-rc1
>  - moved serio patch to ip30 patch series
>  - adapted nvmem patch
> 
> Changes in v5:
>  - requested by Jakub I've splited ioc3 ethernet driver changes into
>    more steps to make the transition more visible; on the way there 
>    I've "checkpatched" the driver and reduced code reorderings
>  - dropped all uint16_t and uint32_t
>  - added nvmem API extension to the documenation file
>  - changed to use request_irq/free_irq in serio driver
>  - removed wrong kfree() in serio error path
> 
> Changes in v4:
>  - added w1 drivers to the series after merge in 5.3 failed because
>    of no response from maintainer and other parts of this series
>    won't work without that drivers
>  - moved ip30 systemboard support to the ip30 series, which will
>    deal with rtc oddity Lee found
>  - converted to use devm_platform_ioremap_resource
>  - use PLATFORM_DEVID_AUTO for serial, ethernet and serio in mfd driver
>  - fixed reverse christmas order in ioc3-eth.c
>  - formating issue found by Lee
>  - re-worked irq request/free in serio driver to avoid crashes during
>    probe/remove
> 
> Changes in v3:
>  - use 1-wire subsystem for handling proms
>  - pci-xtalk driver uses prom information to create PCI subsystem
>    ids for use in MFD driver
>  - changed MFD driver to only use static declared mfd_cells
>  - added IP30 system board setup to MFD driver
>  - mac address is now read from ioc3-eth driver with nvmem framework
> 
> Changes in v2:
>  - fixed issue in ioc3kbd.c reported by Dmitry Torokhov
>  - merged IP27 RTC removal and 8250 serial driver addition into
>    main MFD patch to keep patches bisectable
> 
> Thomas Bogendoerfer (3):
>   MIPS: PCI: Support mapping of INTB/C/D for pci-xtalk-bridge
>   MIPS: SGI-IP27: fix readb/writeb addressing
>   mfd: ioc3: Add driver for SGI IOC3 chip
> 
>  arch/mips/include/asm/mach-ip27/mangle-port.h |   4 +-
>  arch/mips/include/asm/pci/bridge.h            |   3 +-
>  arch/mips/include/asm/sn/ioc3.h               |  38 +-
>  arch/mips/pci/pci-xtalk-bridge.c              |  28 +-
>  arch/mips/sgi-ip27/ip27-timer.c               |  20 -
>  drivers/mfd/Kconfig                           |  13 +
>  drivers/mfd/Makefile                          |   1 +
>  drivers/mfd/ioc3.c                            | 669 ++++++++++++++++++
>  drivers/net/ethernet/sgi/Kconfig              |   5 +-

Series applied to mips-next.

> MIPS: PCI: Support mapping of INTB/C/D for pci-xtalk-bridge
>   commit 2634e5a651e7
>   https://git.kernel.org/mips/c/2634e5a651e7
>   
>   Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
>   Signed-off-by: Paul Burton <paulburton@kernel.org>
> 
> MIPS: SGI-IP27: fix readb/writeb addressing
>   commit 10cf8300ecad
>   https://git.kernel.org/mips/c/10cf8300ecad
>   
>   Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
>   Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
>   Signed-off-by: Paul Burton <paulburton@kernel.org>
> 
> mfd: ioc3: Add driver for SGI IOC3 chip
>   commit 0ce5ebd24d25
>   https://git.kernel.org/mips/c/0ce5ebd24d25
>   
>   Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
>   Signed-off-by: Paul Burton <paulburton@kernel.org>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paulburton@kernel.org to report it. ]
