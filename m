Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DBF22FC66
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgG0WpJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 27 Jul 2020 18:45:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62998 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727820AbgG0WpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:45:07 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RMePol022667
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:45:05 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gj8kh8pr-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 15:45:05 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 15:44:51 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id E37653FAB6F73; Mon, 27 Jul 2020 15:44:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [RFC PATCH v2 13/21] net/tcp: Pad TCP options out to a fixed size for netgpu
Date:   Mon, 27 Jul 2020 15:44:36 -0700
Message-ID: <20200727224444.2987641-14-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=540 spamscore=0 impostorscore=0 malwarescore=0 suspectscore=1
 bulkscore=0 priorityscore=1501 clxscore=1034 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

The "header splitting" feature used by netgpu doesn't actually parse
the incoming packet header.  Instead, it splits the packet at a fixed
offset.  In order for this to work, the sender needs to send packets
with a fixed header size.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/ipv4/tcp_output.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index d8f16f6a9b02..e8a74d0f7ad2 100644
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
@@ -562,6 +563,17 @@ static void tcp_options_write(__be32 *ptr, struct tcp_sock *tp,
 	smc_options_write(ptr, &options);
 
 	mptcp_options_write(ptr, opts);
+
+#if IS_ENABLED(CONFIG_NETGPU)
+	/* pad out options */
+	if (opts->pad_size) {
+		int len = opts->pad_size;
+		u8 *p = (u8 *)ptr;
+
+		while (len--)
+			*p++ = TCPOPT_NOP;
+	}
+#endif
 }
 
 static void smc_set_option(const struct tcp_sock *tp,
@@ -826,6 +838,14 @@ static unsigned int tcp_established_options(struct sock *sk, struct sk_buff *skb
 			opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
 	}
 
+#if IS_ENABLED(CONFIG_NETGPU)
+	/* force padding */
+	if (size < 20) {
+		opts->pad_size = 20 - size;
+		size += opts->pad_size;
+	}
+#endif
+
 	return size;
 }
 
-- 
2.24.1

