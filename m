Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D0016B183
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBXVIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:05 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44508 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbgBXVIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:04 -0500
Received: by mail-wr1-f67.google.com with SMTP id m16so12077543wrx.11
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LbElv8DyZgOoPvNox5nZKXfSiKiWa8tO2NXmxRvCvl8=;
        b=1R3zMM4KNIJ7ZEvFBeekCio926IqLwlqwFPlKIZzhFdcrbduwkqR8bCTORzC4jTRht
         lnoF9QCcoQgC22JBqllYSiyjfQg7D+2PsHENPirXKNdSCrzIScR2iz5C3o4MINdaSOpM
         xwVqVJhooslkXEgn//iJi3q+gQin/jA/7du9oLbtXfZqvc4ysIImvNE4YfwcP8qUJs0E
         rnEmxbuhOPGu2fctAMt6HblOkn3awBLcqLUAX/GLk98sn1HJozwTAUeEyBO9Qj/VAIGD
         G3GNZR88sYDBkkfM/B/FVCUWnr+FVKAS922YM2dOHb2X0xOJQCFPQEFvzLm6GGmq0N35
         0giw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LbElv8DyZgOoPvNox5nZKXfSiKiWa8tO2NXmxRvCvl8=;
        b=jKy9gfihbykh43S6/qpCW4ofFp3hI8wQuaQx588f/ua57xZ5PokjX0MPNPizu9qWq5
         iyaVu2P+WKRp/jkGJ34UVe4k3VF0BxSbYVhNVD5qgCA/Spf85gIeE3pzm9Bo+qe7T+HC
         sY80UOOau+gIRr20fgF1XPitTVcVkAzryBuNtJHVascub4X4OYz3aJpvPl0NltDoZlXl
         NsOhnUmWpTNsVslJQ4UYly7TI/aWArNdi7nSOyyqI0OAwrR8yhnuaLjwgCImq3MQqxLs
         ot6NZTJ8tBDodgt/wsEfvUaJBuqKg6hun1kcXKQal7rTowUqiIFRfbPJ5MF7fVkyDKWv
         k14A==
X-Gm-Message-State: APjAAAWTyIbl87ckVDoLK0mqBIvG+7tNkwk2366KDZU26CF26kisCRNS
        87nfoRXrjvDQSq3kBLjCZ5dSH60sIkU=
X-Google-Smtp-Source: APXvYqwVWGmSkpkXD1s6lq1+m3ib4pI0rRe1YSXO5q+Yu8XKgmpyr7M8CieynYy6lKcb3um4bKfIvA==
X-Received: by 2002:adf:f28d:: with SMTP id k13mr17698882wro.416.1582578482391;
        Mon, 24 Feb 2020 13:08:02 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g25sm1507406wmh.3.2020.02.24.13.08.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:01 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 02/10] devlink: add trap metadata type for cookie
Date:   Mon, 24 Feb 2020 22:07:50 +0100
Message-Id: <20200224210758.18481-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Allow driver to indicate cookie metadata for registered traps.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/devlink.h        | 1 +
 include/uapi/linux/devlink.h | 2 ++
 net/core/devlink.c           | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 07923e619206..014a8b3d1499 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -541,6 +541,7 @@ struct devlink_trap_group {
 };
 
 #define DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT	BIT(0)
+#define DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE	BIT(1)
 
 /**
  * struct devlink_trap - Immutable packet trap attributes.
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index ae37fd4d194a..be2a2948f452 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -252,6 +252,8 @@ enum devlink_trap_type {
 enum {
 	/* Trap can report input port as metadata */
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
+	/* Trap can report flow action cookie as metadata */
+	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
 enum devlink_attr {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0d7c5d3443d2..12e6ef749b8a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5540,6 +5540,9 @@ static int devlink_trap_metadata_put(struct sk_buff *msg,
 	if ((trap->metadata_cap & DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT) &&
 	    nla_put_flag(msg, DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT))
 		goto nla_put_failure;
+	if ((trap->metadata_cap & DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE) &&
+	    nla_put_flag(msg, DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE))
+		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
 
-- 
2.21.1

