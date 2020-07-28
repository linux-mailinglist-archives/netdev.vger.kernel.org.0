Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B4323158A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 00:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgG1Waj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:30:39 -0400
Received: from foss.arm.com ([217.140.110.172]:42032 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729223AbgG1Waj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:30:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 430F131B;
        Tue, 28 Jul 2020 15:30:38 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65A793F71F;
        Tue, 28 Jul 2020 15:30:37 -0700 (PDT)
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
To:     Dan Callaghan <dan.callaghan@opengear.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <9e63aabf-8993-9ce0-1274-c29d7a5fc267@arm.com>
Date:   Tue, 28 Jul 2020 17:30:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1595922651-sup-5323@galangal.danc.bne.opengear.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/28/20 3:06 AM, Dan Callaghan wrote:
> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
>> Now i could be wrong, but are Ethernet switches something you expect
>> to see on ACPI/SBSA platforms? Or is this a legitimate use of the
>> escape hatch?
> 
> As an extra data point: right now I am working on an x86 embedded
> appliance (ACPI not Device Tree) with 3x integrated Marvell switches.
> I have been watching this patch series with great interest, because
> right now there is no way for me to configure a complex switch topology
> in DSA without Device Tree.

DSA though, the switch is hung off a normal MAC/MDIO, right? (ignoring 
whether that NIC/MAC is actually hug off PCIe for the moment).

It just has a bunch of phy devices strung out on that single MAC/MDIO. 
So in ACPI land it would still have a relationship similar to the one 
Andrew pointed out with his DT example where the eth0->mdio->phy are all 
contained in their physical parent. The phy in that case associated with 
the parent adapter would be the first direct decedent of the mdio, the 
switch itself could then be represented with another device, with a 
further string of device/phys representing the devices. (I dislike 
drawing acsii art, but if this isn't clear I will, its also worthwhile 
to look at the dpaa2 docs for how the mac/phys work on this device for 
contrast.).

If so, then its probably possible to represent with a fairly regular 
looking set of ACPI objects and avoids part of the core discussion here 
about whether we need a standardized way to pick phy's out of arbitrary 
parts of the hierarchy using a part of the spec intended for one off 
problems.

Am I missing something?



> 
> For the device I am working on, we will have units shipping before these
> questions about how to represent Ethernet switches in ACPI can be
> resolved. So realistically, we will have to actually configure the
> switches using software_node structures supplied by an out-of-tree
> platform driver, or some hackery like that, rather than configuring them
> through ACPI.
> 
> An approach I have been toying with is to port all of DSA to use the
> fwnode_handle abstraction instead of Device Tree nodes, but that is
> obviously a large task, and frankly I was not sure whether such a patch
> series would be welcomed.
> 

