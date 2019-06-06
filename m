Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C137F2E
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 22:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbfFFU7x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 16:59:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49946 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbfFFU7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 16:59:48 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56Kx7tF006555
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 13:59:48 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy072tdh2-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 13:59:48 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 6 Jun 2019 13:59:45 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id BC58623327D52; Thu,  6 Jun 2019 13:59:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <bjorn.topel@intel.com>, <magnus.karlsson@intel.com>,
        <toke@redhat.com>, <brouer@redhat.com>, <daniel@iogearbox.net>,
        <ast@kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v5 bpf-next 0/4] Better handling of xskmap entries
Date:   Thu, 6 Jun 2019 13:59:39 -0700
Message-ID: <20190606205943.818795-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=687 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the AF_XDP code uses a separate map in order to
determine if an xsk is bound to a queue.  Have the xskmap
lookup return a XDP_SOCK pointer on the kernel side, which
the verifier uses to extract relevant values.

Patches:
 1 - adds XSK_SOCK type
 2 - sync bpf.h with tools
 3 - add tools selftest
 4 - update lib/bpf, removing qidconf

v4->v5:
 - xskmap lookup now returns XDP_SOCK type instead of pointer to element.
 - no changes lib/bpf/xsk.c

v3->v4:
 - Clarify error handling path.

v2->v3:
 - Use correct map type.

Jonathan Lemon (4):
  bpf: Allow bpf_map_lookup_elem() on an xskmap
  bpf/tools: sync bpf.h
  tools/bpf: Add bpf_map_lookup_elem selftest for xskmap
  libbpf: remove qidconf and better support external bpf programs.

 include/linux/bpf.h                           |   8 ++
 include/net/xdp_sock.h                        |   4 +-
 include/uapi/linux/bpf.h                      |   4 +
 kernel/bpf/verifier.c                         |  26 ++++-
 kernel/bpf/xskmap.c                           |   7 ++
 net/core/filter.c                             |  40 +++++++
 tools/include/uapi/linux/bpf.h                |   4 +
 tools/lib/bpf/xsk.c                           | 103 +++++-------------
 .../bpf/verifier/prevent_map_lookup.c         |  15 ---
 tools/testing/selftests/bpf/verifier/sock.c   |  18 +++
 10 files changed, 135 insertions(+), 94 deletions(-)

-- 
2.17.1

