Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF61F5371
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgFJLge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:36:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38673 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728694AbgFJLg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:36:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591788987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=OEzjN2FxH15PLi8yuz9UCOtxvN4Eu5l/ARH2uho30fxJbiO88TF4FGObcAmvLvkGsJV4VT
        ZDLpNp3igpDgY1BuXvMVjVYk6SPpauigr1TSFfeJAkNV+QUnBYQSfjjF/pI90fAzyhP8SB
        LAphuv+k0oaCbpfkRHtrdtRcRkzPDpc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-5YaSr65COjKcaUtT9NFc8g-1; Wed, 10 Jun 2020 07:36:25 -0400
X-MC-Unique: 5YaSr65COjKcaUtT9NFc8g-1
Received: by mail-wr1-f71.google.com with SMTP id j16so946579wre.22
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 04:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=uUvvbq4eAcVkRlX7VVIci7n2+QhYFwU3E+Y4YIkMyHMraygTpcva6zX+pLiWuK78GR
         xe3jqOQI+CNhFLC8CB+Dif0AZBNsMDmh78uu17WSSX9GZ/YFaSVVmT+XWyY0vBbkTlgK
         JyEw229THvk5nqikXXHcdhCqeI8LD4UaMATpoi5NpoEnD+V2lKSr0OKuJEr3NoOavKyZ
         eNJT5MqfEeJfXI92n/XAc1prEoL9QR6rkPE7gPits7uBVLNSfFCCsYzeQ6HeGoyVj8qs
         W/+UCRwAZ5Z8CyEEkwpOkt6T85PmDw/6U7socboqxHSco3sIx1991ZmXZVg44qtjTQa1
         L9Gw==
X-Gm-Message-State: AOAM530GCSGMXIDdf2HzzUNHrm2c1D6OGkN5jr47NrKhTQu/+6Muxywv
        2Xv+MZOweU/V/bpfAowmvpHmkYHHjFLXAx9F06g+asJQqALuRddq5VvevQ2TXqoPyoNzAQKAnLR
        e+rpEJz5+mO8VRkUq
X-Received: by 2002:adf:f611:: with SMTP id t17mr3115449wrp.69.1591788984597;
        Wed, 10 Jun 2020 04:36:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySUb6SmdRetYLS6/lDFnA63vhXBdDD3cCFK65tVJXhEwb5+hLdb3cRehsL9GzZU3pDEV7NVg==
X-Received: by 2002:adf:f611:: with SMTP id t17mr3115431wrp.69.1591788984381;
        Wed, 10 Jun 2020 04:36:24 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id x8sm7694296wrs.43.2020.06.10.04.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 04:36:23 -0700 (PDT)
Date:   Wed, 10 Jun 2020 07:36:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v7 10/14] vhost/net: avoid iov length math
Message-ID: <20200610113515.1497099-11-mst@redhat.com>
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

