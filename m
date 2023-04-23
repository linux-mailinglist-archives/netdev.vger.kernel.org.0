Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82456EC203
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDWTbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjDWTb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:29 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38EB10DB;
        Sun, 23 Apr 2023 12:31:27 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 3154C5FD14;
        Sun, 23 Apr 2023 22:31:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278283;
        bh=I6s5f+VVEU4mKHhe9+5VqHMuX1hjVKhfruoOIGVs/SQ=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=lg8IECuEd4AdXNXlmfSFk/lwSrSIW9NV7ikX3i5WjR0bXNc99qZGI22kPh7CmGrFa
         5v6VDUX9GHXHLqO1eCh1ZIo8OV/5fQU55STHIy0jdTEd98UXKDacNXuPbSpxNarrK3
         R1Si42FZjWRIg+bAOm77sTJmW0WMFzb4lHAy/dSCI3RL40irScDxddAdMroruV8ojK
         tjSqJ6XFiyI+sEO1AVrBzk5mJgJIBamF+dG8SNFNhb0lThzSknyiz0Xs2mlA8biGFA
         zaCdRBB8v1+IZhj7BMOqssJ0Taxvo1nK1xW2Xa0xRCe/ZivNvHq8tdcqAPOhExJtqy
         LPaXPel3vJebw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:23 +0300 (MSK)
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
Subject: [RFC PATCH v2 09/15] vhost/vsock: support MSG_ZEROCOPY for transport
Date:   Sun, 23 Apr 2023 22:26:37 +0300
Message-ID: <20230423192643.1537470-10-AVKrasnov@sberdevices.ru>
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

Add 'msgzerocopy_allow()' callback for vhost transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 drivers/vhost/vsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 1e70aa390e44..4a33940a6020 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -405,6 +405,11 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_msgzerocopy_allow(void)
+{
+	return true;
+}
+
 static bool vhost_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport vhost_transport = {
@@ -451,6 +456,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+		.msgzerocopy_allow        = vhost_transport_msgzerocopy_allow,
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
-- 
2.25.1

