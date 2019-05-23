Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035E1279A8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfEWJrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:47:14 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53637 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbfEWJrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:47:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id 198so5097448wme.3
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xXqjSZMM1covTSrp1HRhIWpS1JuVzYMRj32aOU4LFNY=;
        b=1XHnNdqFoIbdaiuz9GoiCkYL9kuyY9PCBE66sWQIs7za9qBJZQGoSfmfZDZuVgqTqC
         Ogr+pd2iHRvY7V9Lq3yOUqJyXqLdXNqWn53EEdO3Tg8dWMXy4EUCSAXw4eWo820sDuuv
         pgPLJR2fDmJwSJWpqxQRO9dB2YtMXt7XjUv8EwPKjtb1dKCGzkeferdhg/ADjkM2xq2N
         flXlduaCEHCf7i22M32TbqM81/Qdvy7+iC0WYvmEqvt71VgC95YMBPmeQtx+Of/9tQ9S
         IDwyYN5MjT9Bjc+A7Ta4KBi0FZcqpf/DOoiFKSFAiJ9FgTnpbZJSyARW99z48ZLk6B/p
         tQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xXqjSZMM1covTSrp1HRhIWpS1JuVzYMRj32aOU4LFNY=;
        b=Gop/ybIEAwjEoYYTMn9ZvTQhhaulCVZlo1IDTrgr8dWAMWKe/mKldCLURhnA8lMv94
         gAbi1ER++6Lz3YsZOicOL3VKLE7RtSHSukHt0HXUwUKobYFFxwPyHkdCTq+ksVtv2bAf
         Jtt0envJjQ4kJbyXjl47nEqeWHekZ8dBIPV5GC5bA7s4cmH0wd9/X8LgPCTQAYzbdmN2
         zwQqz3v9XG3y0cHUUm0pNwo8WEuk9tHB27l7WHwaonMIdWEStlEYuLUTRivuXuwgEQ0o
         CUIl2krn9sw2n3gN9giHIpSPkkv9Vfm+AnKkhLp93A8v3RiEJPf64kPssWElUK9mRjVp
         67Xw==
X-Gm-Message-State: APjAAAUNIqInLg6Dx8rf/8faHQkA1W3ZPiRZnXqBfsey4Wkxrt8ME/2a
        uoHVHXIN1W1/lQ9gMHUi5kdu5qBDvo8=
X-Google-Smtp-Source: APXvYqza6NRsImLh9VnbBWkpcsO0unPdFzodaUKNNgWT2RDcNDq15It/3nWtZ2MZY9yYCtN1fzPZ3g==
X-Received: by 2002:a1c:be19:: with SMTP id o25mr10512746wmf.138.1558604832403;
        Thu, 23 May 2019 02:47:12 -0700 (PDT)
Received: from localhost (ip-89-176-222-123.net.upcbroadband.cz. [89.176.222.123])
        by smtp.gmail.com with ESMTPSA id d6sm25795783wrp.9.2019.05.23.02.47.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 02:47:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org
Subject: [patch iproute2 2/3] devlink: implement flash update status monitoring
Date:   Thu, 23 May 2019 11:47:09 +0200
Message-Id: <20190523094710.2410-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190523094510.2317-1-jiri@resnulli.us>
References: <20190523094510.2317-1-jiri@resnulli.us>
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

