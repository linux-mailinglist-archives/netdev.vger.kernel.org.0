Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83A0588756
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 08:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiHCG2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 02:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiHCG2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 02:28:11 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0E51F2D5
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 23:28:11 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id p10so2894313ile.5
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 23:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X6lHdphthhN/ZqGN/OVjWiiJZ2d0FceYRUwg0EoQl3Q=;
        b=Fd0c2K0RNaGEBYXiHSnUsG2vKVCNr6DL5CS4cJdDIohfawTx+I7feWj5HmoXGOFm2r
         xuvPQs8MeKc/nIWlsyoIPp7leWofmRoVM3n900nT0GHyrhlqEOwSy/7rgJVWLQ6sI6JY
         24sGN5KP+aa0KG9Q+yyuY/+/gF2IqvKlPDhuHR2SuAi6+pHVO7ukvE14Mi9j30cM90Hy
         iUc+RnvXtnYYNruVNYJ8Q+IoviPmW8QIV5/aeBwFAhy2vZmXVzVhQ9E10OkfTdlaoRN/
         kj7T9IQF3SLWl+nNRgGmxaL1WhuUOgsMG5QRUjCrxwEeg6V48eqG3snajeN7kSCIJ4lD
         3qIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X6lHdphthhN/ZqGN/OVjWiiJZ2d0FceYRUwg0EoQl3Q=;
        b=hyVfGfX7r7tmCL3k7dfpzBi4FVWGIwTIdGjCtWuHShv5ZM5vYoFkm/IQIO2NipDqY8
         hnLrI2EcnBj8nfqVCPv+4dnJulYvXZQ2ErP4PrM4z3OfETfeQ9buX2Alel/saXhRG7e3
         qeoQW/x5jHL/OhPLlKch0ayXPfu7sMvtXKG6n8Vga0meSTxCNu0FpAczEzv1VGBUJOuz
         5JZIXelW/6juP56Sejh7VAzfoJmZoPuEUgWXGmkuTZGhj8ItHMpH/EvTQNazxhu5nhK9
         N03QmstGaQKmWVhFPAlK0eeDeD+9p/xLiaB71mOEwPRwURY6NbZYH84BezLsUyu5Y+Gv
         K32Q==
X-Gm-Message-State: AJIora+ENslr4eNfqf36RVbvX+shcR8aT0E1A60bhcq3iaYLawXTy1jN
        H+nywpcSSWTfvUlyKHjYwJA=
X-Google-Smtp-Source: AGRyM1tJ4uJqUhHQFQb563fJJqRFXqrj1Uj4AZiip/j3rvvdJdkbAEEwiHDagN6sV3TFC6RpeueRDg==
X-Received: by 2002:a05:6e02:1c23:b0:2dc:e497:8b12 with SMTP id m3-20020a056e021c2300b002dce4978b12mr9863725ilh.151.1659508090482;
        Tue, 02 Aug 2022 23:28:10 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id s19-20020a92c5d3000000b002de71f0a132sm4133958ilt.59.2022.08.02.23.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 23:28:10 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemb@google.com, netdev@vger.kernel.org, cbulinaru@gmail.com
Subject: [PATCH v5 net] net: tap: NULL pointer derefence in dev_parse_header_protocol when skb->dev is null
Date:   Wed,  3 Aug 2022 02:27:59 -0400
Message-Id: <20220803062759.3967-1-cbulinaru@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes a NULL pointer derefence bug triggered from tap driver.
When tap_get_user calls virtio_net_hdr_to_skb the skb->dev is null
(in tap.c skb->dev is set after the call to virtio_net_hdr_to_skb)
virtio_net_hdr_to_skb calls dev_parse_header_protocol which
needs skb->dev field to be valid.

The line that trigers the bug is in dev_parse_header_protocol
(dev is at offset 0x10 from skb and is stored in RAX register)
  if (!dev->header_ops || !dev->header_ops->parse_protocol)
  22e1:   mov    0x10(%rbx),%rax
  22e5:	  mov    0x230(%rax),%rax

Setting skb->dev before the call in tap.c fixes the issue.

BUG: kernel NULL pointer dereference, address: 0000000000000230
RIP: 0010:virtio_net_hdr_to_skb.constprop.0+0x335/0x410 [tap]
Code: c0 0f 85 b7 fd ff ff eb d4 41 39 c6 77 cf 29 c6 48 89 df 44 01 f6 e8 7a 79 83 c1 48 85 c0 0f 85 d9 fd ff ff eb b7 48 8b 43 10 <48> 8b 80 30 02 00 00 48 85 c0 74 55 48 8b 40 28 48 85 c0 74 4c 48
RSP: 0018:ffffc90005c27c38 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888298f25300 RCX: 0000000000000010
RDX: 0000000000000005 RSI: ffffc90005c27cb6 RDI: ffff888298f25300
RBP: ffffc90005c27c80 R08: 00000000ffffffea R09: 00000000000007e8
R10: ffff88858ec77458 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000014 R14: ffffc90005c27e08 R15: ffffc90005c27cb6
FS:  0000000000000000(0000) GS:ffff88858ec40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000230 CR3: 0000000281408006 CR4: 00000000003706e0
Call Trace:
 tap_get_user+0x3f1/0x540 [tap]
 tap_sendmsg+0x56/0x362 [tap]
 ? get_tx_bufs+0xc2/0x1e0 [vhost_net]
 handle_tx_copy+0x114/0x670 [vhost_net]
 handle_tx+0xb0/0xe0 [vhost_net]
 handle_tx_kick+0x15/0x20 [vhost_net]
 vhost_worker+0x7b/0xc0 [vhost]
 ? vhost_vring_call_reset+0x40/0x40 [vhost]
 kthread+0xfa/0x120
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x1f/0x30

Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c3d42062559d..9e75ed3f08ce 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -716,10 +716,20 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (!tap) {
+		kfree_skb(skb);
+		rcu_read_unlock();
+		return total_len;
+	}
+	skb->dev = tap->dev;
+
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
 		if (err) {
+			rcu_read_unlock();
 			drop_reason = SKB_DROP_REASON_DEV_HDR;
 			goto err_kfree;
 		}
@@ -732,8 +742,6 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0)
 		skb_set_network_header(skb, depth);
 
-	rcu_read_lock();
-	tap = rcu_dereference(q->tap);
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
 		skb_zcopy_init(skb, msg_control);
@@ -742,14 +750,8 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		uarg->callback(NULL, uarg, false);
 	}
 
-	if (tap) {
-		skb->dev = tap->dev;
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	dev_queue_xmit(skb);
 	rcu_read_unlock();
-
 	return total_len;
 
 err_kfree:
-- 
2.37.1

