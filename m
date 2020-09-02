Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B30825A242
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIBA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:26:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61302 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbgIBA0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 20:26:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0820Qbej031315
        for <netdev@vger.kernel.org>; Tue, 1 Sep 2020 17:26:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=csu76dAsrzZBz+UB4+X/YCZX21I9wzyRKl8bhrEEiww=;
 b=IEruMLfqzZain07bU/fTfFZzttQb76Q1E/aMch1SkiWZ98MkYEFw47HV3PtnHi3psBs+
 vB8/JeTXbSqUbTxeOd6jCOZE4NrjHYtmZOvv9oxSZV2Uu9Mvt2jsqLob38Nc9j7dcQXV
 a39FWJxQh9mxN/PwfgW+312q2oXqqB0TJXk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 338734p2js-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 17:26:38 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Sep 2020 17:26:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 35F0437050EC; Tue,  1 Sep 2020 17:26:08 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next v3 0/2] bpf: avoid iterating duplicated files for task_file iterator
Date:   Tue, 1 Sep 2020 17:26:07 -0700
Message-ID: <20200902002608.994598-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_10:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=8 impostorscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e679654a704e ("bpf: Fix a rcu_sched stall issue with
bpf task/task_file iterator") introduced rate limiting in
bpf_seq_read() to fix a case where traversing too many tasks
and files (tens of millions of files) may cause kernel rcu stall.
But rate limiting won't reduce the amount of work to traverse
all these files.

In practice, for a user process, typically all threads belongs
to that process share the same file table and there is no need
to visit every thread for its files.

This patch added additional logic for task_file iterator to
skip tasks if those tasks are not group_leaders and their files
are the same as those of group_leaders.
Such reduction of unnecessary work will make iterator runtime
much faster if there are a lot of non-main threads and open
files for the process.

Patch #1 is the kernel implementation and Patch #2 is the
selftest.

Changelogs:
  v2 -> v3:
    - add put_task_struct(task) for those skipped tasks
      to avoid leaking tasks. (Josef)
  v1 -> v2:
    - for task_file, no need for additional user parameter,
      kernel can just skip those files already visited, and
      this should not impact user space. (Andrii)
    - to add group_leader-only customization for task will
      be considered later.
    - remove Patch #1 and sent it separately as this patch set
      won't depend on it any more.

Yonghong Song (2):
  bpf: avoid iterating duplicated files for task_file iterator
  selftests/bpf: test task_file iterator without visiting pthreads

 kernel/bpf/task_iter.c                        | 15 +++++++++----
 .../selftests/bpf/prog_tests/bpf_iter.c       | 21 +++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_task_file.c  | 10 ++++++++-
 3 files changed, 41 insertions(+), 5 deletions(-)

--=20
2.24.1

