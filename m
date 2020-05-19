Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43DF1D9BDC
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgESQAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:00:19 -0400
Received: from foss.arm.com ([217.140.110.172]:35518 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729211AbgESQAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:00:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 018FE30E;
        Tue, 19 May 2020 09:00:18 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B80493F305;
        Tue, 19 May 2020 09:00:17 -0700 (PDT)
Subject: Re: [PATCH] net: phy: Fix c45 no phy detected logic
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
References: <20200514170025.1379981-1-jeremy.linton@arm.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <63b1db19-4744-417a-cd26-1e15e60fa571@arm.com>
Date:   Tue, 19 May 2020 11:00:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514170025.1379981-1-jeremy.linton@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/14/20 12:00 PM, Jeremy Linton wrote:
> The commit "disregard Clause 22 registers present bit..." clears
> the low bit of the devices_in_package data which is being used
> in get_phy_c45_ids() to determine if a phy/register is responding
> correctly. That check is against 0x1FFFFFFF, but since the low
> bit is always cleared, the check can never be true. This leads to
> detecting c45 phy devices where none exist.
> 
> Lets fix this by also clearing the low bit in the mask to 0x1FFFFFFE.
> This allows us to continue to autoprobe standards compliant devices
> without also gaining a large number of bogus ones.

So, I've been reworking the c45 ID detection logic, with an aim to 
hinting to the scanner that it should fallback to c22 for a given phy 
address (as well as giving it some additional standardized areas to 
probe for phy ids). It turns out that the c22 registers present bit is a 
pretty useful signal that this needs to happen. So, I think this patch 
really should move the BIT(0) sanitation after the MMD detection loop in 
get_phy_c45_ids().

But having dug into this code for a while now, I'm hard pressed to 
understand the case that the original 3b5e74e0afe3 commit fixed. The 
only thing I can see is that the "bug" i'm fixing here was intentionally 
creating bogus phy nodes when the MMDs weren't responding.


Thanks,

> 
> Fixes: 3b5e74e0afe3 ("net: phy: disregard "Clause 22 registers present" bit in get_phy_c45_devs_in_pkg")
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>   drivers/net/phy/phy_device.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index ac2784192472..b93d984d35cc 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -723,7 +723,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   		if (phy_reg < 0)
>   			return -EIO;
>   
> -		if ((*devs & 0x1fffffff) == 0x1fffffff) {
> +		if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
>   			/*  If mostly Fs, there is no device there,
>   			 *  then let's continue to probe more, as some
>   			 *  10G PHYs have zero Devices In package,
> @@ -733,7 +733,7 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   			if (phy_reg < 0)
>   				return -EIO;
>   			/* no device there, let's get out of here */
> -			if ((*devs & 0x1fffffff) == 0x1fffffff) {
> +			if ((*devs & 0x1ffffffe) == 0x1ffffffe) {
>   				*phy_id = 0xffffffff;
>   				return 0;
>   			} else {
> 

