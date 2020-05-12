Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CDB1CF9C6
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730887AbgELPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:52:39 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730464AbgELPwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:52:38 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFnY2W012893
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=/F8zpBv/fJ9de2fFznTBqA+iFDvktIgJNxfcrO6FY58=;
 b=BNortQafAFhe05Y/xXOLwAZSPQaGJy/sQAFuOcl/omEh1jEtx/73AkPcXxHrioG0lYJ6
 LZTx9gu4b1N8qUI+cFQcInbzdKgmIZ4VBq2RXdT/u6OEigj3AvIpB7+w0yt+YKlF5Mjp
 su1OAFhNDJzR3zBIybT8hLlVMGyz8QN9B8Y= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgbn75f-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 08:52:38 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:52:36 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 28C4E3700839; Tue, 12 May 2020 08:52:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/8] misc fixes for bpf_iter
Date:   Tue, 12 May 2020 08:52:32 -0700
Message-ID: <20200512155232.1080167-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 mlxlogscore=614 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120120
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ae24345da54e ("bpf: Implement an interface to register
bpf_iter targets") and its subsequent commits in the same patch set
introduced bpf iterator, a way to run bpf program when iterating
kernel data structures.

This patch set addressed some followup issues. One big change
is to allow target to pass ctx arg register types to verifier
for verification purpose. Please see individual patch for details.

Yonghong Song (8):
  tools/bpf: selftests : explain bpf_iter test failures with llvm 10.0.0
  bpf: change btf_iter func proto prefix to "bpf_iter_"
  bpf: add comments to interpret bpf_prog return values
  bpf: add WARN_ONCE if bpf_seq_read show() return a positive number
  bpf: net: refactor bpf_iter target registration
  bpf: change func bpf_iter_unreg_target() signature
  bpf: enable bpf_iter targets registering ctx argument types
  samples/bpf: remove compiler warnings

 include/linux/bpf.h                    | 20 +++++++++---
 include/net/ip6_fib.h                  |  7 ++++
 kernel/bpf/bpf_iter.c                  | 44 +++++++++++++++-----------
 kernel/bpf/btf.c                       | 15 ++++++---
 kernel/bpf/map_iter.c                  | 23 ++++++++------
 kernel/bpf/task_iter.c                 | 42 ++++++++++++++++--------
 kernel/bpf/verifier.c                  |  1 -
 net/ipv6/ip6_fib.c                     |  5 ---
 net/ipv6/route.c                       | 25 +++++++++------
 net/netlink/af_netlink.c               | 23 ++++++++------
 samples/bpf/offwaketime_kern.c         |  4 +--
 samples/bpf/sockex2_kern.c             |  4 +--
 samples/bpf/sockex3_kern.c             |  4 +--
 tools/lib/bpf/libbpf.c                 |  2 +-
 tools/testing/selftests/bpf/README.rst | 43 +++++++++++++++++++++++++
 15 files changed, 178 insertions(+), 84 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/README.rst

--=20
2.24.1

