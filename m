Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22512173E67
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgB1RZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:12 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35353 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgB1RZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:11 -0500
Received: by mail-wm1-f65.google.com with SMTP id m3so4102296wmi.0
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XVXOoGzPvTj+2UqFYCJWYrBZSXxkq9H0nxfYcInggXA=;
        b=d7l6o/rgvqcZVH2AQ15TcO0PJCOmbFaL0sK/ZUoPaWzB8rG+0IWGMmVB5221QoKVnN
         eGB77gHJrwUJH9VRGCErg6OMBx1c+7tWWVplacQtucGFwnqrLio4PV0tcqLhTQLwByfW
         Qv/av1hr8Oj0qIPp7wTSvdJ0twnD52Rsvmy/9Lpc5/6Ik35rWZ6iQyzFgJGn9hNtZez+
         QMS9hvk5zB1BXpDKduhLopTX3qR0SW1+XrlAI5TCy7bp18W17nVQQcAO8pYd0CETKLoV
         OmqWf0PtXFpuduSCwT4X7ZRtZOr/O0+6n5uw4TXZv2+534BV6F1X9VTQzHv5xnCsV+05
         2XEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XVXOoGzPvTj+2UqFYCJWYrBZSXxkq9H0nxfYcInggXA=;
        b=n1s3qVp4dEokwFktirsKCFYOhLy3vP61H/VSBF9RB8PX5ZH7KrNJPHvpDHU2q/Z9ZZ
         MpVHM/l/6pZiBDNnPjzAILQQOmN9tqC6xPqh4TlqUA2U80sHbAkQK3OJrbf27Ycg3qS5
         mhGMoiuHfg4DdYuKhJMJ90sOhrCDzsqwMUJsRm1t3VeYb1+1k2KsQMGiTiwPg7UJIjfV
         t2mXljnjV2buTi13KeFBrsvxdCFc5460ERGx7YaXs55/saONfr9JsVKNKFR/6qw6LaEt
         XpW0Ul2F+/X0+iYAe3ev3AWsQ61AuUm09Dz4G8eSrjFrxY1SZpi+o339+TYUWhzkCiSY
         qwUw==
X-Gm-Message-State: APjAAAW7+YS6uoZhL7qZU+ctf83aybfgqfj8rpdCsq1iEeJX/Z8a6cAf
        iuWb8LLObB7p+0HlwbS0KDnnbKE8miU=
X-Google-Smtp-Source: APXvYqzKAhd+D/w05G1NVjZA5MsxpZqUs1t4MARKBtW6V2EP+Q6Mr9sBQHEY+Gkf9RcfEmjHAYDthQ==
X-Received: by 2002:a1c:9a88:: with SMTP id c130mr4885793wme.73.1582910708144;
        Fri, 28 Feb 2020 09:25:08 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id p26sm2929281wmc.24.2020.02.28.09.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:07 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 01/12] flow_offload: Introduce offload of HW stats type
Date:   Fri, 28 Feb 2020 18:24:54 +0100
Message-Id: <20200228172505.14386-2-jiri@resnulli.us>
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

Initially, pass "ANY" (struct is zeroed) to the drivers as that is the
current implicit value coming down to flow_offload. Add a bool
indicating that entries have mixed HW stats type.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- moved to actions
- add mixed bool
---
 include/net/flow_offload.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 4e864c34a1b0..eee1cbc5db3c 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -154,6 +154,10 @@ enum flow_action_mangle_base {
 	FLOW_ACT_MANGLE_HDR_TYPE_UDP,
 };
 
+enum flow_action_hw_stats_type {
+	FLOW_ACTION_HW_STATS_TYPE_ANY,
+};
+
 typedef void (*action_destr)(void *priv);
 
 struct flow_action_cookie {
@@ -168,6 +172,7 @@ void flow_action_cookie_destroy(struct flow_action_cookie *cookie);
 
 struct flow_action_entry {
 	enum flow_action_id		id;
+	enum flow_action_hw_stats_type	hw_stats_type;
 	action_destr			destructor;
 	void				*destructor_priv;
 	union {
@@ -228,6 +233,7 @@ struct flow_action_entry {
 };
 
 struct flow_action {
+	bool				mixed_hw_stats_types;
 	unsigned int			num_entries;
 	struct flow_action_entry 	entries[0];
 };
-- 
2.21.1

