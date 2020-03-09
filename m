Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB2B17E5BD
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbgCIRc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:32:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727225AbgCIRc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:32:27 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029HPCWs023735
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 10:32:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=6QMrGr7Jw4Z2K8p3q4iYcVM2BiiT+tNAHbqcZzUwnlo=;
 b=aUuyofe4QMC3jYw8UFiqrFRVZQ6Dqm7SR6cANK95KmqhY+Mu9CLa1JIvsZ29ovD76rJl
 CGJeg3IqKIVmtMJoUKFS4NAWeWt+60HO7qmDHTj1sbVIXbb6sdPdVzlNCQt4xXTvjUqL
 OucChXF5hJbqlEivdwAFGug1YktCcL2auzA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv2cwrue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:32:27 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 10:32:25 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0E82C62E27FD; Mon,  9 Mar 2020 10:32:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v6 bpf-next 0/4] bpftool: introduce prog profile
Date:   Mon, 9 Mar 2020 10:32:14 -0700
Message-ID: <20200309173218.2739965-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 malwarescore=0 mlxlogscore=871 suspectscore=0 mlxscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090110
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

Changes v5 => v6:
1. Use new header bpf_tracing.h (Yonghong).

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
 tools/bpf/bpftool/skeleton/profiler.bpf.c     | 119 +++++
 tools/bpf/bpftool/skeleton/profiler.h         |  47 ++
 tools/scripts/Makefile.include                |   1 +
 7 files changed, 672 insertions(+), 3 deletions(-)
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

--
2.17.1
