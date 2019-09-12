Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D392B0DCC
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbfILL3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:29:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41524 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbfILL3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:29:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id h7so27020300wrw.8
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 04:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m1hQRQITwtM/j4OjWS3JDOBbFlDNCnBIeV8K5hFagqc=;
        b=vsScVw6Hl5jfxprfLn5iZ0J3EAsoizkRlXryKqcoSmp2nB4PBpmr5NKjJ6V7sY1u9s
         /rgvRrQzIaq+thbzZ3Ts8fFlIIyEQCC+/BrAQhVqkCLbhAAFOHFrAqdHXuh49MFBaSYV
         Jf+4PJgshq32YNN6lcxYUV9kETIufobm7RjETXt6SPgsOayrDBRCp83bWShwbf71tigj
         FkdBPvY9qkryKaEY7fgqEbYjgtrJyKfkSRTN9AE9cIrlVBGm0OmteLkfi3fgxDVxXjyb
         wvHA2HmrJOd5zCv2XXe7p7AzXyLL2bos8IxI//TSv3zg/VXngXto4e0atJD8mOryK2B6
         GUKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m1hQRQITwtM/j4OjWS3JDOBbFlDNCnBIeV8K5hFagqc=;
        b=o/Me7sDwgK2UhQaK4KjpuQTupa2mhHKy/0BFb4Uf2NLvw316/ozs0aPiHGwQcaIyuV
         z+rMnX+cyYJP1hisaC0PsIVXR+7VDufHA2rGcE1rFfPr6DkSuJQDqUhEk6buov4p/vx6
         WqIOSd0AkNX4EF9CdsENkewenVlmLcYzHBv1kmGcM+L7uDr0qCV8XtVrlepMq8XagRLs
         mHMMXSzfArCUdABnwYbMXSIQH0Gv7LvOkbxzaiw2XrufpHI673swdbN124GBKycRwRcU
         QIAPYI+oN6yFzAJ+6hF8MLao4/41cp7pPMreaqXYKx/+k0GBOjGfNAKo1ctgDaaRkmKz
         nQTA==
X-Gm-Message-State: APjAAAW/dTuQ7xZqGRZ7xRBovKTnroInrXV+ErhSlj5hNQCym3A6MHCg
        8n/BrPV8diNKQrSzjFYPoWkIInihCs8=
X-Google-Smtp-Source: APXvYqxgQKgip7QD01tgNAwil9EvE38beku97n+dio/v42lwuOh+Ysr1EZSEL0I36aVNXm3cu/KdOA==
X-Received: by 2002:a5d:4107:: with SMTP id l7mr28352369wrp.303.1568287780166;
        Thu, 12 Sep 2019 04:29:40 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id s10sm8487848wmf.48.2019.09.12.04.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 04:29:39 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        mlxsw@mellanox.com, f.fainelli@gmail.com
Subject: [patch iproute2-next v4 1/2] devlink: implement flash update status monitoring
Date:   Thu, 12 Sep 2019 13:29:37 +0200
Message-Id: <20190912112938.2292-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190912112938.2292-1-jiri@resnulli.us>
References: <20190912112938.2292-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Kernel sends notifications about flash update status, so implement these
messages for monitoring.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v3->v4:
- rebased (traps)
---
 devlink/devlink.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2f084c020765..31c319e3ef7a 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -443,6 +443,10 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE] = MNL_TYPE_U64,
+	[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_STATS] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_NAME] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_TRAP_ACTION] = MNL_TYPE_U8,
@@ -3878,6 +3882,9 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_REGION_SET: return "set";
 	case DEVLINK_CMD_REGION_NEW: return "new";
 	case DEVLINK_CMD_REGION_DEL: return "del";
+	case DEVLINK_CMD_FLASH_UPDATE: return "begin";
+	case DEVLINK_CMD_FLASH_UPDATE_END: return "end";
+	case DEVLINK_CMD_FLASH_UPDATE_STATUS: return "status";
 	case DEVLINK_CMD_TRAP_GET: return "get";
 	case DEVLINK_CMD_TRAP_SET: return "set";
 	case DEVLINK_CMD_TRAP_NEW: return "new";
@@ -3914,6 +3921,10 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_REGION_NEW:
 	case DEVLINK_CMD_REGION_DEL:
 		return "region";
+	case DEVLINK_CMD_FLASH_UPDATE:
+	case DEVLINK_CMD_FLASH_UPDATE_END:
+	case DEVLINK_CMD_FLASH_UPDATE_STATUS:
+		return "flash";
 	case DEVLINK_CMD_TRAP_GET:
 	case DEVLINK_CMD_TRAP_SET:
 	case DEVLINK_CMD_TRAP_NEW:
@@ -3948,6 +3959,29 @@ static bool cmd_filter_check(struct dl *dl, uint8_t cmd)
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
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
@@ -4006,6 +4040,15 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
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
 	case DEVLINK_CMD_TRAP_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_SET: /* fall through */
 	case DEVLINK_CMD_TRAP_NEW: /* fall through */
-- 
2.20.1

