Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BEB23B0BD
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 01:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgHCXKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 19:10:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39594 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729164AbgHCXKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 19:10:51 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 073Mo74l029858
        for <netdev@vger.kernel.org>; Mon, 3 Aug 2020 16:10:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=bvt3I0oCfzjJXyCrbToSJXIJ9nR6dE9Azh74le8JbrQ=;
 b=e1yMYej7/wUuv/2E+iAPCaibW4UKmiMVT4KYkULTxPuc56LHNrBQ9RiOVzq0DD/l4CnW
 wCHDUMugwRnQGlXYB5DLAuEhPObNaSISP8Ju92+DNVgeWAuG0+WFjyxIOxYA3rbS420x
 gQeqyghyGXV8S9o1xuV2RxF5z3m8tR+54l4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32nr82f5tr-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 16:10:50 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 16:10:47 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 70F352943872; Mon,  3 Aug 2020 16:10:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH v4 bpf-next 04/12] tcp: Add saw_unknown to struct tcp_options_received
Date:   Mon, 3 Aug 2020 16:10:39 -0700
Message-ID: <20200803231039.2682896-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200803231013.2681560-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_15:2020-08-03,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 suspectscore=13 phishscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a later patch, the bpf prog only wants to be called to handle
a header option if that particular header option cannot be handled by
the kernel.  This unknown option could be written by the peer's bpf-prog.
It could also be a new standard option that the running kernel does not
support it while a bpf-prog can handle it.

This patch adds a "saw_unknown" bit to "struct tcp_options_received"
and it uses an existing one byte hole to do that.  "saw_unknown" will
be set in tcp_parse_options() if it sees an option that the kernel
cannot handle.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/tcp.h  |  2 ++
 net/ipv4/tcp_input.c | 22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 5528912dc468..981145691f60 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -92,6 +92,8 @@ struct tcp_options_received {
 		smc_ok : 1,	/* SMC seen on SYN packet		*/
 		snd_wscale : 4,	/* Window scaling received from sender	*/
 		rcv_wscale : 4;	/* Window scaling to send to receiver	*/
+	u8	saw_unknown:1,	/* Received unknown option		*/
+		unused:7;
 	u8	num_sacks;	/* Number of SACK blocks		*/
 	u16	user_mss;	/* mss requested by user in ioctl	*/
 	u16	mss_clamp;	/* Maximal mss, negotiated at connection setup */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 05d0818c3e31..c1d2fb507701 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3799,7 +3799,7 @@ static void tcp_parse_fastopen_option(int len, cons=
t unsigned char *cookie,
 	foc->exp =3D exp_opt;
 }
=20
-static void smc_parse_options(const struct tcphdr *th,
+static bool smc_parse_options(const struct tcphdr *th,
 			      struct tcp_options_received *opt_rx,
 			      const unsigned char *ptr,
 			      int opsize)
@@ -3808,10 +3808,13 @@ static void smc_parse_options(const struct tcphdr=
 *th,
 	if (static_branch_unlikely(&tcp_have_smc)) {
 		if (th->syn && !(opsize & 1) &&
 		    opsize >=3D TCPOLEN_EXP_SMC_BASE &&
-		    get_unaligned_be32(ptr) =3D=3D TCPOPT_SMC_MAGIC)
+		    get_unaligned_be32(ptr) =3D=3D TCPOPT_SMC_MAGIC) {
 			opt_rx->smc_ok =3D 1;
+			return true;
+		}
 	}
 #endif
+	return false;
 }
=20
 /* Try to parse the MSS option from the TCP header. Return 0 on failure,=
 clamped
@@ -3872,6 +3875,7 @@ void tcp_parse_options(const struct net *net,
=20
 	ptr =3D (const unsigned char *)(th + 1);
 	opt_rx->saw_tstamp =3D 0;
+	opt_rx->saw_unknown =3D 0;
=20
 	while (length > 0) {
 		int opcode =3D *ptr++;
@@ -3962,15 +3966,21 @@ void tcp_parse_options(const struct net *net,
 				 */
 				if (opsize >=3D TCPOLEN_EXP_FASTOPEN_BASE &&
 				    get_unaligned_be16(ptr) =3D=3D
-				    TCPOPT_FASTOPEN_MAGIC)
+				    TCPOPT_FASTOPEN_MAGIC) {
 					tcp_parse_fastopen_option(opsize -
 						TCPOLEN_EXP_FASTOPEN_BASE,
 						ptr + 2, th->syn, foc, true);
-				else
-					smc_parse_options(th, opt_rx, ptr,
-							  opsize);
+					break;
+				}
+
+				if (smc_parse_options(th, opt_rx, ptr, opsize))
+					break;
+
+				opt_rx->saw_unknown =3D 1;
 				break;
=20
+			default:
+				opt_rx->saw_unknown =3D 1;
 			}
 			ptr +=3D opsize-2;
 			length -=3D opsize;
--=20
2.24.1

