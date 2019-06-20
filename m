Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DDE4CB89
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfFTKHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:07:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:47084 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfFTKHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 06:07:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so1369742pfy.13;
        Thu, 20 Jun 2019 03:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IfwA+i6YnmMV9WMF2Z9ZZedLVyNXMmnDcYm2Z0HfTLk=;
        b=EDKGNiyDRTJsmKCDATuGi950qlcuZ5tMqnt3WkbO1NdIPDSoYtg0C5wfe5rtUUdHE9
         iygeHSQJTt39HVqIwb2S/X12rYRDN4ytdaPkucJFvx8yUB03PI2nqBbYJYD7pmzT1fBS
         kwB4Jkt7kshH9GVk7whaGWId/2XUyPDU5UfKjbvj5CuFrVJX5oNYziO0+8kLy5veu4Pk
         yRzKl/ykRWHFH2/v82Lq00ygPENQLt6Xgr349FF3yrh9JI9lrQyhgqdUSevtJuUCBT/J
         +mPnVSj/Qe2RDVTjj1GZTQC2x2A+uDJvXDDA6sT1leKTcQMNRbKYJdmKkGwBuuKdgLrV
         np7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IfwA+i6YnmMV9WMF2Z9ZZedLVyNXMmnDcYm2Z0HfTLk=;
        b=QDTYUp9CALNQZkVUbV5FJC0bYPsI30PCJxmIuwBZvG1tJ/7g+yoV59IrJEbVOp4aVU
         xqZkwKxjbxVL0EdYoddf/AM2OLo3SdxHGoNRfHNvz8N3XmLn4qMavbg83JVKs68V4yw/
         DqRFkgvoR7+p+x3EsMu9SVT1SGDPuRFgbPaprFq/c5Hm537zibve0nD/nnQMkIDPK3K8
         toOSEuKeubLSbQhYb0h/gY7fTzINqNh9x9zz6vouTRoCAucuPSGGaICw7AJJy/rXHRAM
         buorbh4ii2ymgdf0Hho71PU7sNs+B0uFl+bMIbxS715ze23BVbi4um33Bbn46kumkOMC
         Vnuw==
X-Gm-Message-State: APjAAAVPCvpe3z4dTCdbl2rAEEPNL/7qEQVQZc9kByLhPNbzUkAA7JOZ
        m4K2oqmc3zN0gQ30je1q8+c=
X-Google-Smtp-Source: APXvYqwTWk6Pxr6Q216d7K6EIDBd91tsL13ybgoiYOgL/Z2P3m/QPkuAK/6smY5OanprNR4qZzeRkA==
X-Received: by 2002:a63:18c:: with SMTP id 134mr7476375pgb.432.1561025251420;
        Thu, 20 Jun 2019 03:07:31 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.41])
        by smtp.gmail.com with ESMTPSA id y22sm41574267pgj.38.2019.06.20.03.07.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 20 Jun 2019 03:07:31 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bruce.richardson@intel.com,
        songliubraving@fb.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 2/2] xsk: support BPF_EXIST and BPF_NOEXIST flags in XSKMAP
Date:   Thu, 20 Jun 2019 12:06:52 +0200
Message-Id: <20190620100652.31283-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190620100652.31283-1-bjorn.topel@gmail.com>
References: <20190620100652.31283-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flags when updating
an entry. This patch addresses that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/xskmap.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index af802c89ebab..096cb4b92283 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -227,8 +227,6 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -EINVAL;
 	if (unlikely(i >= m->map.max_entries))
 		return -E2BIG;
-	if (unlikely(map_flags == BPF_NOEXIST))
-		return -EEXIST;
 
 	sock = sockfd_lookup(fd, &err);
 	if (!sock)
@@ -254,15 +252,29 @@ static int xsk_map_update_elem(struct bpf_map *map, void *key, void *value,
 
 	spin_lock_bh(&m->lock);
 	entry = &m->xsk_map[i];
+	old_xs = *entry;
+	if (old_xs && map_flags == BPF_NOEXIST) {
+		err = -EEXIST;
+		goto out;
+	} else if (!old_xs && map_flags == BPF_EXIST) {
+		err = -ENOENT;
+		goto out;
+	}
 	xsk_map_node_init(node, m, entry);
 	xsk_map_add_node(xs, node);
-	old_xs = xchg(entry, xs);
+	*entry = xs;
 	if (old_xs)
 		xsk_map_del_node(old_xs, entry);
 	spin_unlock_bh(&m->lock);
 
 	sockfd_put(sock);
 	return 0;
+
+out:
+	spin_unlock_bh(&m->lock);
+	sockfd_put(sock);
+	xsk_map_node_free(node);
+	return err;
 }
 
 static int xsk_map_delete_elem(struct bpf_map *map, void *key)
-- 
2.20.1

