Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B573C253AD5
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgH0AGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:06:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23798 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726753AbgH0AGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:06:25 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07R05YuT032208
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=51yF5Z6dIpgMRg3AdYtPrGIzS5zNj6lT9RLzpEoRAPc=;
 b=o7gcxetAlRybGMEiP/b6gZleNbHOPObq1Cf7eq1S4Jmg+/2T6dK3b157wN/RCtKqJ57k
 uUl7PrcD7FuhEFLdFabO1SjKDryxOO9HbXZSFoyfLWZcthCMnmUEV1osnAZdSTDkMJFD
 mjP4y5x4x9GZ59ZkIpxn3sPpkSQZWlgHzjw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 335up8jbxp-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 17:06:24 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 26 Aug 2020 17:06:21 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id D3F2937052E0; Wed, 26 Aug 2020 17:06:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/5] bpf: add main_thread_only customization for task/task_file iterators
Date:   Wed, 26 Aug 2020 17:06:18 -0700
Message-ID: <20200827000618.2711826-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-26_14:2020-08-26,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260187
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

This patch implemented a customization for task/task_file iterators
to traverse files only for thread with task->tgid =3D=3D task->pid,
which will include some kernel threads and user process main threads.
Such reduction of unnecessary work will make iterator runtime
much faster if there are a lot of non-main threads and open
files for the process.

Patch #1 fix an uapi issue for bpf_link_info.iter.
Patch #2 implemented the main_thread_only customization for
task/task_file iterators.
Patch #3 added link_query support for new customization.
Patch #4 added bpftool support and Patch #5 added a selftest.

Yonghong Song (5):
  bpf: make bpf_link_info.iter similar to bpf_iter_link_info
  bpf: add main_thread_only customization for task/task_file iterators
  bpf: add link_query support for newly added main_thread_only info
  bpftool: support optional 'task main_thread_only' argument
  selftests/bpf: test task_file iterator with main_thread_only

 include/linux/bpf.h                           |  3 +-
 include/uapi/linux/bpf.h                      | 16 ++++-
 kernel/bpf/task_iter.c                        | 63 ++++++++++++++-----
 .../bpftool/Documentation/bpftool-iter.rst    | 17 ++++-
 tools/bpf/bpftool/bash-completion/bpftool     |  9 ++-
 tools/bpf/bpftool/iter.c                      | 28 +++++++--
 tools/bpf/bpftool/link.c                      | 12 ++++
 tools/include/uapi/linux/bpf.h                | 16 ++++-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 50 +++++++++++----
 .../selftests/bpf/progs/bpf_iter_task_file.c  |  9 ++-
 10 files changed, 183 insertions(+), 40 deletions(-)

--=20
2.24.1

