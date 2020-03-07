Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3120B17CDD6
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgCGLka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:30 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33847 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCGLk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:28 -0500
Received: by mail-wr1-f67.google.com with SMTP id z15so5384397wrl.1
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1lfpj1EwcBbTiXEN786RWS/gOCid52b6tEJP/P6YAPE=;
        b=1QOyefUXUIBhVSLfC1YZAhIY4JeoXevv3pLl2qvgC807C4GePTK2pqu4yXaLmPQi24
         FmtFcpsgf0QULaMsfw5xPH5fifBQ4i4VjAQMzGtjufWA3hvJ6Scoef+l8LrzVn7QWGjd
         Z801lz9A+2LJgqRjE/w4EorcAJVIwCbExbxAfLtwMTOMJ1CpqPxbCVznWjhx+XllSSWA
         zodhVG9TNF6oQS8DjFyuQ2oPKJj9rjL/GNR/EpkEKSWip3SX+/5EK6Eg133gYcaog9l9
         4/vD2c/OMpn9Hag3YYTas054LizOf+ydd7XMsio5fy1ChpXq6Yf+T6CNsxpkv7R1iBqJ
         ryqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1lfpj1EwcBbTiXEN786RWS/gOCid52b6tEJP/P6YAPE=;
        b=EqY190kfDNRoBFS+xMCSf+hdqiVL0JJJS7BMB6Ja4M+zbs0rJRubHLcPKKHXyac0gV
         b0Xr8SOdRYqSkSvr5N/lleL3+Klya8dZtTtWlMNSeK6VZkQe5iYuqMSpCAnmGBW3W4ec
         GLxrRLk3CHm/sq0XEMOjQTK+CGN5CFMRbCGrI2JWWlDLQF2PYigLbyosputStBPlDcsH
         dPYMhMQyKCbnaPdU0Tvib5DWbSoR5K9oNwbW0mA+k6wGAJ3eInpTz9GZmmKQ9Qr3g4K+
         QjyzD/zArZ1WNHHavrxpME6/+1Medh0iLtNkpRNW7N7bMgr9WpdqYY6w/DRUcw+QSflI
         KXYg==
X-Gm-Message-State: ANhLgQ2gTP1G1DldoM5DNITRgE5VD7U4nJvL24woHE0DCCCnLE7uWDRm
        YFnuE06m8ZC47XF9GsuAK/OSmL9IIBw=
X-Google-Smtp-Source: ADFU+vs18WKk4lQD8RYInIOt23vzV+KOmavv01qgdBpyp7Fgap2Z//wfZwTb78IZBOe1h5gGe0cqDA==
X-Received: by 2002:adf:979b:: with SMTP id s27mr784727wrb.134.1583581226640;
        Sat, 07 Mar 2020 03:40:26 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id k2sm21404992wrn.57.2020.03.07.03.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:26 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 02/10] ocelot_flower: use flow_offload_has_one_action() helper
Date:   Sat,  7 Mar 2020 12:40:12 +0100
Message-Id: <20200307114020.8664-3-jiri@resnulli.us>
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

