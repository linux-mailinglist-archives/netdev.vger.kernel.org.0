Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8EE66B7D5
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 08:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjAPHKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 02:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbjAPHKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 02:10:08 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC96BA268
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 23:10:06 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NwNQr6hrrz16MZc;
        Mon, 16 Jan 2023 15:08:20 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 16 Jan 2023 15:10:01 +0800
Message-ID: <aa0a996d-2a55-997d-579e-ad3de218be22@huawei.com>
Date:   Mon, 16 Jan 2023 15:10:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net/ethtool: fix general protection fault in
 ethnl_set_plca_cfg()
To:     <netdev@vger.kernel.org>, <piergiorgio.beruto@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <andrew@lunn.ch>, <syzkaller-bugs@googlegroups.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20230116065230.3438932-1-shaozhengchao@huawei.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20230116065230.3438932-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please igonre this patch. Issue has been solved in
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=28dbf774bc879c1841d58cb711aaea6198955b95.

On 2023/1/16 14:52, Zhengchao Shao wrote:
> As indicated by the ethnl_parse_header_dev_get() comment, return: 0 on
> success or negative error code. ethnl_parse_header_dev_get() is
> incorrectly used in ethnl_set_plca_cfg(). As a result, members in dev
> are still accessed when dev is not obtained, resulting in a general
> protection fault issue.
> 
> The stack information is as follows:
> general protection fault, probably for non-canonical address
> 0xdffffc0000000173: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000b98-0x0000000000000b9f]
> RIP: 0010:ethnl_set_plca_cfg+0x1be/0x7d0
> Call Trace:
> <TASK>
> genl_family_rcv_msg_doit.isra.0+0x1d3/0x2c0
> genl_rcv_msg+0x440/0x6e0
> netlink_rcv_skb+0x140/0x3c0
> genl_rcv+0x29/0x40
> netlink_unicast+0x4a7/0x740
> netlink_sendmsg+0x844/0xcf0
> sock_sendmsg+0xca/0x110
> ____sys_sendmsg+0x588/0x6a0
> ___sys_sendmsg+0xed/0x170
> __sys_sendmsg+0xc4/0x170
> do_syscall_64+0x35/0x80
> entry_SYSCALL_64_after_hwframe+0x46/0xb0
> </TASK>
> 
> Reported-by: syzbot+8cf35743af243e5f417e@syzkaller.appspotmail.com
> Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>   net/ethtool/plca.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
> index d9bb13ffc654..d030cfc64b1f 100644
> --- a/net/ethtool/plca.c
> +++ b/net/ethtool/plca.c
> @@ -151,7 +151,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
>   					 tb[ETHTOOL_A_PLCA_HEADER],
>   					 genl_info_net(info), info->extack,
>   					 true);
> -	if (!ret)
> +	if (ret)
>   		return ret;
>   
>   	dev = req_info.dev;
