Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776041686E8
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgBUSqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:46:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49946 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729454AbgBUSqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:46:54 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01LIcZhY013077
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:46:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=f1MtdhRGPpOHocLyOIkYtXcGL6Y3jkkTcsYbjSLkwYg=;
 b=CQwKnvLNthcsXLFZsrOdgmXohpL1ZHfgjMHw4HxiDdXO1c/chYfQwRUu1TA0jZfwiRG7
 r44npfIwiANa6QkWeJ+ZCjV0nxiXtqmTOq3tVpfNYroaLK16pTBhvEa7bsoU+TGBARMH
 wudo+6rTqoPJNAt+Gf7WiHTUF7qJz60WbZc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2ya7ggkg8q-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:46:53 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 21 Feb 2020 10:46:51 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A975829406D6; Fri, 21 Feb 2020 10:46:50 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] Provide bpf_sk_storage data in INET_DIAG
Date:   Fri, 21 Feb 2020 10:46:50 -0800
Message-ID: <20200221184650.21920-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-21_06:2020-02-21,2020-02-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 suspectscore=13 priorityscore=1501 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=374 spamscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_prog can store specific info to a sk by using bpf_sk_storage.
In other words, a sk can be extended by a bpf_prog.

This series is to support providing bpf_sk_storage data during inet_diag's
dump.  The primary target is the usage like iproute2's "ss".

The first two patches are refactoring works in inet_diag to make
adding bpf_sk_storage support easier.  The next two patches do
the actual work.

Please see individual patch for details.

Martin KaFai Lau (4):
  inet_diag: Refactor inet_sk_diag_fill(), dump(), and dump_one()
  inet_diag: Move the INET_DIAG_REQ_BYTECODE nlattr to cb->data
  bpf: INET_DIAG support in bpf_sk_storage
  bpf: inet_diag: Dump bpf_sk_storages in inet_diag_dump()

 include/linux/bpf.h            |   1 +
 include/linux/inet_diag.h      |  27 +--
 include/linux/netlink.h        |   4 +-
 include/net/bpf_sk_storage.h   |  27 +++
 include/uapi/linux/inet_diag.h |   5 +-
 include/uapi/linux/sock_diag.h |  26 +++
 kernel/bpf/syscall.c           |  15 ++
 net/core/bpf_sk_storage.c      | 283 +++++++++++++++++++++++++++++-
 net/dccp/diag.c                |   9 +-
 net/ipv4/inet_diag.c           | 304 ++++++++++++++++++++-------------
 net/ipv4/raw_diag.c            |  24 ++-
 net/ipv4/tcp_diag.c            |   8 +-
 net/ipv4/udp_diag.c            |  41 +++--
 net/sctp/diag.c                |   7 +-
 14 files changed, 596 insertions(+), 185 deletions(-)

-- 
2.17.1

