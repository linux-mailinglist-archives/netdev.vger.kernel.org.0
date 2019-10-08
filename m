Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05B8CF7B0
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbfJHLB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:01:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33941 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730409AbfJHLB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:01:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id j11so13079668wrp.1
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzuT4Mm77xLeHFlZGQjKrClU0JORArGXFfyv3K/uiq8=;
        b=Wmrn3E9VvLe/s/uwbEf8hWQrZYoLS3Z9CwpGmBGYzUM+Ct0kVjfIK/bogJ+ZaWwJA6
         PjxFDN0HqTmbTdNKv4rsNFV1kFcHFSDwKpfVYccaNPn1fVeRGn0OQozrSoz7DJzzTWjl
         zXZRB6u6pB2tEtB+MC4Ki8iotNpWedDKKlI5Ya7iZOsHDbKLNVLGPsc/NLTHe8FKlvvS
         Hi9Tc0ydGa8I/JF/9nlUGDtXRkl73ACFOIHML2G9BBJQJYoWFjuZMZzDZoFSknTp/hWQ
         xs8O36pkNagixIA0cfE+Mzz63Gxg242PTG9qlI3dSnnhkQAd1wKPPqbF8ok4/8LiVEtA
         eFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzuT4Mm77xLeHFlZGQjKrClU0JORArGXFfyv3K/uiq8=;
        b=m69foROyN2RZ8rr5A38gulWx3EvMeRb44X1qeopx7zuVtLtLh+TjnDx7RSjVeTLwQ+
         OHlcsKhYZ96AQYWzz+spQm411H5wkRroH6pj+CJ53szsyukXY1CGcH1B3J0vmj5nWcaT
         yM8X0MkkjJ8HbQVBVurg79ysJjtXa3U9ucPh6RWprF10gyLoGjuoi4saob/+JuB0cnZs
         wcz4m9TLe03g5mXSr4L0j0JDnzhesXw28h0GT/hLfZNho5OmPRomBbSmZWV8okFkmY6L
         +5sWzVsj4rpt5AoFPF8QHZlu1ac4m1QbbFzuWGhCgw1nKzpSe9CqHcsX7BLqYt+YkjoF
         Y1Zg==
X-Gm-Message-State: APjAAAXjZKBFWndu7feJdaKi6/W9oExSKW27M1dLL9SiB1vj1wg2flmA
        h9rx2Ae94h5rSUzaIkAuhShMMQpTywo=
X-Google-Smtp-Source: APXvYqwVbd0Y1V9EHFuIqPVBGKYrZ3RHE1PxCzG5FzfbIUui5Z5pvas37ihzWOj5OgbTByno2FTpdQ==
X-Received: by 2002:adf:f88d:: with SMTP id u13mr26597562wrp.104.1570532513443;
        Tue, 08 Oct 2019 04:01:53 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id y186sm5144578wmb.41.2019.10.08.04.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 04:01:52 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jon.maloy@ericsson.com,
        ying.xue@windriver.com, johannes.berg@intel.com, mkubecek@suse.cz,
        mlxsw@mellanox.com
Subject: [patch net-next] net: tipc: prepare attrs in __tipc_nl_compat_dumpit()
Date:   Tue,  8 Oct 2019 13:01:51 +0200
Message-Id: <20191008110151.6999-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

__tipc_nl_compat_dumpit() calls tipc_nl_publ_dump() which expects
the attrs to be available by genl_dumpit_info(cb)->attrs. Add info
struct and attr parsing in compat dumpit function.

Reported-by: syzbot+8d37c50ffb0f52941a5e@syzkaller.appspotmail.com
Fixes: 057af7071344 ("net: tipc: have genetlink code to parse the attrs during dumpit")

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/tipc/netlink_compat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 4950b754dacd..17a529739f8d 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -181,6 +181,7 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 				   struct tipc_nl_compat_msg *msg,
 				   struct sk_buff *arg)
 {
+	struct genl_dumpit_info info;
 	int len = 0;
 	int err;
 	struct sk_buff *buf;
@@ -191,6 +192,7 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 	memset(&cb, 0, sizeof(cb));
 	cb.nlh = (struct nlmsghdr *)arg->data;
 	cb.skb = arg;
+	cb.data = &info;
 
 	buf = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!buf)
@@ -209,6 +211,13 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 		goto err_out;
 	}
 
+	info.attrs = attrbuf;
+	err = nlmsg_parse_deprecated(cb.nlh, GENL_HDRLEN, attrbuf,
+				     tipc_genl_family.maxattr,
+				     tipc_genl_family.policy, NULL);
+	if (err)
+		goto err_out;
+
 	do {
 		int rem;
 
-- 
2.21.0

