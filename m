Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455714A32F7
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 02:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353614AbiA3A66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 19:58:58 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17831 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiA3A66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 19:58:58 -0500
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JmXq118Khz9sPH;
        Sun, 30 Jan 2022 08:57:33 +0800 (CST)
Received: from [10.174.178.165] (10.174.178.165) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sun, 30 Jan 2022 08:58:55 +0800
Subject: Re: [PATCH net-next] net/fsl: xgmac_mdio: fix return value check in
 xgmac_mdio_probe()
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
References: <20220129012702.3220704-1-weiyongjun1@huawei.com>
 <87czkabjgo.fsf@waldekranz.com>
From:   "weiyongjun (A)" <weiyongjun1@huawei.com>
Message-ID: <2855194d-9680-c78f-ad87-a2b789cc0363@huawei.com>
Date:   Sun, 30 Jan 2022 08:58:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87czkabjgo.fsf@waldekranz.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.165]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Sat, Jan 29, 2022 at 01:27, Wei Yongjun <weiyongjun1@huawei.com> wrote:
>> In case of error, the function devm_ioremap() returns NULL pointer
>> not ERR_PTR(). The IS_ERR() test in the return value check should
>> be replaced with NULL test.
>>
>> Fixes: 1d14eb15dc2c ("net/fsl: xgmac_mdio: Use managed device resources")
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
>
> Sorry about that. I started out by using devm_ioremap_resource, which
> uses the in-band error signaling, and forgot to match the guard when I
> changed it.
>
> I see that this was reported by your CI, do you mind me asking what it
> is running in the back-end? At least my version of sparse does not seem
> to catch this.


It was reported by coccinelle with follow script:


@@
expression ret, E;
@@
ret = \(devm_ioport_map\|
devm_ioremap\|
devm_ioremap_wc\|
devm_irq_alloc_generic_chip\|
devm_kasprintf\|
devm_kcalloc\|
devm_kmalloc\|
devm_kmalloc_array\|
devm_kmemdup\|
devm_kstrdup\|
devm_kzalloc\|
\)(...);
... when != ret = E
(
- IS_ERR(ret)
+ !ret
|
- !IS_ERR(ret)
+ ret
|
- PTR_ERR(ret)
+ -ENOMEM
)



It seems smatch also can report this.


Regards,

Wei Yongjun


