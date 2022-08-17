Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AF6597092
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbiHQN6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239788AbiHQN62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:58:28 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE332240BB;
        Wed, 17 Aug 2022 06:58:19 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 7CE131008B38F;
        Wed, 17 Aug 2022 21:58:17 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id D36002009BEAD;
        Wed, 17 Aug 2022 21:58:10 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BeLQLT-bhQHC; Wed, 17 Aug 2022 21:58:10 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 36ED6200BFDA8;
        Wed, 17 Aug 2022 21:57:56 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 3/7] vsock: batch buffers in tx
Date:   Wed, 17 Aug 2022 21:57:14 +0800
Message-Id: <20220817135718.2553-4-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vsock uses buffers in order, and for tx driver doesn't have to
know the length of the buffer. So we can do a batch for vsock if
in order negotiated, only write one used ring for a batch of buffers

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/vsock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 368330417bde..b0108009c39a 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -500,6 +500,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	int head, pkts = 0, total_len = 0;
 	unsigned int out, in;
 	bool added = false;
+	int last_head = -1;
 
 	mutex_lock(&vq->mutex);
 
@@ -551,10 +552,16 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 		else
 			virtio_transport_free_pkt(pkt);
 
-		vhost_add_used(vq, head, 0);
+		if (!vhost_has_feature(vq, VIRTIO_F_IN_ORDER))
+			vhost_add_used(vq, head, 0);
+		else
+			last_head = head;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
 
+	/* If in order feature negotiaged, we can do a batch to increase performance */
+	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER) && last_head != -1)
+		vhost_add_used(vq, last_head, 0);
 no_more_replies:
 	if (added)
 		vhost_signal(&vsock->dev, vq);
-- 
2.17.1

