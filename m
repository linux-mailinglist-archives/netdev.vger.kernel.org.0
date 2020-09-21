Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5372718ED
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgIUBJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIUBJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A10C0613CF
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so7518349pgd.5
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KxX++AHaKzTjXw7TwUS3IWSavzlkxgBJf3fj3bYWvEY=;
        b=SWGqHguDVsB6raj3/CF7tcLNoScguKbNgv0zBGJ4914bg6X3U1/S3pXQsPXQxs5Tir
         CVoixP9pHyTk9XGS9sCPcK3vzrTLwhKYa3gwiGJ1+TeQSh27I1Kw2EMjIAZbhpK4HI3l
         FwoET6udegsveXCwibnShMclKgiCmFALerhrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KxX++AHaKzTjXw7TwUS3IWSavzlkxgBJf3fj3bYWvEY=;
        b=ck2lUfnwB6zjK1wVcdnV0qrgL4fKzuEnPX92FCRxLYjtKdmL+wyL13tk3H+uwkoNIS
         CXeFb6nDmaUQjLRahgPj5UUl8JijACyJ0Jo5Foivhpfm7uT97o/x8rDGd1oP39xCgxMu
         /2qwXGSRzYL5K80KPmAq0cl1NGh74MEq2R7dfoKngYfcISkHiNX/BiG1F7gB+3YEdgD2
         ZZ2zbCN3qZ8y1uv72YTRb5TSVgxBsD9pPIyynbNsAGk8tpmwU1/TkCPMxOQTwnhGW3YF
         ECkW0S/9qKszbYdEifXY8nmIPwQxQaTKYUgUr/XICni6datCggQ6gdv6c3pwlW+MGluB
         RZMQ==
X-Gm-Message-State: AOAM531XZxjoJZ8ftA8I9ak9kXhG/X1OKPviQL5XTj9UOhIa1z3ZkVgz
        bFw2uVk1HJeGCQUi7DxhaPXcaA==
X-Google-Smtp-Source: ABdhPJw30LZQHqx2yXnsQrMt11GpqIZqu1cyCOuql7Y/SqzRundjr3hpPTKKgDnY/mB2d9CUOPuZQw==
X-Received: by 2002:a63:4450:: with SMTP id t16mr35332258pgk.3.1600650565715;
        Sun, 20 Sep 2020 18:09:25 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/6] bnxt_en: Fix wrong flag value passed to HWRM_PORT_QSTATS_EXT fw call.
Date:   Sun, 20 Sep 2020 21:08:59 -0400
Message-Id: <1600650539-19967-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wrong flag value caused the firmware call to return actual port
counters instead of the counter masks.  This messed up the counter
overflow logic and caused erratic extended port counters to be
displayed under ethtool -S.

Fixes: 531d1d269c1d ("bnxt_en: Retrieve hardware masks for port counters.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d527c9c..7b7e8b7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3853,7 +3853,7 @@ static void bnxt_init_stats(struct bnxt *bp)
 		tx_masks = stats->hw_masks;
 		tx_count = sizeof(struct tx_port_stats_ext) / 8;
 
-		flags = FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK;
+		flags = PORT_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK;
 		rc = bnxt_hwrm_port_qstats_ext(bp, flags);
 		if (rc) {
 			mask = (1ULL << 40) - 1;
-- 
1.8.3.1

