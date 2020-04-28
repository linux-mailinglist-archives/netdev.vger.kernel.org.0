Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D391BB908
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 10:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgD1InH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 04:43:07 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:32782 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgD1InE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 04:43:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588063383; x=1619599383;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=ZBIDdybMYq8lnP0dIJgZo7CcYomKwnVJ72SEEnBM1p8=;
  b=L1zZ/7Ki0f3a0oXkKBMbVBG6Gu+OMRkFVmsnv/eC0TFa8qaSFhbevSoO
   vPhmY5T8G06jE4OUW805hkBF2EOBqGBtHyxlo7DA/gRrKU0i1ml4ZwKpc
   CrQiG95fFpNSog+g1CaKKQ2m5wrJBt/C2RjNQQbzULljXx/l3ksiaopOW
   KqFlVsjGvWY+p55A5+eCLwZEWLi3K1owxamVLm6Rb/ESJal0ngf5lIGV/
   lt+3f8q82HGeY66xv1posK//c4SaojeQ9rjrwWjBqz3w7U2Gzp8ymOafQ
   7AOjZLDcsY4p9nC5alOf0SPz2eBqBfu1L3Y/7BblW2BfsLHUpkEHMuNGG
   Q==;
IronPort-SDR: VWCNs13wcBkAEe8N/tYOxBJSKbk1fI8FiRerhE/YUKVuuAlVy2yWFO/Xv45YcodWBWU7d+D7xq
 Eq2PUvRMrUHt6f1dU3DRsWCW8r3Vlicmi8u+jnFpKGhrVzaVeeswTtb4Sv/OsvwvMMdzi9Q508
 rHrI1NVdnBNvEZsO5d7UoMFVKI64l7DpZkWVZ9MC7yp0GgZu379P1Lv4tY8+gD8PDH+hny8ztY
 aDAhyl1Bvytnkc3xuomfeuhw61/ZlPjQ4v/A3KhiRMc2lvwLfbsqfuXVdXlyNXtvSL+B/4pvEM
 sKg=
X-IronPort-AV: E=Sophos;i="5.73,327,1583218800"; 
   d="scan'208";a="77536524"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2020 01:43:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 Apr 2020 01:43:01 -0700
Received: from [10.205.29.82] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 28 Apr 2020 01:42:57 -0700
Subject: Re: [PATCH net v1] net: macb: fix an issue about leak related system
 resources
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, <yash.shah@sifive.com>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
References: <20200425125737.5245-1-zhengdejin5@gmail.com>
 <CAHp75VceH08X5oWSCXhx8O0Bsx9u=Tm+DVQowG+mC3Vs2=ruVQ@mail.gmail.com>
 <20200428032453.GA32072@nuc8i5>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <acdfcb8d-9079-1340-09d5-2c10383f9c26@microchip.com>
Date:   Tue, 28 Apr 2020 10:42:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428032453.GA32072@nuc8i5>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2020 at 05:24, Dejin Zheng wrote:
> On Mon, Apr 27, 2020 at 01:33:41PM +0300, Andy Shevchenko wrote:
>> On Sat, Apr 25, 2020 at 3:57 PM Dejin Zheng <zhengdejin5@gmail.com> wrote:
>>>
>>> A call of the function macb_init() can fail in the function
>>> fu540_c000_init. The related system resources were not released
>>> then. use devm_ioremap() to replace ioremap() for fix it.
>>>
>>
>> Why not to go further and convert to use devm_platform_ioremap_resource()?
>>
> devm_platform_ioremap_resource() will call devm_request_mem_region(),
> and here did not do it.

And what about devm_platform_get_and_ioremap_resource()? This would 
streamline this whole fu540_c000_init() function.

Regards,
   Nicolas

>>> Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
>>> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
>>> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
>>> ---
>>>   drivers/net/ethernet/cadence/macb_main.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>>> index a0e8c5bbabc0..edba2eb56231 100644
>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>> @@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device *pdev)
>>>          if (!res)
>>>                  return -ENODEV;
>>>
>>> -       mgmt->reg = ioremap(res->start, resource_size(res));
>>> +       mgmt->reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
>>>          if (!mgmt->reg)
>>>                  return -ENOMEM;
>>>


-- 
Nicolas Ferre
