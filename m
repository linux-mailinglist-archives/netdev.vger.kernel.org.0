Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD66459707B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiHQN6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239482AbiHQN6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:58:07 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB3D9675B;
        Wed, 17 Aug 2022 06:58:05 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 9F4331008B38F;
        Wed, 17 Aug 2022 21:57:59 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 8D49D2032D489;
        Wed, 17 Aug 2022 21:57:56 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SFMeObJ2TNmb; Wed, 17 Aug 2022 21:57:56 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id E48B92009BEAD;
        Wed, 17 Aug 2022 21:57:44 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 2/7] vhost_test: batch used buffer
Date:   Wed, 17 Aug 2022 21:57:13 +0800
Message-Id: <20220817135718.2553-3-qtxuning1999@sjtu.edu.cn>
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

Only add to used ring when a batch of buffer have all been used.  And if
in order feature negotiated, only add the last used descriptor for a
batch of buffer.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index bc8e7fb1e635..57cdb3a3edf6 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -43,6 +43,9 @@ struct vhost_test {
 static void handle_vq(struct vhost_test *n)
 {
 	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
+	struct vring_used_elem *heads = kmalloc(sizeof(*heads)
+			* vq->num, GFP_KERNEL);
+	int batch_idx = 0;
 	unsigned out, in;
 	int head;
 	size_t len, total_len = 0;
@@ -84,11 +87,14 @@ static void handle_vq(struct vhost_test *n)
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		heads[batch_idx].id = cpu_to_vhost32(vq, head);
+		heads[batch_idx++].len = cpu_to_vhost32(vq, len);
 		total_len += len;
 		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
 	}
+	if (batch_idx)
+		vhost_add_used_and_signal_n(&n->dev, vq, heads, batch_idx);
 
 	mutex_unlock(&vq->mutex);
 }
-- 
2.17.1

