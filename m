Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99272C5AC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfE1Lsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:48:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40146 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfE1Lsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:48:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id 15so2496442wmg.5
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 04:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=epU2k/cBEMzaegX+zA+I0N6IA/FvNv2FtO4ZKvLQ00Y=;
        b=udbLjwVUuRU+BaWvf1Kt0IxPiRWDOgbWaayhrkmVNOm79Xob65fzZRMakCCHucLkOH
         DEL0rhXmrCBr//2RgRYY1/sT+thWwq9z531D2cTUKZOJNYNaZ6cefyUZGtix4XEOtKdG
         qjt8VdMGMW5Ui7BD0nMuih2tFnCsnT0gYwZBqmD3ZBk0sAMuAbBoDKenTYTpxBQfwCy2
         0u4lg5sbJcErDtOYqEwbTDDFR20l2Ow2o7oXLOxhc7TXzW/spj6lDWxeZsBdYmKV0hjh
         9XCQ05dKyddXrrdIXahG01taoOaG4bDIA3wOOwdKKYzg6O8hevJCAAYum9GnNpfCfjCz
         AazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=epU2k/cBEMzaegX+zA+I0N6IA/FvNv2FtO4ZKvLQ00Y=;
        b=KFnK+qvsf+ojhFZ/PXZQhzVFSL1YXpXDu5EXMmbnm7SGdKpQvr2g1J681cE6/4IyfW
         GcPQFG5rae6CG8yWRitXaENroipx8wYaOuTy+eBlRrQrOuD67xOUKy4F2qVvEBK87V14
         E1A0XWl5SiCd24mmtBHo803uzdKIO+IBX8dSiTfs2hbdkFhbCNULvsuFY6Ien8qhUnMV
         wuxEtElS3X2+Hek5qHcWNGuphTG1D+IQJF0GRtSq8Cj9V5k3jRPmY27nSl7Ta79J9dti
         J8Tt0DahvDolH7ob7C3ST+8aTxULU0u9BoJUjOrliUCoSpy6dO9rpK1fcaQK/Ob4d+yI
         /GOw==
X-Gm-Message-State: APjAAAV67jXIRHpf16VGj0Xczf1CE5WpisZIhzc3siyLAfWLsbjMhBmp
        2javiOMicHmz5A+Vqa2bw+p+ZohLn10=
X-Google-Smtp-Source: APXvYqwooL2F+KxbqcwNT6yapCtI133MzFI6sOXvASqgxBgyCdm25NE3f8WvARqSH3qRTo8wihajGw==
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr2825709wmh.103.1559044130823;
        Tue, 28 May 2019 04:48:50 -0700 (PDT)
Received: from localhost (ip-89-177-126-215.net.upcbroadband.cz. [89.177.126.215])
        by smtp.gmail.com with ESMTPSA id p16sm27871811wrg.49.2019.05.28.04.48.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 04:48:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, saeedm@mellanox.com, leon@kernel.org,
        f.fainelli@gmail.com
Subject: [patch net-next v2 4/7] devlink: allow driver to update progress of flash update
Date:   Tue, 28 May 2019 13:48:43 +0200
Message-Id: <20190528114846.1983-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190528114846.1983-1-jiri@resnulli.us>
References: <20190528114846.1983-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce a function to be called from drivers during flash. It sends
notification to userspace about flash update progress.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        |   8 +++
 include/uapi/linux/devlink.h |   5 ++
 net/core/devlink.c           | 102 +++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 151eb930d329..8f65356132be 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -741,6 +741,14 @@ void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_reporter_state state);
 
+void devlink_flash_update_begin_notify(struct devlink *devlink);
+void devlink_flash_update_end_notify(struct devlink *devlink);
+void devlink_flash_update_status_notify(struct devlink *devlink,
+					const char *status_msg,
+					const char *component,
+					unsigned long done,
+					unsigned long total);
+
 #if IS_ENABLED(CONFIG_NET_DEVLINK)
 
 void devlink_compat_running_version(struct net_device *dev,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 5bb4ea67d84f..5287b42c181f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -104,6 +104,8 @@ enum devlink_command {
 	DEVLINK_CMD_HEALTH_REPORTER_DUMP_CLEAR,
 
 	DEVLINK_CMD_FLASH_UPDATE,
+	DEVLINK_CMD_FLASH_UPDATE_END,		/* notification only */
+	DEVLINK_CMD_FLASH_UPDATE_STATUS,	/* notification only */
 
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
@@ -331,6 +333,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME,	/* string */
 	DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,	/* string */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,	/* string */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
+	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 9716a7f382cb..963178d32dda 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2673,6 +2673,108 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	return devlink->ops->reload(devlink, info->extack);
 }
 
+static int devlink_nl_flash_update_fill(struct sk_buff *msg,
+					struct devlink *devlink,
+					enum devlink_command cmd,
+					const char *status_msg,
+					const char *component,
+					unsigned long done, unsigned long total)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, 0, 0, &devlink_nl_family, 0, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+
+	if (cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS)
+		goto out;
+
+	if (status_msg &&
+	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG,
+			   status_msg))
+		goto nla_put_failure;
+	if (component &&
+	    nla_put_string(msg, DEVLINK_ATTR_FLASH_UPDATE_COMPONENT,
+			   component))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,
+			      done, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,
+			      total, DEVLINK_ATTR_PAD))
+		goto nla_put_failure;
+
+out:
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void __devlink_flash_update_notify(struct devlink *devlink,
+					  enum devlink_command cmd,
+					  const char *status_msg,
+					  const char *component,
+					  unsigned long done,
+					  unsigned long total)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_FLASH_UPDATE &&
+		cmd != DEVLINK_CMD_FLASH_UPDATE_END &&
+		cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_flash_update_fill(msg, devlink, cmd, status_msg,
+					   component, done, total);
+	if (err)
+		goto out_free_msg;
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+	return;
+
+out_free_msg:
+	nlmsg_free(msg);
+}
+
+void devlink_flash_update_begin_notify(struct devlink *devlink)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE,
+				      NULL, NULL, 0, 0);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_begin_notify);
+
+void devlink_flash_update_end_notify(struct devlink *devlink)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_END,
+				      NULL, NULL, 0, 0);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_end_notify);
+
+void devlink_flash_update_status_notify(struct devlink *devlink,
+					const char *status_msg,
+					const char *component,
+					unsigned long done,
+					unsigned long total)
+{
+	__devlink_flash_update_notify(devlink,
+				      DEVLINK_CMD_FLASH_UPDATE_STATUS,
+				      status_msg, component, done, total);
+}
+EXPORT_SYMBOL_GPL(devlink_flash_update_status_notify);
+
 static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 				       struct genl_info *info)
 {
-- 
2.17.2

