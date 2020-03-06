Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E305417BE6B
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCFN3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39820 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgCFN3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id j1so2370245wmi.4
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oFM6SyE2aER0WnJ4MqNWu0vHBsyzC8hOSSYUb5aNdbM=;
        b=qpdFqsdNuX9Zs2TXVr5CpPYGYdWYDMv0LD65FqO2X/eV15/1yWvleYZJ6s4pJOZwWa
         FRg/62JD7lm6poPOHhF+JuU6EQ91lbuJEHUTB51r0Wn7voqJMvTUkWSc9gzlATgtW5BF
         vGAn5gmuWIeyzVthbPFtuIGgQdoFmkf/KU7bvMdkSmjBZj92B3FzuRUqdUUWT5+aq5to
         M3uqyOB88cfFoc4phdQ0ji2NaOolj4ly/2CQEIbuor4bxY3HJ321V6MV50UGVGMbUQgQ
         VdywuPpjLAj5xPCqjgJ5KxX8u3nC4ZtYMHWO2Kuceqa6I3CmTuqsJB8i15txellR42id
         MQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oFM6SyE2aER0WnJ4MqNWu0vHBsyzC8hOSSYUb5aNdbM=;
        b=qAKDgkqQH4JgdD8i3Faqs1mH3ESusqDv5SossSEjjQDNyYIHeghiejrbu+AGxUhzL6
         ZVQcqYQHEHyKnBKIZjdN11B3ky/oN/Aa4a49KlDQeeTbzVbDaf7YZxdXRAseycYXfOYv
         or+CnxT7j2nHacCFLYnLYm2ihShXCrDBpH4EY9GpzBK9qjHjArJDIp+TdYtSCBYx/PBh
         gy2Lh2CAN7ELjNS+vIIOlfxs04025njYf2Q4NeI/mbdlKLvysE2a21uSUB9q4rm2DpX6
         s0AjJBQRZIYo602ifm4Vslnq0drHCdpd0poOWpQTBkTZth8YFAGWUOij5IsIGWMuDdj8
         MSPA==
X-Gm-Message-State: ANhLgQ0bHWKsf0stVkWrVV8UfCAIZWsjk47Emx3cbTMxLYmxjeWh9WMV
        D9XWRDNcA9fuTIBZ/iVtq1pqN5AlKvU=
X-Google-Smtp-Source: ADFU+vs2YO+H2scCrgJYcPdaScJrbnyLaiJK09SIeLums5KXy980vcm45wY75UaOJAoPsFf6gQRkug==
X-Received: by 2002:a1c:df07:: with SMTP id w7mr3936571wmg.7.1583501343681;
        Fri, 06 Mar 2020 05:29:03 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u21sm7491412wmm.48.2020.03.06.05.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:02 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 04/10] mlxsw: spectrum_flower: Do not allow mixing HW stats types for actions
Date:   Fri,  6 Mar 2020 14:28:50 +0100
Message-Id: <20200306132856.6041-5-jiri@resnulli.us>
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

