Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE335863AD
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiHAE5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiHAE5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:57:53 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58C5B484
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:57:52 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x64so7644407iof.1
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X++rLBXBV9e86kcnusmVtw++WnGBsm/M5XmpU+vjj6A=;
        b=nxQs8ug4B2Gf/jav02kw2SMOGlVFpxJ5TOCqpL4/tDCtXs8S/yRzffG517bc0/lOiX
         EvpL5Td5mc5dQnYeYbR/qNN8jLoWciGosz4zBRquVgd0326IQ4RelPrkF+4ZmA2AqqWX
         j97cZwUMTTlv+3kYYKf88qnv9gyYGb5d0i9QrELu5JvC6KzGBr1wf+BgudNYdid+u0Ts
         nHWRvFVdVOq43UOOto4du9/mCU3VxUQYx26j4ujzVYT5B2CUatj3szJw2ag5a0vkn/35
         sLM/CRkPheiSajhaXlxScgLfDUmQxt5gTQLV2FOWZqwiybyiE50+gOzF2B9Q5mts42qJ
         V0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X++rLBXBV9e86kcnusmVtw++WnGBsm/M5XmpU+vjj6A=;
        b=fgwRUfmUT8xynzk5wt4+8CYB/Z8w0fq163Th0F38InN5J2pdIOYgqw78o+c5/lEyvM
         YhtBjBvs39Ug19gonyG9MzXFYhxxH6Z04gq+L8j1aqqfu4a8ywxROQ9F4HQeOczG7QO8
         W3DJskmAGagt57VjQ2GqNYCTu4RsvnXn3FjMfZJfHMTzOsFTQRfVi5gWaBEUM8KRWG/p
         ABDN6ifkqA+CmzrSEZKLA14xN4KdSnUS5UUECm/cCtoiLvfSn0rgZDc9WVvbu0mDxATC
         FijF7VIjgUWR5+s9D3BOkF0a7jK4ciw0oxx6AWt81U/yqdUjS3CErVvgjuUGMqSYZy4/
         Q/+w==
X-Gm-Message-State: ACgBeo1wxYl7ALF9hdOnONvfZkHxmB0/GAJQOT29ZEqb9cigAkbhoz3V
        ooAW9lkeruSynguk1JLAo9Q=
X-Google-Smtp-Source: AA6agR47JmEubT09F4mfqUaDJ+AUYhGcfmEtrJFDaaopeY74hoz1HjSlj8N4ytNdf53js1aC9nwDmg==
X-Received: by 2002:a02:b10c:0:b0:342:6c6a:eb4e with SMTP id r12-20020a02b10c000000b003426c6aeb4emr2818514jah.172.1659329872275;
        Sun, 31 Jul 2022 21:57:52 -0700 (PDT)
Received: from localhost (cpec09435e3ea83-cmc09435e3ea81.cpe.net.cable.rogers.com. [99.235.148.253])
        by smtp.gmail.com with UTF8SMTPSA id i1-20020a0566022c8100b0067b74df7960sm5220197iow.32.2022.07.31.21.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 21:57:52 -0700 (PDT)
From:   Cezar Bulinaru <cbulinaru@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemb@google.com, netdev@vger.kernel.org, cbulinaru@gmail.com
Subject: [PATCH v3 1/2] Fixes: 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
Date:   Mon,  1 Aug 2022 00:57:35 -0400
Message-Id: <20220801045736.20674-1-cbulinaru@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729190307.667b4be0@kernel.org>
References: <20220729190307.667b4be0@kernel.org>
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

Signed-off-by: Cezar Bulinaru <cbulinaru@gmail.com>

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c3d42062559d..557236d51d01 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -716,10 +716,20 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
+	rcu_read_lock();
+	tap = rcu_dereference(q->tap);
+	if (tap) {
+		skb->dev = tap->dev;
+	} else {
+		kfree_skb(skb);
+		goto post_send;
+	}
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
@@ -742,12 +750,9 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 		uarg->callback(NULL, uarg, false);
 	}
 
-	if (tap) {
-		skb->dev = tap->dev;
-		dev_queue_xmit(skb);
-	} else {
-		kfree_skb(skb);
-	}
+	dev_queue_xmit(skb);
+
+post_send:
 	rcu_read_unlock();
 
 	return total_len;
-- 
2.34.1

