Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841E83F0D43
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhHRVYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:24:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233753AbhHRVYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 17:24:19 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ILEiqC010153
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 14:23:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7fpbhmy4NjQlauIn6hGsGBA07BHUjNjrEoUXjX+MLm0=;
 b=h5WzG6E3IMvgY1dXv227QrqrYs2vfYIqDgPIKMoOF5e2814BcfCGthQXs2CA6MqXFFoH
 htTOjCvkE9UcKNXS3vjYRwYfKL0dQ/aOQi9Fuo7ckFYEOnu3PLHk61hVqgu8Myg1qPvf
 NrkiSp4dPu74MWTiHWxwFFnx6w7YjekSuds= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ags1v5war-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 14:23:44 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 18 Aug 2021 14:23:43 -0700
Received: by devvm2049.vll0.facebook.com (Postfix, from userid 197479)
        id 536FB1A8F337; Wed, 18 Aug 2021 14:23:37 -0700 (PDT)
From:   Neil Spring <ntspring@fb.com>
To:     <davem@davemloft.net>, <edumazet@google.com>
CC:     <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <ncardwell@google.com>,
        <ycheng@google.com>, Neil Spring <ntspring@fb.com>
Subject: [net-next 0/1] tcp: support window clamp mid-stream
Date:   Wed, 18 Aug 2021 14:23:30 -0700
Message-ID: <20210818212331.3780069-1-ntspring@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: iYIusZ7YLCou-wvu2MR3p_xFT8gGhpFH
X-Proofpoint-ORIG-GUID: iYIusZ7YLCou-wvu2MR3p_xFT8gGhpFH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_07:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=866 mlxscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180132
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

Neil Spring (1):
  tcp: enable mid stream window clamp

 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

--=20
2.30.2

