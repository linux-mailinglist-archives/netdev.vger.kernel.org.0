Return-Path: <netdev+bounces-5139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6400670FC35
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:09:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E2AC281390
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:09:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E427719E7C;
	Wed, 24 May 2023 17:09:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042F31951A
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68596C433EF;
	Wed, 24 May 2023 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684948147;
	bh=WUHoPK2caAmuNQAL2lJbXAgqrn9jUu7/4vw2Mn9UWAk=;
	h=From:To:Cc:Subject:Date:From;
	b=eUkikjYo/IOz3mE03oEVVg8jBzyP26Qv2MnNjITpX13Vm/cx9QxKXpTQA7VIUpBJH
	 J5RAyGRxoCGG1PAvs0mMNYQvIz0joID3AUYEyL0FR+e+LTebE3bk4CbrUFALCBeiLT
	 sUUWRWDfXzlWAO0S65btdMbDYWQU9JUPss+y7qrACmyJ045iCBbct4cBY6MacyomkN
	 6Pxt6nF9r3z4tbOJX+ocENJEcIgCnMB78iNcoOQjKjqMp1dv9+TgZdEnpTwWu2Z9H7
	 yWB9mqcbovU9VKbZLA4tX+MBxA141ynwgTZQboS0W5VtKyjVoDklvKUmDnIq+pgztr
	 C9CJCyNoNLqQg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	chuck.lever@oracle.com
Subject: [PATCH net-next] net: ynl: prefix uAPI header include with uapi/
Date: Wed, 24 May 2023 10:09:01 -0700
Message-Id: <20230524170901.2036275-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To keep things simple we used to include the uAPI header
in the kernel in the #include <linux/$family.h> format.
This works well enough, most of the genl families should
have headers in include/net/ so linux/$family.h ends up
referring to the uAPI header, anyway. And if it doesn't
no big deal, we'll just include more info than we need.

Unless that is there is a naming conflict. Someone recently
created include/linux/psp.h which will be a problem when
supporting the PSP protocol. (I'm talking about
work-in-progress patches, but it's just a proof that assuming
lack of name conflicts was overly optimistic.)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: chuck.lever@oracle.com
---
 net/core/netdev-genl-gen.c | 2 +-
 net/core/netdev-genl-gen.h | 2 +-
 net/handshake/genl.c       | 2 +-
 net/handshake/genl.h       | 2 +-
 net/ipv4/fou_nl.c          | 2 +-
 net/ipv4/fou_nl.h          | 2 +-
 tools/net/ynl/ynl-gen-c.py | 4 +++-
 7 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
index de17ca2f7dbf..ea9231378aa6 100644
--- a/net/core/netdev-genl-gen.c
+++ b/net/core/netdev-genl-gen.c
@@ -8,7 +8,7 @@
 
 #include "netdev-genl-gen.h"
 
-#include <linux/netdev.h>
+#include <uapi/linux/netdev.h>
 
 /* NETDEV_CMD_DEV_GET - do */
 static const struct nla_policy netdev_dev_get_nl_policy[NETDEV_A_DEV_IFINDEX + 1] = {
diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
index 74d74fc23167..7b370c073e7d 100644
--- a/net/core/netdev-genl-gen.h
+++ b/net/core/netdev-genl-gen.h
@@ -9,7 +9,7 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
-#include <linux/netdev.h>
+#include <uapi/linux/netdev.h>
 
 int netdev_nl_dev_get_doit(struct sk_buff *skb, struct genl_info *info);
 int netdev_nl_dev_get_dumpit(struct sk_buff *skb, struct netlink_callback *cb);
diff --git a/net/handshake/genl.c b/net/handshake/genl.c
index 9f29efb1493e..233be5cbfec9 100644
--- a/net/handshake/genl.c
+++ b/net/handshake/genl.c
@@ -8,7 +8,7 @@
 
 #include "genl.h"
 
-#include <linux/handshake.h>
+#include <uapi/linux/handshake.h>
 
 /* HANDSHAKE_CMD_ACCEPT - do */
 static const struct nla_policy handshake_accept_nl_policy[HANDSHAKE_A_ACCEPT_HANDLER_CLASS + 1] = {
diff --git a/net/handshake/genl.h b/net/handshake/genl.h
index 2c1f1aa6a02a..ae72a596f6cc 100644
--- a/net/handshake/genl.h
+++ b/net/handshake/genl.h
@@ -9,7 +9,7 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
-#include <linux/handshake.h>
+#include <uapi/linux/handshake.h>
 
 int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info);
 int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info);
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 6c37c4f98cca..98b90107b5ab 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -8,7 +8,7 @@
 
 #include "fou_nl.h"
 
-#include <linux/fou.h>
+#include <uapi/linux/fou.h>
 
 /* Global operation policy for fou */
 const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
diff --git a/net/ipv4/fou_nl.h b/net/ipv4/fou_nl.h
index dbd0780a5d34..63a6c4ed803d 100644
--- a/net/ipv4/fou_nl.h
+++ b/net/ipv4/fou_nl.h
@@ -9,7 +9,7 @@
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
-#include <linux/fou.h>
+#include <uapi/linux/fou.h>
 
 /* Global operation policy for fou */
 extern const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1];
diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index cc2f8c945340..be664510f484 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2101,7 +2101,9 @@ _C_KW = {
             if args.out_file:
                 cw.p(f'#include "{os.path.basename(args.out_file[:-2])}.h"')
             cw.nl()
-    headers = [parsed.uapi_header]
+        headers = ['uapi/' + parsed.uapi_header]
+    else:
+        headers = [parsed.uapi_header]
     for definition in parsed['definitions']:
         if 'header' in definition:
             headers.append(definition['header'])
-- 
2.40.1


