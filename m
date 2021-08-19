Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2B73F2124
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhHSTzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:55:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23396 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234371AbhHSTzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 15:55:48 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17JJsmNh013968
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 12:55:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=5hZu6M7Ng+3MnHuYvRCD+Ll8dQucfd0NEP4GuQaJvGw=;
 b=eacnpM7nWynqNJMANF8JWfb5koVJUqkivjVS99eDlaGKRYPtOqGknQn2/2AMagXiU+jl
 JZXOFQyf0kfKHYkGkeyajWT9CNsm8cyj8YULcxhpGY9HqUBfR0kp+0cWCkooV6z4I6+i
 YDkzRpMtaV5Ecn2LfKidcD3rPn690aWmAF0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ahrtb28rc-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 12:55:11 -0700
Received: from intmgw002.48.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 12:55:07 -0700
Received: by devvm2049.vll0.facebook.com (Postfix, from userid 197479)
        id 75B311BFB179; Thu, 19 Aug 2021 12:54:59 -0700 (PDT)
From:   Neil Spring <ntspring@fb.com>
To:     <davem@davemloft.net>, <edumazet@google.com>
CC:     <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <ncardwell@google.com>,
        <ycheng@google.com>, Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next v2] tcp: enable mid stream window clamp
Date:   Thu, 19 Aug 2021 12:54:43 -0700
Message-ID: <20210819195443.1191973-1-ntspring@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: doX_gku0FqlQXqtlqFoFLYmcfxORevsk
X-Proofpoint-GUID: doX_gku0FqlQXqtlqFoFLYmcfxORevsk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-19_07:2021-08-17,2021-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 bulkscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108190115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the siz=
e of
the advertised window to this value."  Window clamping is distributed acr=
oss two
variables, window_clamp ("Maximal window to advertise" in tcp.h) and rcv_=
ssthresh
("Current window clamp").

This patch updates the function where the window clamp is set to also red=
uce the current
window clamp, rcv_sshthresh, if needed.  With this, setting the TCP_WINDO=
W_CLAMP option
has the documented effect of limiting the window.

Signed-off-by: Neil Spring <ntspring@fb.com>
---
v2: - fix email formatting


 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f931def6302e..2dc6212d5888 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3338,6 +3338,8 @@ int tcp_set_window_clamp(struct sock *sk, int val)
 	} else {
 		tp->window_clamp =3D val < SOCK_MIN_RCVBUF / 2 ?
 			SOCK_MIN_RCVBUF / 2 : val;
+		tp->rcv_ssthresh =3D min(tp->rcv_ssthresh,
+				       tp->window_clamp);
 	}
 	return 0;
 }
--=20
2.30.2

