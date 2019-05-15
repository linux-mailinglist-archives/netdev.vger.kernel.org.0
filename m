Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10411E90F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 09:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfEOHeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 03:34:14 -0400
Received: from mail.bix.bg ([193.105.196.21]:41885 "HELO mail.bix.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1725876AbfEOHeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 03:34:13 -0400
Received: (qmail 26158 invoked from network); 15 May 2019 07:34:12 -0000
Received: from d2.declera.com (212.116.131.122)
  by indigo.declera.com with SMTP; 15 May 2019 07:34:12 -0000
Message-ID: <b9c6845e14026676cf9f9b7dd733c70a2e3ae49a.camel@declera.com>
Subject: Re: mvpp2:  oops on first received packet
From:   Yanko Kaneti <yaneti@declera.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Marcin Wojtas <mw@semihalf.com>
Cc:     netdev <netdev@vger.kernel.org>, Matteo Croce <mcroce@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Date:   Wed, 15 May 2019 10:34:12 +0300
In-Reply-To: <d9f15f5266bcf748dfe2bc937c9cdaa22ccc2764.camel@declera.com>
References: <856dc9462c31bc9f102940c61f94db1f44574733.camel@declera.com>
         <20190514121948.4def4872@carbon> <20190514143212.5abaf995@bootlin.com>
         <d9f15f5266bcf748dfe2bc937c9cdaa22ccc2764.camel@declera.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.33.1 (3.33.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-05-14 at 16:25 +0300, Yanko Kaneti wrote:
> On Tue, 2019-05-14 at 14:32 +0200, Maxime Chevallier wrote:
> > Hi Yanko,
> > 
> > > On Tue, 14 May 2019 10:29:31 +0300
> > > Yanko Kaneti <yaneti@declera.com> wrote:
> > > 
> > > > Hello,
> > > > 
> > > > I am trying to get some Fedora working on the MACCHIATObin SingleShot
> > > > and I am getting an OOPS on what seems to be the first received packet
> > > > on the gigabit port.
> > > > 
> > > > I've tried both 5.0.x stable and 5.1.1 with the same result.  
> > > > mvpp2 f4000000.ethernet eth2: Link is Up - 1Gbps/Full - flow control rx/tx
> > > > IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> > > > page:ffff7e0001ff1000 count:0 mapcount:0 mapping:0000000000000000 index:0x0
> > > > flags: 0x1fffe000000000()
> > > > raw: 001fffe000000000 ffff7e0001ff1008 ffff7e0001ff1008 0000000000000000
> > > > raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
> > > > page dumped because: VM_BUG_ON_PAGE(page_ref_count(page) == 0)  
> > > 
> > > Looks like a page refcnt bug (trying to free a page with already have
> > > zero refcnt).
> > 
> > This looks like another issue that was reported here, where the cause
> > was in the EFI firmware :
> > 
> > https://lore.kernel.org/netdev/6355174d-4ab6-595d-17db-311bce607aef@arm.com/
> > 
> > Can you give some details on the version of the firmware you have and
> > if you are using EFI or uboot ?
> 
> I am booting a UEFI enabled uboot as built by Fedora , wrapped around by
> the Marvell ATF, v18.12 , also tried with 17.10 without a difference.
> From an SD card. 4G memory DIMM as supplied by SolidRun.
...
> I am not sure if uboot or EDK2 with the marvell build instructions is
> the best way to go about it.
> 

FWIW, from this thread I learned about the Macchiato list @einval and
tried the last test internal edk2 build that Marcin mentions there
(flash-image-mcbin-mainline-r20190509.bin).

It finds and boots the same Fedora 30 setup that uboot works with. 

Gigabit ethernet seems to work without crashing. The 10Gs do not seem to
work and show suspect PHY status with or without SFP+/DACs,  probably
for some DoubleShot vs SingleShot reason..

PCIe (where I have an NVMe drive on an M.2 adapter) doesn't. Same drive,
same kernel with the uboot firmware works fine.

On a balance of what works or doesn't with uboot vs edk2 and what it
would take to build one of the two I'd prefer uboot (if mvpp2 somehow
manages to work with whatever uboot+shim+grub leave behind).

-Yanko





