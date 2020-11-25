Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DB32C3770
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgKYDDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:03:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727245AbgKYDB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:29 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AP2s9Le020711
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=th+CKi28MlGZAnT3YwU2SbBmrPkQrrRTwPpc7M09M30=;
 b=J0s14A/abR7S3ij/5bwDSI6P1VvpxG7aEYtohkJF82E9DrwRGS6dj2pBEZKxZ9P7s3kh
 rDOqAihSLAkonDKsGV5ZUmN8JLp/uoZMh6BDejXDNy5aEfhuOBSuj8ChwRQ6nVKix+VF
 ww5+UorNU2/xr7HZiuEPg8gj+28MJax3AC8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34yx1t31xr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:27 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:26 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 1C3F416A1897; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 11/34] bpf: refine memcg-based memory accounting for devmap maps
Date:   Tue, 24 Nov 2020 19:00:56 -0800
Message-ID: <20201125030119.2864302-12-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=13 spamscore=0
 mlxlogscore=838 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011250018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include map metadata and the node size (struct bpf_dtab_netdev)
into the accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/devmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2b5ca93c17de..a4dfe544946f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -175,7 +175,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *=
attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
=20
-	dtab =3D kzalloc(sizeof(*dtab), GFP_USER);
+	dtab =3D kzalloc(sizeof(*dtab), GFP_USER | __GFP_ACCOUNT);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
=20
@@ -602,8 +602,9 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(s=
truct net *net,
 	struct bpf_prog *prog =3D NULL;
 	struct bpf_dtab_netdev *dev;
=20
-	dev =3D kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
-			   dtab->map.numa_node);
+	dev =3D bpf_map_kmalloc_node(&dtab->map, sizeof(*dev),
+				   GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
+				   dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

