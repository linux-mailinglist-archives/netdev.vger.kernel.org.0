Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF96D594B4E
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351753AbiHPAOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 20:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356637AbiHPAMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 20:12:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDBBCCE38
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:29:32 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FIbwYg014763
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:29:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=zrAu2d6Awa3DTHIWUHb462duCgxHnfPFFfUZlSOGOdk=;
 b=oyYACSCpPU418kbuX5HnHwP0VwsFL2GVaC6E8GVNeMhNomimS3MT9MlZWIlBSNcHSvMO
 o3dkrbeWxU6FFw9diVrI2pP5H/d3ZLZPPrGE+O6x+YpP1QjxRPpVlyxC9ORJzPSZnK9M
 9MwhhKiWS+SDqcCK7wunnKN5eRWoOqkkn8E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hyry8t3vw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:29:31 -0700
Received: from twshared22246.03.prn5.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 15 Aug 2022 13:29:30 -0700
Received: by devbig150.prn5.facebook.com (Postfix, from userid 187975)
        id BC718DF6F050; Mon, 15 Aug 2022 13:29:18 -0700 (PDT)
From:   Jie Meng <jmeng@fb.com>
To:     <netdev@vger.kernel.org>
CC:     <kafai@fb.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <bpf@vger.kernel.org>, Jie Meng <jmeng@fb.com>
Subject: [PATCH net-next] tcp: Make SYN ACK RTO tunable by BPF programs with TFO
Date:   Mon, 15 Aug 2022 13:29:00 -0700
Message-ID: <20220815202900.3961097-1-jmeng@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: hNBfo_ZLakzw7fuLPYJ1SpqX9e9Sakpz
X-Proofpoint-ORIG-GUID: hNBfo_ZLakzw7fuLPYJ1SpqX9e9Sakpz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of the hardcoded TCP_TIMEOUT_INIT, this diff calls tcp_timeout_in=
it
to initiate req->timeout like the non TFO SYN ACK case.

Tested using the following packetdrill script, on a host with a BPF
program that sets the initial connect timeout to 10ms.

`../../common/defaults.sh`

// Initialize connection
    0 socket(..., SOCK_STREAM, IPPROTO_TCP) =3D 3
   +0 setsockopt(3, SOL_TCP, TCP_FASTOPEN, [1], 4) =3D 0
   +0 bind(3, ..., ...) =3D 0
   +0 listen(3, 1) =3D 0

   +0 < S 0:0(0) win 32792 <mss 1000,sackOK,FO TFO_COOKIE>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
   +.01 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
   +.02 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
   +.04 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK>
   +.01 < . 1:1(0) ack 1 win 32792

   +0 accept(3, ..., ...) =3D 4

Signed-off-by: Jie Meng <jmeng@fb.com>
---
 net/ipv4/tcp_fastopen.c | 3 ++-
 net/ipv4/tcp_timer.c    | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 825b216d11f5..45cc7f1ca296 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -272,8 +272,9 @@ static struct sock *tcp_fastopen_create_child(struct =
sock *sk,
 	 * The request socket is not added to the ehash
 	 * because it's been added to the accept queue directly.
 	 */
+	req->timeout =3D tcp_timeout_init(child);
 	inet_csk_reset_xmit_timer(child, ICSK_TIME_RETRANS,
-				  TCP_TIMEOUT_INIT, TCP_RTO_MAX);
+				  req->timeout, TCP_RTO_MAX);
=20
 	refcount_set(&req->rsk_refcnt, 2);
=20
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index b4dfb82d6ecb..cb79127f45c3 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -428,7 +428,7 @@ static void tcp_fastopen_synack_timer(struct sock *sk=
, struct request_sock *req)
 	if (!tp->retrans_stamp)
 		tp->retrans_stamp =3D tcp_time_stamp(tp);
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
-			  TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
+			  req->timeout << req->num_timeout, TCP_RTO_MAX);
 }
=20
=20
--=20
2.30.2

