Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9552B287BC8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgJHSen convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Oct 2020 14:34:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44790 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729162AbgJHSen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 14:34:43 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 098IUuXM000891
        for <netdev@vger.kernel.org>; Thu, 8 Oct 2020 11:34:43 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 341wvrb66q-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 11:34:42 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 11:34:38 -0700
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id 196F624751BE; Thu,  8 Oct 2020 11:34:36 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>
Subject: [PATCH net-next] virtio_net: handle non-napi callers to virtnet_poll_tx
Date:   Thu, 8 Oct 2020 11:34:36 -0700
Message-ID: <20201008183436.3093286-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-08_12:2020-10-08,2020-10-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1034
 mlxscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=701 suspectscore=2 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

netcons will call napi_poll with a budget of 0, indicating
a non-napi caller (and also called with irqs disabled).  Call
free_old_xmit_skbs() with the is_napi parameter set correctly.

Found by this splat:

WARNING: CPU: 2 PID: 1368 at net/core/skbuff.c:650 skb_release_head_state+0x7f/0x90
RIP: 0010:skb_release_head_state+0x7f/0x90
Code: e7 7f 08 00 80 7b 7f 00 74 f3 48 8b bb d8 00 00 00 5b e9 d4 f2 ff ff 48 83 e7 fe e8 bb f5 01 00

RSP: 0000:ffffc900000e4d18 EFLAGS: 00010006
RAX: ffffffff818fc470 RBX: ffff888235a36d00 RCX: ffff88822df23000
RDX: 0000000000010000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff888235a36d00 R08: 0000000000000002 R09: 00000000ffffdd86
R10: 00000000ffffdd86 R11: 0000000000000000 R12: ffff8882367b4800
R13: 0000000000000001 R14: ffff8882367b4ac8 R15: ffff8882367b4ab8
FS:  00007fdc30f8a700(0000) GS:ffff888237d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdc300ea000 CR3: 000000022992f001 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 skb_release_all+0xe/0x30
 napi_consume_skb+0x4c/0x110
 free_old_xmit_skbs+0x3e/0xa0 [virtio_net]
 virtnet_poll_tx+0x7e/0xe0 [virtio_net]
 netpoll_poll_dev+0xba/0x190
 netpoll_send_skb_on_dev+0x1e7/0x240
 netpoll_send_udp+0x2b3/0x3d0
 write_ext_msg+0x1be/0x1d0
 console_unlock+0x227/0x4b0
 vprintk_emit+0xe5/0x1b0
 printk+0x58/0x6f
 smp_apic_timer_interrupt+0x5e/0x120
 apic_timer_interrupt+0xf/0x20
 </IRQ>

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..59f65ac9e4c7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1518,7 +1518,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
 
 	txq = netdev_get_tx_queue(vi->dev, index);
 	__netif_tx_lock(txq, raw_smp_processor_id());
-	free_old_xmit_skbs(sq, true);
+	free_old_xmit_skbs(sq, budget != 0);
 	__netif_tx_unlock(txq);
 
 	virtqueue_napi_complete(napi, sq->vq, 0);
-- 
2.24.1

