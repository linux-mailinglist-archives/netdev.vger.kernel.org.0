Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4022817CDDA
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgCGLkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:36 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33851 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgCGLkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:33 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so5384512wrl.1
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T4OFmFt6JOxktMHZ2+5Oitl+IRkdS8s4RI4jPwiunUg=;
        b=dFmqPgbJ0f88uflCQWeF4+ocZ8t5mBOmiVQzyA972LWbE0m14qbYsT99IqXkUPLwzm
         M/OdMELXJvrIFoWo60zE9XEDrryJR5+vUWzhGibmpSe/ssZXH54UJ+yvu8ZHEol+Y5xn
         esl3r376DjoCrd8KRa3Y5CkaPEmW0hmoe85TpxK9PNOeU0aJ0otPVZYoMYAKsx0Xq3c4
         MWcGCEy73K+OMeo6g5btImLMYyMeI0bNfYGv0NIqMREYL4+XINgdm1UcvKS53pO5SMYh
         NGdHbI7FEduxw3uVSfo4gA2XJQT/bfuFUur5qewQrK/efHY0LxyCR+UtulRLfD9Nkkfn
         +utQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4OFmFt6JOxktMHZ2+5Oitl+IRkdS8s4RI4jPwiunUg=;
        b=ZvAfR7MrVIraY1pDHlvQz04S4bLUtM8f9jCDWnV1tZXWinDLOSiZCrN2M/lc7XPgML
         85yOte9fLZlJLzYQH4rawAd7jscwz5fCVRs04zSB1cYhAWMt0GJnEDMsUT33+vHHbA8R
         RX+zFS9qwFli4k7A1hOznu8MWL5J1KLrmZtT5dMRLa19bKtphxwZScQrZRSK9qhbJGJb
         MrCDM+QURjPVZvjOTZNCYGMkJY+lj1Cme3jVk4J0dajxy/R+PwfUzozPYa6oEGs9kDLt
         ioIhBRiDvblYXFxcYSKz+Y2AHMUpx61qmdLpoRAG2AXUXzFXBs1R7DFdi/on/fWqMHjL
         rzcw==
X-Gm-Message-State: ANhLgQ2IT2x1R22XPf/v70B82iwpvV8E6v/B/5ZbB84PFKmf8qNgILlL
        2XXNysf+Z+HL1r0x7jfAe2IDyIRyVXo=
X-Google-Smtp-Source: ADFU+vu2I0dHHD+tcnRWCa657cpA7qrcQn/t3ITs3mxItcCL1rnhlRSMx73bkdjUXOgeBUn1qhqqGg==
X-Received: by 2002:a5d:4bc8:: with SMTP id l8mr9110959wrt.89.1583581231451;
        Sat, 07 Mar 2020 03:40:31 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id e22sm18710526wme.45.2020.03.07.03.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:31 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 06/10] flow_offload: introduce "immediate" HW stats type and allow it in mlxsw
Date:   Sat,  7 Mar 2020 12:40:16 +0100
Message-Id: <20200307114020.8664-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200307114020.8664-1-jiri@resnulli.us>
References: <20200307114020.8664-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce new type for immediate HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- moved to bitfield
v1->v2:
- moved to action
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 3 ++-
 include/net/flow_offload.h                            | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 588d374531cc..4bf3ac1cb20d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -30,7 +30,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		return -EOPNOTSUPP;
 
 	act = flow_action_first_entry_get(flow_action);
-	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_ANY) {
+	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_ANY ||
+	    act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE) {
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 8b40f612a565..6580c58b368f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -155,7 +155,8 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
-#define FLOW_ACTION_HW_STATS_TYPE_ANY 0
+#define FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE BIT(0)
+#define FLOW_ACTION_HW_STATS_TYPE_ANY FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE
 
 typedef void (*action_destr)(void *priv);
 
-- 
2.21.1

