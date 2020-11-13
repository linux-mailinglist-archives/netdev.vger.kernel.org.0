Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0E72B2369
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKMSLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:11:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34466 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKMSLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:11:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI5Qsm057509;
        Fri, 13 Nov 2020 18:10:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=9orNLX1ll2a3EKw4293msaHhsYY0khsm/1CVXyi7QAQ=;
 b=z5Ps6zwBmOair4Lh91yRIYhxbPAiihkAjknhoPHMDMSErirXw0q/+o9diyFX7juZHV8Y
 yXaCJTDs8kGURpSKASo/8hW0hCzcd6776/BB6jvA3hKJBsNiz3hN56uW0/pUDx3fzfK7
 XVzhtn7jkwrQiX6FY/DxfVtURRUsKa1zufkwPNGU6aYFNM0Clbu0rRnazL4DxUzBx96I
 SwSP1hkBCd6LB1w0kYyS33vtdkL6ISbE9+Qck6cZWwUWUn29OHuUFSFnsWQrAhiyQrXN
 LZX/kkZkBXqf8xCLaT2pus3ZKpqCur9KOPp+qwyMDFEiNn//b7Pk5n7t5T9+rFCkRz0s dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34p72f1taa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 18:10:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADI5NtO055651;
        Fri, 13 Nov 2020 18:10:21 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55tgdjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 18:10:21 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0ADIAKv6021478;
        Fri, 13 Nov 2020 18:10:20 GMT
Received: from localhost.uk.oracle.com (/10.175.203.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 10:10:19 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RFC bpf-next 0/3] bpf: support module BTF in btf display helpers
Date:   Fri, 13 Nov 2020 18:10:10 +0000
Message-Id: <1605291013-22575-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to add support to bpf_snprintf_btf() and 
bpf_seq_printf_btf() allowing them to store string representations
of module-specific types, as well as the kernel-specific ones
they currently support.

Patch 1 adds an additional field "const char *module" to
"struct btf_ptr", allowing the specification of a module
name along with a data pointer, BTF id, etc.  It is then 
used to look up module BTF, rather than the default
vmlinux BTF.

Patch 2 makes a small fix to libbpf to allow 
btf__type_by_name[_kind] to work with split BTF.  Without
this fix, type lookup of a module-specific type id will fail
in patch 3.

Patch 3 is a selftest that uses veth (when built as a
module) and a kprobe to display both a module-specific 
and kernel-specific type; both are arguments to veth_stats_rx().

Alan Maguire (3):
  bpf: add module support to btf display helpers
  libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()
  selftests/bpf: verify module-specific types can be shown via
    bpf_snprintf_btf

 include/linux/btf.h                                |  8 ++
 include/uapi/linux/bpf.h                           |  5 +-
 kernel/bpf/btf.c                                   | 18 ++++
 kernel/trace/bpf_trace.c                           | 42 +++++++---
 tools/include/uapi/linux/bpf.h                     |  5 +-
 tools/lib/bpf/btf.c                                |  4 +-
 .../selftests/bpf/prog_tests/snprintf_btf_mod.c    | 96 ++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/btf_ptr.h        |  1 +
 tools/testing/selftests/bpf/progs/veth_stats_rx.c  | 73 ++++++++++++++++
 9 files changed, 238 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_mod.c
 create mode 100644 tools/testing/selftests/bpf/progs/veth_stats_rx.c

-- 
1.8.3.1

