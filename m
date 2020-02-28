Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4BB173E70
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgB1RZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:26 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35216 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgB1RZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:21 -0500
Received: by mail-wr1-f65.google.com with SMTP id r7so3884288wro.2
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pvvbQVmpASp887Wf4l9C6603WfCd+ki2MzoZkRT2QyE=;
        b=XNJyf0E7c8ZH3Xni+t6DYBHjB+mwaMEJYh68iZzibDLWgyKsiziAS0lcDJEd8Sw/KG
         jnyQpk8pDOhlX+7zk2K+gJ0ROEcvOgqpI3Vkidv9A/Ke39reKJfDO+IB0z3RO/CNAVNT
         Z5PxRw5eRmKpHqGpUsnMRtOZaFfLPaCnUJxqBKCFq5Z0eGFi5XW+rIMz11NFKT/Yh38P
         jYn5ae4/5rFxIX0JlNUUu+1yxiAgjl8Xn9JJtJSgC+/MXNl4s+rAGlSAF2hrlD/vtMLy
         lmtV0S9NLBqXkRfc4JIUZoeycfHfC2RAIil5ocqcrebHQu2zaJy5kraOVxuANVeZvY3E
         ytzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvvbQVmpASp887Wf4l9C6603WfCd+ki2MzoZkRT2QyE=;
        b=WoBnaL6GuSFVoAQGJtQ9xwxAS1HZufOBJH09HaucerAxNTukke+c6UkP98MwXNhvKo
         tgVBetLEDeC0Rn04o9oqHSegNcDNUDALdS0wSFEyMoqItXTTp1MR96g4AlMDuCupL9mC
         MNimtiklBhwYEsmb/yjOTvI6YqXHo5CgHHQ8Vp4Td12oCd5WfCKDJIEczLe9IcfHJhtT
         1TcLxnkGZgkt0ucqzm2YZXXFpc5yIPev22b9SDBkSA0JtH0BU/Zt40hg0YnXZb0mIen8
         d+f3Jls3gvkp2Ep5IEj0ZHwlH62tUTLKWMWgKEuwDST+k9kRHuE9R3tXznapI8M/7/Cm
         LNoQ==
X-Gm-Message-State: APjAAAW3k9nK1TNJuPp0/pytm769sNcMEqgxbIoutAYNg+IqgWzIuzIu
        dnUG4Xm5dnmIDRR5atMzMCBYFn8uw3g=
X-Google-Smtp-Source: APXvYqyoeVHHcx7VBf1vvFEa8hYNL7Wal+HqiopcMg8M8NnXVIAhUU5vL48Qsxvgbx1UqQDT/ugNXw==
X-Received: by 2002:adf:8b59:: with SMTP id v25mr5964107wra.419.1582910719572;
        Fri, 28 Feb 2020 09:25:19 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id l8sm3149679wmj.2.2020.02.28.09.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:19 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 10/12] mlxsw: spectrum_acl: Ask device for rule stats only if counter was created
Date:   Fri, 28 Feb 2020 18:25:03 +0100
Message-Id: <20200228172505.14386-11-jiri@resnulli.us>
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

Set a flag in case rule counter was created. Only query the device for
stats of a rule, which has the valid counter assigned.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 ++-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 25 +++++++++++++------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 9708156e7871..ea712e6fa390 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -641,7 +641,8 @@ struct mlxsw_sp_acl_rule_info {
 	struct mlxsw_afa_block *act_block;
 	u8 action_created:1,
 	   ingress_bind_blocker:1,
-	   egress_bind_blocker:1;
+	   egress_bind_blocker:1,
+	   counter_valid:1;
 	unsigned int counter_index;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 36b264798f04..889330ac39dc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -642,8 +642,14 @@ int mlxsw_sp_acl_rulei_act_count(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_acl_rule_info *rulei,
 				 struct netlink_ext_ack *extack)
 {
-	return mlxsw_afa_block_append_counter(rulei->act_block,
-					      &rulei->counter_index, extack);
+	int err;
+
+	err = mlxsw_afa_block_append_counter(rulei->act_block,
+					     &rulei->counter_index, extack);
+	if (err)
+		return err;
+	rulei->counter_valid = true;
+	return 0;
 }
 
 int mlxsw_sp_acl_rulei_act_fid_set(struct mlxsw_sp *mlxsw_sp,
@@ -862,13 +868,16 @@ int mlxsw_sp_acl_rule_get_stats(struct mlxsw_sp *mlxsw_sp,
 	int err;
 
 	rulei = mlxsw_sp_acl_rule_rulei(rule);
-	err = mlxsw_sp_flow_counter_get(mlxsw_sp, rulei->counter_index,
-					&current_packets, &current_bytes);
-	if (err)
-		return err;
+	if (rulei->counter_valid) {
+		err = mlxsw_sp_flow_counter_get(mlxsw_sp, rulei->counter_index,
+						&current_packets,
+						&current_bytes);
+		if (err)
+			return err;
 
-	*packets = current_packets - rule->last_packets;
-	*bytes = current_bytes - rule->last_bytes;
+		*packets = current_packets - rule->last_packets;
+		*bytes = current_bytes - rule->last_bytes;
+	}
 	*last_use = rule->last_used;
 
 	rule->last_bytes = current_bytes;
-- 
2.21.1

