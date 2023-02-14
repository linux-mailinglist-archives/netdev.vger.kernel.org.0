Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBB695F4A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjBNJdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232378AbjBNJdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:33:43 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE8255A3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:33:38 -0800 (PST)
Received: from dggpemm500016.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PGGDP4cL4z16NbY;
        Tue, 14 Feb 2023 17:31:17 +0800 (CST)
Received: from [10.67.110.48] (10.67.110.48) by dggpemm500016.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Tue, 14 Feb
 2023 17:33:36 +0800
Message-ID: <d85f25cf-3c37-dff2-85fd-f8f3a5a57645@huawei.com>
Date:   Tue, 14 Feb 2023 17:33:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net] net: mpls: fix stale pointer if allocation fails
 during device rename
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, lianhui tang <bluetlh@gmail.com>,
        <kuniyu@amazon.co.jp>, <rshearma@brocade.com>
References: <20230214065355.358890-1-kuba@kernel.org>
From:   Gong Ruiqi <gongruiqi1@huawei.com>
In-Reply-To: <20230214065355.358890-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.48]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just be curious: would this be a simpler solution?

@@ -1439,6 +1439,7 @@ static void mpls_dev_sysctl_unregister(struct
net_device *dev,

        table = mdev->sysctl->ctl_table_arg;
        unregister_net_sysctl_table(mdev->sysctl);
+       mdev->sysctl = NULL;
        kfree(table);

        mpls_netconf_notify_devconf(net, RTM_DELNETCONF, 0, mdev);

However I'm not sure if we need to preserve the old value of
mdev->sysctl after we unregister it.


On 2023/02/14 14:53, Jakub Kicinski wrote:
> lianhui reports that when MPLS fails to register the sysctl table
> under new location (during device rename) the old pointers won't
> get overwritten and may be freed again (double free).
> 
> Handle this gracefully. The best option would be unregistering
> the MPLS from the device completely on failure, but unfortunately
> mpls_ifdown() can fail. So failing fully is also unreliable.
> 
> Another option is to register the new table first then only
> remove old one if the new one succeeds. That requires more
> code, changes order of notifications and two tables may be
> visible at the same time.
> 
> sysctl point is not used in the rest of the code - set to NULL
> on failures and skip unregister if already NULL.
> 
> Reported-by: lianhui tang <bluetlh@gmail.com>
> Fixes: 0fae3bf018d9 ("mpls: handle device renames for per-device sysctls")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: kuniyu@amazon.co.jp
> CC: gongruiqi1@huawei.com
> CC: rshearma@brocade.com
> ---
>  net/mpls/af_mpls.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
> index 35b5f806fdda..dc5165d3eec4 100644
> --- a/net/mpls/af_mpls.c
> +++ b/net/mpls/af_mpls.c
> @@ -1428,6 +1428,7 @@ static int mpls_dev_sysctl_register(struct net_device *dev,
>  free:
>  	kfree(table);
>  out:
> +	mdev->sysctl = NULL;
>  	return -ENOBUFS;
>  }
>  
> @@ -1437,6 +1438,9 @@ static void mpls_dev_sysctl_unregister(struct net_device *dev,
>  	struct net *net = dev_net(dev);
>  	struct ctl_table *table;
>  
> +	if (!mdev->sysctl)
> +		return;
> +
>  	table = mdev->sysctl->ctl_table_arg;
>  	unregister_net_sysctl_table(mdev->sysctl);
>  	kfree(table);
