Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF54A6C7B20
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjCXJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjCXJVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:21:11 -0400
Received: from mail-m3169.qiye.163.com (mail-m3169.qiye.163.com [103.74.31.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFB923DB6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:20:46 -0700 (PDT)
Received: from localhost.localdomain (unknown [106.75.220.2])
        by mail-m3169.qiye.163.com (Hmail) with ESMTPA id 220C37A0293;
        Fri, 24 Mar 2023 17:20:38 +0800 (CST)
From:   Faicker Mo <faicker.mo@ucloud.cn>
To:     faicker.mo@ucloud.cn
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] net/net_failover: fix txq exceeding warning
Date:   Fri, 24 Mar 2023 17:19:54 +0800
Message-Id: <20230324091954.1890561-1-faicker.mo@ucloud.cn>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCGEsdVk9OTUlDGExKTUMfT1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUpLTVVMTlVJSUtVSVlXWRYaDxIVHRRZQVlPS0hVSkpLSE5IVUpLS1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MjY6Tzo*NzJKNBMBDk8ZKAsh
        EREKCjdVSlVKTUxCTU9CTUhDQkJJVTMWGhIXVR0aEhgQHglVFhQ7DhgXFA4fVRgVRVlXWRILWUFZ
        SktNVUxOVUlJS1VJWVdZCAFZQU9PSUw3Bg++
X-HM-Tid: 0a8712eb882c00a9kurm220c37a0293
X-HM-MType: 1
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The failover txq is inited as 16 queues.
when a packet is transmitted from the failover device firstly,
the failover device will select the queue which is returned from
the primary device if the primary device is UP and running.
If the primary device txq is bigger than the default 16,
it can lead to the following warning:
eth0 selects TX queue 18, but real number of TX queues is 16

The warning backtrace is:
[   32.146376] CPU: 18 PID: 9134 Comm: chronyd Tainted: G            E      6.2.8-1.el7.centos.x86_64 #1
[   32.147175] Hardware name: Red Hat KVM, BIOS 1.10.2-3.el7_4.1 04/01/2014
[   32.147730] Call Trace:
[   32.147971]  <TASK>
[   32.148183]  dump_stack_lvl+0x48/0x70
[   32.148514]  dump_stack+0x10/0x20
[   32.148820]  netdev_core_pick_tx+0xb1/0xe0
[   32.149180]  __dev_queue_xmit+0x529/0xcf0
[   32.149533]  ? __check_object_size.part.0+0x21c/0x2c0
[   32.149967]  ip_finish_output2+0x278/0x560
[   32.150327]  __ip_finish_output+0x1fe/0x2f0
[   32.150690]  ip_finish_output+0x2a/0xd0
[   32.151032]  ip_output+0x7a/0x110
[   32.151337]  ? __pfx_ip_finish_output+0x10/0x10
[   32.151733]  ip_local_out+0x5e/0x70
[   32.152054]  ip_send_skb+0x19/0x50
[   32.152366]  udp_send_skb.isra.0+0x163/0x3a0
[   32.152736]  udp_sendmsg+0xba8/0xec0
[   32.153060]  ? __folio_memcg_unlock+0x25/0x60
[   32.153445]  ? __pfx_ip_generic_getfrag+0x10/0x10
[   32.153854]  ? sock_has_perm+0x85/0xa0
[   32.154190]  inet_sendmsg+0x6d/0x80
[   32.154508]  ? inet_sendmsg+0x6d/0x80
[   32.154838]  sock_sendmsg+0x62/0x70
[   32.155152]  ____sys_sendmsg+0x134/0x290
[   32.155499]  ___sys_sendmsg+0x81/0xc0
[   32.155828]  ? _get_random_bytes.part.0+0x79/0x1a0
[   32.156240]  ? ip4_datagram_release_cb+0x5f/0x1e0
[   32.156649]  ? get_random_u16+0x69/0xf0
[   32.156989]  ? __fget_light+0xcf/0x110
[   32.157326]  __sys_sendmmsg+0xc4/0x210
[   32.157657]  ? __sys_connect+0xb7/0xe0
[   32.157995]  ? __audit_syscall_entry+0xce/0x140
[   32.158388]  ? syscall_trace_enter.isra.0+0x12c/0x1a0
[   32.158820]  __x64_sys_sendmmsg+0x24/0x30
[   32.159171]  do_syscall_64+0x38/0x90
[   32.159493]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

Fix that by reducing txq number as the non-existent primary-dev does.

Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>
---
 drivers/net/net_failover.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 7a28e082436e..d0c916a53d7c 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_device *dev,
 			txq = ops->ndo_select_queue(primary_dev, skb, sb_dev);
 		else
 			txq = netdev_pick_tx(primary_dev, skb, NULL);
-
-		qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
-
-		return txq;
+	} else {
+		txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
 	}
 
-	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
-
 	/* Save the original txq to restore before passing to the driver */
 	qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
 
-- 
2.39.1

