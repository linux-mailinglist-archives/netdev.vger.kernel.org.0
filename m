Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6F1BB215
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 01:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgD0Xof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 19:44:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11096 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726257AbgD0Xof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 19:44:35 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RNdrnv019630
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:44:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=JtnFU5ns4jyj4oANFXxgl8pdYQZhehldaLP5eAL8E2Y=;
 b=oBjLJ5fJwzQUGyosFicCDHXUk4E4djAeGFDtZ/TYBh9mIWWDBOhfcUH38pLIY/iacPP7
 UOZYiDNQPw7wnTsdQ9eEE5ikv37B0O0L6aIklQLk65VZljIRDoL0FnuxGkWNV43nsFP6
 ECF7+NVZGJGfLqvX/IEux+hxXUI9SW07Wi0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57pb8d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 16:44:34 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 16:44:33 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id E96BF62E3380; Mon, 27 Apr 2020 16:44:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 0/3] bpf: sharing bpf runtime stats with
Date:   Mon, 27 Apr 2020 16:44:20 -0700
Message-ID: <20200427234423.998085-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_17:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=8 mlxlogscore=971
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270193
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

Changes v4 =3D> v5:
  1. Use memset to zero bpf_attr in bpf_enable_stats() (Andrii).

Changes v3 =3D> v4:
  1. Add libbpf support and selftest;
  2. Avoid cleaning trailing space.

Changes v2 =3D> v3:
  1. Rename the command to BPF_ENABLE_STATS, and make it extendible.
  2. fix commit log;
  3. remove unnecessary headers.

Song Liu (3):
  bpf: sharing bpf runtime stats with BPF_ENABLE_STATS
  libbpf: add support for command BPF_ENABLE_STATS
  bpf: add selftest for BPF_ENABLE_STATS

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      | 11 ++++
 kernel/bpf/syscall.c                          | 50 +++++++++++++++++++
 kernel/sysctl.c                               | 36 ++++++++++++-
 tools/include/uapi/linux/bpf.h                | 11 ++++
 tools/lib/bpf/bpf.c                           | 10 ++++
 tools/lib/bpf/bpf.h                           |  1 +
 tools/lib/bpf/libbpf.map                      |  5 ++
 .../selftests/bpf/prog_tests/enable_stats.c   | 45 +++++++++++++++++
 .../selftests/bpf/progs/test_enable_stats.c   | 28 +++++++++++
 10 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/enable_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_enable_stats.c

--
2.24.1
