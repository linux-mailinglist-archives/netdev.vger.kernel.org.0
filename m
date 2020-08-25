Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA42517F2
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgHYLk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730027AbgHYLga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 07:36:30 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E5FC0613ED;
        Tue, 25 Aug 2020 04:36:22 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id ds1so1116246pjb.1;
        Tue, 25 Aug 2020 04:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0D1IRpXS9A/gM5G1vVZT30mGYc3nb9zLCzTnVKaIp0Q=;
        b=kJ/OjMY/0zKjOsjwXbWe80OaUcrCWI2VaXvSlTeKsqE/pX4FYryY+C6pLo7Zshe01D
         JiL4Yu1reJroYMY0XzsVs52vmfe/eX+AB9pdeJAe7OHpJoZcvD8BWuCbQfA2bKVF3tB6
         mvN1ay89Qqv9RcqMHYEYJoPHZQpStIptLmEzOS3hepeAaBRMp+Pib3AODqBnTPDgGEIK
         AKKJpdXv12RdvewPtJrVhPey/YpwcdPbPz4C8gtk1fPnxeQgs4gAHA8H5Ll16OaR9RwW
         40GQVAaZw0g/Or1vIDEjlbTdK39oAuBHSrrgZvZ+sAWp+hyiTDUtR1K7O8ZQGrs1Sla7
         7kdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0D1IRpXS9A/gM5G1vVZT30mGYc3nb9zLCzTnVKaIp0Q=;
        b=Moq2VDWSX2eOCnqhHaZL3ODXk/HVGKQRCcuK0nX1X7Ss3KBe98YT4soTEcVi0IHbIi
         RUv2tMx08FG/Xd5xmHFWvgxlnghm5qVWkVOwr0+ovv7zaUi6SBXSxYT9oEs9ymTxI860
         mqcmxU8551RqXBsr6G03OwP7KXXzyqeso0WpUih9Xxsuw1W/FZoIxOzKUuDMKam7p1ww
         muGLjZ6pWg/1CmKQ8NcnZvZC+6+8W4UgnFuOuWvwlIiotPENuvwaPeOKtwAv3V2ZYS95
         NiOozBKbOJrAfp6DFEXhqv6DoFzAHQmjMjzFb8LJlZ9iL3g/X3PHBfNdiI8rikJbLn9u
         zzkg==
X-Gm-Message-State: AOAM5315sPbA9I6hltsn935W6HP2t2/JqYtc4c5XYfx5KOxuyWqtv2HN
        AjYFrj6VuwwZEQcCRKLptFg=
X-Google-Smtp-Source: ABdhPJxHHZOwCMiCYZq1sRRMNmhU/TdDDnu697pELj/7wX2ML19Au0dKJA6pClE6hVfKwDNZu9wyTA==
X-Received: by 2002:a17:90a:9203:: with SMTP id m3mr1266792pjo.148.1598355382229;
        Tue, 25 Aug 2020 04:36:22 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id e7sm12699937pgn.64.2020.08.25.04.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 04:36:21 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 3/3] i40e, xsk: move buffer allocation out of the Rx processing loop
Date:   Tue, 25 Aug 2020 13:35:56 +0200
Message-Id: <20200825113556.18342-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200825113556.18342-1-bjorn.topel@gmail.com>
References: <20200825113556.18342-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Instead of checking in each iteration of the Rx packet processing
loop, move the allocation out of the loop and do it once for each napi
activation.

For AF_XDP the rx_drop benchmark was improved by 6%.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 1f2dd591dbf1..ae40592c31f9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -277,8 +277,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
-	bool failure = false;
 	struct sk_buff *skb;
+	bool failure;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
@@ -286,13 +286,6 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		unsigned int size;
 		u64 qword;
 
-		if (cleaned_count >= I40E_RX_BUFFER_WRITE) {
-			failure = failure ||
-				  !i40e_alloc_rx_buffers_zc(rx_ring,
-							    cleaned_count);
-			cleaned_count = 0;
-		}
-
 		rx_desc = I40E_RX_DESC(rx_ring, rx_ring->next_to_clean);
 		qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
 
@@ -367,6 +360,9 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 		napi_gro_receive(&rx_ring->q_vector->napi, skb);
 	}
 
+	if (cleaned_count >= I40E_RX_BUFFER_WRITE)
+		failure = !i40e_alloc_rx_buffers_zc(rx_ring, cleaned_count);
+
 	i40e_finalize_xdp_rx(rx_ring, xdp_xmit);
 	i40e_update_rx_stats(rx_ring, total_rx_bytes, total_rx_packets);
 
-- 
2.25.1

