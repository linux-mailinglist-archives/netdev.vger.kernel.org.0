Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647EA8C11B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfHMSzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:55:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35256 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727182AbfHMSzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:55:19 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7DIrsHY030669
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=tu52X/aBM0QBHjL+mzrNRcQPeYQPOEPRN0uQWajrw2I=;
 b=DZK2D41UiyY7zvB/EvTmKFrFmYe1GbXhNRuXJ9UWwV65C162PjeFWR/ugzeeKSPoldIz
 2etnIpI8KDkeULdudtGSplZpgzYFBcBBrCNRBQ8tqJJ0TywnHbWTvxQGSSf6dkyLk3Bv
 GtoFljFkO2VsO++v3yGfZLna3Uo7rgeRrJU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2uc2tg010j-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:55:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 11:55:17 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id A24FC861677; Tue, 13 Aug 2019 11:55:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <acme@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/2] libbpf: make use of BTF through sysfs
Date:   Tue, 13 Aug 2019 11:54:41 -0700
Message-ID: <20190813185443.437829-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=9 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=276 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130177
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that kernel's BTF is exposed through sysfs at well-known location, attempt
to load it first as a target BTF for the purpose of BPF CO-RE relocations.

Patch #1 is a follow-up patch to rename /sys/kernel/btf/kernel into
/sys/kernel/btf/vmlinux.
Patch #2 adds ability to load raw BTF contents from sysfs and expands the list
of locations libbpf attempts to load vmlinux BTF from.

Andrii Nakryiko (2):
  btf: rename /sys/kernel/btf/kernel into /sys/kernel/btf/vmlinux
  libbpf: attempt to load kernel BTF from sysfs first

 Documentation/ABI/testing/sysfs-kernel-btf |  2 +-
 kernel/bpf/sysfs_btf.c                     | 30 +++++-----
 scripts/link-vmlinux.sh                    | 18 +++---
 tools/lib/bpf/libbpf.c                     | 64 +++++++++++++++++++---
 4 files changed, 82 insertions(+), 32 deletions(-)

-- 
2.17.1

