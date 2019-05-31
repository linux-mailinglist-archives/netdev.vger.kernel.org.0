Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB30F30C13
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfEaJyX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 31 May 2019 05:54:23 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:32975 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726415AbfEaJyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:54:23 -0400
Received: from LHREML711-CAH.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 7A9EE46C39B85A88990B;
        Fri, 31 May 2019 10:54:21 +0100 (IST)
Received: from lhreml707-chm.china.huawei.com (10.201.108.56) by
 LHREML711-CAH.china.huawei.com (10.201.108.34) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 31 May 2019 10:54:17 +0100
Received: from lhreml702-chm.china.huawei.com (10.201.108.51) by
 lhreml707-chm.china.huawei.com (10.201.108.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 31 May 2019 10:54:17 +0100
Received: from lhreml702-chm.china.huawei.com ([10.201.68.197]) by
 lhreml702-chm.china.huawei.com ([10.201.68.197]) with mapi id 15.01.1713.004;
 Fri, 31 May 2019 10:54:17 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     linyunsheng <linyunsheng@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [PATCH v2 net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
Thread-Topic: [PATCH v2 net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
Thread-Index: AQHVF4+KnJVjg+EZ+0GafWQlfrL2fqaE8XtA
Date:   Fri, 31 May 2019 09:54:17 +0000
Message-ID: <0500aaf60c464528b6bae010c7f9994d@huawei.com>
References: <1559293233-43017-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1559293233-43017-1-git-send-email-linyunsheng@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.226.43]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org On Behalf Of Yunsheng Lin
> Sent: Friday, May 31, 2019 10:01 AM
> To: davem@davemloft.net
> Cc: hkallweit1@gmail.com; f.fainelli@gmail.com;
> stephen@networkplumber.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Linuxarm <linuxarm@huawei.com>
> Subject: [PATCH v2 net-next] net: link_watch: prevent starvation when
> processing linkwatch wq
> 
> When user has configured a large number of virtual netdev, such
> as 4K vlans, the carrier on/off operation of the real netdev
> will also cause it's virtual netdev's link state to be processed
> in linkwatch. Currently, the processing is done in a work queue,
> which may cause cpu and rtnl locking starvation problem.
> 
> This patch releases the cpu and rtnl lock when link watch worker
> has processed a fixed number of netdev' link watch event.
> 
> Currently __linkwatch_run_queue is called with rtnl lock, so
> enfore it with ASSERT_RTNL();


Typo enfore --> enforce ?



> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V2: use cond_resched and rtnl_unlock after processing a fixed
>     number of events
> ---
>  net/core/link_watch.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
> index 7f51efb..07eebfb 100644
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -168,9 +168,18 @@ static void linkwatch_do_dev(struct net_device
> *dev)
> 
>  static void __linkwatch_run_queue(int urgent_only)
>  {
> +#define MAX_DO_DEV_PER_LOOP	100
> +
> +	int do_dev = MAX_DO_DEV_PER_LOOP;
>  	struct net_device *dev;
>  	LIST_HEAD(wrk);
> 
> +	ASSERT_RTNL();
> +
> +	/* Give urgent case more budget */
> +	if (urgent_only)
> +		do_dev += MAX_DO_DEV_PER_LOOP;
> +
>  	/*
>  	 * Limit the number of linkwatch events to one
>  	 * per second so that a runaway driver does not
> @@ -200,6 +209,14 @@ static void __linkwatch_run_queue(int urgent_only)
>  		}
>  		spin_unlock_irq(&lweventlist_lock);
>  		linkwatch_do_dev(dev);
> +


A comment like below would be helpful in explaining the reason of the code.
 
/* This function is called with rtnl_lock held. If excessive events
 * are present as part of the watch list, their processing could
 * monopolize the rtnl_lock and which could lead to starvation in
 * other modules which want to acquire this lock. Hence, co-operative
 * scheme like below might be helpful in mitigating the problem.
 * This also tries to be fair CPU wise by conditional rescheduling.
 */


> +		if (--do_dev < 0) {
> +			rtnl_unlock();
> +			cond_resched();
> +			do_dev = MAX_DO_DEV_PER_LOOP;
> +			rtnl_lock();
> +		}
> +
>  		spin_lock_irq(&lweventlist_lock);
>  	}
