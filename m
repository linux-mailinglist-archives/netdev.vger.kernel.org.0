Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8ED4F8F46
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfKLMIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:08:10 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58214 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725919AbfKLMIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:08:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 14:08:07 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACC87mH029764;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xACC87Rs004238;
        Tue, 12 Nov 2019 14:08:07 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xACC87mx004237;
        Tue, 12 Nov 2019 14:08:07 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next 1/4] devlink: Allow large formatted message of binary output
Date:   Tue, 12 Nov 2019 14:07:49 +0200
Message-Id: <1573560472-4187-2-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
References: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink supports pair output of name and value. When the value is
binary, it must be presented in an array. If the length of the binary
value exceeds fmsg limitation, break the value into chunks internally.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  4 +---
 net/core/devlink.c    | 24 +++++++++++++++---------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 92ebc25bd88c..47f87b2fcf63 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -971,8 +971,6 @@ int devlink_fmsg_u8_put(struct devlink_fmsg *fmsg, u8 value);
 int devlink_fmsg_u32_put(struct devlink_fmsg *fmsg, u32 value);
 int devlink_fmsg_u64_put(struct devlink_fmsg *fmsg, u64 value);
 int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value);
-int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
-			    u16 value_len);
 
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
 			       bool value);
@@ -985,7 +983,7 @@ int devlink_fmsg_u64_pair_put(struct devlink_fmsg *fmsg, const char *name,
 int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
 				 const char *value);
 int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
-				 const void *value, u16 value_len);
+				 const void *value, u32 value_len);
 
 struct devlink_health_reporter *
 devlink_health_reporter_create(struct devlink *devlink,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b1cde50f788d..1338f5fbc7d2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4419,12 +4419,11 @@ int devlink_fmsg_string_put(struct devlink_fmsg *fmsg, const char *value)
 }
 EXPORT_SYMBOL_GPL(devlink_fmsg_string_put);
 
-int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
-			    u16 value_len)
+static int devlink_fmsg_binary_put(struct devlink_fmsg *fmsg, const void *value,
+				   u16 value_len)
 {
 	return devlink_fmsg_put_value(fmsg, value, value_len, NLA_BINARY);
 }
-EXPORT_SYMBOL_GPL(devlink_fmsg_binary_put);
 
 int devlink_fmsg_bool_pair_put(struct devlink_fmsg *fmsg, const char *name,
 			       bool value)
@@ -4532,19 +4531,26 @@ int devlink_fmsg_string_pair_put(struct devlink_fmsg *fmsg, const char *name,
 EXPORT_SYMBOL_GPL(devlink_fmsg_string_pair_put);
 
 int devlink_fmsg_binary_pair_put(struct devlink_fmsg *fmsg, const char *name,
-				 const void *value, u16 value_len)
+				 const void *value, u32 value_len)
 {
+	u32 data_size;
+	u32 offset;
 	int err;
 
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, name);
 	if (err)
 		return err;
 
-	err = devlink_fmsg_binary_put(fmsg, value, value_len);
-	if (err)
-		return err;
+	for (offset = 0; offset < value_len; offset += data_size) {
+		data_size = value_len - offset;
+		if (data_size > DEVLINK_FMSG_MAX_SIZE)
+			data_size = DEVLINK_FMSG_MAX_SIZE;
+		err = devlink_fmsg_binary_put(fmsg, value + offset, data_size);
+		if (err)
+			return err;
+	}
 
-	err = devlink_fmsg_pair_nest_end(fmsg);
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
 		return err;
 
-- 
2.14.1

