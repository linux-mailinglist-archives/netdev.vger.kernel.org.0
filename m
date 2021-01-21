Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0011E2FE695
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 10:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbhAUJmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 04:42:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbhAUJmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 04:42:09 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0336C061757;
        Thu, 21 Jan 2021 01:41:28 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A0A4A22F99;
        Thu, 21 Jan 2021 10:41:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1611222086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAI4d5E5IrpOA+2Fee0JWaMo5gtggjAam42jIHHHqBY=;
        b=anJb+frYYEwtl/9Poa+3LMZp4un6EwNIczpFjFWTZmKRlsOVL0GcfBOWegWsTBm+zD6Z1x
        EtlAtIbhIOLc9Gfisb3mDzfcs9L5PHHA86I7S5Q3BE6YxTql3/QMWVj7szmTCYiM90RCxq
        ljpPKCVwwbJ8O2sOnntn4XNVZZCWafE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 21 Jan 2021 10:41:26 +0100
From:   Michael Walle <michael@walle.cc>
To:     Claudiu.Beznea@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas.Ferre@microchip.com, davem@davemloft.net
Subject: Re: [PATCH] net: macb: ignore tx_clk if MII is used
In-Reply-To: <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
References: <20210120194303.28268-1-michael@walle.cc>
 <38734f00-e672-e694-1344-35f4dd68c90c@microchip.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <bd029c647db42e05bf1a54d43d601861@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Claudiu,

Am 2021-01-21 10:19, schrieb Claudiu.Beznea@microchip.com:
> On 20.01.2021 21:43, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
>> the content is safe
>> 
>> If the MII interface is used, the PHY is the clock master, thus don't
>> set the clock rate. On Zynq-7000, this will prevent the following
>> warning:
>>   macb e000b000.ethernet eth0: unable to generate target frequency: 
>> 25000000 Hz
>> 
> 
> Since in this case the PHY provides the TX clock and it provides the 
> proper
> rate based on link speed, the MACB driver should not handle the 
> bp->tx_clk
> at all (MACB driver uses this clock only for setting the proper rate on 
> it
> based on link speed). So, I believe the proper fix would be to not pass 
> the
> tx_clk at all in device tree. This clock is optional for MACB driver.

Thanks for looking into this.

I had the same thought. But shouldn't the driver handle this case 
gracefully?
I mean it does know that the clock isn't needed at all. Ususually that 
clock
is defined in a device tree include. So you'd have to redefine that node 
in
an actual board file which means duplicating the other clocks.

-michael
