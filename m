Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBCA1F193F
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgFHMxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:53:33 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40317 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729696AbgFHMxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=bvmfN3v+w6ikhXyCNHkoWNLwdTWu9IdmgCnc4ftx6Dz8lhUTnHYT7h5RxWKw2GIUrFJKgy
        24Iz8Dm5czNCSVusW8d7fhgEGIZ5tQTtES0SA5/nNQ/ih5MgNwpbtk8NQWmGQAqkMuLBvD
        WXRPJQMR+bnz022eKkKTfLZiBKj3Rj8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-3fldm4uyM1OTB3qiMHYdeg-1; Mon, 08 Jun 2020 08:53:16 -0400
X-MC-Unique: 3fldm4uyM1OTB3qiMHYdeg-1
Received: by mail-wm1-f70.google.com with SMTP id p24so5217939wmc.1
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TEosg1cbEhe9hhKHYKqZg2N/D89Ri/A+CQJLw8Cq4Bg=;
        b=MEg+gB8OlkMNuDY/SaHUez/45S3pUd60CZ6awNprzFiE6TCAkjEXsCHgvYJaLwZ27W
         XTlxSbyz61WhXToccRp+AkIqX5SmagxHj4XGtOb2Y75DBSKNDIk0LeYUrofVzS34FHXA
         jkoR8tee8AupJDAYbpYSCPHHIE/o+gQO8wWwohAd4KWEdaknJ0SDvUXA8FVWBqkk3gjs
         1jW+MWw15Nmw/gEGOJUDvuYjXB+NlpZA9NYBF0NhsFiNh7T8f01dVFlQL7pVwmLX93ni
         tt+rcm22Q0td9b11P+B8W07XCCiNPU72mKLAcS1Ow2p8Rjud27ArWu1Fp+WenWhDPOBf
         nhlA==
X-Gm-Message-State: AOAM532EjxusQq4yVnHIjnRqq8KYZdZ7SzGEOP8ooP/n3yNA920EnB2Y
        iisRdk95U7gOUkc0zkjCGfISi8+WJ7X8BALFhB1nSILebIqsvzVC9Su6hRd8PZFDn7YiwzJcMDH
        wLslwdILVBrrcxQGZ
X-Received: by 2002:adf:9d8e:: with SMTP id p14mr22776196wre.236.1591620795493;
        Mon, 08 Jun 2020 05:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzojN0Rni5a/KRQQtayEgafAMQjL2u7TFZEVEHmdO1lnxFxUgOcYrWuJF226hamluzbsGThDA==
X-Received: by 2002:adf:9d8e:: with SMTP id p14mr22776176wre.236.1591620795249;
        Mon, 08 Jun 2020 05:53:15 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id i10sm22891380wrw.51.2020.06.08.05.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:14 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH RFC v6 10/11] vhost/vsock: switch to the buf API
Message-ID: <20200608125238.728563-11-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
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

