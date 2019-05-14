Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B32C1C8C9
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 14:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfENMcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 08:32:20 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:46819 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfENMcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 08:32:19 -0400
X-Originating-IP: 90.88.28.253
Received: from bootlin.com (aaubervilliers-681-1-86-253.w90-88.abo.wanadoo.fr [90.88.28.253])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 1E1F924000F;
        Tue, 14 May 2019 12:32:12 +0000 (UTC)
Date:   Tue, 14 May 2019 14:32:12 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Marcin Wojtas <mw@semihalf.com>
Cc:     Yanko Kaneti <yaneti@declera.com>, netdev <netdev@vger.kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: mvpp2:  oops on first received packet
Message-ID: <20190514143212.5abaf995@bootlin.com>
In-Reply-To: <20190514121948.4def4872@carbon>
References: <856dc9462c31bc9f102940c61f94db1f44574733.camel@declera.com>
        <20190514121948.4def4872@carbon>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yanko,

>On Tue, 14 May 2019 10:29:31 +0300
>Yanko Kaneti <yaneti@declera.com> wrote:
>
>> Hello,
>> 
>> I am trying to get some Fedora working on the MACCHIATObin SingleShot
>> and I am getting an OOPS on what seems to be the first received packet
>> on the gigabit port.
>> 
>> I've tried both 5.0.x stable and 5.1.1 with the same result.  
>
>> mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full - flow control rx/tx
>> IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
>> page:ffff7e0001ff1000 count:0 mapcount:0 mapping:0000000000000000 index:0x0
>> flags: 0x1fffe000000000()
>> raw: 001fffe000000000 ffff7e0001ff1008 ffff7e0001ff1008 0000000000000000
>> raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>> page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)  
>
>Looks like a page refcnt bug (trying to free a page with already have
>zero refcnt).

This looks like another issue that was reported here, where the cause
was in the EFI firmware :

https://lore.kernel.org/netdev/6355174d-4ab6-595d-17db-311bce607aef@arm.com/

Can you give some details on the version of the firmware you have and
if you are using EFI or uboot ?

Maybe Marcin could confirm this is the same issue as what happened in
this thread.

Thanks,

Maxime

>> ------------[ cut here ]------------
>> kernel BUG at include/linux/mm.h:547!
>> Internal error: Oops - BUG: 0 [#1] SMP
>> Modules linked in: crct10dif_ce ghash_ce spi_orion i2c_mux_pca954x i2c_mux sfp mdio_i2c omap_rng mvpp2 armada_thermal phylink marvell sbsa_gwdt mvmdio vfat fat mmc_block rtc_armada38x sdhci_xenon_driver phy_generic sdhci_pltfm xhci_plat_hcd ahci_platform phy_mvebu_cp110_comphy i2c_mv64xxx sdhci fuse
>> Process swapper/0 (pid: 0, stack limit = 0x0000000058631e79)
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.1.1-300.fc30.aarch64 #1
>> Hardware name: Marvell mvebu_armada-8k/mvebu_armada-8k, BIOS 2019.04 04/18/2019
>> pstate: 40400005 (nZcv daif +PAN -UAO)
>> pc : page_frag_free+0x74/0xa0
>> lr : page_frag_free+0x74/0xa0
>> sp : ffff000010003a60
>> x29: ffff000010003a60 x28: ffff0000117e5480 
>> x27: 0000000000000000 x26: 0000000000000000 
>> x25: ffff80007fc40462 x24: ffff80007fc40458 
>> x23: ffff80007fc40450 x22: ffff0000117dbc00 
>> x21: ffff8001356c2a00 x20: ffff80007fc404c0 
>> x19: ffff80007fc40400 x18: 0000000000000000 
>> x17: 0000000000000000 x16: 0000000000000000 
>> x15: 0000000000000010 x14: ffffffffffffffff 
>> x13: ffff00009000375f x12: ffff000010003767 
>> x11: ffff000011679000 x10: ffff000010eb6428 
>> x9 : ffff00001185a000 x8 : 00000000000001c7 
>> x7 : 0000000000000015 x6 : 0000000000000001 
>> x5 : 0000000000000000 x4 : ffff80013f72a190 
>> x3 : ffff80013f730488 x2 : ffff80013f72a190 
>> x1 : 0000000000000000 x0 : 000000000000003e 
>> Call trace:
>>  page_frag_free+0x74/0xa0
>>  skb_free_head+0x28/0x48
>>  skb_release_data+0x13c/0x178
>>  skb_release_all+0x30/0x40
>>  consume_skb+0x38/0xc8
>>  arp_process+0x2d0/0x6e0
>>  arp_rcv+0x100/0x178
>>  __netif_receive_skb_one_core+0x50/0x60
>>  __netif_receive_skb+0x28/0x70
>>  netif_receive_skb_internal+0x44/0xd0
>>  napi_gro_receive+0x198/0x1c8
>>  mvpp2_rx+0x1f8/0x500 [mvpp2]
>>  mvpp2_poll+0x150/0x1e8 [mvpp2]
>>  napi_poll+0xb4/0x250
>>  net_rx_action+0xbc/0x1b0
>>  __do_softirq+0x138/0x334
>>  irq_exit+0xc0/0xe0
>>  __handle_domain_irq+0x70/0xc0
>>  gic_handle_irq+0x58/0xa8
>>  el1_irq+0xf0/0x1c0
>>  arch_cpu_idle+0x3c/0x1c8
>>  default_idle_call+0x20/0x3c
>>  cpuidle_idle_call+0x140/0x190
>>  do_idle+0xb0/0x108
>>  cpu_startup_entry+0x2c/0x30
>>  rest_init+0xc0/0xcc
>>  arch_call_rest_init+0x14/0x1c
>>  start_kernel+0x4ac/0x4c0
>> Code: aa0203e0 d0006101 91226021 9400cf32 (d4210000) 
>> ---[ end trace 267606a8b5fb06cb ]---
>> Kernel panic - not syncing: Fatal exception in interrupt
>> SMP: stopping secondary CPUs
>> Kernel Offset: disabled
>> CPU features: 0x002,21006000
>> Memory Limit: none
>> ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---  
>
>
