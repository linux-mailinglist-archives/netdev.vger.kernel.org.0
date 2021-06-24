Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6BE3B353D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhFXSKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbhFXSJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 14:09:59 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF02C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:39 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 5-20020ac859450000b029024ba4a903ccso7150064qtz.6
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 11:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tjrFmAcdGmdXBIkucBkkFjt61nWL/7f+vFW1EC6EKf8=;
        b=KuewAeq13aB/qhBq90fGY90QnPR6yt+Evt+ncQScRLYXt0Uqe6jof8vsNZH8ZBK4Jd
         CDCWXb8xa9UVpfEomP5iDBoEJkfSTOi1HfygRsMnc5JV1Nmu+rgOEjML0eE+K5uirpSH
         4Zxt24vvk/QpINL8u318QVvHZ+OPbNvh+xEYuCu031z8Nc+twGe3n3jRm8KDPeBDDqKN
         tNRO3YI+7mdF3idILiY/kRZrmiD7IvNH5AT7Q6H3Ke3r3OEcFX1unvzt1ElkBO4PEpqr
         t7taLIGIzgZgkcngJzR9XrqRnVbA9bm/VSQXJ6DXhNCtf1DyE+DT18SyMl8DTUgPWpiz
         n1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tjrFmAcdGmdXBIkucBkkFjt61nWL/7f+vFW1EC6EKf8=;
        b=LhFiTn9edn6/h6FcQOsKfCVy2bZZWivCQ6N3LnT/zqNr7EReW0nU6lUFW8YvRMEQvf
         l6+r7T1fNJHqDareWUBVQtQh++sMTwskoZ5vfQkFF+0gZkxJ0n+R5fWTMYM7WlhmDYHg
         BCIlfHjCislDb/neJQlwc9NJHxZJBGUgDzovtcKmQsYhHo4uVdb4V7JMvz7zyRRa9zCe
         X75vfVcFwyuD1GQyiVkDAkiufV7Q6xhLMFeWahQEAlHBl1S2eDHPFPoA0CFIKNNLUL70
         lHyxdX+r0t0w4jo+AOlv2ZGNNOgR0d81u9nh5/5Pem3FO3hvx6d0JNwl4QXLVVBzuVVk
         2qAQ==
X-Gm-Message-State: AOAM530oZBGY03RpPEDir/xAhf6VXgIB/2I8TqhI33PkTKf2B4LmsS4b
        ijO0H1FRoTyTfMEgWrgoxtOO/xg=
X-Google-Smtp-Source: ABdhPJxG3uWRw5DbguAoIeybVA3vQFQgbxQRDo/4zZ0DOfoi0NWRZNfEbNSVuBXGDpK7ahVkS597GPE=
X-Received: from bcf-linux.svl.corp.google.com ([2620:15c:2c4:1:cb6c:4753:6df0:b898])
 (user=bcf job=sendgmr) by 2002:a0c:bf01:: with SMTP id m1mr6801214qvi.13.1624558059004;
 Thu, 24 Jun 2021 11:07:39 -0700 (PDT)
Date:   Thu, 24 Jun 2021 11:06:20 -0700
In-Reply-To: <20210624180632.3659809-1-bcf@google.com>
Message-Id: <20210624180632.3659809-5-bcf@google.com>
Mime-Version: 1.0
References: <20210624180632.3659809-1-bcf@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH net-next 04/16] gve: Make gve_rx_slot_page_info.page_offset an
 absolute offset
From:   Bailey Forrest <bcf@google.com>
To:     Bailey Forrest <bcf@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using `page_offset` like a boolean means a page may only be split into
two sections. With page sizes larger than 4k, this can be very wasteful.
Future commits in this patchset use `struct gve_rx_slot_page_info` in a
way which supports a fixed buffer size and a variable page size.

Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve.h       | 4 ++--
 drivers/net/ethernet/google/gve/gve_rx.c    | 4 ++--
 drivers/net/ethernet/google/gve/gve_utils.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index daf07c0f790b..5467c74d379e 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0 OR MIT)
  * Google virtual Ethernet (gve) driver
  *
- * Copyright (C) 2015-2019 Google, Inc.
+ * Copyright (C) 2015-2021 Google, Inc.
  */
 
 #ifndef _GVE_H_
@@ -51,7 +51,7 @@ struct gve_rx_desc_queue {
 struct gve_rx_slot_page_info {
 	struct page *page;
 	void *page_address;
-	u8 page_offset; /* flipped to second half? */
+	u32 page_offset; /* offset to write to in page */
 	u8 can_flip;
 };
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index c51578c1e2b2..e14509614287 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -272,7 +272,7 @@ static struct sk_buff *gve_rx_add_frags(struct napi_struct *napi,
 		return NULL;
 
 	skb_add_rx_frag(skb, 0, page_info->page,
-			(page_info->page_offset ? PAGE_SIZE / 2 : 0) +
+			page_info->page_offset +
 			GVE_RX_PAD, len, PAGE_SIZE / 2);
 
 	return skb;
@@ -283,7 +283,7 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 	const __be64 offset = cpu_to_be64(PAGE_SIZE / 2);
 
 	/* "flip" to other packet buffer on this page */
-	page_info->page_offset ^= 0x1;
+	page_info->page_offset ^= PAGE_SIZE / 2;
 	*(slot_addr) ^= offset;
 }
 
diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index eb3d67c8b3ac..a0607a824ab9 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -50,7 +50,7 @@ struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
 {
 	struct sk_buff *skb = napi_alloc_skb(napi, len);
 	void *va = page_info->page_address + pad +
-		   (page_info->page_offset ? PAGE_SIZE / 2 : 0);
+		   page_info->page_offset;
 
 	if (unlikely(!skb))
 		return NULL;
-- 
2.32.0.288.g62a8d224e6-goog

