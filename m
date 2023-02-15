Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E5769766E
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 07:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbjBOGae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 01:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjBOGab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 01:30:31 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C0F36088
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 22:29:59 -0800 (PST)
Received: from dggpemm500016.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PGp5X39f0znW5k;
        Wed, 15 Feb 2023 14:27:12 +0800 (CST)
Received: from [10.67.110.48] (10.67.110.48) by dggpemm500016.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 15 Feb
 2023 14:29:33 +0800
Message-ID: <2cf28c54-866d-cfd7-499a-e5bc04bd6d19@huawei.com>
Date:   Wed, 15 Feb 2023 14:29:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net] net: mpls: fix stale pointer if allocation fails
 during device rename
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        lianhui tang <bluetlh@gmail.com>, <kuniyu@amazon.co.jp>,
        <rshearma@brocade.com>
References: <20230214065355.358890-1-kuba@kernel.org>
 <d85f25cf-3c37-dff2-85fd-f8f3a5a57645@huawei.com>
 <20230214132331.526f4fb7@kernel.org>
Content-Language: en-US
From:   Gong Ruiqi <gongruiqi1@huawei.com>
In-Reply-To: <20230214132331.526f4fb7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.48]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/02/15 5:23, Jakub Kicinski wrote:
> On Tue, 14 Feb 2023 17:33:36 +0800 Gong Ruiqi wrote:
>> Just be curious: would this be a simpler solution?
>>
>> @@ -1439,6 +1439,7 @@ static void mpls_dev_sysctl_unregister(struct
>> net_device *dev,
>>
>>         table = mdev->sysctl->ctl_table_arg;
>>         unregister_net_sysctl_table(mdev->sysctl);
>> +       mdev->sysctl = NULL;
>>         kfree(table);
>>
>>         mpls_netconf_notify_devconf(net, RTM_DELNETCONF, 0, mdev);
>>
>> However I'm not sure if we need to preserve the old value of
>> mdev->sysctl after we unregister it.
> 
> It'd work too, I decided to limit the zeroing to the exception case
> because of recent discussions on the list. The argument there was that
> zeroing in cases were we don't expect it to be necessary may hide bugs.
> We generally try to avoid defensive programming in the kernel.

Actually my original thought was not to do defensive programming, but to
clearly mark it as invalid after its de-registration. Nevertheless "to
avoid defensive programming in the kernel" is a good point :)

And oops, for my proposal the complete solution should be:

@@ -1437,8 +1437,12 @@ static void mpls_dev_sysctl_unregister(struct
net_device *dev,
        struct net *net = dev_net(dev);
        struct ctl_table *table;

+       if (!mdev->sysctl)
+               return;
+
        table = mdev->sysctl->ctl_table_arg;
        unregister_net_sysctl_table(mdev->sysctl);
+       mdev->sysctl = NULL;
        kfree(table);

        mpls_netconf_notify_devconf(net, RTM_DELNETCONF, 0, mdev);

to avoid NULL dereference at `table = mdev->sysctl->...` if we try to
unregister the device after a failed renaming. Then it looks really
similar with your patch xD. So yeah I'm ok with both of them.
