Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEAF17BE69
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgCFN3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:29:05 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38148 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbgCFN3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 08:29:04 -0500
Received: by mail-wm1-f66.google.com with SMTP id u9so2377188wml.3
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 05:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1lfpj1EwcBbTiXEN786RWS/gOCid52b6tEJP/P6YAPE=;
        b=ZDEmNtSQdQFqWL56R1t47iP6yiRSBIgJ4m1e03b1D7+Fdweu/LXlyB8jaIPY2Z/bPI
         rA7+OhsCx2R9HzxQK3s0GSslNOvj4f14GrBBPfktVu1+NEudC+fEFY1zbjlEtW3fOLZ3
         DXupSY1jAJRzqpphOje1zdIU2jnV5C7AIlv0yFKfzXFA0qvU5RA+oryyYBhIwiUAgTrX
         xVZA5ntJZLhZTvkM44UX3D6dJq3LPZfSRi0VRsudSQYrREwqbwGbV/hAxyfz760ZKlHD
         aAj7nBjSevUJZA/Ug1344knYlb1JktYxlb0c9/4tI4hFkAUJLsauj0g17BfRqjbRBnM9
         n68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1lfpj1EwcBbTiXEN786RWS/gOCid52b6tEJP/P6YAPE=;
        b=OId636wDTw49dw183fGiFEbAaTZzUSxXpD5wl2tBMGR6mxunEZzG1VVF42RtFo4qXR
         E+b/VKpU2LJxehqbwz1qYjky0NusHDLWphdXE/SaO2QpgK32Z6uLY0P57UtqrMzlRQNJ
         FYR08qEtaAZA0vsoUaLnbvnX8qY/LpI4WLPdMIQ9Sxg/VUpwF9wZ87NZ9TUEJ78EYkgf
         AbklYIw7CzNZoic5O66UW7uksa6QgcYqt8fU+x736HECiYNnwXkSRwGNDd+wMBefzbDe
         +SGdZMCtu0uN4j3taaTWV9C2xSYK4LsBvGQ5lhoDBbeVU/Sm9UdYAzar7E1sbhUr/azv
         GjAA==
X-Gm-Message-State: ANhLgQ2jcSMKU6Tl37o/8JXgqHBJFVNEpffvUMuA/ZvJeW3+yTDT7zio
        oULrInBE+G3FaVdDa4k2m29G1V3Yz+s=
X-Google-Smtp-Source: ADFU+vsJD/JjHRdjyzJ/aUuzKUv9pOabv6+rCAJXtRMBkIKoh5CeM9jfgcQhAAw3WvWMbgQtdfpBig==
X-Received: by 2002:a7b:c305:: with SMTP id k5mr4211532wmj.189.1583501340798;
        Fri, 06 Mar 2020 05:29:00 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k2sm17570555wrn.57.2020.03.06.05.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 05:29:00 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v3 02/10] ocelot_flower: use flow_offload_has_one_action() helper
Date:   Fri,  6 Mar 2020 14:28:48 +0100
Message-Id: <20200306132856.6041-3-jiri@resnulli.us>
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

Instead of directly checking number of action entries, use
flow_offload_has_one_action() helper.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- new patch
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 8993dadf063c..8986f209e981 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -14,7 +14,7 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	const struct flow_action_entry *a;
 	int i;
 
-	if (f->rule->action.num_entries != 1)
+	if (!flow_offload_has_one_action(&f->rule->action))
 		return -EOPNOTSUPP;
 
 	flow_action_for_each(i, a, &f->rule->action) {
-- 
2.21.1

