Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339D522FC73
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgG0WqK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:46:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726268AbgG0WqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:46:09 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RMhEqf012449
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:08 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 32ggdmhknw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:46:08 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id E6F463FAB6F75; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 14/21] net/tcp: add netgpu ioctl setting up zero copy RX queues
Date:   Mon, 27 Jul 2020 15:44:37 -0700
Message-ID: <20200727224444.2987641-15-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=542
 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 clxscore=1034 bulkscore=0 lowpriorityscore=0 suspectscore=1
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Netgpu delivers iovecs to userspace for incoming data, but the
destination queue must be attached to the socket.  Do this via
and ioctl call on the socket itself.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/ipv4/tcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 27de9380ed14..261c28ccc8f6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -279,6 +279,7 @@
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
 #include <net/busy_poll.h>
+#include <net/netgpu.h>
 
 struct percpu_counter tcp_orphan_count;
 EXPORT_SYMBOL_GPL(tcp_orphan_count);
@@ -636,6 +637,10 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 			answ = READ_ONCE(tp->write_seq) -
 			       READ_ONCE(tp->snd_nxt);
 		break;
+#if IS_ENABLED(CONFIG_NETGPU)
+	case NETGPU_SOCK_IOCTL_ATTACH_QUEUES:	/* SIOCPROTOPRIVATE */
+		return netgpu_attach_socket(sk, (void __user *)arg);
+#endif
 	default:
 		return -ENOIOCTLCMD;
 	}
-- 
2.24.1

