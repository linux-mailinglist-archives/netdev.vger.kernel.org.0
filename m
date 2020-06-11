Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF761F66D4
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgFKLfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:35:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728151AbgFKLeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 07:34:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=SqUOpLX+JpIOzz/ldOFYkRyb2CbZe2+IK0b/z5LmwANBnWlEEvTfAyjFFEQigYAnYB6B/I
        kvMo+Cm6h3yKyZN0cvgfhcrPY7+58TuvN/i4iFADr5bVtq+yVn1Z0a56RrHla7ajZagmMZ
        6FvqlCd6kqkat/OzLBeSSjBFY4F2Z7M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-6Aheex0NNsiqurIEPc9bYQ-1; Thu, 11 Jun 2020 07:34:43 -0400
X-MC-Unique: 6Aheex0NNsiqurIEPc9bYQ-1
Received: by mail-wm1-f69.google.com with SMTP id 11so1014334wmj.6
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 04:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=bCWe9E4u+vO3f3qEHQg5Z9K2+PNmSfqxh1FtOrzV/tPJ6DrkqPq3/bfuXS7YkD8hQA
         f89xfPaNNTb0PDqHJxPsSxC+6rs2V896MhMe5BVVvU5zj6QjQbISSbFUs4MjGbtLe2UG
         8c/U9EMMZVsOJvLS9Yt/8sZDrMMqeKmaAjuiujpDgujeq73UXoYyxR6rtDYS+Ee3DHUX
         skYiShVAOFnd2oJe+dJOxq/DsXBe3aHJ6yrKjBQmLVl+cKGIPUcNEXe/17CUnry5OfV3
         AYcUrRe5hmEEW8z13IlS8reAEW/0AVSfGCRDn6rUI1/o9umXfQZ41WSfngBhyFaWpzzo
         8Y3Q==
X-Gm-Message-State: AOAM532q+6Qlv0qoOe9Hpkw0CitGGa8q1imtl0b3PHjVd4h5sg6t6waB
        njIunDienzLGQ4ESrv4D8TLzrpSg1zXhDYml+opXoBYIOH5ZldCxV9QDyc+iJoEHg85GO34qgP/
        PQLvxjvIc0MYFndzh
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr9034933wro.250.1591875281758;
        Thu, 11 Jun 2020 04:34:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaN8UyMkBoje3zvcs8Zrl24G62sBtAAqwPmdfUt3YrWvvfabslQFTxFX6q1D42asxDp7PEuw==
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr9034914wro.250.1591875281527;
        Thu, 11 Jun 2020 04:34:41 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id v7sm4245400wre.93.2020.06.11.04.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:41 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH RFC v8 10/11] vhost/vsock: switch to the buf API
Message-ID: <20200611113404.17810-11-mst@redhat.com>
References: <20200611113404.17810-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611113404.17810-1-mst@redhat.com>
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

