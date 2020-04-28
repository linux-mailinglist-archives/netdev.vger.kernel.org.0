Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4C1BB78F
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgD1HdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 03:33:11 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:36242 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD1HdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 03:33:10 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03S7U8Ck042611;
        Tue, 28 Apr 2020 02:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588059008;
        bh=aRvGfNxOocQ8CHT1/R2w9I5wrqH65Ibh4Z5yfLh+5fo=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=sdPdisrYo35cbCC/WjP5pc+Iya7tYXd6EAJ6pwK4rQvsMf8NFfNzCtCrFd1UoKerQ
         7XjjQaG3chiLCtZrWMxjUSmvfEs9JIW+qYG0iSdH0gntebYzJJNNbq7xLmqjuPQmwO
         KURELBctUn0jYRc9XH5oxnhDqFnB7e/lodAxuCpc=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03S7U8jH080162
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 28 Apr 2020 02:30:09 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 28
 Apr 2020 02:30:08 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 28 Apr 2020 02:30:08 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03S7U6nK105476;
        Tue, 28 Apr 2020 02:30:06 -0500
Subject: Re: [PATCH net-next] drivers: net: davinci_mdio: fix potential NULL
 dereference in davinci_mdio_probe()
To:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        David Lechner <david@lechnology.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
References: <6AADFAC011213A4C87B956458587ADB419A6B43E@dggeml532-mbs.china.huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <68b08143-971a-4607-098c-2cdca9a1b0ba@ti.com>
Date:   Tue, 28 Apr 2020 10:30:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <6AADFAC011213A4C87B956458587ADB419A6B43E@dggeml532-mbs.china.huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/04/2020 06:25, weiyongjun (A) wrote:
>>
>> On 4/27/20 4:40 AM, Wei Yongjun wrote:
>>> platform_get_resource() may fail and return NULL, so we should better
>>> check it's return value to avoid a NULL pointer dereference a bit
>>> later in the code.
>>>
>>> This is detected by Coccinelle semantic patch.
>>>
>>> @@
>>> expression pdev, res, n, t, e, e1, e2; @@
>>>
>>> res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t, n);
>>> + if (!res)
>>> +   return -EINVAL;
>>> ... when != res == NULL
>>> e = devm_ioremap(e1, res->start, e2);
>>>
>>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>>> ---
>>
>> Could we use devm_platform_ioremap_resource() instead?
> 
> We cannot use devm_platform_ioremap_resource() here, see
> Commit 03f66f067560 ("net: ethernet: ti: davinci_mdio: use devm_ioremap()")

Correct, could you add fixed tag as above commit actually introduced an issue:
devm_ioremap_resource() checks input parameters for null.
  
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
