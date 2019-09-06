Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE49ABFC1
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406144AbfIFSrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 14:47:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37577 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbfIFSrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 14:47:08 -0400
Received: by mail-wm1-f65.google.com with SMTP id r195so8182672wme.2
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 11:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N1hOY0NvIiSffFdX4VqFgaEN0dG+LhJae4iCvHrHv3A=;
        b=Dcdyw8IyL7F4j7hChSYacpGZ4YLtT1mR434UxNODBoQMgYHtUC8jHtmcS9VB1sz5Pq
         IXgWBWBxpVV60lb7i4HXri7SkjXq4umY99dlKVcJyQKV5g3wJ/5uq3US29fE0fOzwB0E
         ZwqmlIW1MlhhYLKKkNHWIwiWaev4yM1qjKjGn88cI6NLekB6qKa0tlDo5d/1LeCFXRAe
         lgdlJanSI06Ugu47Rps3wBa8/pyNUOOa4N7TLxnI41PLgT0AKsxsepu/Iq5nptZhksOc
         +hRMZ/JX3DXDP7Q2CFGILr8y82TgRx3ep6nttl99/46b1fMuXMSJqsyZEV6/fF8Y8C+S
         HDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N1hOY0NvIiSffFdX4VqFgaEN0dG+LhJae4iCvHrHv3A=;
        b=emQybKO/VLgHdLMKb4HC67QrWOFHG1Pq4Qkg8Ceu2lcXU+icvtItGSJRLl0Qd7s84y
         kpRhTMLbWedlUZFv8s53yB72HulO2XIkKurG7Ge+V9J6MwPf1i1ENY5vlwzALHWPvN1Y
         u9opBXQE3VvG8Mqvy4A7eaxHqbq3LbOnOsYZ67/WUFWhSFGYOr0EDvPgPiHySIFxBmn5
         /qcus1YH3F+I/ebYOnnRlshpaxsLXjWu6VxUBxu7V/mImvuF9oww/RJYZU6cu3pTSWFy
         fzr9poJLeUZEH9sc6gr0wxW5I9cWm8EmuXQPzPko5wI+hEjEyCxOcJCCUd5KTaSTK4mX
         lk0A==
X-Gm-Message-State: APjAAAXIUUZcFJkJzogcy8Btbf4KBhtSPKxkevyoyxk+wEMt2W88AryV
        HrA7CiCUlXq9bwst7N13ajEAkLpIOlM=
X-Google-Smtp-Source: APXvYqxQKMESR9PqOV01LkR+/DnXukmYMENs/zC/OS2fpQoJlfdyZm+tj9fTCjo8PpqIAQ8aXy0VJA==
X-Received: by 2002:a1c:1dd4:: with SMTP id d203mr8810311wmd.45.1567795626230;
        Fri, 06 Sep 2019 11:47:06 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l1sm7971243wrb.1.2019.09.06.11.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 11:47:05 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2/net-next] devlink: add reload failed indication
Date:   Fri,  6 Sep 2019 20:47:04 +0200
Message-Id: <20190906184704.5348-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184419.5101-1-jiri@resnulli.us>
References: <20190906184419.5101-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c            | 22 +++++++++++++++-------
 include/uapi/linux/devlink.h |  2 ++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8c5612a9f9a8..8020d76dd7f7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -451,6 +451,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
 	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
 };
 
 static const enum mnl_attr_data_type
@@ -1950,11 +1951,6 @@ static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
 	pr_out_region_chunk_end(dl);
 }
 
-static void pr_out_dev(struct dl *dl, struct nlattr **tb)
-{
-	pr_out_handle(dl, tb);
-}
-
 static void pr_out_section_start(struct dl *dl, const char *name)
 {
 	if (dl->json_output) {
@@ -2630,11 +2626,23 @@ static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
 	struct dl *dl = data;
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
 	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	uint8_t reload_failed = 0;
 
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 		return MNL_CB_ERROR;
-	pr_out_dev(dl, tb);
+
+	if (tb[DEVLINK_ATTR_RELOAD_FAILED])
+		reload_failed = mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED]);
+
+	if (reload_failed) {
+		__pr_out_handle_start(dl, tb, true, false);
+		pr_out_bool(dl, "reload_failed", true);
+		pr_out_handle_end(dl);
+	} else {
+		pr_out_handle(dl, tb);
+	}
+
 	return MNL_CB_OK;
 }
 
@@ -3972,7 +3980,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_dev(dl, tb);
+		pr_out_handle(dl, tb);
 		break;
 	case DEVLINK_CMD_PORT_GET: /* fall through */
 	case DEVLINK_CMD_PORT_SET: /* fall through */
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3fb683bee6ba..d63cf9723f57 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -410,6 +410,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
 	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
 
+	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.21.0

