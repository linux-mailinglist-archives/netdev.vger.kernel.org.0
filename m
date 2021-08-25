Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200EE3F7D73
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 23:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235149AbhHYVCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:02:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232773AbhHYVCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 17:02:45 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17PL18HX001909
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 14:01:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ZEVOqanLqTGacVq1ZEG1obp1A22NvOoHUdSOBClH+pw=;
 b=h5AAXsaJycIWChIkuhsVMwldxLZPg2Ga+7brX19ieJfarokP0rFClvYZ5U78dMPp1KJ+
 SNQrjWdiP/UNzodcbDjODY0mdBRzzHW9eF0sK7Hgb1ZRoM6UNxbA7HRUEd8gPdVhAGLS
 DJ5VX7bF5uhhupALkkolK8JfPwUadgXmI0I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3an50714qu-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 14:01:58 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 14:01:53 -0700
Received: by devvm2049.vll0.facebook.com (Postfix, from userid 197479)
        id 834E928575E7; Wed, 25 Aug 2021 14:01:40 -0700 (PDT)
From:   Neil Spring <ntspring@fb.com>
To:     <davem@davemloft.net>, <edumazet@google.com>
CC:     <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <ncardwell@google.com>,
        <ycheng@google.com>, Neil Spring <ntspring@fb.com>
Subject: [PATCH net-next v3] tcp: enable mid stream window clamp
Date:   Wed, 25 Aug 2021 14:01:17 -0700
Message-ID: <20210825210117.1668371-1-ntspring@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: vZJXsPWg-kd5H1o3vzWx2O68Y1pQKsR0
X-Proofpoint-ORIG-GUID: vZJXsPWg-kd5H1o3vzWx2O68Y1pQKsR0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_08:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108250121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCP_WINDOW_CLAMP socket option is defined in tcp(7) to "Bound the siz=
e
of the advertised window to this value."  Window clamping is distributed
across two variables, window_clamp ("Maximal window to advertise" in
tcp.h) and rcv_ssthresh ("Current window clamp").

This patch updates the function where the window clamp is set to also
reduce the current window clamp, rcv_sshthresh, if needed.  With this,
setting the TCP_WINDOW_CLAMP option has the documented effect of limiting
the window.

Signed-off-by: Neil Spring <ntspring@fb.com>
---
v2: - fix email formatting

v3: - address comments by setting rcv_ssthresh based on prior window=20

 net/ipv4/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f931def6302e..e8b48df73c85 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3338,6 +3338,7 @@ int tcp_set_window_clamp(struct sock *sk, int val)
 	} else {
 		tp->window_clamp =3D val < SOCK_MIN_RCVBUF / 2 ?
 			SOCK_MIN_RCVBUF / 2 : val;
+		tp->rcv_ssthresh =3D min(tp->rcv_wnd, tp->window_clamp);
 	}
 	return 0;
 }
--=20
2.30.2

