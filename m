Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AEA2CAF56
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391113AbgLAWAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34898 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390570AbgLAWAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:00:03 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LnrGt027045
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hkpfF67xQ6U1ZlIknKfbnaBnXqBUdqcL6K2akhLDsUE=;
 b=bzUE2q9DD1cdMLZugy/nJMVAX9G4Lot1NWzr6jqPDVx/fzqt80NCE/YwEDqPzYRX3OSZ
 0dfb7muouut41fP797LE0GvyKYdKsn1SmX5+5iPnQ4Q8NrEDlglTdjpZSLyNMGWAKGzf
 C8g4y54m37m9/gOAXPUSZrSrN0wOr3UA3SY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfk0t9t-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:21 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:11 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 8DE2A19702C0; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 17/34] bpf: refine memcg-based memory accounting for xskmap maps
Date:   Tue, 1 Dec 2020 13:58:43 -0800
Message-ID: <20201201215900.3569844-18-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=717 malwarescore=0 spamscore=0 suspectscore=13 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xskmap memory accounting to include the memory taken by
the xsk_map_node structure.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/xdp/xskmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 66231ba6c348..9fff1e6dc9cd 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -16,7 +16,8 @@ static struct xsk_map_node *xsk_map_node_alloc(struct x=
sk_map *map,
 {
 	struct xsk_map_node *node;
=20
-	node =3D kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
+	node =3D bpf_map_kzalloc(&map->map, sizeof(*node),
+			       GFP_ATOMIC | __GFP_NOWARN);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

