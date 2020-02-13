Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E59A15CCCB
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgBMVB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:01:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36522 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727864AbgBMVB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:01:27 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DKwp26030291
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=TONvgSSzrtPKCxdzVuy2atQ2a6WUxRJ0gJLjMqMfzRY=;
 b=quHz6yVzvKSSr8XHHzA1iVLSOLhOFmBcfmRk4u4JZ1Ut0gVcfY2MsTF/RO4OuwEaCKAQ
 haIVK0G46MudPD1peqg+JYM+rB4N5Xg9zAYoqfF0t+tpJ0vkH8X4hzTmfOpSQAxOmddt
 2bIACEIFoFnfQ93oVStI0igm9HtFH+vHDiE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y53j937u2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:27 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 13 Feb 2020 13:01:24 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A07EA62E1536; Thu, 13 Feb 2020 13:01:21 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC bpf-next 0/4] bpftool: introduce prog profile
Date:   Thu, 13 Feb 2020 13:01:11 -0800
Message-ID: <20200213210115.1455809-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 spamscore=0 mlxlogscore=836 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002130150
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

Sending as RFC because 2/4 will be replaced by Eelco Chaudron's work for
bpf_program__set_attach_target().

Please share your comments.

Thanks,
Song

Song Liu (4):
  bpf: allow bpf_perf_event_read_value in all BPF programs
  libbpf: introduce bpf_program__overwrite_section_name()
  bpftool: introduce "prog profile" command
  bpftool: Documentation for bpftool prog profile

 kernel/trace/bpf_trace.c                      |   4 +-
 .../bpftool/Documentation/bpftool-prog.rst    |  17 +
 tools/bpf/bpftool/profiler.skel.h             | 820 ++++++++++++++++++
 tools/bpf/bpftool/prog.c                      | 387 ++++++++-
 tools/bpf/bpftool/skeleton/README             |   3 +
 tools/bpf/bpftool/skeleton/profiler.bpf.c     | 185 ++++
 tools/bpf/bpftool/skeleton/profiler.h         |  47 +
 tools/lib/bpf/libbpf.c                        |  13 +-
 tools/lib/bpf/libbpf.h                        |   4 +
 tools/lib/bpf/libbpf.map                      |   5 +
 10 files changed, 1481 insertions(+), 4 deletions(-)
 create mode 100644 tools/bpf/bpftool/profiler.skel.h
 create mode 100644 tools/bpf/bpftool/skeleton/README
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

--
2.17.1
