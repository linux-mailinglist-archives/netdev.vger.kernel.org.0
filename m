Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E1A2C5BF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfE1Lu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:50:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35608 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfE1LuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:50:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so2522381wmi.0
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xXqjSZMM1covTSrp1HRhIWpS1JuVzYMRj32aOU4LFNY=;
        b=vTkRhWjo6jSEvpWWEW1Emjn6CcfDnJ+7SwvtoIsAlNCDcMbdXiRy3kalnrVXTtFYka
         jZzqXEPpWYCrpV0W/Zsob0s/etvADU77QaxmjS7NVnZ9NkhMUmi86RlyAKPSS5KCmOkv
         SvGJzr03sW2Jz6+1VIlUp08uJ/Cn9UaLTgLYpYp1huLKIXUVn52QH+zBb4Dzk1yOBrgD
         +RSJFMHj5KTa3IaRp4Dr+SPWSj5AhwANUVwrNZtIha0MAsPk+KIMafkGEV4DJeFMDCbG
         xTH9rUL2bj50WyjG0a84ARIJfOuCE1ut1aiBDrx8JEnymT145rPGXeCFCQnCZNeDBjz6
         Bk6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xXqjSZMM1covTSrp1HRhIWpS1JuVzYMRj32aOU4LFNY=;
        b=tfgem6tmzeXRUMEeEN8GjAQhqGJ0OhsJ+xeohBBsXMuRsEZnUiUXWar5kOXTIomuv9
         0Qn3vSsk7UHTX/DUkuHD/5G5zg9jRCzmiwE6svDMajNi6jQNVQulaStrdbncoZ7gnEcf
         6d7JFvormWjt4j2UGocdcpuZtGTl5nrmQZdK8v2LEDss0WLfBH0z7vTwvyh70AeacuKy
         qebD3oCSRjKWaCRYIO3Qjhkf0/FhhHCcBHLmBgtHcLFbHbbVdI/nfom5au07TGPtXEFs
         zZus+3j3k7QIWwgeuHaQGNmjPKxUBtYX0yyaaon+jTNWjI571duAyTUpj6m5PSOSlplw
         u72A==
X-Gm-Message-State: APjAAAWbYR+frBlKShsaO016JSLWJs/JBPkd8M8EkMvhToWavpJpEveG
        Cntk/CzZp4BXUm6gzczmbZcQ1OiZXhc=
X-Google-Smtp-Source: APXvYqxSWdDSoobgjiSXtkAJfoD0gB355xiQD1x8HYntdbkOX2mTFcGVtpT4PF+l+iF4xObK4rwXIQ==
X-Received: by 2002:a7b:c159:: with SMTP id z25mr2968313wmi.105.1559044223763;
        Tue, 28 May 2019 04:50:23 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id h17sm16171177wrq.79.2019.05.28.04.50.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:50:23 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 2/3] devlink: implement flash update status monitoring
Date:   Tue, 28 May 2019 13:50:20 +0200
Message-Id: <20190528115021.2063-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Kernel sends notifications about flash update status, so implement these
messages for monitoring.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 436935f88bda..55cbc01189db 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -414,6 +414,10 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -3712,6 +3716,9 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_REGION_SET: return "set";
 	case DEVLINK_CMD_REGION_NEW: return "new";
 	case DEVLINK_CMD_REGION_DEL: return "del";
+	case DEVLINK_CMD_FLASH_UPDATE: return "begin";
+	case DEVLINK_CMD_FLASH_UPDATE_END: return "end";
+	case DEVLINK_CMD_FLASH_UPDATE_STATUS: return "status";
 	default: return "<unknown cmd>";
 	}
 }
@@ -3740,6 +3747,10 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_REGION_NEW:
 	case DEVLINK_CMD_REGION_DEL:
 		return "region";
+	case DEVLINK_CMD_FLASH_UPDATE:
+	case DEVLINK_CMD_FLASH_UPDATE_END:
+	case DEVLINK_CMD_FLASH_UPDATE_STATUS:
+		return "flash";
 	default: return "<unknown obj>";
 	}
 }
@@ -3764,6 +3775,29 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
 	return false;
 }
 
+static void pr_out_flash_update(struct dl *dl, struct nlattr **tb)
+{
+	__pr_out_handle_start(dl, tb, true, false);
+
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG])
+		pr_out_str(dl, "msg",
+			   mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]));
+
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT])
+		pr_out_str(dl, "component",
+			   mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT]));
+
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE])
+		pr_out_u64(dl, "done",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]));
+
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
+		pr_out_u64(dl, "total",
+			   mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]));
+
+	pr_out_handle_end(dl);
+}
+
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
 
 static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
@@ -3820,6 +3854,15 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_region(dl, tb);
 		break;
+	case DEVLINK_CMD_FLASH_UPDATE: /* fall through */
+	case DEVLINK_CMD_FLASH_UPDATE_END: /* fall through */
+	case DEVLINK_CMD_FLASH_UPDATE_STATUS:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_flash_update(dl, tb);
+		break;
 	}
 	return MNL_CB_OK;
 }
-- 
2.17.2

