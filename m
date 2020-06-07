Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B571F0BCE
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 16:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgFGOMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 10:12:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29768 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726762AbgFGOLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 10:11:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=aSvRuJRDwZN0P760tlt/8JqHTuIupkQJfd6ntM4ACM0Zt4/lhCkAhGygx6pjOeyCCqBE7F
        vXASTvptrpnqzElUZ/GsZoBNEHmSGAMR0hwe7JugtCm1I+SlD4Gk4Q33BJtXuVhtK7WKDx
        jiUF0lwO3k6zbrdLprkKADXHSnmnKPc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-r5CO-28OMFmO4PGvdd0Z5A-1; Sun, 07 Jun 2020 10:11:45 -0400
X-MC-Unique: r5CO-28OMFmO4PGvdd0Z5A-1
Received: by mail-wr1-f70.google.com with SMTP id o1so6011487wrm.17
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 07:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8yeTF/4xoJH8JkJEZ+aqTMVrfSsZomUNfl5tfcaaPRM=;
        b=Emv16sEW6w/WFpwblF6J7ni6lGdvSDRHsyu8/W/rZog/h02I5yqCGDYlKHjjxE840T
         u0xAlXaOCuuGIseLFL+t0AGQfBOuPGXFE+k32E98jZXxfE813WWJ7hEIVSbV1YW+lCZl
         Wet/437DT0Ttp5t4nPv+F3vPzsS2uddkrWvXv88q6b46NuwC1bYoSJSJveuL5oTEnU8M
         htISbaOA+VdeLZo+mdrGTZpya9p6M4Nhsx0cJy/h7IYBjY5i6iuniz9a0gNTGteEbP2M
         Tghvi71tfkS4DoH3b3O9OfIBG91uKDUQMILs7UlhQkq25ImK0QI4OWy4QuX9WnD6mYW7
         n8nw==
X-Gm-Message-State: AOAM532x2bz4JGTsofr3ryGrl3O8yyeid6a8q/kztlEFR4sUx18YHeVG
        5PpMif7FFkTwZRovZeVM46H1sL1dX4oYdYKeDS8WjPOwPASPC30QnSK9oF9QaVQZeCkK0EiiMNF
        Xi8zr7mRBevyY4QBe
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr12417401wmi.165.1591539104515;
        Sun, 07 Jun 2020 07:11:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw57J09cTKbeRmJVX90+N+R46OyNEvndsO7VwU1Ip6tS22b7zKgKAjdQddCV5K1/YT0vuS/Pg==
X-Received: by 2002:a7b:cb93:: with SMTP id m19mr12417393wmi.165.1591539104370;
        Sun, 07 Jun 2020 07:11:44 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id h5sm20290400wrw.85.2020.06.07.07.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:44 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 09/13] vhost/net: avoid iov length math
Message-ID: <20200607141057.704085-10-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
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

