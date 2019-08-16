Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E25990B0A
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfHPWd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41220 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727908AbfHPWdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:54 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so3818955pfz.8
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mmW8YPtsz/Pq3tMA0Dog6lLToNJ746rqL0VUwvy/URM=;
        b=Y1DWBlDDCYwcEk9dpRxltflU/6YqxpyHMG4cThBcMC9L3PWk34XAolux77E5LuVrL2
         xKdlWCd8hJiE+ijW/nY2NTxcdVAm6+3q4QUIDvNAfreJ7Jj2sE76QzFlYwbyXg35egm9
         FiDE2hyEBZZmvWQt0IYMRpsWQLvCjXVAaL2s8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mmW8YPtsz/Pq3tMA0Dog6lLToNJ746rqL0VUwvy/URM=;
        b=Sibx5tPYlhylfy9/Wkvwerm9B2oZrqvSNhEmNRgObjU6Jm6xbJy/JYPq9y42249Jd4
         p+YzFeH+2jV1l9ZOeljA+SEovZA4UPYw2BOHYpRdvZeZ81wyJ3ljFJKdFh2zosJ2gfMU
         pbx9IYJAf/GPubFfvUgOAUaU0rt28eWdPoexwv+cf8jEi8oee3MgZQDwu5nYKCziiaV6
         mbP3k1jz28lrFtbIS/wkDQPZUEUDYIVVE+RXsnAjLi9c6a7l4BFD8s8P9NHvH+5aqsmv
         lrAO619RfR9yZldvJgM9dxdE/FoviMsNz39TSKBbmfE2SyEXVEB67LVPWYW6bsI/qvmz
         QQ8g==
X-Gm-Message-State: APjAAAU87530P6C22RNUhTyU3S81J3c46MRYJu5Z1tRGADSHwjs9wMsf
        LPt6hZK75sF+IvuCcNcDDOGpgONEQKE=
X-Google-Smtp-Source: APXvYqysOa8lFi3Wlvm5TTJO8GA4SQ1SBeJBwg1HvzKrBy3K6ooOUifQ0Bhrl/PsSBhmQ+HaI7BL+w==
X-Received: by 2002:a17:90a:6581:: with SMTP id k1mr9302581pjj.47.1565994833447;
        Fri, 16 Aug 2019 15:33:53 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>
Subject: [PATCH net 5/6] bnxt_en: Use correct src_fid to determine direction of the flow
Date:   Fri, 16 Aug 2019 18:33:36 -0400
Message-Id: <1565994817-6328-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
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

