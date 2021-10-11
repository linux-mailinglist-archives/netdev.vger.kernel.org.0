Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CA4429390
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243534AbhJKPjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243328AbhJKPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 11:39:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316D3C061768
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso23644235ybq.10
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 08:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PSjfyu1ChdlgSSxfTzhpeyMZixB5wwmSjmCj88bzjYo=;
        b=P84YpPAt66Glt/fiB1PM2P1gvmvBMpbG9GWEG7/CMWx7p+OdxHrozecW3i68+emqW2
         8LuEcHfFOVhdu0EolHQaj0hlosAYG1L41wANMaZTnlHGMb6o/AJGe+aJOkZQdcsZUfIF
         j7Utyq29wAeQpMYabODdSjLjfRhqRhbJfXkB9MixYfQLMg/ENDLIXA6l7PEKNixEuY5R
         23c6crpeScfjNW8UpRjiXUQJmtrJ2qAwdxCSd8lWME3u/7HuIYWsfNMyApOCV87AT5zf
         C3PZ5oMOS+2HSSgwMzvQTobvitZGnCaqvYHlKtTJI71Oko5MTwpACPgrhJ0eV30AzvZn
         P4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PSjfyu1ChdlgSSxfTzhpeyMZixB5wwmSjmCj88bzjYo=;
        b=RNWLt2ITkfS7fFY9Lasj9oqqw7I6udIzYfUJzg6mFDb9K5CRI2kMKYLHZLAw653+KK
         hg6eIs30SqhMgITFpW3YCMGOwNQRS3oGWDhM+2L6hePEd1P/+WGdRyXZzq1Op7r4A8TY
         oQaDa1cMXh1I2G0KSvOqjxaYD01I2Qa6kbTgxSi0aV96Ovw1vUHd1UThFurR6rvUCbfd
         qMffcJ65852PgkECxzLJHqxlMdYnE3CSo99tdEKY+tATFuw/Eq0rDXwFpw4fQ5RELV4K
         Uy7IT4ABQu1xGTPe3r3IBqRyFNEwjHoD+QbxzOQsIm8Or3khHmABWyMT/ZLmLr+JnjlG
         RSXw==
X-Gm-Message-State: AOAM530CCPTUutaf5Ept8QA/eNCYxBc5jO9Lb1EjcLnvp3jFCAPWxx4k
        I4eMjNF4Dhnbrx7zngQrwjU2CCwRIvsL7DOTVT+0Qhn1JBxpN2TGfSqovI95XeX2cxNOfeygeXD
        xgDQ3/iyh6iEdna651Q/qpfwvEkWTe5f8KM8GtDL/HNErBp9xsPZwlLykcX00wRYkmPk=
X-Google-Smtp-Source: ABdhPJwjxa4W0W4qsQqeIVP+bkr8eHFYen20xVFL1ELQbhk8T8z8IaWbF0OSpoj4rrWCwWMewtB826hAq2gTag==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:94b6:8af3:6cef:e277])
 (user=jeroendb job=sendgmr) by 2002:a25:6106:: with SMTP id
 v6mr22526347ybb.531.1633966626411; Mon, 11 Oct 2021 08:37:06 -0700 (PDT)
Date:   Mon, 11 Oct 2021 08:36:50 -0700
In-Reply-To: <20211011153650.1982904-1-jeroendb@google.com>
Message-Id: <20211011153650.1982904-8-jeroendb@google.com>
Mime-Version: 1.0
References: <20211011153650.1982904-1-jeroendb@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH net-next v2 7/7] gve: Track RX buffer allocation failures
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

The rx_buf_alloc_fail counter wasn't getting updated.

Fixes: 433e274b8f7b0 ("gve: Add stats for gve.")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 98ba981cd534..95bc4d8a1811 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -532,8 +532,13 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 
 				gve_rx_free_buffer(dev, page_info, data_slot);
 				page_info->page = NULL;
-				if (gve_rx_alloc_buffer(priv, dev, page_info, data_slot))
+				if (gve_rx_alloc_buffer(priv, dev, page_info,
+							data_slot)) {
+					u64_stats_update_begin(&rx->statss);
+					rx->rx_buf_alloc_fail++;
+					u64_stats_update_end(&rx->statss);
 					break;
+				}
 			}
 		}
 		fill_cnt++;
-- 
2.33.0.882.g93a45727a2-goog

v2: Unchanged
