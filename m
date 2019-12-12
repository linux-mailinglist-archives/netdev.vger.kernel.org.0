Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1611C240
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfLLBfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:35:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41612 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfLLBfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:35:36 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBC1ZXUr027659
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:35:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=WHDVLKXch0JZJMNlq7P4/ZykdBdCBYHhbPv+M/DAjyc=;
 b=BIpz2+kwEMEzM1ZEXjiA4BQl34saMzVtdpAEVs5di3j+JtBrg8o730MgxvfxA1LVKH/a
 DLfUYaTzljZFYgH0ckD1GXYblKE3pe8Thvg0T482536QrdA9mmLIGU/Ss4dMn2K0N8YY
 qRFrIQC40Pc/AxUHj0df6z3EflHCI20GfLE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu87qgwfk-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:35:35 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 11 Dec 2019 17:35:24 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EB18A2EC1A0E; Wed, 11 Dec 2019 17:35:23 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with offline CPUs
Date:   Wed, 11 Dec 2019 17:35:20 -0800
Message-ID: <20191212013521.1689228-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 malwarescore=0
 spamscore=0 mlxscore=0 suspectscore=8 phishscore=0 lowpriorityscore=0
 mlxlogscore=875 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes perf_buffer__new() behavior on systems which have some of
the CPUs offline/missing (due to difference between "possible" and "online"
sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
perf_event only on CPUs present and online at the moment of perf_buffer
creation. Without this logic, perf_buffer creation has no chances of
succeeding on such systems, preventing valid and correct BPF applications from
starting.

Andrii Nakryiko (4):
  libbpf: extract and generalize CPU mask parsing logic
  selftests/bpf: add CPU mask parsing tests
  libbpf: don't attach perf_buffer to offline/missing CPUs
  selftests/bpf: fix perf_buffer test on systems w/ offline CPUs

 tools/lib/bpf/libbpf.c                        | 157 ++++++++++++------
 tools/lib/bpf/libbpf_internal.h               |   2 +
 .../selftests/bpf/prog_tests/cpu_mask.c       |  78 +++++++++
 .../selftests/bpf/prog_tests/perf_buffer.c    |  29 +++-
 4 files changed, 213 insertions(+), 53 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c

-- 
2.17.1

