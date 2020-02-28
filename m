Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C859173E6D
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgB1RZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:22 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35367 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgB1RZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:17 -0500
Received: by mail-wm1-f68.google.com with SMTP id m3so4102680wmi.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8AHLRNrQSUpqq5kx3mM6e23WdkQldZ02uKkhtFrtK+c=;
        b=nzdqVanDZW53VBEqm9MpF2ZbvleGRgNSbvf6it++pUUHqpKRpP+uLNNcGYEmQNJPd2
         5eYIQDUf2fZFR6+LHW9SsIr57eKnUQTSanCOPTVrREdJKn7ZIQR3t9dBS1m6rf3op+4G
         txjc7IADBrKadl75HfMKNYN7pXUDT2mtnIpLJNvYE80KVhhWCmT/a89dbJc0xN7UPeKK
         6s2uZAUJkfyNy5Vc+AT3VJc3KqOt7c/8gk/AcEwh1++9r9bjUlSAEVqUnMlsQ6N/Wtri
         mtboAGCeJL6uV13ELUnMg+USZEYWuGIHZyYs2BCUEomI3MC5U3E+XOUBChsM7AnGj/FQ
         6Nnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8AHLRNrQSUpqq5kx3mM6e23WdkQldZ02uKkhtFrtK+c=;
        b=blB9fQIPsxEADa+ZDQl1axlWTxF7mubk4VyXYDJud395/Qof37/PfbxMkbt8xpA3Aw
         vClrveINMx0gi+yvXi5EXlMjm1YuJyjJs9NBPtjZw3csK/dHdjc3RpERT4T0vYiHLSi4
         pcMnTFWdgkIP6hyl532E+uPPwKJW2UWZS3Hv+pE3+NPpAd7U/V8yruzPEDFIJkFpBN6R
         HM22N1ZS8bnloFLRm9qVR4TZSgnkJqR0r9eW/kFRb4qVEPcyqZzdTMBD9AxnyEaJXnC7
         i032HNma7u8hdq0qYcUngruN1M70wSacp1mWszeWsKtaykmtj88HwHGDDNTRkhTDHOsH
         5sHg==
X-Gm-Message-State: APjAAAWYC+4JAWC7uOchWt3r71RnQTRUa0NAX837xDKgN4k8THEg65cd
        4r6mE0mTvSWA+RLnhS1uiWMMVNwMwzA=
X-Google-Smtp-Source: APXvYqxUMOl2wN2JjNIZ4guEfAUXzczpiZOAwl1Co1HMWqHH7xXs6s9kE6RoKc11v4Vn5KCBipUKug==
X-Received: by 2002:a1c:8041:: with SMTP id b62mr5057743wmd.76.1582910715657;
        Fri, 28 Feb 2020 09:25:15 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id m125sm2993022wmf.8.2020.02.28.09.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:15 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 07/12] mlxsw: restrict supported HW stats type to "any"
Date:   Fri, 28 Feb 2020 18:25:00 +0100
Message-Id: <20200228172505.14386-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200228172505.14386-1-jiri@resnulli.us>
References: <20200228172505.14386-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently don't allow actions with any other type to be inserted.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- move the code to the first action processing
---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c    | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 7435629c9e65..40d3ed2f4961 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -29,10 +29,18 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
-	/* Count action is inserted first */
-	err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
-	if (err)
-		return err;
+	act = flow_action_first_entry_get(flow_action);
+	switch (act->hw_stats_type) {
+	case FLOW_ACTION_HW_STATS_TYPE_ANY:
+		/* Count action is inserted first */
+		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
+		if (err)
+			return err;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
+		return -EOPNOTSUPP;
+	}
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-- 
2.21.1

