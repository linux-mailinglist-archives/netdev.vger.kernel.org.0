Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3D7219843
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgGIGLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:11:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726517AbgGIGLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:11:15 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0696BAav004343
        for <netdev@vger.kernel.org>; Wed, 8 Jul 2020 23:11:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=9w/W7gadCnPV8FsAX9sFMZ/0YEwhyKmbyL970+hTteU=;
 b=LsmU5CAH0J7SN5gMEc0CqM7xtaSFHA0/PZDpIYC3K7jqU4hwHegB4UMa5Ea5UdFh5qNJ
 3U6OXdFKBsPlZRwdpDkruKO5gBviq7y+C3+CJXh8bSZBGt2hZHkzEvoyigRdkRZ/jBC+
 YQMv7Cc3Mm46LQ5wj4WH7UahbT1e6bpesAI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 325k2uate4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:11:14 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 8 Jul 2020 23:10:59 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id F26452945AE1; Wed,  8 Jul 2020 23:10:57 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf 0/2] bpf: net: Fixes in sk_user_data of reuseport_array
Date:   Wed, 8 Jul 2020 23:10:57 -0700
Message-ID: <20200709061057.4018499-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-09_01:2020-07-08,2020-07-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=13 priorityscore=1501 clxscore=1015
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=382 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007090049
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set fixes two issues on sk_user_data when a sk is added to
a reuseport_array.

The first patch is to avoid the sk_user_data being copied
to a cloned sk.  The second patch avoids doing bpf_sk_reuseport_detach()
on sk_user_data that is not managed by reuseport_array.

Since the changes are mostly related to bpf reuseport_array, so it is
currently tagged as bpf fixes.

v2:
- Avoid ~3UL (Andrii)

Martin KaFai Lau (2):
  bpf: net: Avoid copying sk_user_data of reuseport_array during
    sk_clone
  bpf: net: Avoid incorrect bpf_sk_reuseport_detach call

 include/net/sock.h           |  3 ++-
 kernel/bpf/reuseport_array.c | 14 ++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

--=20
2.24.1

