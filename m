Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DB755718
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbfFYSXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:23:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732917AbfFYSXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:23:11 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x5PIM0BY016007
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:23:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=d1ExIXP69uhF7f8Fjq0YWM/zSbL5re4X0urT4JJCyrc=;
 b=Ffb3VSoEg6SA5JwABhpZdMkC5/JFIpBWx7tpNce+uR+kGKl7f8l+2i8OHH8IaI4ALG0F
 e1Aa1SmogyjScUigBjsk7rhJs4TzZxcPB/QzlKCwqtA0RKSSSlsQt3A9rTA/FSMesn4f
 mJN6rztrJ7UwrwEBRR5YzriYGVNHbaP/OeE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tbpv80h83-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:23:09 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 11:23:08 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C983B62E1DB8; Tue, 25 Jun 2019 11:23:06 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] sys_bpf() access control via /dev/bpf
Date:   Tue, 25 Jun 2019 11:22:59 -0700
Message-ID: <20190625182303.874270-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=795 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, most access to sys_bpf() is limited to root. However, there are
use cases that would benefit from non-privileged use of sys_bpf(), e.g.
systemd.

This set introduces a new model to control the access to sys_bpf(). A
special device, /dev/bpf, is introduced to manage access to sys_bpf().
Users with access to open /dev/bpf will be able to access most of
sys_bpf() features. The use can get access to sys_bpf() by opening /dev/bpf
and use ioctl to get/put permission.

The permission to access sys_bpf() is marked by bit TASK_BPF_FLAG_PERMITTED
in task_struct. During fork(), child will not inherit this bit.

libbpf APIs libbpf_[get|put]_bpf_permission() are added to help get and
put the permission. bpftool is updated to use these APIs.

Song Liu (4):
  bpf: unprivileged BPF access via /dev/bpf
  bpf: sync tools/include/uapi/linux/bpf.h
  libbpf: add libbpf_[get|put]_bpf_permission()
  bpftool: use libbpf_[get|put]_bpf_permission()

 Documentation/ioctl/ioctl-number.txt |  1 +
 include/linux/bpf.h                  | 12 +++++
 include/linux/sched.h                |  8 ++++
 include/uapi/linux/bpf.h             |  5 ++
 kernel/bpf/arraymap.c                |  2 +-
 kernel/bpf/cgroup.c                  |  2 +-
 kernel/bpf/core.c                    |  4 +-
 kernel/bpf/cpumap.c                  |  2 +-
 kernel/bpf/devmap.c                  |  2 +-
 kernel/bpf/hashtab.c                 |  4 +-
 kernel/bpf/lpm_trie.c                |  2 +-
 kernel/bpf/offload.c                 |  2 +-
 kernel/bpf/queue_stack_maps.c        |  2 +-
 kernel/bpf/reuseport_array.c         |  2 +-
 kernel/bpf/stackmap.c                |  2 +-
 kernel/bpf/syscall.c                 | 72 +++++++++++++++++++++-------
 kernel/bpf/verifier.c                |  2 +-
 kernel/bpf/xskmap.c                  |  2 +-
 kernel/fork.c                        |  4 ++
 net/core/filter.c                    |  6 +--
 tools/bpf/bpftool/feature.c          |  2 +-
 tools/bpf/bpftool/main.c             |  5 ++
 tools/include/uapi/linux/bpf.h       |  5 ++
 tools/lib/bpf/libbpf.c               | 54 +++++++++++++++++++++
 tools/lib/bpf/libbpf.h               |  7 +++
 tools/lib/bpf/libbpf.map             |  2 +
 26 files changed, 178 insertions(+), 35 deletions(-)

--
2.17.1
