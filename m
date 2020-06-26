Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E54520A9C5
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 02:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgFZAOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 20:14:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgFZANw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 20:13:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05Q09lkg028169
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=L+G+5ICmD+hXddYJtcmy5XMdUPoBv6VGsfT8fpChsDI=;
 b=CJGYCOcsr6tdSepWqrREDfcoW7d9YzW3EzwEREokPhgduifDZ/zm2a4vVBDGx4nI7JSy
 1osPEHkEfTL4Zq84p7kvGg6f+ztmESU1PiM9nVZrQNcEAIWkPEKweQF6g0k7eLlogyh8
 wKCS/sqAW5dQt0ROEMHYTTT5TYftokvBr2k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 31ux0nttyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 17:13:51 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 17:13:50 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2DDAD62E4FA9; Thu, 25 Jun 2020 17:13:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/4] bpf: introduce bpf_get_task_stack()
Date:   Thu, 25 Jun 2020 17:13:28 -0700
Message-ID: <20200626001332.1554603-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 cotscore=-2147483648 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces a new helper bpf_get_task_stack(). The primary use ca=
se
is to dump all /proc/*/stack to seq_file via bpf_iter__task.

A few different approaches have been explored and compared:

  1. A simple wrapper around stack_trace_save_tsk(), as v1 [1].

     This approach introduces new syntax, which is different to existing
     helper bpf_get_stack(). Therefore, this is not ideal.

  2. Extend get_perf_callchain() to support "task" as argument.

     This approach reuses most of bpf_get_stack(). However, extending
     get_perf_callchain() requires non-trivial changes to architecture
     specific code. Which is error prone.

  3. Current (v2) approach, leverages most of existing bpf_get_stack(), a=
nd
     uses stack_trace_save_tsk() to handle architecture specific logic.

[1] https://lore.kernel.org/netdev/20200623070802.2310018-1-songliubravin=
g@fb.com/

Changes v1 =3D> v2:
1. Reuse most of bpf_get_stack() logic. (Andrii)
2. Fix unsigned long vs. u64 mismatch for 32-bit systems. (Yonghong)
3. Add %pB support in bpf_trace_printk(). (Daniel)
4. Fix buffer size to bytes.

Song Liu (4):
  perf: export get/put_chain_entry()
  bpf: introduce helper bpf_get_task_stak()
  bpf: allow %pB in bpf_seq_printf() and bpf_trace_printk()
  selftests/bpf: add bpf_iter test with bpf_get_task_stack_trace()

 include/linux/bpf.h                           |  1 +
 include/linux/perf_event.h                    |  2 +
 include/uapi/linux/bpf.h                      | 35 +++++++-
 kernel/bpf/stackmap.c                         | 79 ++++++++++++++++++-
 kernel/events/callchain.c                     |  4 +-
 kernel/trace/bpf_trace.c                      | 14 +++-
 scripts/bpf_helpers_doc.py                    |  2 +
 tools/include/uapi/linux/bpf.h                | 35 +++++++-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 17 ++++
 .../selftests/bpf/progs/bpf_iter_task_stack.c | 60 ++++++++++++++
 10 files changed, 239 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_stack=
.c

--
2.24.1
