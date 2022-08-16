Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31DB5953FB
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiHPHiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiHPHhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:37:35 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA94D34AA7B;
        Mon, 15 Aug 2022 21:27:05 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27G4QM1c042958;
        Mon, 15 Aug 2022 23:26:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660623982;
        bh=gZ7HFoVulwf+zwLoj8jhox5+w34fA2KlOcryO4LM2ac=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=a0++RTTgY6BmCsetimSNTDRyvKyKUDR35v3b6zGGOmLdFVSpXCrS0Pj8FdIlL4n65
         cKm6N7+h/9hRecho/C/HjXXYgJb7ky8q2j99PryxReWoE+B42LPsbtiD3P+oXhyviP
         XlYD/4EXDIFc19eeW5Pf7IIcSjH7pmbjIU6ZfdYQ=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27G4QMeH097622
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 15 Aug 2022 23:26:22 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Mon, 15
 Aug 2022 23:26:21 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Mon, 15 Aug 2022 23:26:21 -0500
Received: from [10.24.69.79] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27G4QHld077320;
        Mon, 15 Aug 2022 23:26:18 -0500
Message-ID: <43c7ea8b-f0ca-7f06-02b7-acf677a6f21d@ti.com>
Date:   Tue, 16 Aug 2022 09:56:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net-next] net: ethernet: ti: davinci_mdio: Add
 workaround for errata i2329
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <vigneshr@ti.com>
References: <20220810111345.31200-1-r-gunasekaran@ti.com>
 <YvRNpAdG7/edUEc+@lunn.ch> <9d17ab9f-1679-4af1-f85c-a538cb330d7b@ti.com>
 <YvT8ovgHz2j7yOQP@lunn.ch> <ed3554bc-af62-78ce-a3eb-ff5f27ade6a2@ti.com>
 <YvZ3uc0xi18C1g5t@lunn.ch>
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <YvZ3uc0xi18C1g5t@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/08/22 9:24 pm, Andrew Lunn wrote:
>> sh_eth is not configured for autosuspend and uses only pm_runtime_put().
> 
> I don't know the runtime power management code very well. We should
> probably ask somebody how does. However:
> 
> https://elixir.bootlin.com/linux/latest/source/drivers/base/power/runtime.c#L168
> 
> This suggests it should be safe to perform an auto suspend on a device
> which is not configured for auto suspend. To me, it looks like is
> should directly suspend.

I checked the pm_runtime_put() and pm_runtime_put_autosuspend() and I 
have quite a few unanswered questions. I do not have much knowledge 
about the runtime PM, so I'm not confident about adding the runtime PM 
mdiobb_read/mdiobb_write variants in the mdio bitbang core. I would 
rather take a safe approach for now and stick with the implementation 
submitted in this v2 patch.

Thanks for your feedback on this submission so far. I will fix the two 
other comments and send out a v3 patch.

-- 
Regards,
Ravi
