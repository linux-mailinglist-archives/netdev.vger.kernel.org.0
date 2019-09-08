Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41F6AACC53
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 13:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfIHLFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 07:05:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728748AbfIHLFo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 07:05:44 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAFE78E251
        for <netdev@vger.kernel.org>; Sun,  8 Sep 2019 11:05:44 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id b9so12203679qti.20
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 04:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=mJ79VyQiPMiGxBu7/NgWOAdwnTdH8zf8E/dxV83oJIQ=;
        b=mW0zYhsYevuTsE8G7lcRQRtk3Jmr+WIPFzQtKfncq4qtR6qwIbA4k7pkPOt1n0lCfW
         GUtWzi+yoHkGGcdsBEjuzeDKGgN90n5atjHeBjW/Ban5S1qBH+2ToR+yCFkv6JRTbEjB
         S0q+PkHsTJdXXhmcyu3GO7ACSTspRjcFSZYBnRQEVVDm2+/A4e9r+9rHQLGW/WyLpcHQ
         tov23f2oLc3w8MV5hsoeLerwmticOummOwGKgsie7VrvwWnNqog2GqiwZ67U7DdwgNzn
         PByRu6qJXEemrLXU6zC0ymEHB0s3FER6oJYEGFcBywyy0lyghVwNXOEayUAGQMPS0NCE
         BEbQ==
X-Gm-Message-State: APjAAAV3VqY2FsyPYyOcguIXKmA8iCuID5Ri2XfQc8CIKOijo8dgwxY9
        vhY1Glr1ldCXzSB8q7MMBLhP+j4GXXXQpDAIgLGG6ecVTojsEJe6AYxCX2/NXly/0LoENDn37Jw
        W3Fxt6j/tARysHcBC
X-Received: by 2002:ac8:845:: with SMTP id x5mr18054485qth.42.1567940744063;
        Sun, 08 Sep 2019 04:05:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzWSBaHX6xbj2IMf12T1d2jOLe4XYAW+o7heTvxil6hRKkUH9dOz/sVHUORF99wcOY9BFlSSQ==
X-Received: by 2002:ac8:845:: with SMTP id x5mr18054478qth.42.1567940743938;
        Sun, 08 Sep 2019 04:05:43 -0700 (PDT)
Received: from redhat.com ([212.92.124.241])
        by smtp.gmail.com with ESMTPSA id 139sm5217532qkf.14.2019.09.08.04.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Sep 2019 04:05:43 -0700 (PDT)
Date:   Sun, 8 Sep 2019 07:05:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC PATCH untested] vhost: block speculation of translated
 descriptors
Message-ID: <20190908110521.4031-1-mst@redhat.com>
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
---
 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5dc174ac8cac..0ee375fb7145 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2072,7 +2072,9 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 		size = node->size - addr + node->start;
 		_iov->iov_len = min((u64)len - s, size);
 		_iov->iov_base = (void __user *)(unsigned long)
-			(node->userspace_addr + addr - node->start);
+			(node->userspace_addr +
+			 array_index_nospec(addr - node->start,
+					    node->size));
 		s += size;
 		addr += size;
 		++ret;
-- 
MST
