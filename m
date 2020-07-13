Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302AB21E38F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgGMXYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:24:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49162 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726432AbgGMXYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 19:24:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DNJ7tT013031
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 16:24:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=aDOwrjjpwdtnPySuqg0BsRMlSG1fuB2xzY3H2P0dP+o=;
 b=Z3DVpg/KD2+gTFPkp3lzQznzVrYodGwjzkZofGjaa65HEKS505BsMXYZzBIkE9lJgjjR
 YaGzIHCajzY1KyX0+O8FXtcW7pEySSnTmAiywA4pL/fnoIRnSEqgfKEJo6TKhEVKifR+
 nsJk2P6URbOINx6AZpNpmUpvyVJ6SqhE+y0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 327b8ht9e8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 16:24:48 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 16:24:46 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A7C3D2EC4105; Mon, 13 Jul 2020 16:24:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] Strip away modifiers from BPF skeleton global variables
Date:   Mon, 13 Jul 2020 16:24:07 -0700
Message-ID: <20200713232409.3062144-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_17:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=648 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bpftool logic of stripping away const/volatile modifiers for all glob=
al
variables during BPF skeleton generation. See patch #1 for details on whe=
n
existing logic breaks and why it's important. Support special .strip_mods=
=3Dtrue
mode in btf_dump__emit_type_decl.

Recent example of when this has caused problems can be found in [0].

  [0] https://github.com/iovisor/bcc/pull/2994#issuecomment-650588533

Cc: Anton Protopopov <a.s.protopopov@gmail.com>

Andrii Nakryiko (2):
  libbpf: support stripping modifiers for btf_dump
  tools/bpftool: strip away modifiers from global variables

 tools/bpf/bpftool/gen.c                       | 23 ++++++++-----------
 tools/lib/bpf/btf.h                           |  4 +++-
 tools/lib/bpf/btf_dump.c                      | 10 ++++++--
 .../selftests/bpf/prog_tests/skeleton.c       |  6 ++---
 .../selftests/bpf/progs/test_skeleton.c       |  6 +++--
 5 files changed, 28 insertions(+), 21 deletions(-)

--=20
2.24.1

