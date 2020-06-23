Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5652067D3
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgFWXCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 19:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388185AbgFWXCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 19:02:00 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382A8C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:02:00 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id cy7so42671edb.5
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 16:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2sqXVTvo6Nrfx3CgxvFalUAC0NEinoekNFgnjtbM1C8=;
        b=AeeLKsGTq6yg/hWGAnv2oQrxlzZg4afVAsSuC2gJebInBXAqc8B+0iOzEmCLjabIJf
         c3WIz4eapd6W4rJfbtB9LRKFFfch4wIHs2nBcEY2UxiCo3MlBLrBc6Ji1sPq5DwtvDdB
         SsNhZZHKZ2zFyPuShgHxlMchHqHkuTFL8D+kY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2sqXVTvo6Nrfx3CgxvFalUAC0NEinoekNFgnjtbM1C8=;
        b=LHlxVadsEDaFDlI/i4Vo7VKoLxSjbgcEIAaCTqh6KS5wa8Yz6L/IaoR7aopDZ9uOhH
         ilsAhR85qw9JWjVmRwOI/xdooGdCvuuI8GUPbAwdvQLZ7FktVZ91UDJ6uZdzEJkAhXiL
         SYU48y4K4bbxOk+7LNP77rzhRgtiquDJbE5A+rQX4jIPLNGRetMgXQcvaTZOZSwubfr3
         qWOzK8mMmKVFxadaQBNREyzbbs4OkyEst8kPWyOnbX+yS1lS6KvnwcWt3CezH4ar0CCV
         SmqlEqEZ46Th8CGObOxr2GTVHy3pQvxVMdBil/XOeCAyWr/9gnWnNHFy3C+ejVK04mGd
         4eYw==
X-Gm-Message-State: AOAM5307MjGchqR65f6WOU3Zkj5/Az44Y4OZChGvIizzcCvkKBaoyVZ0
        9zh5YlZ4cWfzLJ5ciAgEHU1nvQ==
X-Google-Smtp-Source: ABdhPJzyCjO4Qdgui3q1kucMPkqunuLBGz93e6L76zngolX/u0NG99Ucx28KkuiiwfExCIJKdi95Ew==
X-Received: by 2002:a05:6402:1761:: with SMTP id da1mr23683039edb.68.1592953318840;
        Tue, 23 Jun 2020 16:01:58 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cw19sm8205865ejb.39.2020.06.23.16.01.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 16:01:58 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/4] bnxt_en: Fix statistics counters issue during ifdown with older firmware.
Date:   Tue, 23 Jun 2020 19:01:37 -0400
Message-Id: <1592953298-20858-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
References: <1592953298-20858-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On older firmware, the hardware statistics are not cleared when the
driver frees the hardware stats contexts during ifdown.  The driver
expects these stats to be cleared and saves a copy before freeing
the stats contexts.  During the next ifup, the driver will likely
allocate the same hardware stats contexts and this will cause a big
increase in the counters as the old counters are added back to the
saved counters.

We fix it by making an additional firmware call to clear the counters
before freeing the hw stats contexts when the firmware is the older
20.x firmware.

Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
Reported-by: Jakub Kicinski <kicinski@fb.com>
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f8c50b1..6dc7cc4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6292,6 +6292,7 @@ int bnxt_hwrm_set_coal(struct bnxt *bp)
 
 static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 {
+	struct hwrm_stat_ctx_clr_stats_input req0 = {0};
 	struct hwrm_stat_ctx_free_input req = {0};
 	int i;
 
@@ -6301,6 +6302,7 @@ static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 	if (BNXT_CHIP_TYPE_NITRO_A0(bp))
 		return;
 
+	bnxt_hwrm_cmd_hdr_init(bp, &req0, HWRM_STAT_CTX_CLR_STATS, -1, -1);
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_STAT_CTX_FREE, -1, -1);
 
 	mutex_lock(&bp->hwrm_cmd_lock);
@@ -6310,7 +6312,11 @@ static void bnxt_hwrm_stat_ctx_free(struct bnxt *bp)
 
 		if (cpr->hw_stats_ctx_id != INVALID_STATS_CTX_ID) {
 			req.stat_ctx_id = cpu_to_le32(cpr->hw_stats_ctx_id);
-
+			if (BNXT_FW_MAJ(bp) <= 20) {
+				req0.stat_ctx_id = req.stat_ctx_id;
+				_hwrm_send_message(bp, &req0, sizeof(req0),
+						   HWRM_CMD_TIMEOUT);
+			}
 			_hwrm_send_message(bp, &req, sizeof(req),
 					   HWRM_CMD_TIMEOUT);
 
-- 
1.8.3.1

