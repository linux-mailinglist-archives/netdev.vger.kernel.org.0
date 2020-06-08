Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2411F193C
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgFHMxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:53:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29670 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729565AbgFHMxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=XtDNveGuZPiBncvOQ1RUrUT3Bc9YXnjnBDkm/7WhzEVOnTUpV8cw+L64ZFvRs23YgYvvXQ
        40j99TiyGu9fgMl7OesPSP8StQcwGGYNG5v3vUXHvc/TQhc5W9Qzi7A5YUpZeMX12obfaD
        3NtUcRgkCHZfEyStvevob4LnIgvDX1g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-3QEKxDFlPgWUl4NwOmVgQQ-1; Mon, 08 Jun 2020 08:53:09 -0400
X-MC-Unique: 3QEKxDFlPgWUl4NwOmVgQQ-1
Received: by mail-wr1-f69.google.com with SMTP id d6so7112810wrn.1
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:53:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=pGCEoQD+oDyTCwecMNMrR7HD0VIwPG7vorE48Iz66HvIrndlGeL/4jdfc+OCiroXjV
         PxGHfu5BvRRjisdhg+drgVYWjINLnn0wou0hLfVf47UcASTxTL51/G4+JZ9j9gcfzsc+
         MXAX1UVtBDAvaXBjiu9K1o7dIxHhQkazRwT/SSt00EJL5fPazusqahf7Mcu7rxTyXLzb
         4DidFu17IO4DiEriM+OoNZFWbI3Ee7y1m80jgi3xLgqhmXHbF6DgfmMQ9EV0vC0xlotF
         L4O/T+RPk7zA5v07pWyad9gYWLCBdiMm+TGm17s430+lSE2NEUU1ilCEPS31Nuy75dSb
         uaOw==
X-Gm-Message-State: AOAM5308tEQrD+l4G/tRG0XMs7Gb/0j9tGh78ApIZ9QjM8cQ7w6EbtGL
        Mvykzp+v8xPBeQD4hRJssgdJ/sWwobiahLseWJv98VkpNGPcjAXf6ybesUxH03zDEcElPqM/KK7
        QTiEruF2DrYptpEuc
X-Received: by 2002:a5d:5585:: with SMTP id i5mr23127121wrv.112.1591620788703;
        Mon, 08 Jun 2020 05:53:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy11gQF/NmEmSn0DK4pnAXz2ogVtvYom9rwdJUwvE7o5lVdYxjyVZYvm9PoiqoHGw3Jn2dmGA==
X-Received: by 2002:a5d:5585:: with SMTP id i5mr23127106wrv.112.1591620788527;
        Mon, 08 Jun 2020 05:53:08 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id z16sm23295568wrm.70.2020.06.08.05.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:08 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 07/11] vhost/net: avoid iov length math
Message-ID: <20200608125238.728563-8-mst@redhat.com>
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

Now that API exposes buffer length, we no longer need to
scan IOVs to figure it out.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 830fe84912a5..0b509be8d7b1 100644
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

