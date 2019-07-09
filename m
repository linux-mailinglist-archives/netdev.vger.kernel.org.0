Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8F0462F20
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 06:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfGIEAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 00:00:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2246 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfGIEAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 00:00:15 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x693tfdG032539
        for <netdev@vger.kernel.org>; Mon, 8 Jul 2019 21:00:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=VAGd0gf1ncmepyOLs6mYxhFEODiYCDILer/9l6YHMHA=;
 b=cvWKv2mY11KzGVTkr7qwEixT2SuyhAsI7HvBa6fLYXX/VjwcYZMLBfPW1WjRot5yslZA
 z4Cqi7gCPmKj2shs6f8OBvQYOa1VVRCfdtiogj/Oyob6lbJGGGwSa4Anu0HinLThpXCl
 7keCzLXsuRGAwYJTuSTWuOh28eaxYWJv+sk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tmebu0ue6-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 21:00:14 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 8 Jul 2019 21:00:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 6E86A8615B1; Mon,  8 Jul 2019 21:00:11 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] libbpf: fix ptr to u64 conversion warning on 32-bit platforms
Date:   Mon, 8 Jul 2019 21:00:07 -0700
Message-ID: <20190709040007.1665882-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 32-bit platforms compiler complains about conversion:

libbpf.c: In function =E2=80=98perf_event_open_probe=E2=80=99:
libbpf.c:4112:17: error: cast from pointer to integer of different
size [-Werror=3Dpointer-to-int-cast]
  attr.config1 =3D (uint64_t)(void *)name; /* kprobe_func or uprobe_path =
*/
                 ^

Reported-by: Matt Hart <matthew.hart@linaro.org>
Fixes: b26500274767 ("libbpf: add kprobe/uprobe attach API")
Tested-by: Matt Hart <matthew.hart@linaro.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ed07789b3e62..794dd5064ae8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4126,8 +4126,8 @@ static int perf_event_open_probe(bool uprobe, bool =
retprobe, const char *name,
 	}
 	attr.size =3D sizeof(attr);
 	attr.type =3D type;
-	attr.config1 =3D (uint64_t)(void *)name; /* kprobe_func or uprobe_path =
*/
-	attr.config2 =3D offset;		       /* kprobe_addr or probe_offset */
+	attr.config1 =3D ptr_to_u64(name); /* kprobe_func or uprobe_path */
+	attr.config2 =3D offset;		 /* kprobe_addr or probe_offset */
=20
 	/* pid filter is meaningful only for uprobes */
 	pfd =3D syscall(__NR_perf_event_open, &attr,
--=20
2.17.1

