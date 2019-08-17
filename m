Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36FAA912F0
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfHQVFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33755 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so4701917pgn.0
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mmW8YPtsz/Pq3tMA0Dog6lLToNJ746rqL0VUwvy/URM=;
        b=bNysoYjahYt4D9P0DRAWz32ecl1vsThBNyEYM1RBlgnHtgchgDRPij48L4LmTbS5Xl
         x9YvC5PF7QPqTvAE0IgsQKg/YoiHHCi5k139Ia42wu/rDTnppVcVGk7TQCrSbJGNTLik
         tURemrtGsziatF2he83piGl/cC6cJ7fsWngAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mmW8YPtsz/Pq3tMA0Dog6lLToNJ746rqL0VUwvy/URM=;
        b=raRQ6XEIiifEGT6S4x1s6fk/JdVH/Hb+hGsstxHsiW6ffP4K0/t6cBOzQQt35A5ZCM
         8DHlgSL0g2IfvM7SEcjKqmpomrL8gU9zcsgSlvKGjsrSJTrGpUCzd5gF6WJihy8upm3s
         dpTN6+CeBZzbJeZcx0HBSbn5t9WhmrPC2msKkpg1pqKA+I+rmM3ru67pus+XNHvYEfsn
         biGBERlcptEBUo2cKJJ/VNZSifFaXEsrFZonUjX2QXGIoSyfgLxPL6teFxcI7YaFHiu/
         c15Ig0G8Dq2GJo3F4tCN7WakMtSby1rDsiWz2aFDaerorxsbizDaDtH1CG3uSqqFfDfG
         GX1g==
X-Gm-Message-State: APjAAAWgWNY9dthX9mKk3WKca9Jek5Hd0L4m3MBB5sN2/Vb9F1F8vwul
        NK7caJoNPqeKi4/3HxzjiF32/A==
X-Google-Smtp-Source: APXvYqxMJjizASkcQ3d9iyw2jHwBPnoHJRHgo5RrktjjFqefoOxxH78efs39OQSKqqq0gnW8IsqN2g==
X-Received: by 2002:a17:90a:1110:: with SMTP id d16mr13870092pja.29.1566075935791;
        Sat, 17 Aug 2019 14:05:35 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:35 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Subject: [PATCH net v2 5/6] bnxt_en: Use correct src_fid to determine direction of the flow
Date:   Sat, 17 Aug 2019 17:04:51 -0400
Message-Id: <1566075892-30064-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
References: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>

Direction of the flow is determined using src_fid. For an RX flow,
src_fid is PF's fid and for TX flow, src_fid is VF's fid. Direction
of the flow must be specified, when getting statistics for that flow.
Currently, for DECAP flow, direction is determined incorrectly, i.e.,
direction is initialized as TX for DECAP flow, instead of RX. Because
of which, stats are not reported for this DECAP flow, though it is
offloaded and there is traffic for that flow, resulting in flow age out.

This patch fixes the problem by determining the DECAP flow's direction
using correct fid.  Set the flow direction in all cases for consistency
even if 64-bit flow handle is not used.

Fixes: abd43a13525d ("bnxt_en: Support for 64-bit flow handle.")
Signed-off-by: Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index 6fe4a71..6224c30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1285,9 +1285,7 @@ static int bnxt_tc_add_flow(struct bnxt *bp, u16 src_fid,
 		goto free_node;
 
 	bnxt_tc_set_src_fid(bp, flow, src_fid);
-
-	if (bp->fw_cap & BNXT_FW_CAP_OVS_64BIT_HANDLE)
-		bnxt_tc_set_flow_dir(bp, flow, src_fid);
+	bnxt_tc_set_flow_dir(bp, flow, flow->src_fid);
 
 	if (!bnxt_tc_can_offload(bp, flow)) {
 		rc = -EOPNOTSUPP;
-- 
2.5.1

