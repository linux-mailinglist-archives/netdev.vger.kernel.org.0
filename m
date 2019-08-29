Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D8DA120B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 08:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbfH2Gpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 02:45:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63226 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726889AbfH2GpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 02:45:12 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x7T6gYqZ025076
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=NT7SZrw3Qy+6M0D0VAHxgNYPUvtSj8aHb73BTo4D7nk=;
 b=WY+AbgpwkAmNEChFcTVDjVhSlMmegaCwMCrljsSMs8Sie8oosQZLKQQqxYVGyxrO5BYA
 fwhT9iAnC9UV9eZzpCtjjWwEyZL5uyNzRExWeRcdd0ZLb8r+IszTH+KZkru3Pdc4bpt7
 PtowletVaAqYEdhc8tiOw1/U0Ap3M9E6SK4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2unuwqbhyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 23:45:10 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 28 Aug 2019 23:45:09 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C453C3702BA3; Wed, 28 Aug 2019 23:45:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Date:   Wed, 28 Aug 2019 23:45:02 -0700
Message-ID: <20190829064502.2750303-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-29_04:2019-08-28,2019-08-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 phishscore=0 mlxlogscore=826 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908290072
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Vazquez has proposed BPF_MAP_DUMP command to look up more than one
map entries per syscall.
  https://lore.kernel.org/bpf/CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-0E9bQEL0qC3A@mail.gmail.com/T/#t

During discussion, we found more use cases can be supported in a similar
map operation batching framework. For example, batched map lookup and delete,
which can be really helpful for bcc.
  https://github.com/iovisor/bcc/blob/master/tools/tcptop.py#L233-L243
  https://github.com/iovisor/bcc/blob/master/tools/slabratetop.py#L129-L138
    
Also, in bcc, we have API to delete all entries in a map.
  https://github.com/iovisor/bcc/blob/master/src/cc/api/BPFTable.h#L257-L264

For map update, batched operations also useful as sometimes applications need
to populate initial maps with more than one entry. For example, the below
example is from kernel/samples/bpf/xdp_redirect_cpu_user.c:
  https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redirect_cpu_user.c#L543-L550

This patch addresses all the above use cases. To make uapi stable, it also
covers other potential use cases. Four bpf syscall subcommands are introduced:
    BPF_MAP_LOOKUP_BATCH
    BPF_MAP_LOOKUP_AND_DELETE_BATCH
    BPF_MAP_UPDATE_BATCH
    BPF_MAP_DELETE_BATCH

In userspace, application can iterate through the whole map one batch
as a time, e.g., bpf_map_lookup_batch() in the below:
    p_key = NULL;
    p_next_key = &key;
    while (true) {
       err = bpf_map_lookup_batch(fd, p_key, &p_next_key, keys, values,
                                  &batch_size, elem_flags, flags);
       if (err) ...
       if (p_next_key) break; // done
       if (!p_key) p_key = p_next_key;
    }
Please look at individual patches for details of new syscall subcommands
and examples of user codes.

The testing is also done in a qemu VM environment:
      measure_lookup: max_entries 1000000, batch 10, time 342ms
      measure_lookup: max_entries 1000000, batch 1000, time 295ms
      measure_lookup: max_entries 1000000, batch 1000000, time 270ms
      measure_lookup: max_entries 1000000, no batching, time 1346ms
      measure_lookup_delete: max_entries 1000000, batch 10, time 433ms
      measure_lookup_delete: max_entries 1000000, batch 1000, time 363ms
      measure_lookup_delete: max_entries 1000000, batch 1000000, time 357ms
      measure_lookup_delete: max_entries 1000000, not batch, time 1894ms
      measure_delete: max_entries 1000000, batch, time 220ms
      measure_delete: max_entries 1000000, not batch, time 1289ms
For a 1M entry hash table, batch size of 10 can reduce cpu time
by 70%. Please see patch "tools/bpf: measure map batching perf"
for details of test codes.

Brian Vazquez (1):
  bpf: add bpf_map_value_size and bp_map_copy_value helper functions

Yonghong Song (12):
  bpf: refactor map_update_elem()
  bpf: refactor map_delete_elem()
  bpf: refactor map_get_next_key()
  bpf: adding map batch processing support
  tools/bpf: sync uapi header bpf.h
  tools/bpf: implement libbpf API functions for map batch operations
  tools/bpf: add test for bpf_map_update_batch()
  tools/bpf: add test for bpf_map_lookup_batch()
  tools/bpf: add test for bpf_map_lookup_and_delete_batch()
  tools/bpf: add test for bpf_map_delete_batch()
  tools/bpf: add a multithreaded test for map batch operations
  tools/bpf: measure map batching perf

 include/uapi/linux/bpf.h                      |  27 +
 kernel/bpf/syscall.c                          | 752 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  27 +
 tools/lib/bpf/bpf.c                           |  67 ++
 tools/lib/bpf/bpf.h                           |  17 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../selftests/bpf/map_tests/map_batch_mt.c    | 126 +++
 .../selftests/bpf/map_tests/map_batch_perf.c  | 242 ++++++
 .../bpf/map_tests/map_delete_batch.c          | 139 ++++
 .../map_tests/map_lookup_and_delete_batch.c   | 164 ++++
 .../bpf/map_tests/map_lookup_batch.c          | 166 ++++
 .../bpf/map_tests/map_update_batch.c          | 115 +++
 12 files changed, 1707 insertions(+), 139 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_batch_mt.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_batch_perf.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_delete_batch.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_batch.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_update_batch.c

-- 
2.17.1

