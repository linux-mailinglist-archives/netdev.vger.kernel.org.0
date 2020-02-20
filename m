Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C53166104
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgBTPeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:34:13 -0500
Received: from crane.lixil.net ([71.19.154.81]:39776 "EHLO crane.lixil.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbgBTPeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 10:34:13 -0500
Received: from webmail.lixil.net (crane.lixil.net [IPv6:2605:2700:1:1045:0:6c:6978:696c])
        by crane.lixil.net (Postfix) with ESMTP id D6EC632ACA2;
        Thu, 20 Feb 2020 08:34:07 -0700 (MST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Feb 2020 08:34:07 -0700
From:   Joel Johnson <mrjoel@lixil.net>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
In-Reply-To: <20200220101232.GU25745@shell.armlinux.org.uk>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
 <20200219092227.GR25745@shell.armlinux.org.uk>
 <8099d231594f1785e7149e4c6c604a5c@lixil.net>
 <20200220101232.GU25745@shell.armlinux.org.uk>
Message-ID: <9c61fda15f89a69989c0d80fda33ea47@lixil.net>
X-Sender: mrjoel@lixil.net
User-Agent: lixil webmail
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-20 03:12, Russell King - ARM Linux admin wrote:
> On Wed, Feb 19, 2020 at 06:49:51AM -0700, Joel Johnson wrote:
>> On 2020-02-19 02:22, Russell King - ARM Linux admin wrote:
>> > On Tue, Feb 18, 2020 at 10:14:48PM -0700, Joel Johnson wrote:
>> > Does debian have support for the comphy enabled in their kernel,
>> > which is controlled by CONFIG_PHY_MVEBU_A38X_COMPHY ?
>> 
>> Well, doh! I stared at the patch series for way to long, but the added
>> Kconfig symbol failed to register mentally somehow. I had been using 
>> the
>> last known good Debian config with make olddefconfig, but it obviously
>> wasn't included in earlier configs and not enabled by default.
>> 
>> Many thanks to you and Willy Tarreau for pointing out my glaring 
>> omission!
> 
> Thanks for letting us know that you've fixed it now.

Sure thing, I've submitted a Debian patch, and was pointed to an 
existing Debian bug with the same issue and patch, so hopefully that 
will get incorporated soon. I'll also keep an eye on OpenWRT when they 
move to an affected kernel version to make sure it's included.

One lingering question that wasn't clear to me is the apparent 
inconsistency in default enablement for PHYs in 
drivers/phy/marvell/Kconfig. Is there a technical reason why 
PHY_MVEBU_A3700_COMPHY defaults to 'y' but PHY_MVEBU_A38X_COMPHY (and 
PHY_MVEBU_CP110_COMPHY) default to 'n', or is it just an artifact of 
being added at different times? Similarly, is there a reason that 
PHY_MVEBU_A3700_COMPHY and PHY_MVEBU_A3700_UTMI default to 'y' instead 
of 'm' for all ARCH_MVEBU builds? In my testing, building with 
PHY_MVEBU_A38X_COMPHY as a module still seemed to autoload the module as 
needed on boot, so modules for different platforms seems off-hand more 
lightweight that building the driver in for all MVEBU boards which don't 
use all drivers.

With the current defaults, it seems like PHY_MVEBU_CP110_COMPHY may be 
affected in Debian the same way as PHY_MVEBU_A38X_COMPHY, but I don't 
have available Armada 7K/8K hardware yet to confirm.

Joel
