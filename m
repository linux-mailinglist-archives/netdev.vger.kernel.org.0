Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9550F1EBC75
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgFBNGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:06:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52515 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728364AbgFBNGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LkIC7lu04RjihR3CHtt6ay4K/Xfv1eAdqmqMBhW1nUc=;
        b=LifWSsa+dlAOqYvpOSxVpBrjO3E+PBxENGpFlQtx4cQYfV62b1jr+4Pbsf3V4bb6xvbLyq
        QZRqGkQCeXrnqgLbtIK0Pr2AIwjlxjHRVplUyUUGw96c2xRrykc3YhCUVNL7RIptsmY81l
        YEKpPIMCOrhWgmV1AGPLHWWLgRcI+ps=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-fzEW7qVnNZSNRGD3EVVnkw-1; Tue, 02 Jun 2020 09:06:21 -0400
X-MC-Unique: fzEW7qVnNZSNRGD3EVVnkw-1
Received: by mail-wr1-f72.google.com with SMTP id j16so1356250wre.22
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LkIC7lu04RjihR3CHtt6ay4K/Xfv1eAdqmqMBhW1nUc=;
        b=meRjy27yQ96cuOQZCK0EtEBIU9p3OYGLwvVISY2CYlB/zewX5cZaJdnQt3dNXiPz9O
         dtY3aYlFDvoaD/OAHuLTDagaENZ5GKAAX1ozJnHCvaeBGQUZ9SdsSQlV1oei5ZbLgNHL
         XFiir03RuTWN/d8dPQEsJ5HptQUTn1+zLOasDBdPMfsRLNgYIimxKmIKKiLowRobXMoP
         06MV4OOfbS+htLPtkIm3LyTbwqTlZfil1gsecqIcEaE4LnfeftKgl2zxqiSvKbuZzN2j
         W9e3U76zI+zryrFewwt5OyG7icfll54hk7P1/l3kXq9N6+s4EIlmMtVaHVP6jWqysdMq
         icWQ==
X-Gm-Message-State: AOAM530clM2VXtygpGxu8YF/GOOjhVBoCb+n8jnBIga5c1u8r8AfURl9
        0xNUcfHn4DzZ35F4SfOW+5owZfkZ5x5ssMn7EeeFdI0/fZ9K0GkyRE+meRMiuSD9aDhWuXII+0U
        ZNJhdn3OJa6yfQ/xv
X-Received: by 2002:a05:6000:87:: with SMTP id m7mr26716061wrx.306.1591103180173;
        Tue, 02 Jun 2020 06:06:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy5w09ZL79wZ7Oh271xsfdoKTPaA5LzVH1a7uDl4PbLKlKnjLFOCQbjfNEw+zB0N+AN5b0WkA==
X-Received: by 2002:a05:6000:87:: with SMTP id m7mr26716050wrx.306.1591103179992;
        Tue, 02 Jun 2020 06:06:19 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id j5sm3782271wrq.39.2020.06.02.06.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:19 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 10/13] vhost/test: convert to the buf API
Message-ID: <20200602130543.578420-11-mst@redhat.com>
References: <20200602130543.578420-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602130543.578420-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 02806d6f84ef..251fd2bf74a3 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -44,9 +44,10 @@ static void handle_vq(struct vhost_test *n)
 {
 	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
 	unsigned out, in;
-	int head;
+	int ret;
 	size_t len, total_len = 0;
 	void *private;
+	struct vhost_buf buf;
 
 	mutex_lock(&vq->mutex);
 	private = vhost_vq_get_backend(vq);
@@ -58,15 +59,15 @@ static void handle_vq(struct vhost_test *n)
 	vhost_disable_notify(&n->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					 ARRAY_SIZE(vq->iov),
-					 &out, &in,
-					 NULL, NULL);
+		ret = vhost_get_avail_buf(vq, vq->iov, &buf,
+					  ARRAY_SIZE(vq->iov),
+					  &out, &in,
+					  NULL, NULL);
 		/* On error, stop handling until the next kick. */
-		if (unlikely(head < 0))
+		if (unlikely(ret < 0))
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
-		if (head == vq->num) {
+		if (!ret) {
 			if (unlikely(vhost_enable_notify(&n->dev, vq))) {
 				vhost_disable_notify(&n->dev, vq);
 				continue;
@@ -78,13 +79,14 @@ static void handle_vq(struct vhost_test *n)
 			       "out %d, int %d\n", out, in);
 			break;
 		}
-		len = iov_length(vq->iov, out);
+		len = buf.out_len;
 		/* Sanity check */
 		if (!len) {
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		vhost_put_used_buf(vq, &buf);
+		vhost_signal(&n->dev, vq);
 		total_len += len;
 		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
-- 
MST

