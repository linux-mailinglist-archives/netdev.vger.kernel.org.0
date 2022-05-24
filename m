Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F236532193
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 05:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiEXD3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 23:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbiEXD26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 23:28:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C08F50E3A;
        Mon, 23 May 2022 20:28:57 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L6fmF5VKrzjX05;
        Tue, 24 May 2022 11:28:13 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 11:28:54 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH net-next] ipv6: Fix signed integer overflow in __ip6_append_data
Date:   Tue, 24 May 2022 11:46:29 +0800
Message-ID: <20220524034629.395939-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resurrect ubsan overflow checks and ubsan report this warning,
fix it by change len check from INT_MAX to IPV6_MAXPLEN.

UBSAN: signed-integer-overflow in net/ipv6/ip6_output.c:1489:19
2147479552 + 8567 cannot be represented in type 'int'
CPU: 0 PID: 253 Comm: err Not tainted 5.16.0+ #1
Hardware name: linux,dummy-virt (DT)
Call trace:
  dump_backtrace+0x214/0x230
  show_stack+0x30/0x78
  dump_stack_lvl+0xf8/0x118
  dump_stack+0x18/0x30
  ubsan_epilogue+0x18/0x60
  handle_overflow+0xd0/0xf0
  __ubsan_handle_add_overflow+0x34/0x44
  __ip6_append_data.isra.48+0x1598/0x1688
  ip6_append_data+0x128/0x260
  udpv6_sendmsg+0x680/0xdd0
  inet6_sendmsg+0x54/0x90
  sock_sendmsg+0x70/0x88
  ____sys_sendmsg+0xe8/0x368
  ___sys_sendmsg+0x98/0xe0
  __sys_sendmmsg+0xf4/0x3b8
  __arm64_sys_sendmmsg+0x34/0x48
  invoke_syscall+0x64/0x160
  el0_svc_common.constprop.4+0x124/0x300
  do_el0_svc+0x44/0xc8
  el0_svc+0x3c/0x1e8
  el0t_64_sync_handler+0x88/0xb0
  el0t_64_sync+0x16c/0x170

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7f0fa9bd9ffe..9cdb8c5f734c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1368,7 +1368,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	/* Rough check on arithmetic overflow,
 	   better check is made in ip6_append_data().
 	   */
-	if (len > INT_MAX - sizeof(struct udphdr))
+	if (len > IPV6_MAXPLEN)
 		return -EMSGSIZE;
 
 	getfrag  =  is_udplite ?  udplite_getfrag : ip_generic_getfrag;
-- 
2.25.1

