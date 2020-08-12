Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E5D24240F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHLC3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:29:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31728 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726173AbgHLC3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 22:29:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07C2SrRC005021
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:29:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=gWuW5eKj6LNbzlC7DSCDOcTS5DYUysXwrd1bdhjydP0=;
 b=ft3X0B9UF0Qndcn0rg5YQSvikSWGLXdKLOl08Hg5oWjP/Q9xtxDua01UKWABH/j+xLZa
 h8/SdB0ZRzHYXkWa1aQL0mN1GoahaeMqWqtT/t9y6r80aAQekbTBbT3NXtSjtLrpH5UE
 bhSKoLWCkczAmMoKDSDhRzokFDyxpFx92yM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32v0kjswc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:29:31 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 11 Aug 2020 19:29:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BBA792EC594F; Tue, 11 Aug 2020 19:29:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: fix XDP FD-based attach/detach logic around XDP_FLAGS_UPDATE_IF_NOEXIST
Date:   Tue, 11 Aug 2020 19:29:23 -0700
Message-ID: <20200812022923.1217922-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-11_19:2020-08-11,2020-08-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=406 malwarescore=0 phishscore=0 adultscore=0
 spamscore=0 impostorscore=0 suspectscore=8 priorityscore=1501 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120015
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enforce XDP_FLAGS_UPDATE_IF_NOEXIST only if new BPF program to be attache=
d is
non-NULL (i.e., we are not detaching a BPF program).

Reported-by: Stanislav Fomichev <sdf@google.com>
Fixes: d4baa9368a5e ("bpf, xdp: Extract common XDP program attachment log=
ic")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..b5d1129d8310 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8913,10 +8913,6 @@ static int dev_xdp_attach(struct net_device *dev, =
struct netlink_ext_ack *extack
 		NL_SET_ERR_MSG(extack, "Active program does not match expected");
 		return -EEXIST;
 	}
-	if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
-		NL_SET_ERR_MSG(extack, "XDP program already attached");
-		return -EBUSY;
-	}
=20
 	/* put effective new program into new_prog */
 	if (link)
@@ -8927,6 +8923,10 @@ static int dev_xdp_attach(struct net_device *dev, =
struct netlink_ext_ack *extack
 		enum bpf_xdp_mode other_mode =3D mode =3D=3D XDP_MODE_SKB
 					       ? XDP_MODE_DRV : XDP_MODE_SKB;
=20
+		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && cur_prog) {
+			NL_SET_ERR_MSG(extack, "XDP program already attached");
+			return -EBUSY;
+		}
 		if (!offload && dev_xdp_prog(dev, other_mode)) {
 			NL_SET_ERR_MSG(extack, "Native and generic XDP can't be active at the=
 same time");
 			return -EEXIST;
--=20
2.24.1

