Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC04330B19E
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbhBAUdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbhBAUdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 15:33:19 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F821C061573;
        Mon,  1 Feb 2021 12:32:39 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f1so24681435lfu.3;
        Mon, 01 Feb 2021 12:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mm+gqPPtT3ykIJnjiqZUK3SQ00bT+N0nYZsq8iy0pto=;
        b=RaPkDX1gPwnslbiiJ17EhK4oGFZW+7DAvlkpmVxv4/2ekpMzFg+l44JlbFhSJimi4K
         a6ZfeVPYoALr9Ahhd61n47BUNkne2fPX161E4ub1KCylUgREwh3TxmWaeOByzY+Dar+S
         bADm2s8w0eb79/ldgNES0LagfWgxA1upSZ+RcHr0NmP7WgWWu28GjgNT6LTXfSpBqq1g
         s757eWXXgfYE62ojzGATr2uVoQcF3dxQF4En/J1ArGLYuTjiH4PcfBSvhKShknwFODeK
         z2S1FW0DFPFs/3rSKTCafzk/AY1D4mSf/LuGYFIaj1u6C4Wa4kdtbgowdcxdfyS61XZs
         JQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mm+gqPPtT3ykIJnjiqZUK3SQ00bT+N0nYZsq8iy0pto=;
        b=J08zRBzSYtXdLr2SpyTFE6v76GKJvMKZLzw4H5nUtB9EDDWHDKLHIrWI1UJofX8BXO
         myOpVobf6Ebq2wsvA9bPwdh65MZ2zkWDDEObg+3snMWeR3n53yWjNnqLes8x+JlWnPoC
         tSRmsZ5Gc5yuidddHn8VZuTRrGJY08sjthcYM/gYdY5vYyy3abeA0gePTcROHJo09fhn
         fkAWybU8+N7QLizB8zPKk1k3LsCY840h2Q7Ju92PKWi1B3bN9b7c+ag2Ftz+wzVaVKy+
         v/0BLiu1d2n42o6hz3YlmoEAyVKCETCg9C0lkc8+9jbNFf3yMGPhkqzr+CJK+tW39VDX
         evTg==
X-Gm-Message-State: AOAM531u0d/ZstGFYC+7Rp4QD+agZpDv3D+JTIEekVYooY1L7ebIAidp
        xpQes959ftk7MIEZRiC6H9DxhlgksKGqiIQs
X-Google-Smtp-Source: ABdhPJzglxpP8utAXB9egMWGzs+nYcPmfwE4HOvoD5SxSq1ynspf7hhnPKPUoPJR0quypq4e8qXdog==
X-Received: by 2002:a05:6512:1181:: with SMTP id g1mr5796396lfr.351.1612211557539;
        Mon, 01 Feb 2021 12:32:37 -0800 (PST)
Received: from localhost.localdomain ([37.151.209.186])
        by smtp.googlemail.com with ESMTPSA id u17sm4055497ljj.2.2021.02.01.12.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 12:32:35 -0800 (PST)
From:   Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com
Subject: [PATCH] net/rds: restrict iovecs length for RDS_CMSG_RDMA_ARGS
Date:   Tue,  2 Feb 2021 02:32:33 +0600
Message-Id: <20210201203233.1324704-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found WARNING in rds_rdma_extra_size [1] when RDS_CMSG_RDMA_ARGS
control message is passed with user-controlled
0x40001 bytes of args->nr_local, causing order >= MAX_ORDER condition.

The exact value 0x40001 can be checked with UIO_MAXIOV which is 0x400.
So for kcalloc() 0x400 iovecs with sizeof(struct rds_iovec) = 0x10
is the closest limit, with 0x10 leftover.

Same condition is currently done in rds_cmsg_rdma_args().

[1] WARNING: mm/page_alloc.c:5011
[..]
Call Trace:
 alloc_pages_current+0x18c/0x2a0 mm/mempolicy.c:2267
 alloc_pages include/linux/gfp.h:547 [inline]
 kmalloc_order+0x2e/0xb0 mm/slab_common.c:837
 kmalloc_order_trace+0x14/0x120 mm/slab_common.c:853
 kmalloc_array include/linux/slab.h:592 [inline]
 kcalloc include/linux/slab.h:621 [inline]
 rds_rdma_extra_size+0xb2/0x3b0 net/rds/rdma.c:568
 rds_rm_size net/rds/send.c:928 [inline]

Reported-by: syzbot+1bd2b07f93745fa38425@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 net/rds/rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index 1d0afb1dd77b..6f1a50d50d06 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -565,6 +565,9 @@ int rds_rdma_extra_size(struct rds_rdma_args *args,
 	if (args->nr_local == 0)
 		return -EINVAL;
 
+	if (args->nr_local > UIO_MAXIOV)
+		return -EMSGSIZE;
+
 	iov->iov = kcalloc(args->nr_local,
 			   sizeof(struct rds_iovec),
 			   GFP_KERNEL);
-- 
2.25.1

