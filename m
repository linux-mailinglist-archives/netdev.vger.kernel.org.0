Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1900A3F0D44
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhHRVYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:24:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3632 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234038AbhHRVYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 17:24:21 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17ILHw5r002646
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 14:23:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qAIKPnKR5LeBsYQCc2Ot5a4Z5bfZTlPktPXRzM/cAcw=;
 b=dbPe7mIU8doNTIuiwSVCiv6UMlxMqWRKgiJHpzb7LUd+7JmCjDsfD7yBP2hi7z26PYga
 3vipIi48nNNKUpaj3LD+BvIoVIrDhwXM11MkTqXZD39oBOfsMw9DUzi19ZehJxxAG57K
 SRL/77vghA7k0JpVkbs54q2/Kbch5V0PtRc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3aguu1w3e2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 14:23:45 -0700
Received: from intmgw001.27.prn2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 14:23:45 -0700
Received: by devvm2049.vll0.facebook.com (Postfix, from userid 197479)
        id 492111A8F342; Wed, 18 Aug 2021 14:23:38 -0700 (PDT)
From:   Neil Spring <ntspring@fb.com>
To:     <davem@davemloft.net>, <edumazet@google.com>
CC:     <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <ncardwell@google.com>,
        <ycheng@google.com>, Neil Spring <ntspring@fb.com>
Subject: [net 1/1] tcp: enable mid stream window clamp
Date:   Wed, 18 Aug 2021 14:23:31 -0700
Message-ID: <20210818212331.3780069-2-ntspring@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818212331.3780069-1-ntspring@fb.com>
References: <20210818212331.3780069-1-ntspring@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: YWVVxwyM_K-L-0CCBadktpJRfcyRzQOj
X-Proofpoint-GUID: YWVVxwyM_K-L-0CCBadktpJRfcyRzQOj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_07:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=774 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Neil Spring <ntspring@fb.com>
---
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

