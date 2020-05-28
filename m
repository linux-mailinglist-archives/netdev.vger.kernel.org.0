Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95181E5571
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgE1FNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgE1FNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 01:13:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192ABC05BD1E;
        Wed, 27 May 2020 22:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OiNHoC++ZJU6Frq2cw0ICACNWwiR/rswekrw6423rd8=; b=rkGGksOhNzB0fjN8MqaowV5Kjp
        gVC7Y/3rFWBpdFGLzPcDwmemMR1h14UTRr8JmFAhgaC9aTFnNAruNNAtLp0Qy4ugZ+e4o1H9C/ZPq
        RsuWiPIzBsDw8xLMgOjUQXlkDoYmnJVurcinzDc+bftRIBCI0J2kgImNjB9ourKn3A0pQgKABrwHI
        Hn8ObVPnBBo9y/UQY32qzssj51jMPReVMrNmW6QzVGJaPN1aWK6SrNIpjQ5YStuYGCGQUb6mqBubf
        +ojcAw2FhI66B8JNh3OkxuLCdyEV0FvUSLBEIZOjKh5qdSvQv/izNkxDU4U8V7Sb5PVryuZlroikh
        VYDUbIRg==;
Received: from p4fdb1ad2.dip0.t-ipconnect.de ([79.219.26.210] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jeAqg-0001fT-LD; Thu, 28 May 2020 05:13:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH 06/28] net: add sock_enable_timestamps
Date:   Thu, 28 May 2020 07:12:14 +0200
Message-Id: <20200528051236.620353-7-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528051236.620353-1-hch@lst.de>
References: <20200528051236.620353-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to directly enable timestamps instead of setting the
SO_TIMESTAMP* sockopts from kernel space and going through a fake
uaccess.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/sock.h       |  1 +
 net/core/sock.c          | 47 +++++++++++++++++++++++++---------------
 net/rxrpc/local_object.c |  8 +------
 3 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cdec7bc055d5b..99ef43508d2b5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2689,6 +2689,7 @@ static inline bool sk_dev_equal_l3scope(struct sock *sk, int dif)
 void sock_def_readable(struct sock *sk);
 
 int sock_bindtoindex(struct sock *sk, int ifindex);
+void sock_enable_timestamps(struct sock *sk);
 void sock_no_linger(struct sock *sk);
 void sock_set_priority(struct sock *sk, u32 priority);
 void sock_set_reuseaddr(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 23f80880fbb2c..e4a4dd2b3d8b3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -757,6 +757,28 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs)
 }
 EXPORT_SYMBOL(sock_set_sndtimeo);
 
+static void __sock_set_timestamps(struct sock *sk, bool val, bool new, bool ns)
+{
+	if (val)  {
+		sock_valbool_flag(sk, SOCK_TSTAMP_NEW, new);
+		sock_valbool_flag(sk, SOCK_RCVTSTAMPNS, ns);
+		sock_set_flag(sk, SOCK_RCVTSTAMP);
+		sock_enable_timestamp(sk, SOCK_TIMESTAMP);
+	} else {
+		sock_reset_flag(sk, SOCK_RCVTSTAMP);
+		sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
+		sock_reset_flag(sk, SOCK_TSTAMP_NEW);
+	}
+}
+
+void sock_enable_timestamps(struct sock *sk)
+{
+	lock_sock(sk);
+	__sock_set_timestamps(sk, true, false, true);
+	release_sock(sk);
+}
+EXPORT_SYMBOL(sock_enable_timestamps);
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -948,28 +970,17 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_TIMESTAMP_OLD:
+		__sock_set_timestamps(sk, valbool, false, false);
+		break;
 	case SO_TIMESTAMP_NEW:
+		__sock_set_timestamps(sk, valbool, true, false);
+		break;
 	case SO_TIMESTAMPNS_OLD:
+		__sock_set_timestamps(sk, valbool, false, true);
+		break;
 	case SO_TIMESTAMPNS_NEW:
-		if (valbool)  {
-			if (optname == SO_TIMESTAMP_NEW || optname == SO_TIMESTAMPNS_NEW)
-				sock_set_flag(sk, SOCK_TSTAMP_NEW);
-			else
-				sock_reset_flag(sk, SOCK_TSTAMP_NEW);
-
-			if (optname == SO_TIMESTAMP_OLD || optname == SO_TIMESTAMP_NEW)
-				sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			else
-				sock_set_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_set_flag(sk, SOCK_RCVTSTAMP);
-			sock_enable_timestamp(sk, SOCK_TIMESTAMP);
-		} else {
-			sock_reset_flag(sk, SOCK_RCVTSTAMP);
-			sock_reset_flag(sk, SOCK_RCVTSTAMPNS);
-			sock_reset_flag(sk, SOCK_TSTAMP_NEW);
-		}
+		__sock_set_timestamps(sk, valbool, true, true);
 		break;
-
 	case SO_TIMESTAMPING_NEW:
 		sock_set_flag(sk, SOCK_TSTAMP_NEW);
 		/* fall through */
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 01135e54d95d2..5ea2bd01fdd59 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -189,13 +189,7 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 		}
 
 		/* We want receive timestamps. */
-		opt = 1;
-		ret = kernel_setsockopt(local->socket, SOL_SOCKET, SO_TIMESTAMPNS_OLD,
-					(char *)&opt, sizeof(opt));
-		if (ret < 0) {
-			_debug("setsockopt failed");
-			goto error;
-		}
+		sock_enable_timestamps(local->socket->sk);
 		break;
 
 	default:
-- 
2.26.2

