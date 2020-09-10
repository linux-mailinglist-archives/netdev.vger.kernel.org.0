Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0666263F2B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgIJH4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgIJH4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 03:56:47 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B66DC061573;
        Thu, 10 Sep 2020 00:56:47 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m15so522552pls.8;
        Thu, 10 Sep 2020 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JNiVOnXoOmxnAqeInt5hP731APRpSiA1TTMc4u8CbeY=;
        b=eJMQUEeROFf5Pr5SDTd6xxzG1DUkMZs7oscC84zhAORZtUKSgHlPCFeUXd0VXt4jX8
         NBE5I+PQA60uy6V/YSEI2BovVkMNac53s5Ivmw1CQSoXooWfbHnhVX6Mtq1YffKUOP/b
         nRXvBYctQgXQKTNe//xAHLh5Gpvzzk/bxtndANcSIl5Pn3/eIlx+YqsrrgLJGwcTuKqv
         vfAx3pYBS9fwmS/C+XytUUFBD6UnZ1ruiNQT6aOxd35ChgLNz/ssmRb2UKUhPcSVlQH+
         wArASng+GVtqA77XhK8sWOI0Itdq4cLFlLanTYi0dzT0RpWzcmm3J5CHP8cQLFWjoyuj
         NdDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JNiVOnXoOmxnAqeInt5hP731APRpSiA1TTMc4u8CbeY=;
        b=DMWebERPL4pbbgFbasq4Q1C7Cdc7y2A2pmedHW7BFyCp8YyF3vG0zsuHB0WCAdNu5/
         Zp4zFNgGyZ77WXe136P4P9oMRtj5rpEk6N8U3LOccdFe42QuoBJOqD5Ij5qy9LD9x84G
         YewdG32JcLJ7rEbcTJBZBkvYwVzxj4bSsgsDIBSfacw6nVf0CmliWrZvjwuKztmWLwv3
         nGqZaKFhLG0eqYpWhUVheaxf+rue670WxP1MAHP0G8k+QzKRnSL09nedHfOUp1cxM5HA
         KwwFlvUAEfnbxJhzwNNNgxID4UZGddz8H8uW9GNrJtDD2S3GxdAGXbqE1s+9zqxogB3l
         0Bew==
X-Gm-Message-State: AOAM530B0Aj8PoEXzKT/KsSNSb7H/SJftcPM28HsEA8UQ0HUXkVygCF6
        ieaJ6p6zI25P8oXvALIqje464kqy/JjpSVHy
X-Google-Smtp-Source: ABdhPJw6VhWR5D1jFVLOmkYyYca+xejAQj1GUf1+HxVZAIPNNLnOE2s/x3Mwu/vqBpuR8IbF4eciCg==
X-Received: by 2002:a17:902:74c7:: with SMTP id f7mr4531949plt.144.1599724606163;
        Thu, 10 Sep 2020 00:56:46 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id j20sm4756070pfh.146.2020.09.10.00.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 00:56:45 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@nvidia.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, ciara.loftus@intel.com
Subject: [PATCH bpf] xsk: fix number of pinned pages/umem size discrepancy
Date:   Thu, 10 Sep 2020 09:56:09 +0200
Message-Id: <20200910075609.7904-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

For AF_XDP sockets, there was a discrepancy between the number of of
pinned pages and the size of the umem region.

The size of the umem region is used to validate the AF_XDP descriptor
addresses. The logic that pinned the pages covered by the region only
took whole pages into consideration, creating a mismatch between the
size and pinned pages. A user could then pass AF_XDP addresses outside
the range of pinned pages, but still within the size of the region,
crashing the kernel.

This change correctly calculates the number of pages to be
pinned. Further, the size check for the aligned mode is
simplified. Now the code simply checks if the size is divisible by the
chunk size.

Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
Reported-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xdp_umem.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index e97db37354e4..b010bfde0149 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -303,10 +303,10 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
+	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
-	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
 	u64 npgs, addr = mr->addr, size = mr->len;
-	unsigned int chunks, chunks_per_page;
+	unsigned int chunks, chunks_rem;
 	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -336,19 +336,18 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if ((addr + size) < addr)
 		return -EINVAL;
 
-	npgs = size >> PAGE_SHIFT;
+	npgs = div_u64_rem(size, PAGE_SIZE, &npgs_rem);
+	if (npgs_rem)
+		npgs++;
 	if (npgs > U32_MAX)
 		return -EINVAL;
 
-	chunks = (unsigned int)div_u64(size, chunk_size);
+	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
 	if (chunks == 0)
 		return -EINVAL;
 
-	if (!unaligned_chunks) {
-		chunks_per_page = PAGE_SIZE / chunk_size;
-		if (chunks < chunks_per_page || chunks % chunks_per_page)
-			return -EINVAL;
-	}
+	if (!unaligned_chunks && chunks_rem)
+		return -EINVAL;
 
 	if (headroom >= chunk_size - XDP_PACKET_HEADROOM)
 		return -EINVAL;

base-commit: 746f534a4809e07f427f7d13d10f3a6a9641e5c3
-- 
2.25.1

