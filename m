Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486DC179782
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgCDSHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:07:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5490 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727804AbgCDSHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:07:18 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024I4dIZ009715
        for <netdev@vger.kernel.org>; Wed, 4 Mar 2020 10:07:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=182sOQoDKa1rVxoKOEyU+KhF+rEC3jpLhoxoKxo4lgg=;
 b=Hi3hxCjTj0KS0J5hZbFELKGVPD5SDCYRm4Vkmvr8Fqv81Zata7ZFuz2ZydSyeob27H81
 bbLQNqYnq+EWv3fE4ZdDqk8hMXpLKnB1mTkzwGMIHlaURZPdRW0gFPwHdUh6s1JpqBMr
 2a0kBR1RkLJ1samkaxF579eNINGpIpd9rnI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yhugwxmv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:07:16 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 10:07:15 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id B64CE62E3375; Wed,  4 Mar 2020 10:07:13 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Date:   Wed, 4 Mar 2020 10:07:06 -0800
Message-ID: <20200304180710.2677695-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_07:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=847
 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040123
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces bpftool prog profile command, which uses hardware
counters to profile BPF programs.

This command attaches fentry/fexit programs to a target program. These two
programs read hardware counters before and after the target program and
calculate the difference.

Changes v3 => v4:
1. Simplify err handling in profile_open_perf_events() (Quentin);
2. Remove redundant p_err() (Quentin);
3. Replace tab with space in bash-completion; (Quentin);
4. Fix typo _bpftool_get_map_names => _bpftool_get_prog_names (Quentin).

Changes v2 => v3:
1. Change order of arguments (Quentin), as:
     bpftool prog profile PROG [duration DURATION] METRICs
2. Add bash-completion for bpftool prog profile (Quentin);
3. Fix build of selftests (Yonghong);
4. Better handling of bpf_map_lookup_elem() returns (Yonghong);
5. Improve clean up logic of do_profile() (Yonghong);
6. Other smaller fixes/cleanups.

Changes RFC => v2:
1. Use new bpf_program__set_attach_target() API;
2. Update output format to be perf-stat like (Alexei);
3. Incorporate skeleton generation into Makefile;
4. Make DURATION optional and Allow Ctrl-C (Alexei);
5. Add calcated values "insn per cycle" and "LLC misses per million isns".

Song Liu (4):
  bpftool: introduce "prog profile" command
  bpftool: Documentation for bpftool prog profile
  bpftool: bash completion for "bpftool prog profile"
  bpftool: fix typo in bash-completion

 .../bpftool/Documentation/bpftool-prog.rst    |  19 +
 tools/bpf/bpftool/Makefile                    |  18 +
 tools/bpf/bpftool/bash-completion/bpftool     |  47 +-
 tools/bpf/bpftool/prog.c                      | 425 +++++++++++++++++-
 tools/bpf/bpftool/skeleton/profiler.bpf.c     | 171 +++++++
 tools/bpf/bpftool/skeleton/profiler.h         |  47 ++
 tools/scripts/Makefile.include                |   1 +
 7 files changed, 725 insertions(+), 3 deletions(-)
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

--
2.17.1
