Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0097917C991
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:17:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgCGARe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:17:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbgCGARc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:17:32 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0270GkqR001618
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 16:17:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=OboYXIBduw9GPniLpE7NZnGGtQuBy9kWCmm97HV6toc=;
 b=RWwmPNa/FBZPPuR/HqNR80cPTRCLs+mZjxa2wRrc/vQm7T323Xp0QdFYpCBdTZYNCC3c
 ar6ShRdVrcA/cEGhITRIiXuteVqQNLcgvkKjYceO0sg4FcTg1Ig0Y4rBcIu0KVaoiw68
 2h6mz7APzw1Qcplwq49LAk6Nvn320dKXOtc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yk7x8ekhn-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 16:17:31 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 6 Mar 2020 16:17:29 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2574162E2880; Fri,  6 Mar 2020 16:17:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 0/4] bpftool: introduce prog profile
Date:   Fri, 6 Mar 2020 16:17:09 -0800
Message-ID: <20200307001713.3559880-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_09:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=910
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003070000
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

Changes v4 => v5:
1. Adjust perf_event_attr for the events (Jiri).

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
  ybpftool: bash completion for "bpftool prog profile"
  bpftool: fix typo in bash-completion

 .../bpftool/Documentation/bpftool-prog.rst    |  19 +
 tools/bpf/bpftool/Makefile                    |  18 +
 tools/bpf/bpftool/bash-completion/bpftool     |  47 +-
 tools/bpf/bpftool/prog.c                      | 424 +++++++++++++++++-
 tools/bpf/bpftool/skeleton/profiler.bpf.c     | 171 +++++++
 tools/bpf/bpftool/skeleton/profiler.h         |  47 ++
 tools/scripts/Makefile.include                |   1 +
 7 files changed, 724 insertions(+), 3 deletions(-)
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

--
2.17.1
