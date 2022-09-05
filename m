Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D706D5AC9A6
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 06:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiIEExz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 00:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbiIEExy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 00:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A832657A
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 21:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662353633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=m9dcPGbMHXaYmZUV3H1zsLHmGsdVHZV/OdAWS9Cd78s=;
        b=bp7pMdcqJtVzUF3JvkG8CgiQ5gYbZ9sEhMMxO5mynDsMwxrsktMZhGtJYkYuiuj9MtrM8Z
        voSvRclyH8iQyG8HPESURbaZptoshlz21kqIOX1gmv3MunJCvExeefHfULDij/74qB/AwN
        UIhR3cB4z5GUx5jIzhoh++wimzJdWF8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-dwOq394-M3KwOdNU4AR59g-1; Mon, 05 Sep 2022 00:53:48 -0400
X-MC-Unique: dwOq394-M3KwOdNU4AR59g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F93A185A79C;
        Mon,  5 Sep 2022 04:53:48 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-129.pek2.redhat.com [10.72.12.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51F421410F37;
        Mon,  5 Sep 2022 04:53:44 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     gautam.dawar@xilinx.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] virtio-net: add cond_resched() to the command waiting loop
Date:   Mon,  5 Sep 2022 12:53:41 +0800
Message-Id: <20220905045341.66191-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding cond_resched() to the command waiting loop for a better
co-operation with the scheduler. This allows to give CPU a breath to
run other task(workqueue) instead of busy looping when preemption is
not allowed.

What's more important. This is a must for some vDPA parent to work
since control virtqueue is emulated via a workqueue for those parents.

Fixes: bda324fd037a ("vdpasim: control virtqueue support")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ece00b84e3a7..169368365d6a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2000,8 +2000,10 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	 * into the hypervisor, so the request should be handled immediately.
 	 */
 	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
-	       !virtqueue_is_broken(vi->cvq))
+	       !virtqueue_is_broken(vi->cvq)) {
+		cond_resched();
 		cpu_relax();
+	}
 
 	return vi->ctrl->status == VIRTIO_NET_OK;
 }
-- 
2.25.1

