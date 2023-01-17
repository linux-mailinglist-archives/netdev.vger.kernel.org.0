Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E597666E8B6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAQVrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjAQVpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:45:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C30270C75
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 12:08:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 017EDCE19C8
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 20:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8ECC433EF;
        Tue, 17 Jan 2023 20:08:03 +0000 (UTC)
Subject: [PATCH RFC 1/3] net/tls: Add an AF_TLSH address family
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com
Date:   Tue, 17 Jan 2023 15:08:02 -0500
Message-ID: <167398608250.5631.8948909443803573469.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
References: <167398534919.5631.3008767788631058826.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for an AF_TLSH address family. The next patch
explains its purpose and operation.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 include/linux/socket.h                         |    4 +++-
 net/core/sock.c                                |    2 +-
 net/socket.c                                   |    1 +
 security/selinux/hooks.c                       |    4 +++-
 security/selinux/include/classmap.h            |    4 +++-
 tools/perf/trace/beauty/include/linux/socket.h |    4 +++-
 6 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index de3701a2a212..e650c7a90138 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -235,8 +235,9 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
+#define AF_TLSH		46	/* TLS handshake request */
 
-#define AF_MAX		46	/* For now.. */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -287,6 +288,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_TLSH		AF_TLSH
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/net/core/sock.c b/net/core/sock.c
index 30407b2dd2ac..8a8ac154d243 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -229,7 +229,7 @@ static struct lock_class_key af_family_kern_slock_keys[AF_MAX];
   x "AF_IEEE802154",	x "AF_CAIF"	,	x "AF_ALG"      , \
   x "AF_NFC"   ,	x "AF_VSOCK"    ,	x "AF_KCM"      , \
   x "AF_QIPCRTR",	x "AF_SMC"	,	x "AF_XDP"	, \
-  x "AF_MCTP"  , \
+  x "AF_MCTP"  ,	x "AF_TLSH"	, \
   x "AF_MAX"
 
 static const char *const af_family_key_strings[AF_MAX+1] = {
diff --git a/net/socket.c b/net/socket.c
index 00da9ce3dba0..3f5e80173166 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -214,6 +214,7 @@ static const char * const pf_family_names[] = {
 	[PF_SMC]	= "PF_SMC",
 	[PF_XDP]	= "PF_XDP",
 	[PF_MCTP]	= "PF_MCTP",
+	[PF_TLSH]	= "PF_TLSH",
 };
 
 /*
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f553c370397e..e1c67e8f2bc4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1257,7 +1257,9 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 			return SECCLASS_XDP_SOCKET;
 		case PF_MCTP:
 			return SECCLASS_MCTP_SOCKET;
-#if PF_MAX > 46
+		case PF_TLSH:
+			return SECCLASS_TLSH_SOCKET;
+#if PF_MAX > 47
 #error New address family defined, please update this function.
 #endif
 		}
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index a3c380775d41..af2046f2d13d 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -237,6 +237,8 @@ const struct security_class_mapping secclass_map[] = {
 	  { COMMON_SOCK_PERMS, NULL } },
 	{ "smc_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
+	{ "tlsh_socket",
+	  { COMMON_SOCK_PERMS, NULL } },
 	{ "infiniband_pkey",
 	  { "access", NULL } },
 	{ "infiniband_endport",
@@ -259,6 +261,6 @@ const struct security_class_mapping secclass_map[] = {
 	{ NULL }
   };
 
-#if PF_MAX > 46
+#if PF_MAX > 47
 #error New address family defined, please update secclass_map.
 #endif
diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
index de3701a2a212..e650c7a90138 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -235,8 +235,9 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
+#define AF_TLSH		46	/* TLS handshake request */
 
-#define AF_MAX		46	/* For now.. */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -287,6 +288,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_TLSH		AF_TLSH
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */


