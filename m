Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797CC13D006
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgAOWW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:22:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48378 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730654AbgAOWW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:22:57 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00FMMoZg026607
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 14:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=qtFzyE4iiZiPqTpnphin2/gfu5t99YfwSg3NBgCO4xY=;
 b=UTWObrSB2d4GrS0OQmQxks6ApSxmtZIWuUyOhyhVudPvQWQ6+ejl3eODNJa7kjgg5h5x
 iwPjqaigjXEwFViPULgJRovKWfCyNxo/TR/JBWW3b0ZX6y6ZXEJe0GTtCOHG+lABfCa8
 aettlOx+NfWqqPv/8Gj4SBWPXlwgdEIoNF0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xj9vcrfsy-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 14:22:56 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 15 Jan 2020 14:22:42 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6678C294163F; Wed, 15 Jan 2020 14:22:41 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/5] bpftool: Support dumping a map with btf_vmlinux_value_type_id
Date:   Wed, 15 Jan 2020 14:22:41 -0800
Message-ID: <20200115222241.945672-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-15_03:2020-01-15,2020-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=529
 clxscore=1015 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=13 priorityscore=1501 malwarescore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001150167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a map is storing a kernel's struct, its
map_info->btf_vmlinux_value_type_id is set.  The first map type
supporting it is BPF_MAP_TYPE_STRUCT_OPS.

This series adds support to dump this kind of map with BTF.
The first two patches are bug fixes which only applicable to
in bpf-next.

Please see individual patches for details.

v2:
- Expose bpf_find_kernel_btf() as a LIBBPF_API in patch 3 (Andrii)
- Cache btf_vmlinux in bpftool/map.c (Andrii)

Martin KaFai Lau (5):
  bpftool: Fix a leak of btf object
  bpftool: Fix missing BTF output for json during map dump
  libbpf: Expose bpf_find_kernel_btf as a LIBBPF_API
  bpftool: Add struct_ops map name
  bpftool: Support dumping a map with btf_vmlinux_value_type_id

 tools/bpf/bpftool/map.c  | 103 ++++++++++++++++++++++++---------------
 tools/lib/bpf/btf.c      | 102 +++++++++++++++++++++++++++++++++++---
 tools/lib/bpf/btf.h      |   2 +
 tools/lib/bpf/libbpf.c   |  93 ++---------------------------------
 tools/lib/bpf/libbpf.map |   1 +
 5 files changed, 167 insertions(+), 134 deletions(-)

-- 
2.17.1

