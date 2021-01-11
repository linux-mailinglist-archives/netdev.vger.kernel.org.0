Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6982F1C7B
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389620AbhAKRes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:34:48 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:53084 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbhAKRer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:34:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BHJxfO062560;
        Mon, 11 Jan 2021 17:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=rb7NUlfPAZJYvDNNr1QbLZkUrqVA6PwcClCbyGkCa10=;
 b=dH3ur6+nnsAyHiGLbVcDj0xtp5XyP7exJ9eyCrMnNe3uMZi50ToCyszF2R1WlmeqJ8QB
 OMFM36uKhx2eOb2DptRIF7QWw+fdYbL7q0eHerm0ILEQ6GFkRqw2FuQb56ZGn6qjPURY
 wtckQCJTKabmi7HFvgkHIa39vFIk9cxGMSuUPUaN/rxMOYrI+bHGX+LS9uy8QKPG5jYu
 3uY8OtaH5Kylc7DNPPGW7uOdmPiwK0FaEeOLA7PP1bA7KfQx4/5jpi0HkHe6E4LhSqNy
 PElMzJ5N9jho3A1gjGbCxNPZtG2Zk3Yb7sJ1WHF0grLm8sTxW4tavrTj4QgiGk+EYYuv Ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 360kcyje6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 11 Jan 2021 17:33:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10BHKSIn017476;
        Mon, 11 Jan 2021 17:33:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 360kf3v4h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 17:33:21 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10BHXJ1D012499;
        Mon, 11 Jan 2021 17:33:20 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Jan 2021 09:33:19 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, haoluo@google.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
Subject: [RFC PATCH bpf-next 0/2] bpf, libbpf: share BTF data show functionality
Date:   Mon, 11 Jan 2021 17:32:51 +0000
Message-Id: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110100
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9861 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 mlxlogscore=999 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF Type Format (BTF) can be used in conjunction with the helper
bpf_snprintf_btf() to display kernel data with type information.

This series generalizes that support and shares it with libbpf so
that libbpf can display typed data.  BTF display functionality is
factored out of kernel/bpf/btf.c into kernel/bpf/btf_show_common.c,
and that file is duplicated in tools/lib/bpf.  Similarly, common
definitions and inline functions needed for this support are
extracted into include/linux/btf_common.h and this header is again
duplicated in tools/lib/bpf.

Patch 1 carries out the refactoring, for which no kernel changes
are intended, and introduces btf__snprintf() a libbpf function
that supports dumping a string representation of typed data using
the struct btf * and id associated with that type.

Patch 2 tests btf__snprintf() with built-in and kernel types to
ensure data is of expected format.  The test closely mirrors
the BPF program associated with the snprintf_btf.c; in this case
however the string representations are verified in userspace rather
than in BPF program context.

Alan Maguire (2):
  bpf: share BTF "show" implementation between kernel and libbpf
  selftests/bpf: test libbpf-based type display

 include/linux/btf.h                                |  121 +-
 include/linux/btf_common.h                         |  286 +++++
 kernel/bpf/Makefile                                |    2 +-
 kernel/bpf/arraymap.c                              |    1 +
 kernel/bpf/bpf_struct_ops.c                        |    1 +
 kernel/bpf/btf.c                                   | 1215 +------------------
 kernel/bpf/btf_show_common.c                       | 1218 ++++++++++++++++++++
 kernel/bpf/core.c                                  |    1 +
 kernel/bpf/hashtab.c                               |    1 +
 kernel/bpf/local_storage.c                         |    1 +
 kernel/bpf/verifier.c                              |    1 +
 kernel/trace/bpf_trace.c                           |    1 +
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/btf.h                                |    7 +
 tools/lib/bpf/btf_common.h                         |  286 +++++
 tools/lib/bpf/btf_show_common.c                    | 1218 ++++++++++++++++++++
 tools/lib/bpf/libbpf.map                           |    1 +
 .../selftests/bpf/prog_tests/snprintf_btf_user.c   |  192 +++
 18 files changed, 3236 insertions(+), 1319 deletions(-)
 create mode 100644 include/linux/btf_common.h
 create mode 100644 kernel/bpf/btf_show_common.c
 create mode 100644 tools/lib/bpf/btf_common.h
 create mode 100644 tools/lib/bpf/btf_show_common.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf_user.c

-- 
1.8.3.1

