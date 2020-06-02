Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE7F1EBC93
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgFBNGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:06:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36712 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728083AbgFBNGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EXfjPrDyqejhZJQKUWL2cxT5rK4Jnqa149Nn7T1gq18=;
        b=fSexiHW9l09yNuKon60LwwEn3hNOIHwld2GdSwkkeMqZKklg3vWr1LDJtLD3mFCDQF3o8f
        ZsLUfw9BBx8DygUvOh5pdqsvC0sCUC/6ZWepBzN3pwqaxbiJx88k3dWWBkYAG1/3j/7jP2
        RmBZegbTUHIvfAL0yMl/BKc8Il6IpKg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-GjyHK8i2M3SjeQsFJdkB4A-1; Tue, 02 Jun 2020 09:06:07 -0400
X-MC-Unique: GjyHK8i2M3SjeQsFJdkB4A-1
Received: by mail-wr1-f70.google.com with SMTP id d6so1383080wrn.1
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EXfjPrDyqejhZJQKUWL2cxT5rK4Jnqa149Nn7T1gq18=;
        b=kwhJA1mGUSnzOz8PKiuthIIYwFEpLOeugsOo2h994mjPMTN0mfG/NOWKOIZvpsCg8Q
         FiFIQneNfT52EOO34rfIpKbwQFgtPmCdKuZss2ufqJeJeJFaMcPPio4kCPn64T3ebbVj
         Dloi3JtBgl21YzOX49U/0aWe6pIDxV+6eXgUfrWLL7u6zaOObPn+jvgFGCoX3U/HMlQL
         44ZDIhZEppbOzxkGY3y9QvnkIPRAd/7geGY1NEyRyidLS5+u4ZbBqF5BPEl33P5XILnh
         B5o0etMHhsSBPkqDUBNK1zVOnxDoNZblht7NS6v6Vz7M9jtr4xtxZ148RUxpQXaKKo5D
         FcGA==
X-Gm-Message-State: AOAM530Uo6PDAH3KAQkrgoFq2Y4ig+Y+QpwR9yw4v2kGoKlHrhz77lZq
        SGVl57aINMEnBsGB3XwnhwoD7p0m1MwPbNGLw9sTSu1/Kl0BlgMe1ZjPN4OYCpV2iaJ//uPrerb
        WunsX8varI3sgBR1c
X-Received: by 2002:a5d:6391:: with SMTP id p17mr28295032wru.118.1591103165844;
        Tue, 02 Jun 2020 06:06:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycUSkpBa2fgUPLZAf/ybOapg7EllouqLaj5tY/W/L7i8gJ0j5W3iBZNA/fqWHGkhJHN82J9A==
X-Received: by 2002:a5d:6391:: with SMTP id p17mr28295007wru.118.1591103165610;
        Tue, 02 Jun 2020 06:06:05 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id m129sm3760525wmf.2.2020.06.02.06.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:05 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 04/13] vhost: cleanup fetch_buf return code handling
Message-ID: <20200602130543.578420-5-mst@redhat.com>
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

Return code of fetch_buf is confusing, so callers resort to
tricks to get to sane values. Let's switch to something standard:
0 empty, >0 non-empty, <0 error.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index aca2a5b0d078..bd52b44b0d23 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2146,6 +2146,8 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
 	return 0;
 }
 
+/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
 static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	unsigned int i, head, found = 0;
@@ -2162,7 +2164,7 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
 		/* If we already have work to do, don't bother re-checking. */
 		if (likely(vq->ndescs))
-			return vq->num;
+			return 0;
 
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
@@ -2181,7 +2183,7 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 		 * invalid.
 		 */
 		if (vq->avail_idx == last_avail_idx)
-			return vq->num;
+			return 0;
 
 		/* Only get avail ring entries after they have been
 		 * exposed by guest.
@@ -2251,12 +2253,14 @@ static int fetch_buf(struct vhost_virtqueue *vq)
 	/* On success, increment avail index. */
 	vq->last_avail_idx++;
 
-	return 0;
+	return 1;
 }
 
+/* This function returns a value > 0 if a descriptor was found, or 0 if none were found.
+ * A negative code is returned on error. */
 static int fetch_descs(struct vhost_virtqueue *vq)
 {
-	int ret = 0;
+	int ret;
 
 	if (unlikely(vq->first_desc >= vq->ndescs)) {
 		vq->first_desc = 0;
@@ -2266,10 +2270,14 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	if (vq->ndescs)
 		return 0;
 
-	while (!ret && vq->ndescs <= vhost_vq_num_batch_descs(vq))
-		ret = fetch_buf(vq);
+	for (ret = 1;
+	     ret > 0 && vq->ndescs <= vhost_vq_num_batch_descs(vq);
+	     ret = fetch_buf(vq))
+		;
 
-	return vq->ndescs ? 0 : ret;
+	/* On success we expect some descs */
+	BUG_ON(ret > 0 && !vq->ndescs);
+	return ret;
 }
 
 /* This looks in the virtqueue and for the first available buffer, and converts
@@ -2288,7 +2296,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	int ret = fetch_descs(vq);
 	int i;
 
-	if (ret)
+	if (ret <= 0)
 		return ret;
 
 	/* Now convert to IOV */
-- 
MST

