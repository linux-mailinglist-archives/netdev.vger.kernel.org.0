Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5723A505CBD
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346425AbiDRQxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346447AbiDRQwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:52:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDF82BC3;
        Mon, 18 Apr 2022 09:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70666B80FF4;
        Mon, 18 Apr 2022 16:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B34C385AA;
        Mon, 18 Apr 2022 16:49:44 +0000 (UTC)
Subject: [PATCH RFC 3/5] net/tls: Add an AF_TLSH address family
From:   Chuck Lever <chuck.lever@oracle.com>
To:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Date:   Mon, 18 Apr 2022 12:49:43 -0400
Message-ID: <165030058340.5073.5461321687798728373.stgit@oracle-102.nfsv4.dev>
In-Reply-To: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for an AF_TLSH address family. The next patch
explains its purpose and operation.

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
index 6f85f5d957ef..fc28c68e6b5f 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -226,8 +226,9 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
+#define AF_TLSH		46	/* TLS handshake request */
 
-#define AF_MAX		46	/* For now.. */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -278,6 +279,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_TLSH		AF_TLSH
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..81bc14b67468 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -224,7 +224,7 @@ static struct lock_class_key af_family_kern_slock_keys[AF_MAX];
   x "AF_IEEE802154",	x "AF_CAIF"	,	x "AF_ALG"      , \
   x "AF_NFC"   ,	x "AF_VSOCK"    ,	x "AF_KCM"      , \
   x "AF_QIPCRTR",	x "AF_SMC"	,	x "AF_XDP"	, \
-  x "AF_MCTP"  , \
+  x "AF_MCTP"  ,	x "AF_TLSH"	, \
   x "AF_MAX"
 
 static const char *const af_family_key_strings[AF_MAX+1] = {
diff --git a/net/socket.c b/net/socket.c
index 6887840682bb..fc43ebd5ad66 100644
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
index e9e959343de9..734e284eb06a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1259,7 +1259,9 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
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
index 35aac62a662e..673b51f8281d 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -237,6 +237,8 @@ struct security_class_mapping secclass_map[] = {
 	  { COMMON_SOCK_PERMS, NULL } },
 	{ "smc_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
+	{ "tlsh_socket",
+	  { COMMON_SOCK_PERMS, NULL } },
 	{ "infiniband_pkey",
 	  { "access", NULL } },
 	{ "infiniband_endport",
@@ -257,6 +259,6 @@ struct security_class_mapping secclass_map[] = {
 	{ NULL }
   };
 
-#if PF_MAX > 46
+#if PF_MAX > 47
 #error New address family defined, please update secclass_map.
 #endif
diff --git a/tools/perf/trace/beauty/include/linux/socket.h b/tools/perf/trace/beauty/include/linux/socket.h
index 6f85f5d957ef..fc28c68e6b5f 100644
--- a/tools/perf/trace/beauty/include/linux/socket.h
+++ b/tools/perf/trace/beauty/include/linux/socket.h
@@ -226,8 +226,9 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
+#define AF_TLSH		46	/* TLS handshake request */
 
-#define AF_MAX		46	/* For now.. */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -278,6 +279,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_TLSH		AF_TLSH
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */


