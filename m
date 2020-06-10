Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8CB21F5387
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgFJLhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:37:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32549 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728594AbgFJLgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=GjfUIyKjRWWOYcypwrJZ4wDWc4NcklN20xYxWOoeLqWWvoHNb7wedQSHVmlh1sS99t9F1Z
        iKcHu5ZPJ7L1neE3Zfli6YJ4fGvFjv1qfemONGDTx7FizxMNOyHctSwpXXEiM46eeAs0xq
        oDuP97zqkDJ3LAZ9jm1KG92S/MfCYeg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-SDhxWxlnMh6KuJ2Cs9sHUA-1; Wed, 10 Jun 2020 07:36:28 -0400
X-MC-Unique: SDhxWxlnMh6KuJ2Cs9sHUA-1
Received: by mail-wr1-f69.google.com with SMTP id m14so961421wrj.12
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:36:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNh1TL7xZUtXOusVSg8tIG35kTb/6beDbMDeGMbkL8c=;
        b=n0fjgom8r6+8G9vBAktGObjT7WTvsbkwKNoWpe8oecUG0AkWbZ/m4bvwMZj4ca7wrJ
         6wfHnqJUTgzwbFkQwMbaO1QxrokoaeGb69swZR1+kZxjy96WOimx2QH1WvMyi/AEPgIY
         ezEkgEktcoo/Gawt29Xfs99C3srppKLyMP0oMv2GfuKM9u8UZzpXCC/1DObDnhy+oPTc
         r7zKik49EXVQmydddUBMCEJQRkoFxgGT+ORKnuk7UGELESANsqfdr5djeHu3Lnmsku0c
         2Vqj9FKCN5iyacTOARSJNCIlGwucr+PYvAJVn+VRIPz/E6fQm2r9BnUzueCzX7EE/f3v
         SPQA==
X-Gm-Message-State: AOAM531IHxozoyMwZK5SEuunYqNkANuRaXMi73wEkKbWvjqndLHjvdec
        O9Cx8+6bLdc2Z2g0rhAay9MPaHom8LiZrP4q0Ziwt7N8AVrYzMmJjbJvPFIkGgPjNRN5rh9kq2v
        LMKcrfJBYAcyWXyDz
X-Received: by 2002:adf:e9cb:: with SMTP id l11mr3131430wrn.86.1591788987304;
        Wed, 10 Jun 2020 04:36:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+fpU0gApAo9WdU2/MAJH8DR4JAaeeYujgzZhmzjJ0R2CYxZQQqTFJTYVCM7So04QnKQlLdw==
X-Received: by 2002:adf:e9cb:: with SMTP id l11mr3131407wrn.86.1591788987053;
        Wed, 10 Jun 2020 04:36:27 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id a16sm7675327wrx.8.2020.06.10.04.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:26 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 11/14] vhost/test: convert to the buf API
Message-ID: <20200610113515.1497099-12-mst@redhat.com>
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

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 7d69778aaa26..12304eb8da15 100644
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
+		ret = vhost_get_avail_buf(vq, &buf, vq->iov,
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

