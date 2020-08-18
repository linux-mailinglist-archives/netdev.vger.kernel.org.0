Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD547248EF4
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgHRTph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHRTpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:12 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BB3C061345
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:11 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id f5so13565739pfe.2
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/pKScq4EUsF00dUnxiUm0K80d1FnyiFU5PkdPnp0jKk=;
        b=o3NG7sfni4T6vKko3R5e+dWL2lupYGtTCLlIbR2LJbiJs7PkAAXEcsmZhX4I3QQXXZ
         VLzob21oY4k1XevP8FS2u6sabD0ISyLeSHE32fUnB0daluKfGSSMAZPJsAuws9QeyFVY
         FmQxLsloBdL8Wl571bYK9kBmiHMRZKVEm9AVxKSc4BVThREvoIHUKUBhtjEW+1GszFOT
         YRPd0tR2BcFdxbI13aRVTzQYCLDGiyUGC5t3sNA96dsSeTCkNqrfC3aR9vIObEL1oC2L
         L6pYrXliLqfGY0T8nT90Mi8gqeJFSR6w5p76Xa6ni6DH9fdeE5SV1e/IOMbuS1NhReuq
         8Btg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/pKScq4EUsF00dUnxiUm0K80d1FnyiFU5PkdPnp0jKk=;
        b=IwBVyGjLIktd8t+wcM7QfTnWFz8bedp/8m23YBH1rO3wBj8xP59ZouPYAwM2SK8hvF
         hD5s6HH+2aNmOBVrVjsLj/jD0lLjzSL/Ef4IeCGdIxIRRxDpQF3UfGJ5uT91mYGvP7P/
         N7WMIMekbya3CLfwfCDCu0NpH6xEsGtTPxcQXP0RaDrPitEqIzyffD+GAp4HFIlk8YTA
         wrz+ZFwh/MuD2lmhGSuR4j9QuZSfk2oXVtFCwGUzH5OE63wTxUkZjoIKilvzXFiRKkwa
         8UNIvZtLu7KMGOOPkdbyswSS1LL5dhz51rjSDqmX5POSJZ9HvjqQuX98vqCaHt5q66HR
         TCCw==
X-Gm-Message-State: AOAM5331pli5wUO+eWffLNKccmDguhePryfikiKlFdL7oeTsXg/9AlJS
        LLdjs9C3vfXgwYu0R6mSmb2kHqoSvR1oOZ/RV0tIxOhNlXt7jt7ivFwTIOBwnTGu4AK9LDduSVR
        +fMh5Hg+TF2n/d3Ktdpw5NzZ4Mid2annIlfFbjGQSA5v+41e4TfV4CRjZkTDoJNolQdqmIZPC
X-Google-Smtp-Source: ABdhPJziAOTVr0xCzrIdTlftt96PULqob6qKabNEZhjYue26W907HKbfZ8/jzPTeLEwtMPVwZHcJuKZKx1rkYeSh
X-Received: by 2002:a17:902:8d82:: with SMTP id v2mr6943764plo.180.1597779911021;
 Tue, 18 Aug 2020 12:45:11 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:14 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-16-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 15/18] gve: Prefetch packet pages and packet descriptors.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Yangchun Fu <yangchun@google.com>, Nathan Lewis <npl@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangchun Fu <yangchun@google.com>

Prefetching appears to help performance.

Signed-off-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Nathan Lewis <npl@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index c65615b9e602..24bd556f488e 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -447,8 +447,18 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	struct gve_rx_data_slot *data_slot;
 	struct sk_buff *skb = NULL;
 	dma_addr_t page_bus;
+	void *va;
 	u16 len;
 
+	/* Prefetch two packet pages ahead, we will need it soon. */
+	page_info = &rx->data.page_info[(idx + 2) & rx->mask];
+	va = page_info->page_address + GVE_RX_PAD +
+			page_info->page_offset;
+
+	prefetch(page_info->page); // Kernel page struct.
+	prefetch(va);              // Packet header.
+	prefetch(va + 64);           // Next cacheline too.
+
 	/* drop this packet */
 	if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR)) {
 		u64_stats_update_begin(&rx->statss);
@@ -618,6 +628,10 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 			   "[%d] seqno=%d rx->desc.seqno=%d\n",
 			   rx->q_num, GVE_SEQNO(desc->flags_seq),
 			   rx->desc.seqno);
+
+		// prefetch two descriptors ahead
+		prefetch(rx->desc.desc_ring + ((cnt + 2) & rx->mask));
+
 		dropped = !gve_rx(rx, desc, feat, idx);
 		if (!dropped) {
 			bytes += be16_to_cpu(desc->len) - GVE_RX_PAD;
-- 
2.28.0.220.ged08abb693-goog

