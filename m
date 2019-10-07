Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9676CDA88
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 05:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfJGDHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 23:07:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3330 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726828AbfJGDHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 23:07:44 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9734kJD015686
        for <netdev@vger.kernel.org>; Sun, 6 Oct 2019 20:07:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5+Gc5Z92poLAaQdb4q2FzQYYMOFWoe69lURCb/39oq4=;
 b=d6ECUsQMt+cuKTp4ArX1WETZsaCdl+0KAJj3pAe0WJ+8aexhLBqGuhhy2kZTbD6s4KgH
 QCHkfs2390q4dHtiV229wzKAzy2JbAeixdJx+uEO3sYsuUxqh1YXNp6qMSPOHSVtJHAG
 Ypw3IyMgxTk7J/f+Arde6ue79+qPNIQ6z0g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2verwq64g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 20:07:43 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 6 Oct 2019 20:07:42 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 21B0786190E; Sun,  6 Oct 2019 20:07:40 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <quentin.monnet@netronome.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 0/3] Auto-generate list of BPF helpers
Date:   Sun, 6 Oct 2019 20:07:35 -0700
Message-ID: <20191007030738.2627420-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_11:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=779
 lowpriorityscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 suspectscore=9 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910070032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds ability to auto-generate list of BPF helper definitions.
It relies on existing scripts/bpf_helpers_doc.py and include/uapi/linux/bpf.h
having a well-defined set of comments. bpf_helper_defs.h contains all BPF
helper signatures which stay in sync with latest bpf.h UAPI. This
auto-generated header is included from bpf_helpers.h, while all previously
hand-written BPF helper definitions are simultaneously removed in patch #3.
The end result is less manually maintained and redundant boilerplate code,
while also more consistent and well-documented set of BPF helpers. Generated
helper definitions are completely independent from a specific bpf.h on
a target system, because it doesn't use BPF_FUNC_xxx enums.

v3->v4:
- instead of libbpf's Makefile, integrate with selftest/bpf's Makefile (Alexei);

v2->v3:
- delete bpf_helper_defs.h properly (Alexei);

v1->v2:
- add bpf_helper_defs.h to .gitignore and `make clean` (Alexei).

Andrii Nakryiko (3):
  uapi/bpf: fix helper docs
  scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions
  libbpf: auto-generate list of BPF helper definitions

 include/uapi/linux/bpf.h                  |  32 +--
 scripts/bpf_helpers_doc.py                | 155 ++++++++++++-
 tools/include/uapi/linux/bpf.h            |  32 +--
 tools/testing/selftests/bpf/.gitignore    |   1 +
 tools/testing/selftests/bpf/Makefile      |   8 +-
 tools/testing/selftests/bpf/bpf_helpers.h | 264 +---------------------
 6 files changed, 195 insertions(+), 297 deletions(-)

-- 
2.17.1

