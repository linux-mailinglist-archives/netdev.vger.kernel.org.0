Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C627F1696A3
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 08:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgBWHcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 02:32:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51230 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbgBWHb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 02:31:56 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so5894983wmi.1
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 23:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WPR3rKoPxK0vkYSB8kNMqe/WrxNlSqIiQ7H+aV/2MsE=;
        b=XWlHLno/GX0vUFjeUyrQrhov1DsO0lqYClmAaZdGlxvTw0igpi8oYMHBfWYky/dlle
         qqKN8cwx7sHkpg8oVM7TlNBjNbSScCTHCQI0CZP4flWERqsD++s5ohOBRuThC9kRsLl9
         2uJdsi1HYj2uvNAKPQNlawZcMTDr1JQ3rb9F2O7UwamsTpCuqgKnvfat2veDSHn0oW/m
         uQKqA8p9NI+mGbb5JjmCFVV/MSnE17ihzciRsQ5XibOkTpzYLOPjKAUO7wTDD8mznAax
         jvPgVntN1Q3lkab4pMcbMvRWyfqMk5VGGpQo1OjWkX2vN8kkJtuWHQ/K/ejuNM4hVLxd
         3Y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WPR3rKoPxK0vkYSB8kNMqe/WrxNlSqIiQ7H+aV/2MsE=;
        b=PRvgxJJQh4Yfni/KJHCKUTgfcd546RTfR+PIZM7I+EypU/HtQBSVyxW4D/6XQi3XCc
         +g4W+CXeNb9lnVt1BnY54TJ6Ru9bsweHtHa0sVzNOXlq+f2TABvWoEGnvJOuVC2X4uR2
         Svdei+glaZsv0gAG6buPRQuoepHRxcCm3Pl+3fHx0l469kga8+vqyyW6YS0z+0IFkrH0
         /djUuzMUNBUOnDF6RQJJTM4Nh6+zplRLGDKLjQn2ttWOQtYpqXLP/9fHykvPu28zTSv0
         jNuwHZaIDqwAx8ZfWCycLcFj0E3p5bT+iGz4GV1MGpnmvF2+RWZZupw+umTh4AeuaYU+
         Erfw==
X-Gm-Message-State: APjAAAWMn34oux1zku0Iq3n8FUXUdS/Z33Yl9pe+7idFWwSU8REkEcGx
        YzCCLqcMrRn6k3KW9nfPEHCY3NOInM8=
X-Google-Smtp-Source: APXvYqxDtaGoE33k5UmYXFPvXWHSWP84LfGObN6Tgl2FqWKhtc4vtF1Sj/8bzn3G6Td7vcVay/0Haw==
X-Received: by 2002:a05:600c:2942:: with SMTP id n2mr14214853wmd.87.1582443113763;
        Sat, 22 Feb 2020 23:31:53 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c141sm11641650wme.41.2020.02.22.23.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 23:31:53 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 07/12] mlxsw: core: Convert is_event and is_ctrl bools to be single bits
Date:   Sun, 23 Feb 2020 08:31:39 +0100
Message-Id: <20200223073144.28529-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200223073144.28529-1-jiri@resnulli.us>
References: <20200223073144.28529-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

No need for these two flags to be bool. Covert them to bits of u8.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index ba767329e20d..76c0d6e975db 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -79,8 +79,8 @@ struct mlxsw_listener {
 	enum mlxsw_reg_hpkt_action action;
 	enum mlxsw_reg_hpkt_action unreg_action;
 	u8 trap_group;
-	bool is_ctrl; /* should go via control buffer or not */
-	bool is_event;
+	u8 is_ctrl:1, /* should go via control buffer or not */
+	   is_event:1;
 };
 
 #define MLXSW_RXL(_func, _trap_id, _action, _is_ctrl, _trap_group,	\
-- 
2.21.1

