Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C7358B7F
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfF0UTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:19:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20602 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbfF0UTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:19:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RKJAx2007286
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=EmkCpZ2g25wk3hUN85HoId9FAVlz1X23hR3uc73LZGM=;
 b=RP+ulV+fQ/lK1t1848UrHmAPGlEFaC0q23Yr77T51/rYDeZX1Ekg+e3oKufzHyhh0FMm
 AIdMY0jXlwGPLKw0ScoLT2QIVxeMpGZ+Qqfxn/2UKJZ8gLxtYNk8tr1n/hqXmlzONWHS
 DsEggRdA8rV9yC1c46Mzq+T7p4tahASzr1A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td37drby0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:38 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 27 Jun 2019 13:19:33 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9058462E2BE1; Thu, 27 Jun 2019 13:19:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <lmb@cloudflare.com>, <jannh@google.com>,
        <gregkh@linuxfoundation.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/4] sys_bpf() access control via /dev/bpf
Date:   Thu, 27 Jun 2019 13:19:19 -0700
Message-ID: <20190627201923.2589391-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=657 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270233
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes v1 => v2:
1. Make default mode of /dev/bpf 0220 (Greg);
2. Rename ioctl commands as BPF_DEV_IOCTL_ENABLE_SYS_BPF and
   BPF_DEV_IOCTL_DISABLE_SYS_BPF (Daniel);
3. Save space for task_struct by reusing free bit (Daniel);
4. Make the permission per process (Lorenz).

Currently, most access to sys_bpf() is limited to root. However, there are
use cases that would benefit from non-privileged use of sys_bpf(), e.g.
systemd.

This set introduces a new model to control the access to sys_bpf(). A
special device, /dev/bpf, is introduced to manage access to sys_bpf().
Users with access to open /dev/bpf will be able to access most of
sys_bpf() features. The use can get access to sys_bpf() by opening /dev/bpf
and use ioctl to enable/disable the access.

The permission to access sys_bpf() is marked by bit bpf_permitted in
task_struct. During clone(), child will inherit this bit if CLONE_THREAD
is set. Therefore, the permission is shared within same user process,
but not via fork().

libbpf APIs libbpf_[enable|disable]_sys_bpf() are added to help get and
put the permission. bpftool is updated to use these APIs.

Song Liu (4):
  bpf: unprivileged BPF access via /dev/bpf
  bpf: sync tools/include/uapi/linux/bpf.h
  libbpf: add libbpf_[enable|disable]_sys_bpf()
  bpftool: use libbpf_[enable|disable]_sys_bpf()

 Documentation/ioctl/ioctl-number.txt |  1 +
 include/linux/bpf.h                  | 11 +++++
 include/linux/sched.h                |  3 ++
 include/uapi/linux/bpf.h             |  6 +++
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
 kernel/bpf/syscall.c                 | 71 +++++++++++++++++++++-------
 kernel/bpf/verifier.c                |  2 +-
 kernel/bpf/xskmap.c                  |  2 +-
 kernel/fork.c                        |  5 ++
 net/core/filter.c                    |  6 +--
 tools/bpf/bpftool/feature.c          |  2 +-
 tools/bpf/bpftool/main.c             |  5 ++
 tools/include/uapi/linux/bpf.h       |  6 +++
 tools/lib/bpf/libbpf.c               | 54 +++++++++++++++++++++
 tools/lib/bpf/libbpf.h               |  7 +++
 tools/lib/bpf/libbpf.map             |  2 +
 26 files changed, 174 insertions(+), 35 deletions(-)

--
2.17.1
