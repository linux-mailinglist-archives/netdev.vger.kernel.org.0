Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 239AD167A04
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgBUJ5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:57:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54226 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbgBUJ45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id s10so1031124wmh.3
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=McTtTI8GabwacHoiav1zlpdS09CHDGMImk/NjHhuwyQ=;
        b=vaw0OPT/XFUMyle5KNaxcU3Sdg276gElUYamnixqvjHSC6lXgySupYCnLvHiXbhJ30
         09BDY0S8JC4Kpr29/zgVT6lIKFnpY7M5R6CHbjjiQ1V5DHPgW+GLgFo4IW91OlsOvyLf
         Uwckck94eNlcSXTb5zdHSU/0HX6YLztT39Ko/VFmhZJg8fOgMspf3YThTw3lbcK5AVw6
         +uDwgHQgryy/euYjZHVlGz4sv/1ReVxp9KTF2oZDyfANHeQRkbUr/K3gAcJZv0X8n9mZ
         WGQMcH5dlENXbRVpPRTrfKbdf05XKbKMbew6oyTmE0oPyyFXxCVc35l2JO1QYXZ4p4MF
         Eh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=McTtTI8GabwacHoiav1zlpdS09CHDGMImk/NjHhuwyQ=;
        b=s8YNQCn1Cvsttg0gfEYY/zoqfmO7LIMF1bHYCFkqWkXUC7jvPUAaApoNOPE9Kzg13O
         ek5+jowLcpn7RzGatasSnVJY38T5CQ3TcUQbWvCWebfwxr5yLa04Fht++1xUKd1Co5nf
         eM1u9yq+DQifopD3xzw6rblvOfFtVo4ZXpeWNMlDSVIOUqrQ2zt6sdC+LpK/ex5yEAxE
         h0DqQkjbXgc7sRDmwlvLYDnySpXZLC3iWZoYgaz64Sdj8heaCy2GIIHqliToHbA9mdtx
         4L6Jf5zkje03CfcgtMkNpIZughhQsw1TpYCv6Weisqf4Md8xuSt+ly/5zi4WMhv+AyRX
         lwZw==
X-Gm-Message-State: APjAAAWsPutktqeYjT1e6qk0bHqJ612YzIJq3cPEoNTvoduVIMnE3YyK
        iyp4qepSW79OwSi2FWz0nxB/Df5P75A=
X-Google-Smtp-Source: APXvYqxR81xR2Bp1/3atRofbAe9TNiIM/3Gx676BQOAdPglB+0OprcZ1uPByAPU720TCZ6xFG4P8vg==
X-Received: by 2002:a1c:660a:: with SMTP id a10mr2766069wmc.122.1582279014681;
        Fri, 21 Feb 2020 01:56:54 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id r6sm3395758wrq.92.2020.02.21.01.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:54 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 08/10] flow_offload: introduce "delayed" HW stats type and allow it in mlx5
Date:   Fri, 21 Feb 2020 10:56:41 +0100
Message-Id: <20200221095643.6642-9-jiri@resnulli.us>
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

Introduce new type for delayed HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ++-
 include/net/flow_offload.h                      | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 39bbd9675ae4..d48c07bf9711 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3918,7 +3918,8 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 	if (!tc_can_offload_extack(priv->netdev, f->common.extack))
 		return -EOPNOTSUPP;
 
-	if (f->common.hw_stats_type != FLOW_CLS_HW_STATS_TYPE_ANY) {
+	if (f->common.hw_stats_type != FLOW_CLS_HW_STATS_TYPE_ANY &&
+	    f->common.hw_stats_type != FLOW_CLS_HW_STATS_TYPE_DELAYED) {
 		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported HW stats type");
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index b1a182941f1d..4cff09890725 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -353,6 +353,7 @@ enum flow_cls_command {
 enum flow_cls_hw_stats_type {
 	FLOW_CLS_HW_STATS_TYPE_ANY,
 	FLOW_CLS_HW_STATS_TYPE_IMMEDIATE,
+	FLOW_CLS_HW_STATS_TYPE_DELAYED,
 };
 
 struct flow_cls_common_offload {
-- 
2.21.1

