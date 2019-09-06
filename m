Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5D5AAC2BD
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 00:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392700AbfIFWyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 18:54:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38450 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389698AbfIFWyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 18:54:55 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x86Mso13020433
        for <netdev@vger.kernel.org>; Fri, 6 Sep 2019 15:54:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=nSFWwVxQsqHF3/M8YmhJm9tm7mNW8GuKI2jfSdkKnbI=;
 b=As5aC5kSGgXKWDhJ5apGVDyphqIYf+O7oMLgDm+daWTry0FRHrTSt5vUlaTrAqPF9e//
 RQNp8i4rByGf7c47HYU9rzod05MaFVeasAksevdO0DAAhAH98usczxPKFUZZidrdZbqO
 9mNoxXd6ueH86Q2YssMasH1kOGER6/r6IDY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uu8mdxbg7-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 15:54:54 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 6 Sep 2019 15:54:35 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id C532F3703134; Fri,  6 Sep 2019 15:54:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <ast@fb.com>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Stanislav Fomichev <sdf@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 0/2] bpf: adding map batch processing support
Date:   Fri, 6 Sep 2019 15:54:32 -0700
Message-ID: <20190906225434.3635421-1-yhs@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_10:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxlogscore=754 clxscore=1015 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060223
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous discussion at:
  https://lore.kernel.org/bpf/7ba9b492-8a08-a1d0-9c6e-03be4b8e5e07@fb.com/T/#t

Previous approach tries to use existing per-map looks like
bpf_map_{get_next_key, lookup_elem, update_elem, delete_elem}
to implement a batching process.

It has a series drawback when the prev_key used by bpf_map_get_next_key()
is not in hash table. In that case, as the hash table has no idea where
the `prev_key` has been placed in the bucket before deletion, currently,
it returns the first key. This makes batch processing may see
duplicated elements, or in worst case if the hash table has heavy
update/delete, the batch processing may never finish.

This RFC patch set implements bucket based batching for hashtab.
That is, for lookup/delete, either the whole bucket is processed
or none of elements in the bucket is processed. Forward progress
is also guaranteed as long as user provides enough buffer.

This RFC also serves as a base for discussion at upcoming
LPC2019 BPF Microconference.

Changelogs:
   v1 -> RFC v2:
     . To address the bpf_map_get_next_key() issue where
       if a key is not available the first key will be returned,
       implement per-map batch operations for hashtab/lru_hashtab,
       using bucket lock, as suggested by Alexei.

Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Brian Vazquez <brianvv@google.com>
Cc: Stanislav Fomichev <sdf@google.com>

Yonghong Song (2):
  bpf: adding map batch processing support
  tools/bpf: test bpf_map_lookup_and_delete_batch()

 include/linux/bpf.h                           |   9 +
 include/uapi/linux/bpf.h                      |  22 ++
 kernel/bpf/hashtab.c                          | 324 ++++++++++++++++++
 kernel/bpf/syscall.c                          |  68 ++++
 tools/include/uapi/linux/bpf.h                |  22 ++
 tools/lib/bpf/bpf.c                           |  59 ++++
 tools/lib/bpf/bpf.h                           |  13 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../map_tests/map_lookup_and_delete_batch.c   | 155 +++++++++
 9 files changed, 676 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch.c

-- 
2.17.1

