Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9815F1FF8D2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731985AbgFRQKM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 12:10:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65298 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731959AbgFRQKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:10:05 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05IG9xhO011546
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:04 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31q656mqsb-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:10:04 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 09:09:47 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 32D243D44E134; Thu, 18 Jun 2020 09:09:41 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <axboe@kernel.dk>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH 03/21] tcp: Pad TCP options out to a fixed size
Date:   Thu, 18 Jun 2020 09:09:23 -0700
Message-ID: <20200618160941.879717-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200618160941.879717-1-jonathan.lemon@gmail.com>
References: <20200618160941.879717-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-18_14:2020-06-18,2020-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 bulkscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=466 clxscore=1034 cotscore=-2147483648 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 impostorscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006180122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "header splitting" feature used by netgpu doesn't actually parse
the incoming packet header.  Instead, it splits the packet at a fixed
offset.  In order for this to work, the sender needs to send packets
with a fixed header size.

(Obviously not for upstream committing, just for prototyping)

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/ipv4/tcp_output.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a50e1990a845..afc996ef2d4e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -438,6 +438,7 @@ struct tcp_out_options {
 	u8 ws;			/* window scale, 0 to disable */
 	u8 num_sack_blocks;	/* number of SACK blocks to include */
 	u8 hash_size;		/* bytes in hash_location */
+	u8 pad_size;		/* additional nops for padding */
 	__u8 *hash_location;	/* temporary pointer, overloaded */
 	__u32 tsval, tsecr;	/* need to include OPTION_TS */
 	struct tcp_fastopen_cookie *fastopen_cookie;	/* Fast open cookie */
@@ -562,6 +563,15 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 	smc_options_write(ptr, &options);
 
 	mptcp_options_write(ptr, opts);
+
+	/* pad out options for netgpu */
+	if (opts->pad_size) {
+		int len = opts->pad_size;
+		u8 *p = (u8 *)ptr;
+
+		while (len--)
+			*p++ = TCPOPT_NOP;
+	}
 }
 
 static void smc_set_option(const struct tcp_sock *tp,
@@ -824,6 +834,12 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
 
+	/* force padding for netgpu */
+	if (size < 20) {
+		opts->pad_size = 20 - size;
+		size += opts->pad_size;
+	}
+
 	return size;
 }
 
-- 
2.24.1

