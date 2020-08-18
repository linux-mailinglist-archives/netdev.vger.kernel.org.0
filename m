Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369632490B6
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHRWXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:23:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11470 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726617AbgHRWXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:23:20 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMGeKM018046
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:23:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DIX4+I0+fka6sL2luSu5jA+zuSBAZrayhWkigZrpy0A=;
 b=Y2iQsCWNVJKOOWESKz2E9my53eV1+5a6dDFcdYcXC0AySG1p2n7lcRRhXqITVwfeFG/B
 HFXXAYdIGaWJL5+iPH9OK5d9mKDXqqGnnVUoYa9C/gzg6IBmWP8lk805C6I/fXp+vIa2
 tNZ8vX0tkugVw9Xr3U8jSOkPlHFhXx1AQ0A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304p3dbth-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:23:19 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:23:16 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 2AC1037050C9; Tue, 18 Aug 2020 15:23:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf v2 3/3] bpftool: handle EAGAIN error code properly in pids collection
Date:   Tue, 18 Aug 2020 15:23:12 -0700
Message-ID: <20200818222312.2181675-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200818222309.2181236-1-yhs@fb.com>
References: <20200818222309.2181236-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=549
 spamscore=0 mlxscore=0 clxscore=1015 suspectscore=8 adultscore=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the error code is EAGAIN, the kernel signals the user
space should retry the read() operation for bpf iterators.
Let us do it.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/bpf/bpftool/pids.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index e3b116325403..df7d8ec76036 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -134,6 +134,8 @@ int build_obj_refs_table(struct obj_refs_table *table=
, enum bpf_obj_type type)
 	while (true) {
 		ret =3D read(fd, buf, sizeof(buf));
 		if (ret < 0) {
+			if (errno =3D=3D EAGAIN)
+				continue;
 			err =3D -errno;
 			p_err("failed to read PID iterator output: %d", err);
 			goto out;
--=20
2.24.1

