Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DD133FDB2
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCRDTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCRDTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:19:37 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9630DC06174A;
        Wed, 17 Mar 2021 20:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Cc:Subject:From:To:Sender:Reply-To:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=pKHYq1hC0taBlkjCvHKcp3eR8zexcs9SDXnvZOh+BtM=; b=JbClyA67QHU0fDZAxAEByRwKY3
        Kjdxim4mw14IYawYSOtQRHag+7WrFWDQQNeZOkmEf7VvlUwV3bw5qMIMTMga6zGdbjC0HOczNqU7f
        GLx/6Natu/Pl4p1tGrVLrcUamZCCrjjRhQmdgtCqGf37v1q79IWEsZQelCruis0KsHOpkLixqIzqe
        bOx2ZidngIAJyOndMCa3113fziBPrSWW7cSADJ6+9qWbSU0uhe9yaxiJ+A9dItdWoENDDbyfqEd5f
        N4LJhHG8jxHeusWX026tEPY+kInbicq5A6Ru0dLl3SqbCXdVavKRdnwSBdeTPNZyqRd9eEd4WMyBX
        bWchQpBA==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lMjBz-001i9Q-0r; Thu, 18 Mar 2021 03:19:32 +0000
To:     LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: S390: all HAS_IOMEM build failures in one fell swoop
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Message-ID: <5a0172d7-36b1-f18a-ec0f-eb9ee8964a1b@infradead.org>
Date:   Wed, 17 Mar 2021 20:19:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On ARCH=s390:

By disabling CONFIG_PCI and hence also disabling CONFIG_HAS_IOMEM
(after having done 'make ARCH=s390 allmodconfig'),
we can see all of the drivers that use IOMEM-related interfaces
without mentioning that they do so (in their respective Kconfig files).

This should catch all of them, instead of various randconfig builds
catching a few of them at a time.
(I'm not trying to pick on arch/s390/ here -- more on the piecemeal
randconfig approach of some 'bot'. :)


I have grouped them by subsystem (more or less).
(This was done on linux-next of 2021-03-15.)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

make[1]: Entering directory 'linux-next-20210315/S390'

kernel/dma:

gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: kernel/dma/coherent.o: in function `dma_init_coherent_memory':
coherent.c:(.text+0x39c): undefined reference to `memremap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: coherent.c:(.text+0x4e0): undefined reference to `memunmap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: kernel/dma/coherent.o: in function `dma_declare_coherent_memory':
coherent.c:(.text+0xac6): undefined reference to `memunmap'

irqchip:

gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: drivers/irqchip/irq-al-fic.o: in function `al_fic_init_dt':
irq-al-fic.c:(.init.text+0x6c): undefined reference to `of_iomap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: irq-al-fic.c:(.init.text+0x49c): undefined reference to `iounmap'

clk / clocksource:

gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: drivers/clk/clk-fixed-mmio.o: in function `fixed_mmio_clk_setup':
clk-fixed-mmio.c:(.text+0x9a): undefined reference to `of_iomap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: clk-fixed-mmio.c:(.text+0xe6): undefined reference to `iounmap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: drivers/clocksource/timer-of.o: in function `timer_of_init':
timer-of.c:(.init.text+0x8e): undefined reference to `of_iomap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: timer-of.c:(.init.text+0x6ec): undefined reference to `iounmap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: drivers/clocksource/timer-of.o: in function `timer_of_cleanup':
timer-of.c:(.init.text+0x8f2): undefined reference to `iounmap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: drivers/clocksource/timer-microchip-pit64b.o: in function `mchp_pit64b_dt_init_timer':
timer-microchip-pit64b.c:(.init.text+0xf2): undefined reference to `of_iomap'
gcc-9.3.0-nolibc/s390-linux/bin/s390-linux-ld: timer-microchip-pit64b.c:(.init.text+0xa18): undefined reference to `iounmap'

iio:

ERROR: modpost: "devm_platform_ioremap_resource" [drivers/iio/adc/adi-axi-adc.ko] undefined!

pcmcia:

ERROR: modpost: "ioremap" [drivers/pcmcia/pcmcia.ko] undefined!
ERROR: modpost: "iounmap" [drivers/pcmcia/pcmcia.ko] undefined!

mtd:

ERROR: modpost: "devm_ioremap_resource" [drivers/mtd/nand/raw/denali_dt.ko] undefined!

nvmem:

ERROR: modpost: "memunmap" [drivers/nvmem/nvmem-rmem.ko] undefined!
ERROR: modpost: "memremap" [drivers/nvmem/nvmem-rmem.ko] undefined!

crypto:

ERROR: modpost: "devm_ioremap_resource" [drivers/crypto/ccree/ccree.ko] undefined!
ERROR: modpost: "debugfs_create_regset32" [drivers/crypto/ccree/ccree.ko] undefined!

media:

ERROR: modpost: "devm_ioremap_resource" [drivers/media/rc/ir-hix5hd2.ko] undefined!

input:

ERROR: modpost: "devm_ioremap" [drivers/input/keyboard/samsung-keypad.ko] undefined!

net:

ERROR: modpost: "devm_platform_ioremap_resource" [drivers/net/can/grcan.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/arcnet/arc-rimi.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/arcnet/arc-rimi.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/arcnet/com90xx.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/arcnet/com90xx.ko] undefined!
ERROR: modpost: "devm_ioremap" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/xircom/xirc2ps_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/xircom/xirc2ps_cs.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/net/ethernet/xilinx/xilinx_emac.ko] undefined!
ERROR: modpost: "of_address_to_resource" [drivers/net/ethernet/xilinx/xilinx_emac.ko] undefined!
ERROR: modpost: "of_address_to_resource" [drivers/net/ethernet/xilinx/xilinx_emaclite.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/net/ethernet/xilinx/xilinx_emaclite.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource_byname" [drivers/net/ethernet/xilinx/ll_temac.ko] undefined!
ERROR: modpost: "of_address_to_resource" [drivers/net/ethernet/xilinx/ll_temac.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/net/ethernet/xilinx/ll_temac.ko] undefined!
ERROR: modpost: "devm_of_iomap" [drivers/net/ethernet/xilinx/ll_temac.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/smsc/smc91c92_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/smsc/smc91c92_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/fujitsu/fmvj18x_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/fujitsu/fmvj18x_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!

char:

ERROR: modpost: "devm_platform_ioremap_resource" [drivers/char/xillybus/xillybus_of.ko] undefined!

tty:

ERROR: modpost: "ioremap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
ERROR: modpost: "iounmap" [drivers/tty/ipwireless/ipwireless.ko] undefined!

dma:

ERROR: modpost: "devm_ioremap_resource" [drivers/dma/sf-pdma/sf-pdma.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/idma64.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/dw/dw_dmac.ko] undefined!
ERROR: modpost: "devm_ioremap" [drivers/dma/altera-msgdma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/xilinx/xilinx_dpdma.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/qcom/hdma.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/qcom/hdma_mgmt.ko] undefined!
ERROR: modpost: "of_address_to_resource" [drivers/dma/qcom/hdma_mgmt.ko] undefined!

make[1]: Leaving directory 'linux-next-20210315/S390'

-- 
~Randy

