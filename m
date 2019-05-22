Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82DF9272EC
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfEVXU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:20:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44984 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729616AbfEVXU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:20:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MNEHtZ032411
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:20:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=X6P44zjZ47fHY3Lb/kucsCI8qXASyw0JnvINTZV+gOs=;
 b=TfuFpW4L8bxHJ7DQctRXJeWF5d9O646Y+aS27Chd/28P9CVv6t73NQ4c7xRQ73ukJrkX
 94xZ2jUNnZcPR0c63EwPB539Tga5PwRMfVTNrKhOX6AtyJJW+mOLsvTYA6sYnRrKfi45
 M8K1GAEAMpyiDdMc/mZyKFvil+qWfczQg0U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2snabk1bba-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:20:56 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 May 2019 16:20:55 -0700
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id DF3DC12526D44; Wed, 22 May 2019 16:20:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, <kernel-team@fb.com>,
        <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/4] cgroup bpf auto-detachment
Date:   Wed, 22 May 2019 16:20:47 -0700
Message-ID: <20190522232051.2938491-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=597 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements a cgroup bpf auto-detachment functionality:
bpf programs are attached as soon as possible after removal of the
cgroup, without waiting for the release of all associated resources.

Patches 2 and 3 are required to implement a corresponding kselftest
in patch 4.

v2:
  1) removed a bogus check in patch 4
  2) moved buf[len] = 0 in patch 2


Roman Gushchin (4):
  bpf: decouple the lifetime of cgroup_bpf from cgroup itself
  selftests/bpf: convert test_cgrp2_attach2 example into kselftest
  selftests/bpf: enable all available cgroup v2 controllers
  selftests/bpf: add auto-detach test

 include/linux/bpf-cgroup.h                    |   8 +-
 include/linux/cgroup.h                        |  18 +++
 kernel/bpf/cgroup.c                           |  25 ++-
 kernel/cgroup/cgroup.c                        |  11 +-
 samples/bpf/Makefile                          |   2 -
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  57 +++++++
 .../selftests/bpf/test_cgroup_attach.c        | 145 ++++++++++++++++--
 8 files changed, 243 insertions(+), 27 deletions(-)
 rename samples/bpf/test_cgrp2_attach2.c => tools/testing/selftests/bpf/test_cgroup_attach.c (79%)

-- 
2.20.1

