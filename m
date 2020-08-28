Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E879E255279
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgH1BSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:18:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47388 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726147AbgH1BSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 21:18:04 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07S1Eheq022810
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=uH54ukcrNjtEL2V32/PN6QnHE2Ntk+ukHm4Qqmol6A8=;
 b=J8cXt0KLK+3EaXQf+Gk26+IGRh89+g055YGrttY6Xqaj/qGxXD0L2FgG4YCyqaUmj43c
 0VUVjTUOoWYOChP1tb37cnJxYYqDSQ4bw5PD1tTRCEU98vtFE6t8u8WE62mjoUgFAFSl
 K+2Ey7aYxCW9M7D4ZKIpVbkKNSp7dkClb3Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up88j4n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 18:18:03 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 18:18:01 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9D59E2946559; Thu, 27 Aug 2020 18:18:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] bpf: Relax the max_entries check for inner map
Date:   Thu, 27 Aug 2020 18:18:00 -0700
Message-ID: <20200828011800.1970018-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_14:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=13 adultscore=0 mlxlogscore=720 spamscore=0 impostorscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3:
- Add map_meta_equal to bpf_map_ops and use it as an explict
  opt-in support for map-in-map
 =20
v2:
- New BPF_MAP_TYPE_FL to minimize code churns (Alexei)
- s/capabilities/properties/ (Andrii)
- Describe WHY in commit log (Andrii)

People has a use case that starts with a smaller inner map first and then
replaces it with a larger inner map later when it is needed.

This series allows the outer map to be updated with inner map in differen=
t
size as long as it is safe (meaning the max_entries is not used in the
verification time during prog load).

Please see individual patch for details.

Martin KaFai Lau (3):
  bpf: Add map_meta_equal map ops
  bpf: Relax max_entries check for most of the inner map types
  bpf: selftests: Add test for different inner map size

 include/linux/bpf.h                           | 16 +++++++++
 kernel/bpf/arraymap.c                         | 16 +++++++++
 kernel/bpf/bpf_inode_storage.c                |  1 +
 kernel/bpf/cpumap.c                           |  1 +
 kernel/bpf/devmap.c                           |  2 ++
 kernel/bpf/hashtab.c                          |  4 +++
 kernel/bpf/lpm_trie.c                         |  1 +
 kernel/bpf/map_in_map.c                       | 24 +++++--------
 kernel/bpf/map_in_map.h                       |  2 --
 kernel/bpf/queue_stack_maps.c                 |  2 ++
 kernel/bpf/reuseport_array.c                  |  1 +
 kernel/bpf/ringbuf.c                          |  1 +
 kernel/bpf/stackmap.c                         |  1 +
 kernel/bpf/syscall.c                          |  1 +
 net/core/bpf_sk_storage.c                     |  1 +
 net/core/sock_map.c                           |  2 ++
 net/xdp/xskmap.c                              |  8 +++++
 .../selftests/bpf/prog_tests/btf_map_in_map.c | 35 ++++++++++++++++++-
 .../selftests/bpf/progs/test_btf_map_in_map.c | 31 ++++++++++++++++
 19 files changed, 132 insertions(+), 18 deletions(-)

--=20
2.24.1

