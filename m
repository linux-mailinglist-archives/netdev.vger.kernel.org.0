Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93CF11FF8CA
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731931AbgFRQKA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17464 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731766AbgFRQJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:09:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9ju9029958
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:51 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q644n0tx-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:09:51 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:48 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 6B26F3D44E150; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 17/21] net/core: add the SO_REGISTER_DMA socket option
Date:   Thu, 18 Jun 2020 09:09:37 -0700
Message-ID: <20200618160941.879717-18-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=638 phishscore=0 spamscore=0 clxscore=1034 bulkscore=0
 cotscore=-2147483648 suspectscore=1 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This option says that the socket will be performing zero copy sends
and receives through the netgpu module.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/uapi/asm-generic/socket.h |  2 ++
 net/core/sock.c                   | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 77f7c1638eb1..5a8577c90e2a 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -119,6 +119,8 @@
 
 #define SO_DETACH_REUSEPORT_BPF 68
 
+#define SO_REGISTER_DMA		69
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220..c9e93ee675d6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -828,6 +828,25 @@ void sock_set_rcvbuf(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(sock_set_rcvbuf);
 
+extern int netgpu_register_dma(struct sock *sk, char __user *optval, unsigned int optlen);
+
+static int
+sock_register_dma(struct sock *sk, char __user *optval, unsigned int optlen)
+{
+	int rc;
+	int (*fn)(struct sock *sk, char __user *optval, unsigned int optlen);
+
+	fn = symbol_get(netgpu_register_dma);
+	if (!fn)
+		return -EINVAL;
+
+	rc = fn(sk, optval, optlen);
+
+	symbol_put(netgpu_register_dma);
+
+	return rc;
+}
+
 /*
  *	This is meant for all protocols to use and covers goings on
  *	at the socket level. Everything here is generic.
@@ -1232,6 +1251,13 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 		break;
 
+	case SO_REGISTER_DMA:
+		if (!sk->sk_bound_dev_if)
+			ret = -EINVAL;
+		else
+			ret = sock_register_dma(sk, optval, optlen);
+		break;
+
 	case SO_TXTIME:
 		if (optlen != sizeof(struct sock_txtime)) {
 			ret = -EINVAL;
-- 
2.24.1

