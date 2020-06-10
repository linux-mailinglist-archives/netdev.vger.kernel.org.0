Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30401F5383
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgFJLhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:37:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728740AbgFJLgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=NRuhn5aZWJTbFcxQIgI38iMSwyMb2tshI1jQd38v65QpOHsV+dAAaHohYcLICgyeU5zyZc
        lrT9wR+AaSoOZyhpXZmU+OkoWXZIyjkIaRtZ1ZM4OKwLmLkf5DjDrRK3QLdvifGNbobE6x
        sX5zUlocIIwsK0ZeSnFfoJVnFEGQw24=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-uzffMx-TPMGmkdwhuug2cA-1; Wed, 10 Jun 2020 07:36:34 -0400
X-MC-Unique: uzffMx-TPMGmkdwhuug2cA-1
Received: by mail-wm1-f71.google.com with SMTP id p24so402624wmc.1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:36:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=BoRUkBhNmXqx0SEUZdQo2ngg8+JUUcFfgY+gFw6hbupRE6WwxOxCfbB4MyblfYsp2w
         7MseIyfAyytyzWS55I3FEGtBYpIOSCKxoyX45TvLQxGbBXNDWKs6V9Cfp2v/q84GVgMt
         5S1Tff9srnqawR6Hrg47aMO1OSiFTxMdiMpzby+6sGZ3geoe28oHmKuiM0bN1aD4nBUF
         W9KWcC4iK6ul7JthnT7wSGoQD11sHP584CFmPBm29zVZcULNaQq6mOo3ifyGoQuc7EfL
         SoQvBEIQk6C9LWwUk/E0tMIqfuETcOkOL/rcaQBdDHUYPhPcxLqXFm4QdLXgNvCvMHVZ
         /HNQ==
X-Gm-Message-State: AOAM5313rRUAL5XsRYZHU/SFDtfrLq3ChY95M23Epm/bX24Faoyby0xM
        tWlhOFXbzvIWytHJLFDaJD8ohc+kZWI9iQqrVhDBvn3uZPwXDnz2qkDBihvKFzyjpJvcaFiGEqX
        8jcw26qhMTo591von
X-Received: by 2002:a05:600c:645:: with SMTP id p5mr2706632wmm.156.1591788993080;
        Wed, 10 Jun 2020 04:36:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwILwbhe48IqgvIMdBk87XXEqvw7WkIjeF+xwxu1AVsMzWmysnuJrztuEZ4mW7XzCxYzVz5BQ==
X-Received: by 2002:a05:600c:645:: with SMTP id p5mr2706609wmm.156.1591788992842;
        Wed, 10 Jun 2020 04:36:32 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id e15sm6867215wme.9.2020.06.10.04.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:32 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH RFC v7 13/14] vhost/vsock: switch to the buf API
Message-ID: <20200610113515.1497099-14-mst@redhat.com>
References: <20200610113515.1497099-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610113515.1497099-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A straight-forward conversion.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vsock.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a483cec31d5c..61c6d3dd2ae3 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -103,7 +103,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		unsigned out, in;
 		size_t nbytes;
 		size_t iov_len, payload_len;
-		int head;
+		struct vhost_buf buf;
+		int ret;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -117,16 +118,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		list_del_init(&pkt->list);
 		spin_unlock_bh(&vsock->send_pkt_list_lock);
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0) {
+		ret = vhost_get_avail_buf(vq, &buf,
+					  vq->iov, ARRAY_SIZE(vq->iov),
+					  &out, &in, NULL, NULL);
+		if (ret < 0) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
 			break;
 		}
 
-		if (head == vq->num) {
+		if (!ret) {
 			spin_lock_bh(&vsock->send_pkt_list_lock);
 			list_add(&pkt->list, &vsock->send_pkt_list);
 			spin_unlock_bh(&vsock->send_pkt_list_lock);
@@ -186,7 +188,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 */
 		virtio_transport_deliver_tap_pkt(pkt);
 
-		vhost_add_used(vq, head, sizeof(pkt->hdr) + payload_len);
+		buf.in_len = sizeof(pkt->hdr) + payload_len;
+		vhost_put_used_buf(vq, &buf);
 		added = true;
 
 		pkt->off += payload_len;
@@ -440,7 +443,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 	struct vhost_vsock *vsock = container_of(vq->dev, struct vhost_vsock,
 						 dev);
 	struct virtio_vsock_pkt *pkt;
-	int head, pkts = 0, total_len = 0;
+	int ret, pkts = 0, total_len = 0;
+	struct vhost_buf buf;
 	unsigned int out, in;
 	bool added = false;
 
@@ -461,12 +465,13 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			goto no_more_replies;
 		}
 
-		head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
-					 &out, &in, NULL, NULL);
-		if (head < 0)
+		ret = vhost_get_avail_buf(vq, &buf,
+					  vq->iov, ARRAY_SIZE(vq->iov),
+					  &out, &in, NULL, NULL);
+		if (ret < 0)
 			break;
 
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
 				vhost_disable_notify(&vsock->dev, vq);
 				continue;
@@ -494,7 +499,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			virtio_transport_free_pkt(pkt);
 
 		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		buf.in_len = len;
+		vhost_put_used_buf(vq, &buf);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
-- 
MST

