Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE75590B47
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 06:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236796AbiHLEgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 00:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiHLEgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 00:36:32 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA7D90812;
        Thu, 11 Aug 2022 21:36:29 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 27C4a93T002653;
        Thu, 11 Aug 2022 23:36:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1660278969;
        bh=rxFKTwMGkyTFRaVUJXNHx4g7Bh4686ASvFuE6UEmTcY=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=TvwUIMpdzKDHFRiVmpGW8fcgGULYcyRpuzfucv1Jw46NXZigCWdcyissD4AbF7b8F
         G0QlJK8z6sQvymG322ggJvlqmGTycbAZSGMaf2ed1YTm5g4GYUx5IQ0ymI2CxQ/DXR
         3UK/5Xfn8lI7ATuyveDhUcjOMISvUTkoRgcTK8uk=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 27C4a9dh023830
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 11 Aug 2022 23:36:09 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Thu, 11
 Aug 2022 23:36:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Thu, 11 Aug 2022 23:36:09 -0500
Received: from [10.24.69.79] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 27C4a5R0003462;
        Thu, 11 Aug 2022 23:36:06 -0500
Message-ID: <ed3554bc-af62-78ce-a3eb-ff5f27ade6a2@ti.com>
Date:   Fri, 12 Aug 2022 10:06:05 +0530
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
 <YvT8ovgHz2j7yOQP@lunn.ch>
From:   Ravi Gunasekaran <r-gunasekaran@ti.com>
In-Reply-To: <YvT8ovgHz2j7yOQP@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> There is atleast one device sh_eth, which is not configured for autosuspend
>> but uses the bit bang core in sh_mdiobb_read() and invokes regular runtime
>> PM functions.
> 
> And that is the point of moving it into the core. It would of just
> worked for you.
> 
> If you don't feel comfortable with making this unconditional, please
> put runtime pm enabled version of mdiobb_read/mdiobb_write() in the
> core and swap sh_eth and any other drivers to using them.
> 

sh_eth is not configured for autosuspend and uses only pm_runtime_put().
davinci_mdio is configured for autosuspend and it must invoke 
pm_runtime_mark_last_busy() before calling pm_runtime_put_autosuspend().
So it looks like, there needs to be a runtime PM version of 
mdiobb_read/mdiobb_write() for each pm_runtime_put_*(). As of now, it's 
only sh_eth which is currently using runtime PM and davinci_mdio would 
be the next one. So at least in this case, two variants of 
mdiobb_read/mdiobb_write() could be added at the moment. By checking 
against the dev->power.use_autosuspend flag, it is possible to support 
both via a single version.

That being said, I'm quite inclined towards the existing implementation, 
where drivers can have wrappers written around 
mdiobb_read/mdiobb_write(). But I might be failing to see the broader 
picture. If having multiple runtime PM versions of 
mdiobb_read/mdiobb_write() benefits many other future drivers, then I 
will go ahead and add the variant(s) in the bitbang core.

Please provide your views on this. Your inputs on the next course of 
action would be helpful.

-- 
Regards,
Ravi
