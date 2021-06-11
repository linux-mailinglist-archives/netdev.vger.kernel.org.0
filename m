Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AEB3A4932
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhFKTHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhFKTHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:07:35 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15479C0617AF
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:36 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id i13so6118747ilk.3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vZEwEVBDEvCxZgVoTN4odpB95bOFDOiTrujBE+grmHw=;
        b=GODL4EQkGQXW7NnrcMbNEp9Q7LZU1Uas5K0o2f6nyIiJdB/Vy0H9OKhwx9CUrxvv+D
         bbReoR4eQEW81BQQL/T3CFaG5cYhqpshijVgZYecg8EyCu5Bqictl7u16lArAH+VC3jq
         lo8mXnF7nSj+82us+iIUwuktPkS1dzZaMlxlYPSXNW+ml5n6HMLW1YYRInRmmJWX9y73
         xRqfUla7wO8cOGtGQPgLbLp68swLewAPgMosWlZYJ3jKO15w2FtGiD2HVJuPtUZ8Jhu6
         goBLUyOeiNM+kshrpEy7lB2EsBo9tphJLgnjkj61/EwCcb2gMSsaoVhAPIiVOthIdxH8
         DLTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZEwEVBDEvCxZgVoTN4odpB95bOFDOiTrujBE+grmHw=;
        b=dMwj1HD/mAuNliK0AcGWgS7lFEaeOovtnBHqfmy037rfr8pFhPa5EgeCyH825UV0y0
         ib4yMg8wyxjZCNVt6V3ZRoF4SV0X7XizYHnMokE8FBe1Ccl7XEIauKdkoY1K6XAVyLGs
         P9UYOb+tVlBW/FsA/3e0LRH/2gucBMc3z9P6vJZlcwTbc3wkoM/rBCx3PPSu2wBomHin
         sTnoDQWmyu7IV2Dud5uHrvTrgFndxBlx2kI0AiS0C59agg2FqNOkMf4rYERke579wHTP
         syfJU60J3iPBYHnlpPqxJx47BXRcLxZoR6W+Q87NSRE4UFpVLFT0LOk8tZ4MMk72I8pV
         ZxrA==
X-Gm-Message-State: AOAM533nsqqIP9KXzMLWkIoD53ETkKJVbWxseBjG5531fKD1JHQGqZm6
        CQo0xOyyGzXHQHh5bI7KCRWvmg==
X-Google-Smtp-Source: ABdhPJwnF/bYxbZPYf7kXpBg/MRzjAcmy6m7V7CP21h6uortNQV10Cl96u+m4ikcKTn200wGkKqMtw==
X-Received: by 2002:a05:6e02:1153:: with SMTP id o19mr4404755ill.136.1623438335567;
        Fri, 11 Jun 2021 12:05:35 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: qualcomm: rmnet: use ip_is_fragment()
Date:   Fri, 11 Jun 2021 14:05:22 -0500
Message-Id: <20210611190529.3085813-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rmnet_map_ipv4_dl_csum_trailer() use ip_is_fragment() to
determine whether a socket buffer contains a packet fragment.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index cecf72be51029..34bd1a98a1015 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -50,8 +50,9 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	__be16 addend;
 
 	ip4h = (struct iphdr *)(skb->data);
-	if ((ntohs(ip4h->frag_off) & IP_MF) ||
-	    ((ntohs(ip4h->frag_off) & IP_OFFSET) > 0)) {
+
+	/* We don't support checksum offload on IPv4 fragments */
+	if (ip_is_fragment(ip4h)) {
 		priv->stats.csum_fragmented_pkt++;
 		return -EOPNOTSUPP;
 	}
-- 
2.27.0

