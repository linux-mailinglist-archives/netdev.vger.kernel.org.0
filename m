Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFB94F7E0C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 13:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244787AbiDGL26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 07:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244790AbiDGL2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 07:28:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5027535DCB;
        Thu,  7 Apr 2022 04:26:42 -0700 (PDT)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KYzYz0b59zgYLs;
        Thu,  7 Apr 2022 19:24:55 +0800 (CST)
Received: from dggpeml500001.china.huawei.com (7.185.36.227) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 19:26:39 +0800
Received: from huawei.com (10.175.101.6) by dggpeml500001.china.huawei.com
 (7.185.36.227) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 7 Apr
 2022 19:26:39 +0800
From:   kongweibin <kongweibin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <willemb@google.com>,
        <asml.silence@gmail.com>, <dsahern@kernel.org>,
        <vvs@virtuozzo.com>, <edumazet@google.com>, <kafai@fb.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rose.chen@huawei.com>, <liaichun@huawei.com>,
        <kongweibin2@huawei.com>
Subject: [PATCH] ipv6:fix crash when idev is NULL
Date:   Thu, 7 Apr 2022 19:25:12 +0800
Message-ID: <20220407112512.2099221-1-kongweibin2@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500001.china.huawei.com (7.185.36.227)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the remote device uses tc command to construct exception packages,
and send it to the local device, which acts as a forwarding device, it
will crash.

the tc cmd such as:
tc qdisc del dev vxlan100 root
tc qdisc add dev vxlan100 root netem corrupt 5%

When using dev_get_by_index_rcu to get net_device struct, once the 
package is abnormal, the corresponding net_device can't be found 
according with error device index, then return a null value, which 
value will be directly used in the policy check below, resulting in 
system crash.

Anyway, we can't directly use the idev variable. We need to ensure 
that it is a valid value.

kernel version is base on kernel-5.10.0, and the stack information 
of the crash is as follows:

[ 4484.161259] IPVS: __ip_vs_del_service: enter
[ 4484.162263] IPVS: __ip_vs_del_service: enter
[ 4686.564468] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000240
[ 4686.565109] Mem abort info:
[ 4686.565328]   ESR = 0x96000004
[ 4686.565564]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 4686.565948]   SET = 0, FnV = 0
[ 4686.566184]   EA = 0, S1PTW = 0
[ 4686.566427] Data abort info:
[ 4686.566651]   ISV = 0, ISS = 0x00000004
[ 4686.567024]   CM = 0, WnR = 0
[ 4686.567261] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000102daa000
[ 4686.567708] [0000000000000240] pgd=0000000000000000, p4d=0000000000000000
[ 4686.568182] Internal error: Oops: 96000004 [#1] SMP
[ 4686.568530] CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G        W  O      5.10.0-xxxxxx.aarch64 #1
[ 4686.569316] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[ 4686.569787] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=--)
[ 4686.570214] pc : ip6_forward+0xb4/0x744
[ 4686.570499] lr : ip6_forward+0x5c/0x744
[ 4686.570782] sp : ffff80008800ba00
[ 4686.571098] x29: ffff80008800ba00 x28: ffff0000c02e39c0
[ 4686.571560] x27: ffff0000f6e97000 x26: ffff800089cfa500
[ 4686.572021] x25: ffff80008800bc98 x24: ffff80008800bc08
[ 4686.572487] x23: ffff800089cfa500 x22: ffff0000cbfd6c94
[ 4686.572953] x21: 0000000000000000 x20: ffff80008800bb38
[ 4686.573416] x19: ffff0000c995fc00 x18: 0000000000000000
[ 4686.573882] x17: 0000000000000000 x16: ffff8000881b65c0
[ 4686.574350] x15: 0000000000000000 x14: 0000000000000000
[ 4686.574816] x13: 0000000065f01475 x12: 0000000002cc68fd
[ 4686.575298] x11: 00000000d44127a3 x10: b181f30000000000
[ 4686.575760] x9 : ffff800088d5d9cc x8 : ffff0000c02e39c0
[ 4686.576224] x7 : 0000000000000000 x6 : 0000000000000000
[ 4686.576686] x5 : ffff0000c995fc00 x4 : ffff80008800bb38
[ 4686.577148] x3 : 0000000000000000 x2 : ffff0000cbfd6ec0
[ 4686.577609] x1 : 0000000000000000 x0 : 0000000000000000
[ 4686.578079] Call trace:
[ 4686.578323]  ip6_forward+0xb4/0x744
[ 4686.578646]  ip6_sublist_rcv_finish+0x6c/0x90
[ 4686.579051]  ip6_list_rcv_finish.constprop.0+0x198/0x260
[ 4686.579512]  ip6_sublist_rcv+0x40/0xb0
[ 4686.579852]  ipv6_list_rcv+0x144/0x180
[ 4686.580197]  __netif_receive_skb_list_core+0x154/0x28c
[ 4686.580643]  __netif_receive_skb_list+0x120/0x1a0
[ 4686.581057]  netif_receive_skb_list_internal+0xe4/0x1f0
[ 4686.581508]  napi_complete_done+0x70/0x1f0
[ 4686.581883]  virtnet_poll+0x214/0x2b0 [virtio_net]
[ 4686.582309]  napi_poll+0xcc/0x264
[ 4686.582617]  net_rx_action+0xd4/0x21c
[ 4686.582969]  __do_softirq+0x130/0x358
[ 4686.583308]  irq_exit+0x12c/0x150
[ 4686.583621]  __handle_domain_irq+0x88/0xf0
[ 4686.583991]  gic_handle_irq+0x78/0x2c0
[ 4686.584332]  el1_irq+0xc8/0x180
[ 4686.584628]  arch_cpu_idle+0x18/0x40
[ 4686.584960]  default_idle_call+0x5c/0x1c0
[ 4686.585323]  cpuidle_idle_call+0x174/0x1b0
[ 4686.585690]  do_idle+0xc8/0x160
[ 4686.585989]  cpu_startup_entry+0x30/0x10c
[ 4686.586351]  secondary_start_kernel+0x158/0x1e4
[ 4686.586754] Code: b9401842 34002ce2 b940d021 35000281 (b94242a1)
[ 4686.587301] kernel fault(0x1) notification starting on CPU 1
[ 4686.587787] kernel fault(0x1) notification finished on CPU 1

Signed-off-by: kongweibin <kongweibin2@huawei.com>
---
 net/ipv6/ip6_output.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 54cabf1c2..347b5600d 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -495,6 +495,9 @@ int ip6_forward(struct sk_buff *skb)
 	u32 mtu;
 
 	idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
+	if (!idev)
+		goto drop;
+
 	if (net->ipv6.devconf_all->forwarding == 0)
 		goto error;
 
-- 
2.23.0

