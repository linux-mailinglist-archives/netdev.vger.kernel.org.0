Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB831B6DFC
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 08:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgDXGSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 02:18:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64244 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726523AbgDXGSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 02:18:09 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03O69Sfd006950
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 23:18:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=VyYdBfiwCX0VPO/zOgcEcfabNB0ZdFdwwcbM8FN/USI=;
 b=krMzX67uXFUDBCd0h59EFlcblp72ubJSfz4AC2lL0nACQuUnA22vXyb4bT9a2JtQtLAG
 II8vl0LwB7K+5gg7g8fTov1fcwOU+kMsrlzawk0XBEAK/dRveVyLqOoRd21vnz5S0RHt
 Yh7azJhtxrOjTFTGlSHuxmc70GaR6/jIPrY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30jq4jm6fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 23:18:08 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 23:18:06 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BFF9062E4C20; Thu, 23 Apr 2020 23:17:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/3] bpf: sharing bpf runtime stats with
Date:   Thu, 23 Apr 2020 23:17:52 -0700
Message-ID: <20200424061755.436559-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_01:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=982
 malwarescore=0 priorityscore=1501 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=8 spamscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

run_time_ns is a useful stats for BPF programs. However, it is gated by
sysctl kernel.bpf_stats_enabled. When multiple user space tools are
toggling kernl.bpf_stats_enabled at the same time, they may confuse each
other.

Solve this problem with a new BPF command BPF_ENABLE_STATS.

Changes v3 =3D> v4:
  1. Add libbpf support and selftest;
  2. Avoid cleaning trailing space.

Changes v2 =3D> v3:
  1. Rename the command to BPF_ENABLE_STATS, and make it extendible.
  2. fix commit log;
  3. remove unnecessary headers.

Changes RFC =3D> v2:
  1. Add a new bpf command instead of /dev/bpf_stats;
  2. Remove the jump_label patch, which is no longer needed;
  3. Add a static variable to save previous value of the sysctl.

Song Liu (3):
  bpf: sharing bpf runtime stats with BPF_ENABLE_STATS
  libbpf: add support for command BPF_ENABLE_STATS
  bpf: add selftest for BPF_ENABLE_STATS

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      | 11 ++++
 kernel/bpf/syscall.c                          | 50 +++++++++++++++++++
 kernel/sysctl.c                               | 36 ++++++++++++-
 tools/include/uapi/linux/bpf.h                | 11 ++++
 tools/lib/bpf/bpf.c                           |  9 ++++
 tools/lib/bpf/bpf.h                           |  1 +
 tools/lib/bpf/libbpf.map                      |  5 ++
 .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++
 .../selftests/bpf/progs/test_enable_stats.c   | 28 +++++++++++
 10 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c

--
2.24.1
