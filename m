Return-Path: <netdev+bounces-6196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB0E7152D0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 03:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3CE281012
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 01:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE7C636;
	Tue, 30 May 2023 01:06:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3407EC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 01:06:47 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205E2C7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 18:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685408807; x=1716944807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eE+tq2MesmZsn2DWQFGXqI+fu3ttN3VMkVJ2CxcQsgc=;
  b=ayN3LzvWopQQHyzXoUtGJjJUlYbKiCdg6KAvpxSG4r7EpqDuz4iBAgsf
   oSH+e2a5iJXdxOXd5q5iqGVj6Cd/Jo0L8ax0UtHVjifMEdC0Rx6PaQbzx
   w2/ascvsCaCKvMA2Zg5ubPDtXk+j3+ype5ZcXaQjVtMXJhtlh/iCGz4WJ
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,201,1681171200"; 
   d="scan'208";a="329938485"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 01:06:44 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
	by email-inbound-relay-iad-1a-m6i4x-9fe6ad2f.us-east-1.amazon.com (Postfix) with ESMTPS id 9AAF180E1B;
	Tue, 30 May 2023 01:06:41 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:06:40 +0000
Received: from 88665a182662.ant.amazon.com.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 30 May 2023 01:06:37 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, Willem de Bruijn
	<willemdebruijn.kernel@gmail.com>
CC: Kuniyuki Iwashima <kuniyu@amazon.com>, Kuniyuki Iwashima
	<kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 06/14] udp: Remove UDPLITE_SEND_CSCOV and UDPLITE_RECV_CSCOV.
Date: Mon, 29 May 2023 18:03:40 -0700
Message-ID: <20230530010348.21425-7-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230530010348.21425-1-kuniyu@amazon.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D044UWA004.ant.amazon.com (10.13.139.7) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We could set partial checksum coverage for UDP-Lite via setsockopt,
but it's no longer supported.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 include/net/udplite.h |  4 ----
 net/ipv4/udp.c        | 45 ++-----------------------------------------
 net/ipv6/udp.c        |  4 ++--
 3 files changed, 4 insertions(+), 49 deletions(-)

diff --git a/include/net/udplite.h b/include/net/udplite.h
index e436917f9b14..f4c513cff753 100644
--- a/include/net/udplite.h
+++ b/include/net/udplite.h
@@ -8,10 +8,6 @@
 #include <net/ip6_checksum.h>
 #include <net/udp.h>
 
-/* UDP-Lite socket options */
-#define UDPLITE_SEND_CSCOV   10 /* sender partial coverage (as sent)      */
-#define UDPLITE_RECV_CSCOV   11 /* receiver partial coverage (threshold ) */
-
 /*
  *	Checksum computation is all in software, hence simpler getfrag.
  */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9d836604562a..dc416db001c8 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2642,7 +2642,6 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	struct udp_sock *up = udp_sk(sk);
 	int val, valbool;
 	int err = 0;
-	int is_udplite = IS_UDPLITE(sk);
 
 	if (level == SOL_SOCKET) {
 		err = sk_setsockopt(sk, level, optname, optval, optlen);
@@ -2727,36 +2726,6 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 		release_sock(sk);
 		break;
 
-	/*
-	 * 	UDP-Lite's partial checksum coverage (RFC 3828).
-	 */
-	/* The sender sets actual checksum coverage length via this option.
-	 * The case coverage > packet length is handled by send module. */
-	case UDPLITE_SEND_CSCOV:
-		if (!is_udplite)         /* Disable the option on UDP sockets */
-			return -ENOPROTOOPT;
-		if (val != 0 && val < 8) /* Illegal coverage: use default (8) */
-			val = 8;
-		else if (val > USHRT_MAX)
-			val = USHRT_MAX;
-		up->pcslen = val;
-		up->pcflag |= UDPLITE_SEND_CC;
-		break;
-
-	/* The receiver specifies a minimum checksum coverage value. To make
-	 * sense, this should be set to at least 8 (as done below). If zero is
-	 * used, this again means full checksum coverage.                     */
-	case UDPLITE_RECV_CSCOV:
-		if (!is_udplite)         /* Disable the option on UDP sockets */
-			return -ENOPROTOOPT;
-		if (val != 0 && val < 8) /* Avoid silly minimal values.       */
-			val = 8;
-		else if (val > USHRT_MAX)
-			val = USHRT_MAX;
-		up->pcrlen = val;
-		up->pcflag |= UDPLITE_RECV_CC;
-		break;
-
 	default:
 		err = -ENOPROTOOPT;
 		break;
@@ -2769,7 +2738,7 @@ EXPORT_SYMBOL(udp_lib_setsockopt);
 static int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 			  unsigned int optlen)
 {
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
+	if (level == SOL_UDP || level == SOL_SOCKET)
 		return udp_lib_setsockopt(sk, level, optname,
 					  optval, optlen,
 					  udp_push_pending_frames);
@@ -2815,16 +2784,6 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->gro_enabled;
 		break;
 
-	/* The following two cannot be changed on UDP sockets, the return is
-	 * always 0 (which corresponds to the full checksum coverage of UDP). */
-	case UDPLITE_SEND_CSCOV:
-		val = up->pcslen;
-		break;
-
-	case UDPLITE_RECV_CSCOV:
-		val = up->pcrlen;
-		break;
-
 	default:
 		return -ENOPROTOOPT;
 	}
@@ -2840,7 +2799,7 @@ EXPORT_SYMBOL(udp_lib_getsockopt);
 static int udp_getsockopt(struct sock *sk, int level, int optname,
 			  char __user *optval, int __user *optlen)
 {
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
+	if (level == SOL_UDP)
 		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
 	return ip_getsockopt(sk, level, optname, optval, optlen);
 }
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 161686aa0dbe..ecd304bbecb4 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1680,7 +1680,7 @@ static void udpv6_destroy_sock(struct sock *sk)
 static int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 			    unsigned int optlen)
 {
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE || level == SOL_SOCKET)
+	if (level == SOL_UDP || level == SOL_SOCKET)
 		return udp_lib_setsockopt(sk, level, optname,
 					  optval, optlen,
 					  udp_v6_push_pending_frames);
@@ -1690,7 +1690,7 @@ static int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t o
 static int udpv6_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {
-	if (level == SOL_UDP  ||  level == SOL_UDPLITE)
+	if (level == SOL_UDP)
 		return udp_lib_getsockopt(sk, level, optname, optval, optlen);
 	return ipv6_getsockopt(sk, level, optname, optval, optlen);
 }
-- 
2.30.2


