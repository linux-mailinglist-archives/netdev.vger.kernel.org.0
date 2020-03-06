Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5911817BE6C
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgCFN3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45838 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgCFN3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:08 -0500
Received: by mail-wr1-f68.google.com with SMTP id v2so2335063wrp.12
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oPWtciOyCmT+29dg+zPDz56gX8ekvZ6zHt+VGi+XV34=;
        b=BEBo2LVdyOl9FMAbKyd2Oj71PnacSRmgZ16WnDPkPzXD+kb/R6pvTKo8PYWaDBnDtS
         K/UHHnd7Y/5Ab2W3Q6bDtnSEPotstZVPjI4XHP/kKkMidBz+ScArchnDlJkvaqd2r+Y1
         UxQsCWSiXlV4NMC0ENXejIhhD4Sq/jQfhAnlzv7j8hbanhdmpU5gjN9lhyzxso+fwpKh
         4fhxEiCgNufT/4wNDKudzHJ89fc4tVGld2e4KFyhQMD0oo3Ka/QcUJWc20wV7ZiQOrML
         SRZqq1bzbqeibf9I223OI5Z3Pd5SIj3rVwXWdT8GNEUEOXgp74qjqzvUdyXxPxMMus2K
         I/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oPWtciOyCmT+29dg+zPDz56gX8ekvZ6zHt+VGi+XV34=;
        b=UgrmZ+tesDeXck7WBEUntmGtjgsTk2M2/oAd6ICF9gJdlyGKjlIg1x7NLKHU5u5i4K
         q7P+RyBGx5LhJXckU8EQwwBOzK2iWBDb2edUBgxNzKYL1wILJC+6yUaH6e7mFIUSgeE8
         G5i4QLRSD6OdxFsIcnw445v5NwcAxmEN7mOLTK/kdCNfTbQtbukDhsPGyc+1lWRdfcgo
         DaES9bZI7ycBMfjHFf9AF31c9vt50Ms7WqhKnefAUXzpyOE9RHnFKhwxIkR1LmsG45Y3
         7ZWLtvgj9DN1vqQOnCeQE92PpJfced0eOHyBsf7E1JV64h+Nct0inCzkLbodL1jfuO8N
         nusQ==
X-Gm-Message-State: ANhLgQ1QqYYYGdJljPFxqUfx5TWLJlk2N3JM1trRodO3drqF8y28zcol
        dz5gIHVvI+OPWjyyafk/QOZocDhip9E=
X-Google-Smtp-Source: ADFU+vu8MNruowz+lDQJ9c5YDFjykykIfa5V3AeU4hBk1n7t+0Gq7JJcvgGiWocFeWxIAhaPxEdICA==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr3958567wrx.382.1583501346051;
        Fri, 06 Mar 2020 05:29:06 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d15sm47099950wrp.37.2020.03.06.05.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:05 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 06/10] flow_offload: introduce "immediate" HW stats type and allow it in mlxsw
Date:   Fri,  6 Mar 2020 14:28:52 +0100
Message-Id: <20200306132856.6041-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200306132856.6041-1-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
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
index 2dc0332a44c3..e60100f9fa63 100644
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

