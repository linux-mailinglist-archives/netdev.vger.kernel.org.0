Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2DF03493D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfFDNoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:44:55 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38987 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfFDNoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:44:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so108657wma.4
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 06:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xXqjSZMM1covTSrp1HRhIWpS1JuVzYMRj32aOU4LFNY=;
        b=qtgJbDWZKmZ9o+5jTIO2GgjEiHaE84CxNkxowXOEbc2H8qOOMiMCd2klelfJ6/sQlh
         Lbvhz1rDgOhP9qkM4RMYQCNxwFtOGUcGKAzo0PN1ErC3EL2d5Zs3Pet7Wos4r22GbihF
         pVwWv3dPSCwxP4aCK1kBpE5nbeYD7LQokpT88pg2LCyGmQNNIL8R763JxT0SoKuNwj4I
         815NKbyXjCIHG8diZ9llqooFzP+H1QcjeRT/2icIHZDB/y0aVvhvd1No1i0JRLlkyfgO
         IpTU50kkQmNixfIxpT+fYUqcmMn3PNspCaBsQktx0rnME2PHKvRMbOERURpjHPuUL0Dj
         MPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xXqjSZMM1covTSrp1HRhIWpS1JuVzYMRj32aOU4LFNY=;
        b=MPF2pa80mk0/aI+Y5pxra0XDLzXt2x55zb6GxiIRw2Y31TXj2WxBse6TRglll+iKfB
         kKYLEfOaZsYmYY0RCqU0FGtcbJHFfQTLy9k8LgCV0a1g2FWTgurkiI0elpTW721SkiKr
         zV8Twv9rgV7IZ+A8ei4KJL0MpmD14tlbgN4E+CZ56Qlw5/+u4BRYm6JKMhDcwhDvgSFe
         jlgu5giqCIadG6BpfB6GXqOhiew5v28Xd6LloM1ek9ueG0xdjLY4lQqPvFkfgvXRaYDl
         W5BWxhZSB/HDPEHDrSM/I6kq0iWGgjxwlxOm1sYngnPCgsK57BkUmYQTsXHQFIaLjBFw
         cIQA==
X-Gm-Message-State: APjAAAXO0ZFOHcMTsSFbi/ye4w21EBeeqB4K+uudn/dPvJjkFIx2nyWW
        IXscbrZSN1RuqN5qg4WJ3mwu+U1hxKXkFQ==
X-Google-Smtp-Source: APXvYqy+j2ZkmFTRa6piKADXSdAoumeWaEXHHN+IqnDRONlmSDp8FCsAl8c0XKdHaNVH8fz3Hxifrg==
X-Received: by 2002:a7b:c748:: with SMTP id w8mr5847238wmk.36.1559655891958;
        Tue, 04 Jun 2019 06:44:51 -0700 (PDT)
Received: from localhost (ip-62-245-91-87.net.upcbroadband.cz. [62.245.91.87])
        by smtp.gmail.com with ESMTPSA id w14sm5545057wrk.44.2019.06.04.06.44.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 06:44:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v3 2/3] devlink: implement flash update status monitoring
Date:   Tue,  4 Jun 2019 15:44:49 +0200
Message-Id: <20190604134450.2839-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190604134044.2613-1-jiri@resnulli.us>
References: <20190604134044.2613-1-jiri@resnulli.us>
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

