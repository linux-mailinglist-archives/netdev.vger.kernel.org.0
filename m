Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94B21F66E0
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgFKLff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 07:35:35 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27843 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728072AbgFKLef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 07:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591875273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LSaMCS1O17u0g9bd8e2z58Dc9EOg+CQGapBL2hGbMuM=;
        b=VJw6Hwc84UAaZHZxi1f0PZIbxhOEidvSrIVolVNeRWa3uJ7hud3dhs2J7HjDV0TOYSf37G
        cBT+Adtvzb79JoN+2yJbsoIRbB11UbwQLem2iZ8mgaISS4DG9RFWPevxCHv222OWw7niWl
        gv7s/Kww/751bbNFunEvru9qLySEVZg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-u1XpV0TvPbCvi5S2fWMugQ-1; Thu, 11 Jun 2020 07:34:30 -0400
X-MC-Unique: u1XpV0TvPbCvi5S2fWMugQ-1
Received: by mail-wr1-f72.google.com with SMTP id c14so2442780wrm.15
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 04:34:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LSaMCS1O17u0g9bd8e2z58Dc9EOg+CQGapBL2hGbMuM=;
        b=Rzhy7tVJ+XBIuYD6vyqaNvAgZNDCZJWRzVK1PMENpo6/JwDn5oQ6FVG2oN6gKBtdcx
         QYraopLt+tBA+vABGQrUQusmgAch1VbTvq3eVWvrbzDLN+xYy1wt5AsxyAJJFGkGnmDG
         dqrrDosq0yn3RzeF1QSNdp8iLJ7fKe9v/6PDppO/dIjmIsmXnLb618VU6z6azOYScgD0
         tsZcVaN3CdAiM1DgSTzLgJvnMV5VKuMCKi1r6rSh5RbLtzexXsCoS7bUrapFLXfRLw4f
         QUN9qeMRP/SgSDZ+2Zs4HNMG8H8a4hFXrwJjajFhcEWxOPB4hghuo8fTZvyXtJFZZqoH
         rn+Q==
X-Gm-Message-State: AOAM533OASILky5WcLFEsHa8Zkr2L17zaKlDDoT2SHmY6UGz4PeeqDE9
        4aSgHQvI896oaqTkwiSF+uF57lZDoCVO35A/Ed3kxEnZQGEPIX238CWCnErXjqX5sdYfM3tJvZG
        R2Zrts4qrutticCXS
X-Received: by 2002:a1c:4c12:: with SMTP id z18mr8168938wmf.155.1591875268744;
        Thu, 11 Jun 2020 04:34:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRruNuuWVHeVObfkjvydTwC1u/cRDZVYXDLJqDViLWy8eeCG8AzgDjmH1RnLu55gQ/LJierw==
X-Received: by 2002:a1c:4c12:: with SMTP id z18mr8168909wmf.155.1591875268378;
        Thu, 11 Jun 2020 04:34:28 -0700 (PDT)
Received: from redhat.com (bzq-79-181-55-232.red.bezeqint.net. [79.181.55.232])
        by smtp.gmail.com with ESMTPSA id t129sm4130286wmf.41.2020.06.11.04.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 04:34:27 -0700 (PDT)
Date:   Thu, 11 Jun 2020 07:34:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v8 05/11] vhost: format-independent API for used buffers
Message-ID: <20200611113404.17810-6-mst@redhat.com>
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

Add a new API that doesn't assume used ring, heads, etc.
For now, we keep the old APIs around to make it easier
to convert drivers.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 73 +++++++++++++++++++++++++++++++++++++------
 drivers/vhost/vhost.h | 17 +++++++++-
 2 files changed, 79 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c38605b01080..03e6bca02288 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2335,13 +2335,12 @@ static void unfetch_descs(struct vhost_virtqueue *vq)
  * number of output then some number of input descriptors, it's actually two
  * iovecs, but we pack them into one and note how many of each there were.
  *
- * This function returns the descriptor number found, or vq->num (which is
- * never a valid descriptor number) if none was found.  A negative code is
- * returned on error. */
-int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct iovec iov[], unsigned int iov_size,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num)
+ * This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
+int vhost_get_avail_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf,
+			struct iovec iov[], unsigned int iov_size,
+			unsigned int *out_num, unsigned int *in_num,
+			struct vhost_log *log, unsigned int *log_num)
 {
 	int ret = fetch_descs(vq);
 	int i;
@@ -2354,6 +2353,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	*out_num = *in_num = 0;
 	if (unlikely(log))
 		*log_num = 0;
+	buf->in_len = buf->out_len = 0;
+	buf->descs = 0;
 
 	for (i = vq->first_desc; i < vq->ndescs; ++i) {
 		unsigned iov_count = *in_num + *out_num;
@@ -2383,6 +2384,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			/* If this is an input descriptor,
 			 * increment that count. */
 			*in_num += ret;
+			buf->in_len += desc->len;
 			if (unlikely(log && ret)) {
 				log[*log_num].addr = desc->addr;
 				log[*log_num].len = desc->len;
@@ -2398,9 +2400,11 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 				goto err;
 			}
 			*out_num += ret;
+			buf->out_len += desc->len;
 		}
 
-		ret = desc->id;
+		buf->id = desc->id;
+		++buf->descs;
 
 		if (!(desc->flags & VRING_DESC_F_NEXT))
 			break;
@@ -2408,12 +2412,41 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 
 	vq->first_desc = i + 1;
 
-	return ret;
+	return 1;
 
 err:
 	unfetch_descs(vq);
 
-	return ret ? ret : vq->num;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
+
+/* Reverse the effect of vhost_get_avail_buf. Useful for error handling. */
+void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
+			      struct vhost_buf *buf, unsigned count)
+{
+	vhost_discard_vq_desc(vq, count);
+}
+EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
+
+/* This function returns the descriptor number found, or vq->num (which is
+ * never a valid descriptor number) if none was found.  A negative code is
+ * returned on error. */
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	struct vhost_buf buf;
+	int ret = vhost_get_avail_buf(vq, &buf,
+				      iov, iov_size, out_num, in_num,
+				      log, log_num);
+
+	if (likely(ret > 0))
+		return buf->id;
+	if (likely(!ret))
+		return vq->num;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
@@ -2507,6 +2540,26 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 }
 EXPORT_SYMBOL_GPL(vhost_add_used);
 
+int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
+{
+	return vhost_add_used(vq, buf->id, buf->in_len);
+}
+EXPORT_SYMBOL_GPL(vhost_put_used_buf);
+
+int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
+			  struct vhost_buf *bufs, unsigned count)
+{
+	unsigned i;
+
+	for (i = 0; i < count; ++i) {
+		vq->heads[i].id = cpu_to_vhost32(vq, bufs[i].id);
+		vq->heads[i].len = cpu_to_vhost32(vq, bufs[i].in_len);
+	}
+
+	return vhost_add_used_n(vq, vq->heads, count);
+}
+EXPORT_SYMBOL_GPL(vhost_put_used_n_bufs);
+
 static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
 	__u16 old, new;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index fed36af5c444..28eea0155efb 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -67,6 +67,13 @@ struct vhost_desc {
 	u16 id;
 };
 
+struct vhost_buf {
+	u32 out_len;
+	u32 in_len;
+	u16 descs;
+	u16 id;
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
@@ -195,7 +202,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
-
+int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
+			struct iovec iov[], unsigned int iov_count,
+			unsigned int *out_num, unsigned int *in_num,
+			struct vhost_log *log, unsigned int *log_num);
+void vhost_discard_avail_bufs(struct vhost_virtqueue *,
+			      struct vhost_buf *, unsigned count);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
@@ -204,6 +216,9 @@ void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
 			       unsigned int id, int len);
 void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
 			       struct vring_used_elem *heads, unsigned count);
+int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
+int vhost_put_used_n_bufs(struct vhost_virtqueue *,
+			  struct vhost_buf *bufs, unsigned count);
 void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
 void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
-- 
MST

