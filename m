Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B04D6BD566
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjCPQVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjCPQVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:21:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EFE2D62;
        Thu, 16 Mar 2023 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678983642; x=1710519642;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cFYSJueAEaIbpXuTsA6/QHll3QZquVW6kODepVhNrWQ=;
  b=ap6oJ06PNgGH4UuEWj1498HTgd/N5cQB2tWuDmBtwP+IvLBBxxPL/00j
   DAkZV7H4z/1eAjLzm22cQ6aVxbwz0GGX0R6CTcUCR48fp/88EUhpAXzcZ
   3ExfKJcKwLbYh9Bu/Er6N+MgFrJDJ/FPG1cjO26+su4QNF5DUDq5uYKfG
   hxGW4BQvx8Hu/U29lMQz8RlQsZGNQJyI6jR+zSpUD1iGmNeGPivSdE40e
   Kiy8h5/1eMiMW2xKkR9yEhomKt3ZhrsgkHo0N1q4BYMKyYAE77jzBsVan
   uS9tbTAA5TvCpxlWnH1glio0J8UowKyaTisiI3nFkf0NJaAwgmnMW1AWb
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673938800"; 
   d="scan'208";a="216646072"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 09:20:41 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 09:20:40 -0700
Received: from [10.171.246.59] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 16 Mar 2023 09:20:37 -0700
Message-ID: <56836a10-570e-a6da-0456-20dd58fa4b28@microchip.com>
Date:   Thu, 16 Mar 2023 17:20:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next] net: macb: Reset TX when TX halt times out
Content-Language: en-US
To:     Harini Katakam <harini.katakam@amd.com>
CC:     <davem@davemloft.net>, <claudiu.beznea@microchip.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>
References: <20230316083554.2432-1-harini.katakam@amd.com>
 <ZBL1X1U3BJEAEIrX@localhost.localdomain>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <ZBL1X1U3BJEAEIrX@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 at 11:54, Michal Swiatkowski wrote:
> On Thu, Mar 16, 2023 at 02:05:54PM +0530, Harini Katakam wrote:
>> From: Harini Katakam <harini.katakam@xilinx.com>
>>
>> Reset TX when halt times out i.e. disable TX, clean up TX BDs,
>> interrupts (already done) and enable TX.
>> This addresses the issue observed when iperf is run at 10Mps Half
>> duplex where, after multiple collisions and retries, TX halts.
>>
>> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_main.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 96fd2aa9ee90..473c2d0174ad 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -1021,6 +1021,7 @@ static void macb_tx_error_task(struct work_struct *work)
>>        struct sk_buff          *skb;
>>        unsigned int            tail;
>>        unsigned long           flags;
>> +     bool                    halt_timeout = false;
> RCT

Yes, might not pass the netdev checks.

> Otherwise looks fine
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Likewise, this fixed:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Best regards,
   Nicolas

> 
> [...]
> 
>> --
>> 2.17.1
>>

-- 
Nicolas Ferre

