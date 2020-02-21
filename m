Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC455167A08
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgBUJ5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:57:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40150 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728364AbgBUJ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so1020018wmi.5
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbbbf/LwMOht4kninYTv9tjTmyrds5FOnNLj6MSfrqk=;
        b=w4IVDpCcRGWRshftECO/NvxWNNnRBd9j23ogPgcTsy96T/XPM9SyKmzGsCPn7ucOp5
         d3sCdY7WWKoKTl9bWG0PsMgAEsj+EPWCOxfb8mb2/5HDjnDlveDmdx5Gg009zlKy8jHF
         xkewBXlQrLiqubqbmIqXK5KdzWIdiwzLGqGc3uffxltuRCK1T7x/ZG5bSp5CaoDNpHnM
         WByvasaiLFokUNflKgxfFVKU541Vhaf2zgAvM836i7KYrJw6/ggdgTxan7lQHINUT9w4
         vNynaWnKxoVfTfUwWzLOA5dkg1Lee18Cb7VRgeBbSdI3sKvonxIZaQb5CChgfqTrSz7X
         85Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbbbf/LwMOht4kninYTv9tjTmyrds5FOnNLj6MSfrqk=;
        b=ffPp6rR+b0+sRu//7F5bl+LEhGvNNEP6ev+r6Z54FfgzBGR4oGVYP4mKEsH37/GNna
         CJEqEiRuX8hd/bbwOFccSPY+xFCo7g0tQvU3eIeQLU2n8oaq9XmhxwoPF65xcKqGanCb
         GExFjRIOin6P7RKkoUR0mWKq6XaK51Omg8bK9vvtn7587FnjiwT11bXLQs5npSg1XvgH
         MB4IdzjWfU8t7hOJfktmoJHs9sX3J5E1W0jNJP5R/hBtRNeqzTA/wzKCSI2xC2hsHnY2
         imMg1utHjQf5YuUxikwHhyf5vXaPRgk9ymG0BLGKXmhYpiHr5lL5mcCLn41PvFZD9FVZ
         gltw==
X-Gm-Message-State: APjAAAXkgWC7ktOaTSTJtHT1FQOhwmt3Dg0cN9pjO9II/pcCmCU07iTF
        3S8pd5XQ07Y8T7hC5V4zXE88yIG4yyA=
X-Google-Smtp-Source: APXvYqwfV9FSiuV/FguOV19rQ+sVbrqg6v3sWRgqRGIVADeITM3wEiovvlYAC6hBRnRevI4ZdVF59Q==
X-Received: by 2002:a1c:670a:: with SMTP id b10mr2769974wmc.2.1582279010778;
        Fri, 21 Feb 2020 01:56:50 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id v12sm3372519wru.23.2020.02.21.01.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:50 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 05/10] mlx5: restrict supported HW stats type to "any"
Date:   Fri, 21 Feb 2020 10:56:38 +0100
Message-Id: <20200221095643.6642-6-jiri@resnulli.us>
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

Currently don't allow rules with any other type to be inserted.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index bcfe2b6e35e5..39bbd9675ae4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3918,6 +3918,11 @@ mlx5e_tc_add_flow(struct mlx5e_priv *priv,
 	if (!tc_can_offload_extack(priv->netdev, f->common.extack))
 		return -EOPNOTSUPP;
 
+	if (f->common.hw_stats_type != FLOW_CLS_HW_STATS_TYPE_ANY) {
+		NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported HW stats type");
+		return -EOPNOTSUPP;
+	}
+
 	if (esw && esw->mode == MLX5_ESWITCH_OFFLOADS)
 		err = mlx5e_add_fdb_flow(priv, f, flow_flags,
 					 filter_dev, flow);
-- 
2.21.1

