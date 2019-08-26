Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA1E9CCC8
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 11:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbfHZJrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 05:47:35 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729922AbfHZJrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 05:47:35 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id F0F0C5E24C9F767622E8;
        Mon, 26 Aug 2019 17:47:32 +0800 (CST)
Received: from szxyal004123181.china.huawei.com (10.65.65.77) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Mon, 26 Aug 2019 17:47:24 +0800
From:   Dongxu Liu <liudongxu3@huawei.com>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <liudongxu3@huawei.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: Adding parameter detection in __ethtool_get_link_ksettings.
Date:   Mon, 26 Aug 2019 17:47:05 +0800
Message-ID: <20190826094705.10544-1-liudongxu3@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
References: <aa0a372e-a169-7d78-0782-505cbdab8f90@gmail.com>
In-Reply-To: <aa0a372e-a169-7d78-0782-505cbdab8f90@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.65.77]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 8/26/19 9:23 AM, Dongxu Liu wrote:
> The __ethtool_get_link_ksettings symbol will be exported,
> and external users may use an illegal address.
> We should check the parameters before using them,
> otherwise the system will crash.
> 
> [ 8980.991134] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [ 8980.993049] IP: [<ffffffff8155aca7>] __ethtool_get_link_ksettings+0x27/0x140
> [ 8980.994285] PGD 0
> [ 8980.995013] Oops: 0000 [#1] SMP
> [ 8980.995896] Modules linked in: sch_ingress ...
> [ 8981.013220] CPU: 3 PID: 25174 Comm: kworker/3:3 Tainted: G           O   ----V-------   3.10.0-327.36.58.4.x86_64 #1
> [ 8981.017667] Workqueue: events linkwatch_event
> [ 8981.018652] task: ffff8800a8348000 ti: ffff8800b045c000 task.ti: ffff8800b045c000
> [ 8981.020418] RIP: 0010:[<ffffffff8155aca7>]  [<ffffffff8155aca7>] __ethtool_get_link_ksettings+0x27/0x140
> [ 8981.022383] RSP: 0018:ffff8800b045fc88  EFLAGS: 00010202
> [ 8981.023453] RAX: 0000000000000000 RBX: ffff8800b045fcac RCX: 0000000000000000
> [ 8981.024726] RDX: ffff8800b658f600 RSI: ffff8800b045fcac RDI: ffff8802296e0000
> [ 8981.026000] RBP: ffff8800b045fc98 R08: 0000000000000000 R09: 0000000000000001
> [ 8981.027273] R10: 00000000000073e0 R11: 0000082b0cc8adea R12: ffff8802296e0000
> [ 8981.028561] R13: ffff8800b566e8c0 R14: ffff8800b658f600 R15: ffff8800b566e000
> [ 8981.029841] FS:  0000000000000000(0000) GS:ffff88023ed80000(0000) knlGS:0000000000000000
> [ 8981.031715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 8981.032845] CR2: 0000000000000000 CR3: 00000000b39a9000 CR4: 00000000003407e0
> [ 8981.034137] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 8981.035427] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 8981.036702] Stack:
> [ 8981.037406]  ffff8800b658f600 0000000000009c40 ffff8800b045fce8 ffffffffa047a71d
> [ 8981.039238]  000000000000004d ffff8800b045fcc8 ffff8800b045fd28 ffffffff815cb198
> [ 8981.041070]  ffff8800b045fcd8 ffffffff810807e6 00000000e8212951 0000000000000001
> [ 8981.042910] Call Trace:
> [ 8981.043660]  [<ffffffffa047a71d>] bond_update_speed_duplex+0x3d/0x90 [bonding]
> [ 8981.045424]  [<ffffffff815cb198>] ? inetdev_event+0x38/0x530
> [ 8981.046554]  [<ffffffff810807e6>] ? put_online_cpus+0x56/0x80
> [ 8981.047688]  [<ffffffffa0480d67>] bond_netdev_event+0x137/0x360 [bonding]
> ...
> 
> Signed-off-by: Dongxu Liu <liudongxu3@huawei.com>
> ---
>  net/core/ethtool.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c index 
> 6288e69..9a50b64 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -545,6 +545,8 @@ int __ethtool_get_link_ksettings(struct net_device 
> *dev,  {
>  	ASSERT_RTNL();
>  
> +	if (!dev || !dev->ethtool_ops)
> +		return -EOPNOTSUPP;

> I do not believe dev can possibly be NULL at this point.

>  	if (!dev->ethtool_ops->get_link_ksettings)
>  		return -EOPNOTSUPP;
>  
> 

> I tried to find an appropriate Fixes: tag.

> It seems this particular bug was added either by

> Fixes: 9856909c2abb ("net: bonding: use __ethtool_get_ksettings")

> or generically in :

> Fixes: 3f1ac7a700d0 ("net: ethtool: add new ETHTOOL_xLINKSETTINGS API")

In fact, "dev->ethtool_ops" is a null pointer in my environment.
I didn't get the case where "dev" is a null pointer.
Maybe "if (!dev->ethtool_ops)" is more accurate for this bug.

I found this bug in version 3.10, the function name was __ethtool_get_settings.
After 3f1ac7a700d0 ("net: ethtool: add new ETHTOOL_xLINKSETTINGS API"),
This function evolved into __ethtool_get_link_ksettings.

