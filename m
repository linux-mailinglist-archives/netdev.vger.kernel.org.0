Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA13CBCAAD
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441233AbfIXOz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:55:29 -0400
Received: from mail.itouring.de ([188.40.134.68]:53686 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729134AbfIXOz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 10:55:29 -0400
Received: from tux.wizards.de (pD9EBF359.dip0.t-ipconnect.de [217.235.243.89])
        by mail.itouring.de (Postfix) with ESMTPSA id 65F60416A471;
        Tue, 24 Sep 2019 16:55:27 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 33BB8F01602;
        Tue, 24 Sep 2019 16:55:27 +0200 (CEST)
Subject: Re: atlantic: weird hwmon temperature readings with AQC107 NIC
 (kernel 5.2/5.3)
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Netdev <netdev@vger.kernel.org>
References: <0db14339-1b69-8fa4-21fd-6d436037c945@applied-asynchrony.com>
 <4faf7584-860e-6f52-95ab-ea96438af394@applied-asynchrony.com>
 <c26f4a9d-df14-c8af-4c99-5a670099e8bc@aquantia.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <01dc687a-f61e-2ca9-4117-83cb91454848@applied-asynchrony.com>
Date:   Tue, 24 Sep 2019 16:55:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c26f4a9d-df14-c8af-4c99-5a670099e8bc@aquantia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 4:32 PM, Igor Russkikh wrote:
> We've recently found out that as well, could you try applying the following patch:
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> index da726489e3c8..08b026b41571 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> @@ -337,7 +337,7 @@ static int aq_fw2x_get_phy_temp(struct aq_hw_s *self, int *temp)
>          /* Convert PHY temperature from 1/256 degree Celsius
>           * to 1/1000 degree Celsius.
>           */
> -       *temp = temp_res  * 1000 / 256;
> +       *temp = (temp_res & 0xFFFF)  * 1000 / 256;
> 
>          return 0;
>   }

Well, what do you know!

eth0-pci-0600
Adapter: PCI adapter
PHY Temperature:  +63.5°C

This looks like it aligns with reality. :-)

> Funny thing is that this value gets readout from HW memory, all the readouts are
> done by full dwords, but the value is only word width. High word of that dword

I suspected upper-word-garbage but of course don't know internals.

> is estimated cable length. On short cables we use it is often zero ;)

:D

When you send the proper patch feel free to add:
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks again for the quick help!

Holger
