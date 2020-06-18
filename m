Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68741FF8DF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgFRQKe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61748 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732004AbgFRQK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IGARhS009930
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:27 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q65dcys3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:27 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 6EDDC3D44E152; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 18/21] tcp: add MSG_NETDMA flag for sendmsg()
Date:   Thu, 18 Jun 2020 09:09:38 -0700
Message-ID: <20200618160941.879717-19-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=691
 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=1 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 cotscore=-2147483648
 phishscore=0 impostorscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This flag indicates that the attached data is a zero-copy send,
and the pages should be retrieved from the netgpu module.  The
socket must have been marked as SOCK_ZEROCOPY, and also registered
with netgpu via SO_REGISTER_DMA.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/linux/socket.h | 1 +
 net/ipv4/tcp.c         | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 04d2bc97f497..63816cc25dee 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -310,6 +310,7 @@ struct ucred {
 					  */
 
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
+#define MSG_NETDMA  	0x8000000
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
 					   descriptor received through
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 810cc164f795..219670152f77 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1209,6 +1209,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			uarg->zerocopy = 0;
 	}
 
+	if (flags & MSG_NETDMA && size && sock_flag(sk, SOCK_ZEROCOPY)) {
+		zc = sk->sk_route_caps & NETIF_F_SG;
+		if (!zc) {
+			err = -EFAULT;
+			goto out_err;
+		}
+	}
+
 	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
 	    !tp->repair) {
 		err = tcp_sendmsg_fastopen(sk, msg, &copied_syn, size, uarg);
-- 
2.24.1

