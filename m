Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1526EC1E2
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjDWTbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjDWTb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:26 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37358E68;
        Sun, 23 Apr 2023 12:31:23 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 2E8365FD0C;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278279;
        bh=XExB9Kow9SS0d9XJh7TqIuND1hr0gu/engpR4A64Lyc=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=X/bZIwe55jdH2NExosg3J+Iw19MR3DHcCjmw8Ea0ezbbSGk3vvZNJQiAHa5iouzCH
         qK5dAjXFLqfOK1VWkggxaFPc74VJktlv52Sec955qL7FN5f9w61RVNKzmGxO3QtI/T
         MmJ9b/7kyZv+9Cmol3FLkMSohtakkdXyEaHa033WJwK0pKMthZBbPj/3eWL442Ww10
         KEl2bLvVwKQRalZix6K1HuCwhBek+fyCAGr0XvGatGNDMI6QqM6HXkpkFNlhcvGw9L
         hfQ7DZyQeIEF/Otf8fJAXABkKAhwW2nopclEq03uNA973L95EtQ0HPE7BU1pzEEr6N
         29fsQVpCHpSFw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 02/15] vhost/vsock: non-linear skb handling support
Date:   Sun, 23 Apr 2023 22:26:30 +0300
Message-ID: <20230423192643.1537470-3-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds copying to guest's virtio buffers from non-linear skbs. Such
skbs are created by protocol layer when MSG_ZEROCOPY flags is used.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 drivers/vhost/vsock.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6578db78f0ae..1e70aa390e44 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -197,11 +197,20 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
-		if (nbytes != payload_len) {
-			kfree_skb(skb);
-			vq_err(vq, "Faulted on copying pkt buf\n");
-			break;
+		if (skb_is_nonlinear(skb)) {
+			if (virtio_transport_nl_skb_to_iov(skb, &iov_iter,
+							   payload_len,
+							   false)) {
+				vq_err(vq, "Faulted on copying pkt buf from page\n");
+				break;
+			}
+		} else {
+			nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
+			if (nbytes != payload_len) {
+				kfree_skb(skb);
+				vq_err(vq, "Faulted on copying pkt buf\n");
+				break;
+			}
 		}
 
 		/* Deliver to monitoring devices all packets that we
@@ -212,7 +221,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
 		added = true;
 
-		skb_pull(skb, payload_len);
+		if (!skb_is_nonlinear(skb))
+			skb_pull(skb, payload_len);
+
 		total_len += payload_len;
 
 		/* If we didn't send all the payload we can requeue the packet
-- 
2.25.1

