Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11F04CD19F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 10:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbiCDJub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 04:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234317AbiCDJua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 04:50:30 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306032D1D8;
        Fri,  4 Mar 2022 01:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646387383; x=1677923383;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Da4d332btgA6wb9Q+l3iKJmOqScRIu4EjDN43UUz/ns=;
  b=URwQmsB+xlgpTfJPN8jgjANXaI1CpC1IO/UcwtKMBsvYK0PyWvZvIbp9
   LaCX3fPF/5KmcZH9W+IwpRrYeqjxdtI+k9qGIx62+s++Hn90b8lENysfv
   OLjpPeaHPjYcPFveSn8KV20SGd+Wp7IKAiwd7Dekrg4d7kBwi0VBaRghE
   t5HHMAbLcM4pbfbPkkjEg/w3KOanGa2oILttAKbHj9KGLqHVIWh++ZbuR
   QD3Mkzt67c96tiZdBUGOOuQr1nt/lRe68I9b9ibZQzA+8QL5EMeee+Rkr
   fIWoLm4C3CFx1ZuuYr7DQEsF7wXm6sjpg5oiXaI4SBswwhZkRQtZr5U79
   A==;
X-IronPort-AV: E=Sophos;i="5.90,154,1643698800"; 
   d="scan'208";a="155709367"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 02:49:42 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 02:49:42 -0700
Received: from [10.12.72.98] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Fri, 4 Mar 2022 02:49:41 -0700
Message-ID: <6a92bf85-4680-b0cf-aaa8-eb52d0a0adde@microchip.com>
Date:   Fri, 4 Mar 2022 10:49:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [BUG] net: macb: Use-After-Free when removing the module
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Zheyu Ma <zheyuma97@gmail.com>
CC:     <claudiu.beznea@microchip.com>, <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <CAMhUBjkt1E4gQ5-sgAfPvKqNrfXBFUQ14zRP=MWPwfhZJu3QPA@mail.gmail.com>
 <20220303075738.56a90b79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20220303075738.56a90b79@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/03/2022 at 16:57, Jakub Kicinski wrote:
> On Thu, 3 Mar 2022 20:24:53 +0800 Zheyu Ma wrote:
>> When removing the macb_pci module, the driver will cause a UAF bug.
>>
>> Commit d82d5303c4c5 ("net: macb: fix use after free on rmmod") moves
>> the platform_device_unregister() after clk_unregister(), but this
>> introduces another UAF bug.
> 
> The layering is all weird here. macb_probe() should allocate a private
> structure for the _PCI driver_ which it can then attach to
> struct pci_dev *pdev as driver data. Then free it in remove.
> It shouldn't stuff its information into the platform device.

The PCI file was added as an optional layer to the original "platform" 
macb driver. I think it was added to run some experiments in some test 
conditions at Cadence.

> Are you willing to send a fix like that?

I would prefer that we don't change too much the driver in the normal 
working conditions: meaning without the PCI additional glue.

my $0.02.

Regards,
   Nicolas

-- 
Nicolas Ferre
