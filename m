Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18428173E69
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgB1RZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51735 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbgB1RZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:15 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so4034051wmi.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oFM6SyE2aER0WnJ4MqNWu0vHBsyzC8hOSSYUb5aNdbM=;
        b=edbFN7hXIRUBrvyRz/XC11J7WOV4QZwJ7kBQ1CiE/D8QCj+WiJZy5ZuotddudQ5gcN
         LCzX6oNrItx+fBDXy6K4tgdmS81CjXNgS01we/8KWtATQcNavFdifbco+FB7NuGhQg7u
         lyJN2a8j1xViHi+2OhaZ+9hmPG3rfe8cWnFmslgaFbsKiTM2v8cyua9K4I+PjHS8ohOo
         vcO/3IUK1+Fbp1Q4bjIwZ50eBt7rAvQsb/SKsiK1uXh9nTTCdyHbXWXS373mDDiBo1eG
         uolXEPyUI4hVOnn0pFBqLy6998fErQhzYAr3L/2Vh+V0X/YgCbUyn7gpVx2sEiw7D6ov
         ae2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oFM6SyE2aER0WnJ4MqNWu0vHBsyzC8hOSSYUb5aNdbM=;
        b=MLPxrqJE89JIinu4FsGoJyQNw6PzPQgR5nt3RRhyW4LIkZsY+gKh4xyKS5YSHnJrO/
         pf+sOHlWJAg93HkOBpL1/1cxsS7QyCrnMZMqMpMVCUQ1cq+6/E06FtC2OwneoBC9MD83
         n4+rf2Os9AzXaPBxzOXhgf0hRb1j6MtQxwpVl3A6hRlj6ulox95/ijy23D2mWHHPV5Fi
         BEgcRfpXGmVmT5QfIik2ZEJQxxhFgcvwqtNDIaBIIAo4Sm60w7CZ77GBfayHng4j9O+5
         DFkS7iNoegGIRh/cxMok2Qfpyetr0c3/RGCcOPRZ8wMbR/UGS5FJrAI0PYGxS7WA+gQo
         9HQw==
X-Gm-Message-State: APjAAAVQTY3K3aZsJkEEjet13INY6ltR65YQ/BGkw8+rYIXgUOmOWSg+
        tEheHVi/MboHT2cMX9/D8o2yNWTQ5cc=
X-Google-Smtp-Source: APXvYqwfpVsOxqzOohUDQ48+gMYRVYsBP/mZ5FS/u5r+6yK03SC/b5HjUVaUcUrUBc4wMbnMrWWBmA==
X-Received: by 2002:a1c:f21a:: with SMTP id s26mr5781011wmc.39.1582910713050;
        Fri, 28 Feb 2020 09:25:13 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s22sm2835500wmh.4.2020.02.28.09.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 05/12] mlxsw: spectrum_flower: Do not allow mixing HW stats types for actions
Date:   Fri, 28 Feb 2020 18:24:58 +0100
Message-Id: <20200228172505.14386-6-jiri@resnulli.us>
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

As there is one set of counters for the whole action chain, forbid to
mix the HW stats types.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- new patch
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 0011a71114e3..7435629c9e65 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -26,6 +26,8 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 
 	if (!flow_action_has_entries(flow_action))
 		return 0;
+	if (!flow_action_mixed_hw_stats_types_check(flow_action, extack))
+		return -EOPNOTSUPP;
 
 	/* Count action is inserted first */
 	err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
-- 
2.21.1

