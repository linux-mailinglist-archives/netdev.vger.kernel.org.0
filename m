Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01C7262591
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgIIDDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgIIDDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:03:49 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8FAC061573;
        Tue,  8 Sep 2020 20:03:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d6so861379pfn.9;
        Tue, 08 Sep 2020 20:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L0ztXl6pthK1M0XWUvkN5wvzKplhba5Dp+ppl19NO1s=;
        b=REk0x+/y3ZBsJPmho9b86rt2NlB23JjPt1/nbNCkKd7app2duktWItsXUonVLccaN3
         2+edZ5kxWqWxryh2TDtiZAB9UZqFzijT3SS7613XNDEuR6VpmCBYZR2B66olTQzDi/Hs
         WPVYctKuvl2noG8pT83mD9XpikaVwYhqFpyd9KOjy1OGwFfRAK1ZPlVAwQ8NIQiWmRnR
         fearLbqEQUoaF6Y/pxqJGCs58H/KESVCtrVWYjibbFT57ihT8qoDbSaRfxuc4yybLY4C
         6SJlh9eZvNsKyKhUiQNpAEgdJ0V0mbvsPVGRezAXFk/DBzbhdbYlmDI8QITTdbjUDNxO
         mQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L0ztXl6pthK1M0XWUvkN5wvzKplhba5Dp+ppl19NO1s=;
        b=hp/+z4HT1ouiCM2Iuqnuj9p06C/K5vTN9BGfSZ8+SyDTlZl0GBKY6AypXj/dq4jODv
         17zKBjkRl3ReAd4nepfa7g357Wn3he+iEkisXBzl+/Snn695X7Uc/1YpSganu/qv47za
         ve8hFLi5hihcaJGeerBK1NBj3N6ElRhl/PqBZW3iC4XLNb+tqiuI6i7iBouz2DaGLPb3
         Ufo9rZ8pg8ahYAffYAE0ckDrBlvK9f0NElgzC0tOO+1A9rX99GBrmNpVaLDQHE/ZC45F
         t8BiVmhQk1BAEULflxubjy8SdhzbpGB9zrASxWjmUEENvqvr/8/PZI5lhqxlv1n3ToLJ
         Uvzg==
X-Gm-Message-State: AOAM532aJkinETqnkbBHVfKT7pdUhdnv2G7gw78HfLE4J95l/okBG1GM
        yLt63qYim3KsOWKBbTRsqrLyRS6Xccrmkw==
X-Google-Smtp-Source: ABdhPJzLpP3YCiQlMP+UUmh8sB9gCLNV+BZNuultJsgB46kHm/0r/T7D6gx666qO8Nyd+8WJcM61XQ==
X-Received: by 2002:aa7:9a42:: with SMTP id x2mr1709871pfj.5.1599620628554;
        Tue, 08 Sep 2020 20:03:48 -0700 (PDT)
Received: from localhost ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id i1sm768788pfk.21.2020.09.08.20.03.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 20:03:47 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net] mptcp: fix kmalloc flag in mptcp_pm_nl_get_local_id
Date:   Wed,  9 Sep 2020 11:01:24 +0800
Message-Id: <edf5e512a6932d9169f77d9cd5c89aa198b20d31.1599620248.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mptcp_pm_nl_get_local_id may be called in interrupt context, so we need to
use GFP_ATOMIC flag to allocate memory to avoid sleeping in atomic context.

[  280.209809] BUG: sleeping function called from invalid context at mm/slab.h:498
[  280.209812] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1680, name: kworker/1:3
[  280.209814] INFO: lockdep is turned off.
[  280.209816] CPU: 1 PID: 1680 Comm: kworker/1:3 Tainted: G        W         5.9.0-rc3-mptcp+ #146
[  280.209818] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  280.209820] Workqueue: events mptcp_worker
[  280.209822] Call Trace:
[  280.209824]  <IRQ>
[  280.209826]  dump_stack+0x77/0xa0
[  280.209829]  ___might_sleep.cold+0xa6/0xb6
[  280.209832]  kmem_cache_alloc_trace+0x1d1/0x290
[  280.209835]  mptcp_pm_nl_get_local_id+0x23c/0x410
[  280.209840]  subflow_init_req+0x1e9/0x2ea
[  280.209843]  ? inet_reqsk_alloc+0x1c/0x120
[  280.209845]  ? kmem_cache_alloc+0x264/0x290
[  280.209849]  tcp_conn_request+0x303/0xae0
[  280.209854]  ? printk+0x53/0x6a
[  280.209857]  ? tcp_rcv_state_process+0x28f/0x1374
[  280.209859]  tcp_rcv_state_process+0x28f/0x1374
[  280.209864]  ? tcp_v4_do_rcv+0xb3/0x1f0
[  280.209866]  tcp_v4_do_rcv+0xb3/0x1f0
[  280.209869]  tcp_v4_rcv+0xed6/0xfa0
[  280.209873]  ip_protocol_deliver_rcu+0x28/0x270
[  280.209875]  ip_local_deliver_finish+0x89/0x120
[  280.209877]  ip_local_deliver+0x180/0x220
[  280.209881]  ip_rcv+0x166/0x210
[  280.209885]  __netif_receive_skb_one_core+0x82/0x90
[  280.209888]  process_backlog+0xd6/0x230
[  280.209891]  net_rx_action+0x13a/0x410
[  280.209895]  __do_softirq+0xcf/0x468
[  280.209899]  asm_call_on_stack+0x12/0x20
[  280.209901]  </IRQ>
[  280.209903]  ? ip_finish_output2+0x240/0x9a0
[  280.209906]  do_softirq_own_stack+0x4d/0x60
[  280.209908]  do_softirq.part.0+0x2b/0x60
[  280.209911]  __local_bh_enable_ip+0x9a/0xa0
[  280.209913]  ip_finish_output2+0x264/0x9a0
[  280.209916]  ? rcu_read_lock_held+0x4d/0x60
[  280.209920]  ? ip_output+0x7a/0x250
[  280.209922]  ip_output+0x7a/0x250
[  280.209925]  ? __ip_finish_output+0x330/0x330
[  280.209928]  __ip_queue_xmit+0x1dc/0x5a0
[  280.209931]  __tcp_transmit_skb+0xa0f/0xc70
[  280.209937]  tcp_connect+0xb03/0xff0
[  280.209939]  ? lockdep_hardirqs_on_prepare+0xe7/0x190
[  280.209942]  ? ktime_get_with_offset+0x125/0x150
[  280.209944]  ? trace_hardirqs_on+0x1c/0xe0
[  280.209948]  tcp_v4_connect+0x449/0x550
[  280.209953]  __inet_stream_connect+0xbb/0x320
[  280.209955]  ? mark_held_locks+0x49/0x70
[  280.209958]  ? lockdep_hardirqs_on_prepare+0xe7/0x190
[  280.209960]  ? __local_bh_enable_ip+0x6b/0xa0
[  280.209963]  inet_stream_connect+0x32/0x50
[  280.209966]  __mptcp_subflow_connect+0x1fd/0x242
[  280.209972]  mptcp_pm_create_subflow_or_signal_addr+0x2db/0x600
[  280.209975]  mptcp_worker+0x543/0x7a0
[  280.209980]  process_one_work+0x26d/0x5b0
[  280.209984]  ? process_one_work+0x5b0/0x5b0
[  280.209987]  worker_thread+0x48/0x3d0
[  280.209990]  ? process_one_work+0x5b0/0x5b0
[  280.209993]  kthread+0x117/0x150
[  280.209996]  ? kthread_park+0x80/0x80
[  280.209998]  ret_from_fork+0x22/0x30

Fixes: 01cacb00b35cb ("mptcp: add netlink-based PM")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index bd88e9c0bf71..1f6d029ccf40 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -354,7 +354,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 		return ret;
 
 	/* address not found, add to local list */
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
 	if (!entry)
 		return -ENOMEM;
 
-- 
2.17.1

