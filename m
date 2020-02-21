Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71C6167A02
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgBUJ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:57 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39198 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgBUJ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so1266011wrt.6
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YEYeUvHUOEl/1TV7rKz0yc0tco4+BQCw12SfJ2nBJrc=;
        b=RFkYqTluG/mvkAd+06q07jOlN5VQqD8tRn1EImv7hcQ8408FUqbVsFN1p5po4C+kwR
         CluGI7PpF8se7xjSIyy2H6TWI9DL4ZiVOmjnqMWd0kae/TviblV2kngAzr41oehh6jZF
         BLv28UaUCNkziw8x+2am38bAEFL3aE9SL4W5d0ZtdBOX9UxYBWPt4sH5By4xrQnBQMMG
         aQG2FSp1IASPuKiYav98Td1k6bKm4+qU2Lnbd/iEMGPK9rHyBHZvLs5rcYqKwTGZ2NHX
         egoYnPvm4A1G/ycbn7E1n+JM2Rq848ljgeHczyBo6ARqp2h4qAcACid5+cG96csf8Ezv
         6mfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YEYeUvHUOEl/1TV7rKz0yc0tco4+BQCw12SfJ2nBJrc=;
        b=eXpDixnkz3MLYUwYO6XP3MYi29ufra+vaN5RgoCFOUOd5EutCFlR8NAOltRXnMuwzK
         yTajJsfNw3fznMJSW9+1ve8ZIXODqVPd91gPIcg8h8YRFicwruSAMsq5OhYwFZbjWS8Y
         iQ9CSkUyg5ftjEKilVSg0ZlXUhX3zgPpvl1fKGC/UXeTG4r4cwE1zIo1ZYxunwVFDwVk
         13USqwidaJ0HiorLffar/1oXFk2MyyMajT7ymQf6vTlB6o8D8y31ECktrscP9elaQ6ps
         8fxVGXo1cM12I1tk7q0w6g2SB1ysZCaIS5TKXZTF7VNmJ2bB3UDpCnkTymSxTVpLu4T1
         mgOQ==
X-Gm-Message-State: APjAAAU+7T+pTRsRTfMqKbdS46SkpP3meFwmnYQ/tdrwJ86/s+zFfxYs
        cvkQDtastZqgj8kG78Daxb59ABHb+gw=
X-Google-Smtp-Source: APXvYqwgXWrDbhkxJeLqU+uNQ8VQQjhMqktghgeu5RDppHPOX+9Nqnz1J0Gtbi0E2GQw7+qUndHhWA==
X-Received: by 2002:adf:ed8e:: with SMTP id c14mr47673069wro.80.1582279013618;
        Fri, 21 Feb 2020 01:56:53 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id x6sm3304682wrr.6.2020.02.21.01.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:53 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 07/10] flow_offload: introduce "immediate" HW stats type and allow it in mlxsw
Date:   Fri, 21 Feb 2020 10:56:40 +0100
Message-Id: <20200221095643.6642-8-jiri@resnulli.us>
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

Introduce new type for immediate HW stats and allow the value in
mlxsw offload.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 3 ++-
 include/net/flow_offload.h                            | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index ef0799a539d2..a3e9f72f50de 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -30,7 +30,8 @@ mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 
 	switch (hw_stats_type) {
-	case FLOW_CLS_HW_STATS_TYPE_ANY:
+	case FLOW_CLS_HW_STATS_TYPE_ANY: /* fall-through */
+	case FLOW_CLS_HW_STATS_TYPE_IMMEDIATE:
 		/* Count action is inserted first */
 		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
 		if (err)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 34e1e7832cc3..b1a182941f1d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -352,6 +352,7 @@ enum flow_cls_command {
 
 enum flow_cls_hw_stats_type {
 	FLOW_CLS_HW_STATS_TYPE_ANY,
+	FLOW_CLS_HW_STATS_TYPE_IMMEDIATE,
 };
 
 struct flow_cls_common_offload {
-- 
2.21.1

