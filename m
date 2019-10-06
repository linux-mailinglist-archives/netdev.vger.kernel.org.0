Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59ACCCE0A
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 05:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfJFDUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 23:20:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9554 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725881AbfJFDUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 23:20:18 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9635dhh014903
        for <netdev@vger.kernel.org>; Sat, 5 Oct 2019 20:20:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PAfgGg0BcNrZQ0GJkNbYJdXB9JQ+skBPvrXhc1LPUzo=;
 b=YVT9nUnuey6GTy0jV2vYOg+FoPBlSVUznhNfZbT7FFgHd9k9kndLUj1XWf60b75jQQn+
 Ynj4ey/ua6CrUeqp25S7vN6zWrqXkPBNpTR52T0Iuet0hIT5GiX4aMQqhlVTTkr37go8
 eEjEEj3rLCyGhtG4rJbea1RVyCgMhfgAbbo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vervbttf9-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 20:20:17 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 5 Oct 2019 20:20:11 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D1136861847; Sat,  5 Oct 2019 20:20:10 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/3] Auto-generate list of BPF helpers
Date:   Sat, 5 Oct 2019 20:20:05 -0700
Message-ID: <20191006032008.2571427-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_01:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 mlxlogscore=708 lowpriorityscore=0 bulkscore=0 suspectscore=9 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910060031
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

v1->v2:
- add bpf_helper_defs.h to .gitignore and `make clean` (Alexei);

Andrii Nakryiko (3):
  uapi/bpf: fix helper docs
  scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions
  libbpf: auto-generate list of BPF helper definitions

 include/uapi/linux/bpf.h       |  32 ++--
 scripts/bpf_helpers_doc.py     | 155 ++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  32 ++--
 tools/lib/bpf/.gitignore       |   1 +
 tools/lib/bpf/Makefile         |  10 +-
 tools/lib/bpf/bpf_helpers.h    | 264 +--------------------------------
 6 files changed, 196 insertions(+), 298 deletions(-)

-- 
2.17.1

