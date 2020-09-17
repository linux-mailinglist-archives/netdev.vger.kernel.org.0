Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE1F26D1FB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 05:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIQD7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 23:59:43 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3542 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725886AbgIQD7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 23:59:40 -0400
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 23:59:37 EDT
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 1BFA9FB61D8C2F704366;
        Thu, 17 Sep 2020 11:44:12 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Thu, 17 Sep 2020 11:44:11 +0800
Subject: Re: [PATCH] hinic: fix potential resource leak
To:     Wei Li <liwei391@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <huawei.libin@huawei.com>, <guohanjun@huawei.com>
References: <20200917030307.47195-1-liwei391@huawei.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <dadc79e3-a923-7a4a-2d6f-3f33d614591e@huawei.com>
Date:   Thu, 17 Sep 2020 11:44:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200917030307.47195-1-liwei391@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/17 11:03, Wei Li wrote:
> +	err = irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
> +	if (err)
> +		goto err_irq;
> +
> +	return 0;
> +
> +err_irq:
> +	rx_del_napi(rxq);
> +	return err;
If irq_set_affinity_hint fails, irq should be freed as well.
