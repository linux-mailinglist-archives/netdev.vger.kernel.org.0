Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A65F36AA
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfKGSJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:09:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48486 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729688AbfKGSJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:09:17 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7HswlR018516
        for <netdev@vger.kernel.org>; Thu, 7 Nov 2019 10:09:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=K96GgidEl632iluWZ4dUWYa3EKaKV+eQvDHkAdSj0pU=;
 b=E8TKkUobxVTvkWyYXowgE/X3708BnDNPciBDdzS0NjYXi3WnRwzgJL9GzewHK0FWvVkg
 Rq+yuQZ+i+JYSl0wbeynGcZ5QaZG9QicwkYxAiYurtvOybkuQMMEHZuG3ruY54lyuKlx
 AeI2CVFpSYdFq5Z9/cAbUlhVs/dvwtWDeDU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vxxngh-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 10:09:17 -0800
Received: from 2401:db00:2050:5076:face:0:9:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 10:09:05 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CDC82294193C; Thu,  7 Nov 2019 10:09:01 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/2] Add array support to btf_struct_access
Date:   Thu, 7 Nov 2019 10:09:01 -0800
Message-ID: <20191107180901.4097452-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=8 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=809
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds array support to btf_struct_access().
Please see individual patch for details.

v4:
- Avoid removing a useful comment from btf_struct_access()
- Add comments to clarify the "mtrue_end" naming and
  how it may not always correspond to mtype/msize/moff.

v3:
- Fixed an interpreter issue that missed accounting
  for insn->off

v2:
- Fix a divide-by-zero when there is empty array in
  a struct (e.g. "__u8 __cloned_offset[0];" in skbuff)
- Add 'static' to a global var in prog_tests/kfree_skb.c

Martin KaFai Lau (2):
  bpf: Add array support to btf_struct_access
  bpf: Add cb access in kfree_skb test

 kernel/bpf/btf.c                              | 195 +++++++++++++++---
 .../selftests/bpf/prog_tests/kfree_skb.c      |  54 ++++-
 tools/testing/selftests/bpf/progs/kfree_skb.c |  25 ++-
 3 files changed, 229 insertions(+), 45 deletions(-)

-- 
2.17.1

