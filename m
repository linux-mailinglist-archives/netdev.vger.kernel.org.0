Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E506A1D1CF3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390006AbgEMSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:04:03 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733144AbgEMSEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:04:02 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04DHwM5Y004777
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:04:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pvWz4rjy3UzEMGHQANPTs4xF8prE0hBWXpoP4NMxiK4=;
 b=C/YSDFtFgrDLQNN2Jixos0Jsp0t4pP600ZWxHXm00Hqd5Y2qcrerWO9vNYD3g09FK2Y6
 rCLRP6Ftrnsqz/4qVXSQ1yBVfi3s92pIj9so/klBhOZquL+n4b8nK6ZQIw+iwXPH6vHi
 gvb4y2oNXeBoXQUlyMPAxs+E5xQxEEgU88s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 310kwsrr3h-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:04:01 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 11:02:23 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 2D61E37009B0; Wed, 13 May 2020 11:02:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 3/7] bpf: add comments to interpret bpf_prog return values
Date:   Wed, 13 May 2020 11:02:18 -0700
Message-ID: <20200513180218.2949517-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200513180215.2949164-1-yhs@fb.com>
References: <20200513180215.2949164-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_08:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 cotscore=-2147483648
 priorityscore=1501 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a short comment in bpf_iter_run_prog() function to
explain how bpf_prog return value is converted to
seq_ops->show() return value:
  bpf_prog return           seq_ops()->show() return
     0                         0
     1                         -EAGAIN

When show() return value is -EAGAIN, the current
bpf_seq_read() will end. If the current seq_file buffer
is empty, -EAGAIN will return to user space. Otherwise,
the buffer will be copied to user space.
In both cases, the next bpf_seq_read() call will
try to show the same object which returned -EAGAIN
previously.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bpf_iter.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 30efd15cd4a0..0a45a6cdfabd 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -526,5 +526,11 @@ int bpf_iter_run_prog(struct bpf_prog *prog, void *c=
tx)
 	migrate_enable();
 	rcu_read_unlock();
=20
+	/* bpf program can only return 0 or 1:
+	 *  0 : okay
+	 *  1 : retry the same object
+	 * The bpf_iter_run_prog() return value
+	 * will be seq_ops->show() return value.
+	 */
 	return ret =3D=3D 0 ? 0 : -EAGAIN;
 }
--=20
2.24.1

