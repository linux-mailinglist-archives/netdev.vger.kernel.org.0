Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895191EBC73
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 15:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgFBNG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 09:06:28 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728114AbgFBNGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 09:06:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591103180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0y1VAVnqSFAPeWWtS5RcheCrLnqiQBKbwiujoWwz9Qo=;
        b=HHqX5UVkP+KdIlkTkq+pYxu8MSp7bcm094wcRVwhPiZTtP0F4Ngy/NcR9eRCTALek1cHGw
        sJ2l2rpcVyu/MbE5CWbZ2/8xKJ2M4Yg0ADBtBpNftOThyfpdYZkQ4yiZbv1oagZEJRwwe1
        cJHVE1Kx7pwno8sHkcUlnbFm8XhjFxA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-MaVqePc_OLm_xhTh9mvnFw-1; Tue, 02 Jun 2020 09:06:18 -0400
X-MC-Unique: MaVqePc_OLm_xhTh9mvnFw-1
Received: by mail-wr1-f72.google.com with SMTP id s17so1370582wrt.7
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 06:06:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0y1VAVnqSFAPeWWtS5RcheCrLnqiQBKbwiujoWwz9Qo=;
        b=P0Q4YWNezbu9G0epbWcaZRzHbWJFrLN3n2zrXMVr2yHZXveejPvyH+S3M4WnTQks3Q
         1ohD2RHxC8KaF4qtL9zBgRaiFEukEOovCtNexnlM4Or9ybLEdH46VbXDDhgIrwroCFy3
         iOnCfdsVUBLxMkC4/4L15xGKPyOQLTjFNTOZTKIFr3BGIiNUY0yd+Qiahqx/7D/2sZaa
         f4IX4iekeGX8bHUAtiPJngxpEf5Rx6aD4kHEjOT8V5w5+KA3RD0jzZ/9/qst6t+wjIRA
         e9N0lOG6Wy8GlBE/HesoHkWl1OOsM+el/2Da6aC0nxldlNU6TAVu0vpZRCbSfhgAqKUZ
         PeNg==
X-Gm-Message-State: AOAM532+ojCz3h9ePcxep5JB6hvXvnZFjcf+/A1zr09xS8z+UHRH3dsF
        pmLjhOtGVo2d/GBAW4mGu8y5tC47Wmyd5LD+03+GCBeZ/6MG3NwSpWDuhAgWm3u2JEXsiOrBSsK
        dnIZYKTk1sktXtCRM
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr4037603wma.101.1591103177424;
        Tue, 02 Jun 2020 06:06:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIsLUicCN2EL2xmA9MPBvEHkJ+pLyVHS9KUoRtpMVFDzcdIynBCr8beMEJGbnVq7BNGALRIw==
X-Received: by 2002:a7b:cc82:: with SMTP id p2mr4037575wma.101.1591103177147;
        Tue, 02 Jun 2020 06:06:17 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id s8sm3988621wrm.96.2020.06.02.06.06.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 06:06:16 -0700 (PDT)
Date:   Tue, 2 Jun 2020 09:06:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH RFC 09/13] vhost/net: avoid iov length math
Message-ID: <20200602130543.578420-10-mst@redhat.com>
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

Now that API exposes buffer length, we no longer need to
scan IOVs to figure it out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 47af3d1ce3dd..36843058182b 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -607,11 +607,9 @@ static bool vhost_exceeds_maxpend(struct vhost_net *net)
 }
 
 static size_t init_iov_iter(struct vhost_virtqueue *vq, struct iov_iter *iter,
-			    size_t hdr_size, int out)
+			    size_t len, size_t hdr_size, int out)
 {
 	/* Skip header. TODO: support TSO. */
-	size_t len = iov_length(vq->iov, out);
-
 	iov_iter_init(iter, WRITE, vq->iov, out, len);
 	iov_iter_advance(iter, hdr_size);
 
@@ -640,7 +638,7 @@ static int get_tx_bufs(struct vhost_net *net,
 	}
 
 	/* Sanity check */
-	*len = init_iov_iter(vq, &msg->msg_iter, nvq->vhost_hlen, *out);
+	*len = init_iov_iter(vq, &msg->msg_iter, buf->out_len, nvq->vhost_hlen, *out);
 	if (*len == 0) {
 		vq_err(vq, "Unexpected header len for TX: %zd expected %zd\n",
 			*len, nvq->vhost_hlen);
@@ -1080,7 +1078,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			nlogs += *log_num;
 			log += *log_num;
 		}
-		len = iov_length(vq->iov + seg, in);
+		len = bufs[bufcount].in_len;
 		datalen -= len;
 		++bufcount;
 		seg += in;
-- 
MST

