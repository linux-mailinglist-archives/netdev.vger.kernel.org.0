Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0797C169C82
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 04:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgBXDHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 22:07:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbgBXDHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 22:07:18 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 287F8574C0289CFD71E5;
        Mon, 24 Feb 2020 11:07:15 +0800 (CST)
Received: from [127.0.0.1] (10.133.210.141) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Feb 2020
 11:06:49 +0800
Subject: Re: [PATCH 4.4-stable] slip: stop double free sl->dev in slip_open
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200222094649.10933-1-yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <4e89e339-e161-fd8e-85e0-e59cdcc9688f@huawei.com>
Date:   Mon, 24 Feb 2020 11:06:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200222094649.10933-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.210.141]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cc David and netdev mail list too.

On 2020/2/22 17:46, yangerkun wrote:
> After commit e4c157955483 ("slip: Fix use-after-free Read in slip_open"),
> we will double free sl->dev since sl_free_netdev will free sl->dev too.
> It's fine for mainline since sl_free_netdev in mainline won't free
> sl->dev.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>   drivers/net/slip/slip.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index ef6b25ec75a1..7fe9183fad0e 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -861,7 +861,6 @@ err_free_chan:
>   	tty->disc_data = NULL;
>   	clear_bit(SLF_INUSE, &sl->flags);
>   	sl_free_netdev(sl->dev);
> -	free_netdev(sl->dev);
>   
>   err_exit:
>   	rtnl_unlock();
> 

