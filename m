Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590A1B3767
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 11:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbfIPJoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 05:44:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38060 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbfIPJow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 05:44:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so9449081wme.3
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 02:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7ESs9uHM5VkRGACxzxAD9xhB/p6zmuVD2+nKgCKkDo=;
        b=tc8zxyCOhCElfLt7GvnO3HQMfVDzYLslOMuZ3ehiLfgwbWuOvYL2yZJNHU570WKn9Q
         rmXoB6HiKpkOphGUOQhntDGwlmqxhuwotmMScjdmUNTd2rg5v5jG3qAtvpE/uVMcXT6G
         l9lOy+dZXah4+uL0O2pA8tgrnWyGilos9YVuW8AKlgAQBlaeAOaXnr0tBAhX6yjTvR69
         26gR8uteo9zGOII3q2asZNeu30ICuWHcHI6EfumRhpoRQ+0y0DlQ5dfAEGUoxKGCosdG
         0YW58561AyFx/g8tYSo0XNajgBRcRHB2lD2jDCWQLkTPPxCnxvtWc2AXwboBSnOhaNSj
         cERQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7ESs9uHM5VkRGACxzxAD9xhB/p6zmuVD2+nKgCKkDo=;
        b=lFL+iQbiaAP1gwsPyB+7uZj1Rm6bWPBsQiLru4o6zsnBlOtBWDtaao5MlqdnX4dzGy
         wcK98hdzMikBgHWn1h9a7HcjipKnaB5jzlnIMqnBxbD75CXR9hck4kim08h0TkgpaFDV
         bhZxCCdnPjN5AQMjZOkN9utM5qw81jU0ps5hBT4cbX+nuLiv1rIYxuUUqeZ18yDyUwZo
         6tsaxbBXr7daByaA6DxwP0WQopf2koyQkO6UGrWHieW5bwu1phcltSubXZHWc8EeU+zH
         Gsn0/+rDpxbcifIC3jr1oAubqbSflsmysaSrcvPMYSrN9cN10y6Xs40PjhU4yv4achGh
         Lx+g==
X-Gm-Message-State: APjAAAXroUhtms4oKPl+aMqRk120vFwFixr7qPfrn/8P0s1xInR0AGPC
        c9JCTjBMhh3ihVvnbvNFd275DeCCm2E=
X-Google-Smtp-Source: APXvYqxsIuqVqARvNoKOKwXBnHCD9hJbke/RMTb2dXbWmqS0CTMEs7o/Fv9HjXYnSEXOQSyPFmBvnw==
X-Received: by 2002:a7b:c744:: with SMTP id w4mr4113840wmk.11.1568627089455;
        Mon, 16 Sep 2019 02:44:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a4sm4052731wmj.29.2019.09.16.02.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 02:44:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch iproute2-next v2] devlink: add reload failed indication
Date:   Mon, 16 Sep 2019 11:44:48 +0200
Message-Id: <20190916094448.26072-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add indication about previous failed devlink reload.

Example outputs:

$ devlink dev
netdevsim/netdevsim10: reload_failed true
$ devlink dev -j -p
{
    "dev": {
        "netdevsim/netdevsim10": {
            "reload_failed": true
        }
    }
}

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- added patch description including example
---
 devlink/devlink.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 15877a04f5d6..da62c144d5d5 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -450,6 +450,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_GENERIC] = MNL_TYPE_FLAG,
 	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
+	[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
 };
 
 static const enum mnl_attr_data_type
@@ -1949,11 +1950,6 @@ static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
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
@@ -2649,11 +2645,23 @@ static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
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
 
@@ -3991,7 +3999,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_dev(dl, tb);
+		pr_out_handle(dl, tb);
 		break;
 	case DEVLINK_CMD_PORT_GET: /* fall through */
 	case DEVLINK_CMD_PORT_SET: /* fall through */
-- 
2.21.0

