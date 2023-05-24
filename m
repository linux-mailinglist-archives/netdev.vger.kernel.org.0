Return-Path: <netdev+bounces-4895-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B60570F07B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07BE71C20C13
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6312BC155;
	Wed, 24 May 2023 08:19:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58570C14E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:19:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBD0C0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 01:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684916345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5tp/q1PP1rmEvhRQH+UYUnVd2qhSdAOgLuVIB9ywpVA=;
	b=K8cNHCXPaqkWbr7adOK4vzj94sRVLk1EPKbQkS9kQKm1nP+0USwEZGQRmkLlIblDRWnKCU
	jn9bDDJOH9rRJamO4oga/l1B7zWBoXMWkTtLfw4I0rpxebk2s9dZPn9/AwgUbVa8J+wtlh
	We9pj+4695TkW9HGMmEdcmlzx+bisLI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-Z1G78wGxMOGbs01QHEqnVg-1; Wed, 24 May 2023 04:19:02 -0400
X-MC-Unique: Z1G78wGxMOGbs01QHEqnVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5C65802A55;
	Wed, 24 May 2023 08:19:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-76.pek2.redhat.com [10.72.13.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A48F140E95D;
	Wed, 24 May 2023 08:18:54 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alvaro.karsz@solid-run.com
Subject: [PATCH V3 net-next 2/2] virtio-net: add cond_resched() to the command waiting loop
Date: Wed, 24 May 2023 16:18:42 +0800
Message-Id: <20230524081842.3060-3-jasowang@redhat.com>
In-Reply-To: <20230524081842.3060-1-jasowang@redhat.com>
References: <20230524081842.3060-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Adding cond_resched() to the command waiting loop for a better
co-operation with the scheduler. This allows to give CPU a breath to
run other task(workqueue) instead of busy looping when preemption is
not allowed on a device whose CVQ might be slow.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5d2f1da4eaa0..de498dbbf0d4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2207,8 +2207,10 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
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


