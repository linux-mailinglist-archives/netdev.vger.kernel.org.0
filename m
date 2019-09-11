Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C526AFC41
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfIKMKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 08:10:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbfIKMKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 08:10:06 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 628DDAC603
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 12:10:06 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id g62so17845851qkb.20
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 05:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=nO3SYHGDRWEzxT3/abFXM0Gu89GIuWvlxuxu/SDZ8iw=;
        b=ZkzAPysaTY5JwImPjSAfdDqn9ytGZO3+rhStcKg0LuyGBRFwSA+QsdNeKUbiV5emak
         A+J+fBPpxzPu7WQ4zHjmoR7a3B32mu/lHbklqzOK2vYIgDBLHytREoEOQ9U3X3zOrXIz
         AfJ3Dd6JIM8LpAmHt0ZCjyw8Wn0e5h0tEv+UHenCB37fvFAGgY5YACOUtfgZqRjQDXMY
         M6jTehzwH1GcNqQk1E9xz6Zn5zr00106boduS9R8g6k2X3qUJUG2P2y2hWuz7Dcl53d0
         CjQCRLQQ+G5/uAVtxDLG73ik7YNO5f8QI4OxUo4+PREuT+Akn3KicfY3UzBTtTE2Cn55
         VOxg==
X-Gm-Message-State: APjAAAUxzpErZwFMw5ropZdx6c1z4to4KBmQBAV0rE3rDA17RtuFpzgd
        NlQ2vOp76AIuqXlz7EZ+dG6m0J3tvCuCwsMm+vzdWirwthEzHISCbvxxD+mw+asNzaz/73wZOWo
        g9yVlaZZEAimIdbn7
X-Received: by 2002:ad4:5494:: with SMTP id q20mr21893380qvy.8.1568203805669;
        Wed, 11 Sep 2019 05:10:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxpfN8qjonuIyL61v7mAfTW2LcQ+Fqop0jhY4LwumZnvN9ZVZG/z8lBS94ag/ZEibKr7bFsQA==
X-Received: by 2002:ad4:5494:: with SMTP id q20mr21893369qvy.8.1568203805473;
        Wed, 11 Sep 2019 05:10:05 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id h29sm12975276qtb.46.2019.09.11.05.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 05:10:04 -0700 (PDT)
Date:   Wed, 11 Sep 2019 08:10:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911120908.28410-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iovec addresses coming from vhost are assumed to be
pre-validated, but in fact can be speculated to a value
out of range.

Userspace address are later validated with array_index_nospec so we can
be sure kernel info does not leak through these addresses, but vhost
must also not leak userspace info outside the allowed memory table to
guests.

Following the defence in depth principle, make sure
the address is not validated out of node range.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Tested-by: Jason Wang <jasowang@redhat.com>
---

changes from v1: fix build on 32 bit

 drivers/vhost/vhost.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5dc174ac8cac..34ea219936e3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2071,8 +2071,10 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 		_iov = iov + ret;
 		size = node->size - addr + node->start;
 		_iov->iov_len = min((u64)len - s, size);
-		_iov->iov_base = (void __user *)(unsigned long)
-			(node->userspace_addr + addr - node->start);
+		_iov->iov_base = (void __user *)
+			((unsigned long)node->userspace_addr +
+			 array_index_nospec((unsigned long)(addr - node->start),
+					    node->size));
 		s += size;
 		addr += size;
 		++ret;
-- 
MST
