Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF66167A03
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgBUJ47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34709 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728429AbgBUJ46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id n10so1287513wrm.1
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zdx0N+Cx690sbRii4aIIWpIi+/7/8AAJiK4v7R4b+mg=;
        b=GeXIFpxX+c2flfxovAzk7PwBsiPlgujszxpP5Yn0Frnm+jBGrUuQqmjhWuXJEYyGgj
         6MyjUvosMYC/8k+/OWALNxnuse6xP899NugJZtiCuFXVezJ3l2B1rNoV9Ddh+Ua8e8mc
         ZBXUovE0lDsxfSjDv2o2qXt4bvLY6GkXf+jOR3vB10ITEVJfVvgvpo1SJTx8+7Kozv4m
         YtcKGPzF1bPiWeVbx3j/5U99NwqmI2oQ/Uie+hB7G56jby8RAlFzUgpcoSu9KFP/4sKJ
         6NQRf0ra3BkzrmdLAwwPMPGkSiNT2K69Lu/dsB8HwoOH+3ulZs0Ee7zR4J90uc1j2XHl
         ySRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zdx0N+Cx690sbRii4aIIWpIi+/7/8AAJiK4v7R4b+mg=;
        b=FoUs19pgwxnJXJBcfu17FYqcqZ+OqiJ5Tqj3b2IxSQwHYI7yemtwhAxNcwGDVJQZ/4
         ruwoKTtKwjMrWSdMzq0g6hewKEsRjP6JnUrNDVafFF5FVgfJC2SaLvCxUyO6kRQhjwbN
         acDgiOwxS008XtQO/rWqSBXJREDlBZlEs7bbwy/OPxRQxrmenzFpAWse6lfMKQkw/ra2
         8PKtQUi2MzxaMggSu+2QBlHMCX5+SWf3NAmztQI8WA3r7F/glh0+hVOvEmdad/D0OnWl
         NJWiqvHBwdob3S6FAqNtUYHRjL8RN62VLmLf+TPQJxxS9cjzkwmar4n+zRiY3MpqEN4K
         kDWA==
X-Gm-Message-State: APjAAAU0zwO0nrxqDPkxsssWIRBGljlKQGmqq/aYJLEcC0QntcinkMF4
        AOz+Fsn3d9PRjR2wM/5FIX6e43oB1aQ=
X-Google-Smtp-Source: APXvYqxZARGwZv8Tx0MjXeCVe4ZLlQRkmxSUU1F2LNMTRm2YDbSOYIQ/020bOY8x9Stvrr0SjP3TPg==
X-Received: by 2002:a5d:6087:: with SMTP id w7mr46662538wrt.36.1582279015840;
        Fri, 21 Feb 2020 01:56:55 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b10sm977859wmj.48.2020.02.21.01.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:55 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 09/10] flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
Date:   Fri, 21 Feb 2020 10:56:42 +0100
Message-Id: <20200221095643.6642-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce new type for disabled HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 ++
 include/net/flow_offload.h                            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index a3e9f72f50de..108a96901721 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -37,6 +37,8 @@ mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		if (err)
 			return err;
 		break;
+	case FLOW_CLS_HW_STATS_TYPE_DISABLED:
+		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported HW stats type");
 		return -EOPNOTSUPP;
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 4cff09890725..447e039762dd 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -354,6 +354,7 @@ enum flow_cls_hw_stats_type {
 	FLOW_CLS_HW_STATS_TYPE_ANY,
 	FLOW_CLS_HW_STATS_TYPE_IMMEDIATE,
 	FLOW_CLS_HW_STATS_TYPE_DELAYED,
+	FLOW_CLS_HW_STATS_TYPE_DISABLED,
 };
 
 struct flow_cls_common_offload {
-- 
2.21.1

