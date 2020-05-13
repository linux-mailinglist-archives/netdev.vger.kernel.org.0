Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3219D1D20D5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 23:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgEMVVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 17:21:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24056 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728181AbgEMVVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 17:21:09 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04DLJ5F6012373
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 14:21:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JxmnDSPZr+avr3ys4usH/L8YTtNiV6aU82SKuONhcMY=;
 b=p8cu5cgQj3BU4pj+RpzU8anxpAjtbm2SfWyBlemDtI56hbiH7OdM+NdE3Xqnyx9qc+xQ
 c4Cyf7bif0X7L3wEtIQUiEHR3HlOPtKJ+WjkTd9MYKhCJDE/yTs14MxEd7HReDOYvCPR
 teV6fi7OPWkf680/zascC8Kb0UHDZ0qc0KY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x27ffc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 14:21:08 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 14:21:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CFB562EC328C; Wed, 13 May 2020 14:20:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: fix bpf_iter's task iterator logic
Date:   Wed, 13 May 2020 14:20:57 -0700
Message-ID: <20200513212057.147133-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=8 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=908 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

task_seq_get_next might stop prematurely if get_pid_task() fails to get
task_struct. Failure to do so doesn't mean that there are no more tasks w=
ith
higher pids. Procfs's iteration algorithm (see next_tgid in fs/proc/base.=
c)
does a retry in such case. After this fix, instead of stopping prematurel=
y
after about 300 tasks on my server, bpf_iter program now returns >4000, w=
hich
sounds much closer to reality.

Cc: Yonghong Song <yhs@fb.com>
Fixes: eaaacd23910f ("bpf: Add task and task/file iterator targets")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/task_iter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index a9b7264dda08..e1836def6738 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -27,9 +27,15 @@ static struct task_struct *task_seq_get_next(struct pi=
d_namespace *ns,
 	struct pid *pid;
=20
 	rcu_read_lock();
+retry:
 	pid =3D idr_get_next(&ns->idr, tid);
-	if (pid)
+	if (pid) {
 		task =3D get_pid_task(pid, PIDTYPE_PID);
+		if (!task) {
+			*tid++;
+			goto retry;
+		}
+	}
 	rcu_read_unlock();
=20
 	return task;
--=20
2.24.1

