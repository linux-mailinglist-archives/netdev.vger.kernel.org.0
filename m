Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87CA2718EC
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgIUBJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgIUBJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C86C0613CE
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:25 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id u13so7539481pgh.1
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NpE1OCsFU+Vtyk8DXmhKbmxeWvTYioTM7yOEKEB1nu4=;
        b=IRJWcYiH22HGWVpaWUcruOJ32PprMeMo4s8USWWowzaJ1HKeaCgGtjDwYabB8p8Dd0
         x94HYDaCJJwcyko6Zd/ixzxQw42S+H7Jh3XOzGkntT9EuuI7raerIAOvpEFVyuujHnQC
         /pEarhH5xw99mKIgBci0EBPHqniErKdm5L8vA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NpE1OCsFU+Vtyk8DXmhKbmxeWvTYioTM7yOEKEB1nu4=;
        b=ozefKT0PLl+F840ulvrn1n8e3ZP9jxEXf2vMd0ItkUnrtB9JQOGJkAXC5F4Ct12I2I
         qV8U8hjsCUACuXzQJ2N7EXgxNZ2VmCKTjQX1F1XrewBAdH0x3VWTcWEfQZ5cHFw3uzH6
         i/y+LhI9TIjh8ssaxEtTUoe9zjVdojee24CleUB1tBVRFbNWTB1tv6yhiis4sFqEGLrD
         qlERqXsXuLzcBtJOIw+30QZ1tMRlXUYRG8OYElBoQ01qdclBbpObD536g78ikBgWjtCb
         fMpMb2sDhDkbSIlsVobCBo0MDNbHrpLCWM6cbeK5aQX3ZSkZFcpd+sH9RrxlXXG499Iy
         hHRw==
X-Gm-Message-State: AOAM532ZqU05l8M63BqYwk9AzTh2LSE951aPqqL64lggSqQ+AGPf1tMA
        wdRsF5Ae9pSwVtcYY5pxEaJ58Fjy9KTskg==
X-Google-Smtp-Source: ABdhPJzaFNg/GhDPHiyJI6PDHDZUbaYhUnbVPDwgC38iHEq3O/J6Ctl+EYUKCb1XpiYIdYdDvBLrhg==
X-Received: by 2002:aa7:9583:0:b029:142:2501:396a with SMTP id z3-20020aa795830000b02901422501396amr25345538pfj.47.1600650564807;
        Sun, 20 Sep 2020 18:09:24 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/6] bnxt_en: Fix HWRM_FUNC_QSTATS_EXT firmware call.
Date:   Sun, 20 Sep 2020 21:08:58 -0400
Message-Id: <1600650539-19967-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix it to set the required fid input parameter.  The firmware call
fails without this patch.

Fixes: d752d0536c97 ("bnxt_en: Retrieve hardware counter masks from firmware if available.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2865e24..d527c9c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3782,6 +3782,7 @@ static int bnxt_hwrm_func_qstat_ext(struct bnxt *bp,
 		return -EOPNOTSUPP;
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_QSTATS_EXT, -1, -1);
+	req.fid = cpu_to_le16(0xffff);
 	req.flags = FUNC_QSTATS_EXT_REQ_FLAGS_COUNTER_MASK;
 	mutex_lock(&bp->hwrm_cmd_lock);
 	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-- 
1.8.3.1

