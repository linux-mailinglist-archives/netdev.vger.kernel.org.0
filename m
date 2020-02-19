Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F697163C6D
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 06:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgBSFVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 00:21:12 -0500
Received: from crane.lixil.net ([71.19.154.81]:53480 "EHLO crane.lixil.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbgBSFVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 00:21:11 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2020 00:21:11 EST
Received: from webmail.lixil.net (crane.lixil.net [IPv6:2605:2700:1:1045:0:6c:6978:696c])
        by crane.lixil.net (Postfix) with ESMTP id E72B5329B4F;
        Tue, 18 Feb 2020 22:14:48 -0700 (MST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Feb 2020 22:14:48 -0700
From:   Joel Johnson <mrjoel@lixil.net>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: mvneta: comphy regression with SolidRun ClearFog
Message-ID: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
X-Sender: mrjoel@lixil.net
User-Agent: lixil webmail
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In updating recently I'm encountering a regression with the mvneta 
driver on SolidRun ClearFog Base devices. I originally filed the bug 
with Debian (https://bugs.debian.org/951409) since I was using distro 
provided packages, but after further investigation I have isolated the 
issue as related to comphy support added during development for kernel 
version 5.1.

When booting stock kernels up to 5.0 everything works as expected with 
three ethernet devices identified and functional. However, running any 
kernel 5.1 or later, I only have a single ethernet device available. The 
single device available appears to be the one attached to the SoC itself 
and not connected via SerDes lanes using comphy, i.e. the one defined at 
f1070000.ethernet.

With some log/diff assisted bisecting, I've been able to confirm that 
the "tipping point" changeset is f548ced15f90, which actually performs 
the DT change for the ClearFog family of devices. That's the commit at 
which the failure starts, but is just the final enablement of the added 
feature in the overall series. I've also tested booting the same kernel 
binary (including up to v5.6-rc1) and only swapping the dtb for one 
excluding the problematic commit and confirmed that simply changing the 
dtb results in all three devices being functional, albeit obviously 
without comphy support.

The original patch series applied (as best I can tell) is below, merged 
in commit a4751093a26c.

     
https://lore.kernel.org/netdev/20190207161825.ueinmyf6ygjiqzzy@shell.armlinux.org.uk

I'm not overly Device Tree savvy, but a cursory inspection of 
f548ced15f90 at least matches my U-Boot SerDes lane configuration, with 
comphy1 and comphy5 expected to match lane #1 and #5 respectively.

I have been running a locally patched pre-upstream merged v2020.04-rc2 
U-Boot version, but I also tested with a clean build of upstream U-Boot 
v2020.01 as well as the latest SolidRun vendor build [1], with all 
configurations yielding the same result. I happen to be booting off of 
internal SPI, but I doubt that is related. I'm also running both 
ethernet SGMII SerDes lanes at the default 1.25Gbps speed as configured 
in U-Boot.

The only notable difference I can see in /sys/firmware/devicetree is 
expected given the change in dtb, with the following new entries:

     hexdump -C 
/sys/firmware/devicetree/base/soc/internal-regs/ethernet@30000/phys
     00000000  00 00 00 0e 00 00 00 01                           
|........|

     hexdump -C 
/sys/firmware/devicetree/base/soc/internal-regs/ethernet@34000/phys
     00000000  00 00 00 10 00 00 00 02                           
|........|

Likely unrelated, but a difference that also stood out is that 
armada-388-clearfog.dts contains a managed = "in-band-status" entry for 
eth1 but not eth2.

I plan on filing a kernel bugzilla issue (once I get my password reset). 
In the meantime, any further guidance on testing or troubleshooting 
would be greatly appreciated. I'd be happy to provide further details or 
test builds with patches, but as mentioned above am not very savvy with 
Device Tree handling functionality. In the meantime I'll add some trace 
logging messages in the comphy handling changes to dig further, but if 
there's something obvious I'd love to avoid it if it's just busy work.

Thanks,
Joel

[1] 
https://images.solid-build.xyz/A38X/U-Boot/u-boot-clearfog-base-spi.kwb
