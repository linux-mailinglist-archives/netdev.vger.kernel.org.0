Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1288EB49
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbfHOMOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:14:33 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35303 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731771AbfHOMOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:14:30 -0400
Received: by mail-lj1-f194.google.com with SMTP id l14so2059167lje.2
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=33puqWwMZjyd4TYEQvWXwTMbXdpLyUiQZumxgi8mks8=;
        b=pe3tFCbO2RnIoNE/LB44dZjDO8vQ7HB0YywwEaUvwc5hJvVjxuiE04bAv94cX33+Sb
         NgfDL1T8IKqF3c1g4406lT/qYceHkQd/qshFBjOdaqP0ZHzyj22HHZu/JeWW/rtMix7c
         m39QlnkRsMxEe5HcgnuAWA4njyQHElgbOlKYwH25btDHvOouEnZJsGaTKpnzVGBf8/yN
         R0Ph7iMRYy/FpaLft34m9NQOPCOF8oqq82MwG1boLLjuhRBGiOLFaxNaUfXg5jdJyQe2
         fmIudYQsUC1xRYY1XirqkuFbwtTbggb9/i+QGg04jjfUgpk5DfFV73t8cz/EwME7GcTN
         iuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=33puqWwMZjyd4TYEQvWXwTMbXdpLyUiQZumxgi8mks8=;
        b=YlXRSSKE30sTON96yS0jk9iubYWuc7wwob+mR6R/Fuu+A/REXTcwW7T66+/YYiuOXE
         O1VXIv9z6A+/mp935ClDOfc/NiyjTeYvvaW2jgfy7MWvz9jkt+bBaAFQKDjix9yO/TIJ
         Jur7iSvPcWVJ3U861qJRweMBgBDrqDgvWLAGw1RXcdxAdTB5u/f7z6gRiHoNvfCFoDsG
         OM+klC41Hq5AFydX7KivpIMt+qHa5E5Uzj1c8PPL/jS5sv2BIYTpOBo/9ft4b+bNd5MM
         MiWAbhELe5UHJRRj1pw25tq7/HvZKb7No/c/ZzZeFAo21sbckLxz1YwBPEomHB0qYZNt
         8CaQ==
X-Gm-Message-State: APjAAAXv/RRVDQDwlhK2uMnvHq9TPnNtvBOzI/J6uh0+ZyJjLAcJBylC
        fz84E20C+9lInp/iPrjglX5Slw==
X-Google-Smtp-Source: APXvYqybKDvJZSU8YbbGOPb9gPZTpAAbsikrVdJiMkQ2qxDuOntFONRTiz7sQbnawMO/FjK90mokGA==
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr2567234ljg.70.1565871268718;
        Thu, 15 Aug 2019 05:14:28 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id q25sm462060ljg.30.2019.08.15.05.14.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 05:14:28 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com
Cc:     davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, linux-kernel@vger.kernel.org,
        jlemon@flugsvamp.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH bpf-next v2 2/3] xdp: xdp_umem: replace kmap on vmap for umem map
Date:   Thu, 15 Aug 2019 15:13:55 +0300
Message-Id: <20190815121356.8848-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
References: <20190815121356.8848-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 64-bit there is no reason to use vmap/vunmap, so use page_address
as it was initially. For 32 bits, in some apps, like in samples
xdpsock_user.c when number of pgs in use is quite big, the kmap
memory can be not enough, despite on this, kmap looks like is
deprecated in such cases as it can block and should be used rather
for dynamic mm.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 net/xdp/xdp_umem.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index a0607969f8c0..d740c4f8810c 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -14,7 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/idr.h>
-#include <linux/highmem.h>
+#include <linux/vmalloc.h>
 
 #include "xdp_umem.h"
 #include "xsk_queue.h"
@@ -170,7 +170,30 @@ static void xdp_umem_unmap_pages(struct xdp_umem *umem)
 	unsigned int i;
 
 	for (i = 0; i < umem->npgs; i++)
-		kunmap(umem->pgs[i]);
+		if (PageHighMem(umem->pgs[i]))
+			vunmap(umem->pages[i].addr);
+}
+
+static int xdp_umem_map_pages(struct xdp_umem *umem)
+{
+	unsigned int i;
+	void *addr;
+
+	for (i = 0; i < umem->npgs; i++) {
+		if (PageHighMem(umem->pgs[i]))
+			addr = vmap(&umem->pgs[i], 1, VM_MAP, PAGE_KERNEL);
+		else
+			addr = page_address(umem->pgs[i]);
+
+		if (!addr) {
+			xdp_umem_unmap_pages(umem);
+			return -ENOMEM;
+		}
+
+		umem->pages[i].addr = addr;
+	}
+
+	return 0;
 }
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
@@ -312,7 +335,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	unsigned int chunks, chunks_per_page;
 	u64 addr = mr->addr, size = mr->len;
-	int size_chk, err, i;
+	int size_chk, err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
 		/* Strictly speaking we could support this, if:
@@ -378,10 +401,11 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 		goto out_account;
 	}
 
-	for (i = 0; i < umem->npgs; i++)
-		umem->pages[i].addr = kmap(umem->pgs[i]);
+	err = xdp_umem_map_pages(umem);
+	if (!err)
+		return 0;
 
-	return 0;
+	kfree(umem->pages);
 
 out_account:
 	xdp_umem_unaccount_pages(umem);
-- 
2.17.1

