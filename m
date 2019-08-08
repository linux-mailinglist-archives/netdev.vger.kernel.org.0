Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B857C85EB3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbfHHJiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:38:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37065 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732286AbfHHJiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 05:38:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id c9so66273788lfh.4
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 02:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KKq6Rq+EYX8ExcTVOf/aov+7OPET0b1D6K1n31UVB3c=;
        b=L7g3XM0CuaMcn8hysQiAwokrdf3uqIKmkZ8fZ7ry8SmuWC3ecsFb7VNl10/lP7yd/x
         /E0u/ayUH8PafZlMX+eET7r8DVS3gTNBCMsxDUZOPp9OzAXvNBxfoyu3Pq8ci6XkORQe
         tZFRgq9gqK1ElBj747sU15wkuSikL7IVt7CezdOFlaGps24pW942lPcXuo17N4ZBg2K4
         SPp7MeMtFQMhTLstz/zV1ZALgQI16ZpLEQ3UnLh1EsCu6jnXeo/q9jOCCTOZl64TjxeQ
         tyo8jYFPeauPU5tHKH4CppT/cCHg+74BpkE3cyHE3RzAg2xyluC015PMBevegNjPTb7i
         d7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KKq6Rq+EYX8ExcTVOf/aov+7OPET0b1D6K1n31UVB3c=;
        b=SZAnJO2dNrGYP1NElNY2DkAI9zgbmvxdLzjFL1RwVrcTjggcHoktQLwNUq85zhYQ/o
         hU0T+RavAePDomtahm408oECyK/48vlhJOX/zC+UR9DU5vDUwL4Us7aY4Qg3XVbeL9Q5
         /TvPEHdN17RVQElge+lc8ZQBWDMOn42D7nn/xLzyi1ZLJmhhbgN/YrqBmY2tJ2p99bc2
         dhXMc0rTa2RmFXN6UrZdugsxbblhgoUkCm0ABDheRKFSd9TkazKO0YSpyKzVKNyqLYcd
         5NdtDOvWcjSHFkayUIIp8MJ6rgbjQ9DKGE+xfz3NW8mquXLTnaBh6GYnWCAHfTP0wDbI
         9ECw==
X-Gm-Message-State: APjAAAWEaHlxg37bPSQBlB4+ToPCiAEZ3VC4WRvhphQ9ia6jspReTA5X
        zx0M587U7ththFHA7F/ggIoyPw==
X-Google-Smtp-Source: APXvYqyuMdt7jID+q3HcQXEifvW4J/jspv2uf3zNhF13WH6UysEsAqmZJj9n6zkM8fFyTHX7tVgVIA==
X-Received: by 2002:ac2:44ce:: with SMTP id d14mr9058953lfm.143.1565257087328;
        Thu, 08 Aug 2019 02:38:07 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id r21sm3444783lfi.32.2019.08.08.02.38.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 02:38:06 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, hawk@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 bpf-next] xdp: xdp_umem: fix umem pages mapping for 32bits systems
Date:   Thu,  8 Aug 2019 12:38:03 +0300
Message-Id: <20190808093803.4918-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kmap instead of page_address as it's not always in low memory.

Acked-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on bpf-next/master
v2..v1:
	included highmem.h

v1: https://lkml.org/lkml/2019/6/26/693

 net/xdp/xdp_umem.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..a0607969f8c0 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -14,6 +14,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/idr.h>
+#include <linux/highmem.h>
 
 #include "xdp_umem.h"
 #include "xsk_queue.h"
@@ -164,6 +165,14 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 	umem->zc = false;
 }
 
+static void xdp_umem_unmap_pages(struct xdp_umem *umem)
+{
+	unsigned int i;
+
+	for (i = 0; i < umem->npgs; i++)
+		kunmap(umem->pgs[i]);
+}
+
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
 	unsigned int i;
@@ -207,6 +216,7 @@ static void xdp_umem_release(struct xdp_umem *umem)
 
 	xsk_reuseq_destroy(umem);
 
+	xdp_umem_unmap_pages(umem);
 	xdp_umem_unpin_pages(umem);
 
 	kfree(umem->pages);
@@ -369,7 +379,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	}
 
 	for (i = 0; i < umem->npgs; i++)
-		umem->pages[i].addr = page_address(umem->pgs[i]);
+		umem->pages[i].addr = kmap(umem->pgs[i]);
 
 	return 0;
 
-- 
2.17.1

