Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AD3674CD5
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjATFxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjATFxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:53:19 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698F911EAE;
        Thu, 19 Jan 2023 21:53:04 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30K5qMVQ001826;
        Thu, 19 Jan 2023 23:52:22 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674193942;
        bh=rEw45pOXG60oW+WFnG7mWdj5lksF2ir9viEC3I0BjiM=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=kQs84Gu5CWKbiupzUqbYkIFLMUOI5h0nQR7XjEopGRqFPm8QIpXS50avGTu666G+k
         YxzdbjDfXkYfPua3CkW8gvtBOvS8zZJ5oHLC02bS5bRR9sSfiNLtQF2sfZURnbnKIp
         0BL2Z6wNFlyCBHgkZIG8d4trtjUBy7hE82jWiUOQ=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30K5qMw6007004
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Jan 2023 23:52:22 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Thu, 19
 Jan 2023 23:52:22 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Thu, 19 Jan 2023 23:52:22 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30K5qH8k028760;
        Thu, 19 Jan 2023 23:52:18 -0600
Message-ID: <a41c4af3-f054-bbe4-cdff-7651fecaca62@ti.com>
Date:   Fri, 20 Jan 2023 11:22:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <pabeni@redhat.com>, <rogerq@kernel.org>,
        <leon@kernel.org>, <leonro@nvidia.com>,
        <anthony.l.nguyen@intel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <vigneshr@ti.com>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: Re: [PATCH net-next v4 2/2] net: ethernet: ti: am65-cpsw/cpts: Fix
 CPTS release action
To:     Jakub Kicinski <kuba@kernel.org>
References: <20230118095439.114222-3-s-vadapalli@ti.com>
 <20230120044201.357950-1-s-vadapalli@ti.com>
 <20230119214800.63b8c63a@kernel.org>
Content-Language: en-US
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20230119214800.63b8c63a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

On 20/01/23 11:18, Jakub Kicinski wrote:
> On Fri, 20 Jan 2023 10:12:01 +0530 Siddharth Vadapalli wrote:
>> Changes from v3:
>> 1. Rebase patch on net-next commit: cff9b79e9ad5
>> 2. Collect Reviewed-by tags from Leon Romanovsky, Tony Nguyen and
>>    Roger Quadros.
> 
> You need to repost the entire series, and please don't --in-reply-to,
> just CC the people who commented.

Sorry, I wasn't aware of this. Paolo asked me to re-spin, so I thought that I
had to use the "--in-reply-to" option. I will repost the series. Could you let
me know if v4 will be the right version for the series or should it be v5,
considering that the re-spin patch has v4 in subject.

Regards,
Siddharth.
