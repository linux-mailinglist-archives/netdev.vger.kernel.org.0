Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D04D4C3AF1
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 02:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbiBYBcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 20:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiBYBcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 20:32:19 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5E857498;
        Thu, 24 Feb 2022 17:31:46 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K4XK32XrkzdfbP;
        Fri, 25 Feb 2022 09:30:31 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 09:31:39 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH bpf-next 0/4] bpf, sockmap: Fix memleaks and issues of mem charge/uncharge
Date:   Fri, 25 Feb 2022 09:49:25 +0800
Message-ID: <20220225014929.942444-1-wangyufen@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes memleaks and incorrect charge/uncharge memory, these
issues cause the following info:

WARNING: CPU: 0 PID: 9202 at net/core/stream.c:205 sk_stream_kill_queues+0xc8/0xe0
Call Trace:
 <IRQ>
 inet_csk_destroy_sock+0x55/0x110
 tcp_rcv_state_process+0xe5f/0xe90
 ? sk_filter_trim_cap+0x10d/0x230
 ? tcp_v4_do_rcv+0x161/0x250
 tcp_v4_do_rcv+0x161/0x250
 tcp_v4_rcv+0xc3a/0xce0
 ip_protocol_deliver_rcu+0x3d/0x230
 ip_local_deliver_finish+0x54/0x60
 ip_local_deliver+0xfd/0x110
 ? ip_protocol_deliver_rcu+0x230/0x230
 ip_rcv+0xd6/0x100
 ? ip_local_deliver+0x110/0x110
 __netif_receive_skb_one_core+0x85/0xa0
 process_backlog+0xa4/0x160
 __napi_poll+0x29/0x1b0
 net_rx_action+0x287/0x300
 __do_softirq+0xff/0x2fc
 do_softirq+0x79/0x90
 </IRQ>

WARNING: CPU: 0 PID: 531 at net/ipv4/af_inet.c:154 inet_sock_destruct+0x175/0x1b0
Call Trace:
 <TASK>
 __sk_destruct+0x24/0x1f0
 sk_psock_destroy+0x19b/0x1c0
 process_one_work+0x1b3/0x3c0
 ? process_one_work+0x3c0/0x3c0
 worker_thread+0x30/0x350
 ? process_one_work+0x3c0/0x3c0
 kthread+0xe6/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30
 </TASK>

Wang Yufen (4):
  bpf, sockmap: Fix memleak in sk_psock_queue_msg
  bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
  bpf, sockmap: Fix more uncharged while msg has more_data
  bpf, sockmap: Fix double uncharge the mem of sk_msg

 include/linux/skmsg.h | 13 ++++---------
 net/ipv4/tcp_bpf.c    | 13 +++++++++----
 2 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.25.1

