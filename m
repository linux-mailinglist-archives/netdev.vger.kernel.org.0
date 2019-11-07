Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B29F247D
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfKGBqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:46:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727778AbfKGBqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 20:46:44 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA71cdpX020370
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 17:46:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zk1kCImHpvuY6mO76Vwr4uMLDdfV3Tf1/DVrisRAj8w=;
 b=IeLMk0EJHlhHeez1zUvLWWtFC+zGwyliX5AQlwfvKoj5C0BdGU7IjUPM2h6RqAt6dhBp
 Kktb/B4A1Xy0Mn0aWdqXhantjL6bRz+lJHELGpO0HdPZxdvaRqrf/JQwD+jpjPKUzFUD
 nyhP6xYp1BkLy4Sq342TTnR++bnALgdqFf4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41vxtgg7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 17:46:43 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 17:46:42 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9DD8529430DB; Wed,  6 Nov 2019 17:46:39 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] bpf: Add array support to btf_struct_access
Date:   Wed, 6 Nov 2019 17:46:39 -0800
Message-ID: <20191107014639.384014-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 mlxscore=0
 suspectscore=8 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=871
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070016
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds array support to btf_struct_access().
Please see individual patch for details.

v3:
- Fixed an interpreter issue that missed accounting
  for insn->off

v2:
- Fix a divide-by-zero when there is empty array in
  a struct (e.g. "__u8 __cloned_offset[0];" in skbuff)
- Add 'static' to a global var in prog_tests/kfree_skb.c

Martin KaFai Lau (3):
  bpf: Account for insn->off when doing bpf_probe_read_kernel
  bpf: Add array support to btf_struct_access
  bpf: Add cb access in kfree_skb test

 kernel/bpf/btf.c                              | 187 +++++++++++++++---
 kernel/bpf/core.c                             |   2 +-
 .../selftests/bpf/prog_tests/kfree_skb.c      |  54 +++--
 tools/testing/selftests/bpf/progs/kfree_skb.c |  25 ++-
 4 files changed, 221 insertions(+), 47 deletions(-)

-- 
2.17.1

