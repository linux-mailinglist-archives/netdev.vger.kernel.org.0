Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57FB17CDD7
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgCGLkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41015 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCGLkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id v4so5365578wrs.8
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qadHUzF6uBqddy9Kzt+/fH81WIcmaGNA6CeSTeDuQw=;
        b=x2+oRga/dp/q1t484MXDT/UwJjo6tSlOhdOQ5pPzLRz1b3km+aUULry+VogsldSY6i
         mKyT9s/7QbtJ05iLPOVQR7cLEmZ6eFlghkMi7cIDY+HzPy6OShMkl+2tTptPM0d0kSU4
         Q0NBzvr4JUGw7EGRbSg3CRLKpjX3ZSwbrEuI/6dNUhR6TXVhD3LGmA/8+mDeGMdlQS6Y
         MbHT5PFkOMrmuU+E+DzAmGrgnAorxdS+ByYb0xcjtelD97eArQc6VPR4EBbnmuzMIfD3
         ePI3DHRGePpN0aOh5RfZ3lLEPRhVN0YR9RtP2on/7/5xK19mb9cvErWj9hWR6a6EXrYX
         ZZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qadHUzF6uBqddy9Kzt+/fH81WIcmaGNA6CeSTeDuQw=;
        b=LaafaV785xiIr8dIsZs6wAMkG8SESSRxduOn9fAqWqNKw5bw1SKBk/Q1C/pLwzf8iI
         RY/YO5lVITLHYqdde3ZU10UHeoyGE9F0hII4J7llRxiBGnqNGaEG8SkOOM83o1GnIkT3
         flo7wfG1R2wUKWl3gtzOtiVbj6+CndSXU2GwJqgzkaLp90JXnYabJxq7mT1Nl7s4ZoXh
         KkNCq2pf06NIF8VYhbEV/Z1VbwJGA0vXM/DA2hnI69H2/94p/d280IO0CEjqa6CO3Lj6
         GapD2cEfSJ78q9zvVDk47mffWgGIpOI3LT2b/5sIlyCuYZpcjQ2hnkcyH8ts/lwZYaxn
         67iA==
X-Gm-Message-State: ANhLgQ21tJFyIRZfiIX2xgDCwupaKDrHpUMRn+TKh18ekSQSKat0iWYV
        QWYVWuqV/r0ctOhi63u0NOjJoggTNQQ=
X-Google-Smtp-Source: ADFU+vvwhs9efDLthjzyyMkQn9sPElaLvlkhx21ZJiry+2jsCKKJlpoMDp/f2VVXYCpuqAi7MTqXAA==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr3467722wrv.17.1583581230223;
        Sat, 07 Mar 2020 03:40:30 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id c62sm17839750wmd.7.2020.03.07.03.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:29 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 05/10] mlxsw: restrict supported HW stats type to "any"
Date:   Sat,  7 Mar 2020 12:40:15 +0100
Message-Id: <20200307114020.8664-6-jiri@resnulli.us>
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

Currently don't allow actions with any other type to be inserted.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v2->v3:
- moved to bitfield
v1->v2:
- move the code to the first action processing
---
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 7435629c9e65..588d374531cc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -29,10 +29,16 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
 		return -EOPNOTSUPP;
 
-	/* Count action is inserted first */
-	err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
-	if (err)
-		return err;
+	act = flow_action_first_entry_get(flow_action);
+	if (act->hw_stats_type == FLOW_ACTION_HW_STATS_TYPE_ANY) {
+		/* Count action is inserted first */
+		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
+		if (err)
+			return err;
+	} else {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
+		return -EOPNOTSUPP;
+	}
 
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
-- 
2.21.1

