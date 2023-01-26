Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EC267D0D2
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjAZQCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjAZQCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:02:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4997A4FC13
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:02:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF46FB81E80
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FDFC433EF;
        Thu, 26 Jan 2023 16:02:16 +0000 (UTC)
Subject: [PATCH v2 1/3] net: Add an AF_HANDSHAKE address family
From:   Chuck Lever <chuck.lever@oracle.com>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, hare@suse.com, dhowells@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com, bcodding@redhat.com,
        jlayton@redhat.com
Date:   Thu, 26 Jan 2023 11:02:15 -0500
Message-ID: <167474893575.5189.4047983040070744566.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
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

Add definitions for an AF_HANDSHAKE address family. This address
family is a mechanism that is used to serially share socket
endpoints between the kernel and user space so that a library can
perform a transport layer security handshake on the socket.

The next patch further explains the purpose and operation of sockets
in this family.

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
index de3701a2a212..80f0ed0c3820 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -235,8 +235,9 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
+#define AF_HANDSHAKE	46	/* pass an FD to user space */
 
-#define AF_MAX		46	/* For now.. */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -287,6 +288,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_HANDSHAKE	AF_HANDSHAKE
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/net/core/sock.c b/net/core/sock.c
index 30407b2dd2ac..f2bc8fd2a586 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -229,7 +229,7 @@ static struct lock_class_key af_family_kern_slock_keys[AF_MAX];
   x "AF_IEEE802154",	x "AF_CAIF"	,	x "AF_ALG"      , \
   x "AF_NFC"   ,	x "AF_VSOCK"    ,	x "AF_KCM"      , \
   x "AF_QIPCRTR",	x "AF_SMC"	,	x "AF_XDP"	, \
-  x "AF_MCTP"  , \
+  x "AF_MCTP"  ,	x "AF_HANDSHAKE", \
   x "AF_MAX"
 
 static const char *const af_family_key_strings[AF_MAX+1] = {
diff --git a/net/socket.c b/net/socket.c
index 00da9ce3dba0..cef752aa6569 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -214,6 +214,7 @@ static const char * const pf_family_names[] = {
 	[PF_SMC]	= "PF_SMC",
 	[PF_XDP]	= "PF_XDP",
 	[PF_MCTP]	= "PF_MCTP",
+	[PF_HANDSHAKE]	= "PF_HANDSHAKE",
 };
 
 /*
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f553c370397e..7af3b66cbd6d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1257,7 +1257,9 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 			return SECCLASS_XDP_SOCKET;
 		case PF_MCTP:
 			return SECCLASS_MCTP_SOCKET;
-#if PF_MAX > 46
+		case PF_HANDSHAKE:
+			return SECCLASS_HANDSHAKE_SOCKET;
+#if PF_MAX > 47
 #error New address family defined, please update this function.
 #endif
 		}
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index a3c380775d41..5f3d4ff8ca5c 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -237,6 +237,8 @@ const struct security_class_mapping secclass_map[] = {
 	  { COMMON_SOCK_PERMS, NULL } },
 	{ "smc_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
+	{ "handshake_socket",
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
index de3701a2a212..80f0ed0c3820 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -235,8 +235,9 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
+#define AF_HANDSHAKE	46	/* pass an FD to user space */
 
-#define AF_MAX		46	/* For now.. */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -287,6 +288,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_HANDSHAKE	AF_HANDSHAKE
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */


