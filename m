Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860A51645F6
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 14:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBSNtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 08:49:51 -0500
Received: from crane.lixil.net ([71.19.154.81]:35938 "EHLO crane.lixil.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgBSNtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 08:49:51 -0500
Received: from webmail.lixil.net (crane.lixil.net [IPv6:2605:2700:1:1045:0:6c:6978:696c])
        by crane.lixil.net (Postfix) with ESMTP id 51E28329F64;
        Wed, 19 Feb 2020 06:49:51 -0700 (MST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Feb 2020 06:49:51 -0700
From:   Joel Johnson <mrjoel@lixil.net>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Baruch Siach <baruch@tkos.co.il>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Rob Herring <robh@kernel.org>, netdev@vger.kernel.org
Subject: Re: mvneta: comphy regression with SolidRun ClearFog
In-Reply-To: <20200219092227.GR25745@shell.armlinux.org.uk>
References: <af7602ae737cbc21ce7f01318105ae73@lixil.net>
 <20200219092227.GR25745@shell.armlinux.org.uk>
Message-ID: <8099d231594f1785e7149e4c6c604a5c@lixil.net>
X-Sender: mrjoel@lixil.net
User-Agent: lixil webmail
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-19 02:22, Russell King - ARM Linux admin wrote:
> On Tue, Feb 18, 2020 at 10:14:48PM -0700, Joel Johnson wrote:
>> In updating recently I'm encountering a regression with the mvneta 
>> driver on
>> SolidRun ClearFog Base devices. I originally filed the bug with Debian
>> (https://bugs.debian.org/951409) since I was using distro provided 
>> packages,
>> but after further investigation I have isolated the issue as related 
>> to
>> comphy support added during development for kernel version 5.1.
>> 
>> When booting stock kernels up to 5.0 everything works as expected with 
>> three
>> ethernet devices identified and functional. However, running any 
>> kernel 5.1
>> or later, I only have a single ethernet device available. The single 
>> device
>> available appears to be the one attached to the SoC itself and not 
>> connected
>> via SerDes lanes using comphy, i.e. the one defined at 
>> f1070000.ethernet.
>> 
>> With some log/diff assisted bisecting, I've been able to confirm that 
>> the
>> "tipping point" changeset is f548ced15f90, which actually performs the 
>> DT
>> change for the ClearFog family of devices. That's the commit at which 
>> the
>> failure starts, but is just the final enablement of the added feature 
>> in the
>> overall series. I've also tested booting the same kernel binary 
>> (including
>> up to v5.6-rc1) and only swapping the dtb for one excluding the 
>> problematic
>> commit and confirmed that simply changing the dtb results in all three
>> devices being functional, albeit obviously without comphy support.
> 
> Does debian have support for the comphy enabled in their kernel,
> which is controlled by CONFIG_PHY_MVEBU_A38X_COMPHY ?

Well, doh! I stared at the patch series for way to long, but the added 
Kconfig symbol failed to register mentally somehow. I had been using the 
last known good Debian config with make olddefconfig, but it obviously 
wasn't included in earlier configs and not enabled by default.

I tested a build with v5.6-rc1 and actually enabled the platform driver 
and it worked as expected, including log output of "configuring for 
sgmii link mode". Back to moving forward on other testing. Sorry for the 
noise, I'll update the Debian bug with a patch to enable the config 
symbol for armmp kernels.

Many thanks to you and Willy Tarreau for pointing out my glaring 
omission!

Joel
