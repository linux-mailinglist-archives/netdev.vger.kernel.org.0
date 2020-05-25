Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A133E1E04D3
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbgEYCq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:46:57 -0400
Received: from foss.arm.com ([217.140.110.172]:35100 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388136AbgEYCq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:46:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16EB531B;
        Sun, 24 May 2020 19:46:56 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B46FD3F305;
        Sun, 24 May 2020 19:46:55 -0700 (PDT)
Subject: Re: [RFC 01/11] net: phy: Don't report success if devices weren't
 found
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-2-jeremy.linton@arm.com>
 <20200523182054.GW1551@shell.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <e6e08ca4-5a6d-5ea3-0f97-946f1d403568@arm.com>
Date:   Sun, 24 May 2020 21:46:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200523182054.GW1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for taking a look at this.

On 5/23/20 1:20 PM, Russell King - ARM Linux admin wrote:
> On Fri, May 22, 2020 at 04:30:49PM -0500, Jeremy Linton wrote:
>> C45 devices are to return 0 for registers they haven't
>> implemented. This means in theory we can terminate the
>> device search loop without finding any MMDs. In that
>> case we want to immediately return indicating that
>> nothing was found rather than continuing to probe
>> and falling into the success state at the bottom.
> 
> This is a little confusing when you read this comment:
> 
>                          /*  If mostly Fs, there is no device there,
>                           *  then let's continue to probe more, as some
>                           *  10G PHYs have zero Devices In package,
>                           *  e.g. Cortina CS4315/CS4340 PHY.
>                           */
> 
> Since it appears to be talking about the case of a PHY where *devs will
> be zero.  However, tracking down the original submission, it seems this
> is not the case at all, and the comment is grossly misleading.
> 
> It seems these PHYs only report a valid data in the Devices In Package
> registers for devad=0 - it has nothing to do with a zero Devices In
> Package.

Yes, this ended up being my understanding of this commit, and is part of 
my justification for starting the devices search at the reserved address 
0 rather than 1.

> 
> Can I suggest that this comment is fixed while we're changing the code
> to explicitly reject this "zero Devices In package" so that it's not
> confusing?

Its probably better to kill it in 5/11 with a mention that we are 
starting at a reserved address?

OTOH, I'm a bit concerned that reading at 0 as the first address will 
cause problems because the original code was only triggering it after a 
read returning 0xFFFFFFFF at a valid MMD address. It does 
simplify/clarify the loop though. If it weren't for this 0 read, I would 
have tried to avoid some of the additional MMD reserved addresses.

