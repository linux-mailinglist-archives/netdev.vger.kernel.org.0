Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A005D55F3
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 13:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbfJMLmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 07:42:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729061AbfJMLmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Oct 2019 07:42:13 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E27785539
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 11:42:13 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id k67so14120077qkc.3
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 04:42:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ls+7nvLzVD/C5D5VX4czbgip7cBCYdFDThqPFhQtYcU=;
        b=h6ooidwonL10yMwBy8MFOPs3zgf6mIGboj/P1JlAs9JAwvAdIVMzpC6PpuQfQGOO/c
         1N6Nw2mBg3l9d2qKX27qB9CQ+asHOdYnEwtJzZiUnZWKKw1xAKP4cnlSBv2It8UBMX17
         CqsfEzlANQLwBE4zHSvxdZzNFaGqsfFFg11cAatMwBBUe6/9BqpPMsuedI56b/0Zwm4Q
         fAyV2OAxk5MI71vDPVsHxRkz3WbAKNiK4GeBa7akvCjWVgvtk4SKIKPb8t9D+d7eamzL
         X/bWgLdcjnLXxg/kv3qixpUfSyQ3DFNDlS+kA97FA999WuREtHsoJ7FU6WH7fAoAE+4e
         e3gA==
X-Gm-Message-State: APjAAAVQXDa2u10zz3k+rgtNnpjBYGh4EZSbuX5eCWm6GPP9PEhjGG7y
        G0zAVWaOVQuH6UY4YfNsQPzSTPfudzK68IGpDaC43nFYL6Uc1Hb8r3CmKsj0CDyAve15qx2oTQx
        0A0k4oKjv/rgA0MKS
X-Received: by 2002:a0c:fc4a:: with SMTP id w10mr26413623qvp.46.1570966932888;
        Sun, 13 Oct 2019 04:42:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzk+MzrwJBp1s36w10kcHkZ3zHXuqofxfxn+xexQgdtQjVvG9LWQNytw8VUoM650ZyCDUjTNw==
X-Received: by 2002:a0c:fc4a:: with SMTP id w10mr26413597qvp.46.1570966932473;
        Sun, 13 Oct 2019 04:42:12 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id g33sm6728182qtd.12.2019.10.13.04.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2019 04:42:11 -0700 (PDT)
Date:   Sun, 13 Oct 2019 07:42:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC v4 2/5] vhost/test: add an option to test new code
Message-ID: <20191013113940.2863-3-mst@redhat.com>
References: <20191013113940.2863-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013113940.2863-1-mst@redhat.com>
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

