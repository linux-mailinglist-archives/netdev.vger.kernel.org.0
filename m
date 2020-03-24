Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B30190E1A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgCXMwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:52:05 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:50312 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgCXMwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:52:05 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mrjt365Cz1qsb8;
        Tue, 24 Mar 2020 13:52:02 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mrjt1KYSz1r0c0;
        Tue, 24 Mar 2020 13:52:02 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id uc7R3wW2JZQk; Tue, 24 Mar 2020 13:52:01 +0100 (CET)
X-Auth-Info: i+HBeRNuCVNQ7ohYuWMYjynAud1YVGzg4E3MdTmBXu0=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 13:52:01 +0100 (CET)
Subject: Re: [PATCH 06/14] net: ks8851: Remove ks8851_rdreg32()
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-7-marex@denx.de>
 <20200324072219.wochifgdx2mz6orx@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <39a54e58-63d1-d826-a9d1-914e9f546cd0@denx.de>
Date:   Tue, 24 Mar 2020 13:37:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324072219.wochifgdx2mz6orx@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 8:22 AM, Lukas Wunner wrote:
> On Tue, Mar 24, 2020 at 12:42:55AM +0100, Marek Vasut wrote:
>> The ks8851_rdreg32() is used only in one place, to read two registers
>> using a single read. To make it easier to support 16-bit accesses via
>> parallel bus later on, replace this single read with two 16-bit reads
>> from each of the registers and drop the ks8851_rdreg32() altogether.
> 
> This doubles the SPI transactions necessary to read the RX queue status,
> which happens for each received packet, so I expect the performance
> impact to be noticeable.  Can you keep the 32-bit variant for SPI
> and instead just introduce a 32-bit read for the MLL chip which performs
> two 16-bit reads internally?

Please test it before I'll be forced to rework the harder half of this
patchset. I don't have the SPI variant of the chip to collect those
statistics.

But the real fix here would be to convert the driver to regmap in the
end and permit regmap to merge neighboring register accesses over SPI.
