Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA4217436D
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB1XlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:41:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31922 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726773AbgB1XlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 18:41:10 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01SNWXKp004255
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:41:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=vS0nFAaoNCrCgkpI/DjwKxxa9hp82tLxsT4hzC4fGV4=;
 b=ffX2P3TkicESsG8fo4MmbvaEiLU8ddDogixr+WXvddhR/te+h+kl7F5gv+YzZTzy3ZfX
 sAv9gTu+yFi+mvX47qJRH3Y5qDtsBOaziONzHzNHS5rWVy68ux/nweMIwoZCqbtjEGvu
 vNruVCmmYG5uxpHq/cMa7mfgVGp7c2Bx9FI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yepwfp849-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:41:09 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 15:41:08 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 0792962E0BA7; Fri, 28 Feb 2020 15:41:01 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] bpftool: introduce prog profile
Date:   Fri, 28 Feb 2020 15:40:56 -0800
Message-ID: <20200228234058.634044-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_09:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=786 spamscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002280171
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

Changes RFC => v2:
1. Use new bpf_program__set_attach_target() API;
2. Update output format to be perf-stat like (Alexei);
3. Incorporate skeleton generation into Makefile;
4. Make DURATION optional and Allow Ctrl-C (Alexei);
5. Add calcated values "insn per cycle" and "LLC misses per million isns".

Song Liu (2):
  bpftool: introduce "prog profile" command
  bpftool: Documentation for bpftool prog profile

 .../bpftool/Documentation/bpftool-prog.rst    |  17 +
 tools/bpf/bpftool/Makefile                    |  18 +
 tools/bpf/bpftool/prog.c                      | 428 +++++++++++++++++-
 tools/bpf/bpftool/skeleton/profiler.bpf.c     | 171 +++++++
 tools/bpf/bpftool/skeleton/profiler.h         |  47 ++
 tools/scripts/Makefile.include                |   1 +
 6 files changed, 681 insertions(+), 1 deletion(-)
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
 create mode 100644 tools/bpf/bpftool/skeleton/profiler.h

--
2.17.1
