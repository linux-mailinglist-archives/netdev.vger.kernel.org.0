Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B7CD5521
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 10:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfJMIIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 04:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728741AbfJMIII (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 04:08:08 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9FD375AFF8
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 08:08:08 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id q80so13699108qke.22
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 01:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ls+7nvLzVD/C5D5VX4czbgip7cBCYdFDThqPFhQtYcU=;
        b=TyMrIZzXlio/0eNy7OUVN19cgvI5SKm8DGUfNRMQBs74iWsH5zEvOB4mBmrOcMyekf
         SMk+htv2meiSRusJlcj+uczBI6kdwH0z0LUU4IqeH8Yo9X81xoV4HwYXfMU8py4yXxXD
         gv/ssd6we9Qws02oAmNuaN5wmgYxXSJAJmWPYL1vx/DWudzySbW9umOpatOf2uyda4KL
         Dius8zLHtNM09M58qtI4ylOd8KTw+gc24aWe7iHuHTz5fKPxqdY4wR2LGUrd3whjC5CI
         asEhUQEM3fDxXES/ONvVeWyTAr0rQEz/iphz2Of0xEgFZLLDx0n+21GDtMxjSXqYf5/V
         e3LQ==
X-Gm-Message-State: APjAAAV5SVLW19WIXKkvyRkiXdnzX+Bb2BqnBEYQPAwjbcFgo4aI+z8g
        JD5TNqdtrNYA4NQC1yFngBWgvB1UcByHB7n00ascC6CWDkK4HT03WR8XKN1QVIotPts35dxFr/O
        EenUvVORY/cy6Q5As
X-Received: by 2002:ad4:4348:: with SMTP id q8mr26169257qvs.68.1570954087939;
        Sun, 13 Oct 2019 01:08:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxsr5QXq4HoazPqviMkfj/BV1d9U/KoJJ+NnnKghPE5Y5QO+yEsK30TYEPK1VGYKMaPGZafcA==
X-Received: by 2002:ad4:4348:: with SMTP id q8mr26169244qvs.68.1570954087695;
        Sun, 13 Oct 2019 01:08:07 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id r1sm7176245qti.4.2019.10.13.01.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 01:08:07 -0700 (PDT)
Date:   Sun, 13 Oct 2019 04:08:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v3 2/4] vhost/test: add an option to test new code
Message-ID: <20191013080742.16211-3-mst@redhat.com>
References: <20191013080742.16211-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013080742.16211-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a writeable module parameter that tests
the new code. Note: no effort was made to ensure
things work correctly if the parameter is changed
while the device is open. Make sure to
close the device before changing its value.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 056308008288..39a018a7af2d 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -18,6 +18,9 @@
 #include "test.h"
 #include "vhost.h"
 
+static int newcode = 0;
+module_param(newcode, int, 0644);
+
 /* Max number of bytes transferred before requeueing the job.
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_TEST_WEIGHT 0x80000
@@ -58,10 +61,16 @@ static void handle_vq(struct vhost_test *n)
 	vhost_disable_notify(&n->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
-					 ARRAY_SIZE(vq->iov),
-					 &out, &in,
-					 NULL, NULL);
+		if (newcode)
+			head = vhost_get_vq_desc_batch(vq, vq->iov,
+						       ARRAY_SIZE(vq->iov),
+						       &out, &in,
+						       NULL, NULL);
+		else
+			head = vhost_get_vq_desc(vq, vq->iov,
+						 ARRAY_SIZE(vq->iov),
+						 &out, &in,
+						 NULL, NULL);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(head < 0))
 			break;
-- 
MST

