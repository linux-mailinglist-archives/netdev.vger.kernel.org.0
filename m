Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4828027F57C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbgI3WuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:50:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47720 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731812AbgI3WuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:50:14 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UMoDT4000638
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 15:50:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=5xIBFdyzJm/dsFEH5KDFJM344HtZUaE4KWCV2yVaNzQ=;
 b=TwnkyQHCfUdRADpUYoahv1yURgf8lZ/5spHEzijCtbwaEVDwDUMJjIOP8bY4USWF3AcM
 jCSe+MYIy39YCKB/lmQUtQwNEppVuciF1p+4OwcL22DxnSEjlYaZEblkRV8iE5Fqx52r
 EB3nM4Cu+F33kHdZy8SfeN2vxTCNJhDG6j8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33v6v48ug0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 15:50:13 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 15:49:52 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 94DEB62E586A; Wed, 30 Sep 2020 15:49:50 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v5 bpf-next 0/2] introduce BPF_F_PRESERVE_ELEMS
Date:   Wed, 30 Sep 2020 15:49:25 -0700
Message-ID: <20200930224927.1936644-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 spamscore=0 bulkscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=959 phishscore=0
 suspectscore=2 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009300184
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set introduces BPF_F_PRESERVE_ELEMS to perf event array for better
sharing of perf event. By default, perf event array removes the perf even=
t
when the map fd used to add the event is closed. With BPF_F_PRESERVE_ELEM=
S
set, however, the perf event will stay in the array until it is removed, =
or
the map is closed.

---
Changes v3 =3D> v5:
1. Clean up in selftest. (Alexei)

Changes v2 =3D> v3:
1. Move perf_event_fd_array_map_free() to avoid unnecessary forward
   declaration. (Daniel)

Changes v1 =3D> v2:
1. Rename the flag as BPF_F_PRESERVE_ELEMS. (Alexei, Daniel)
2. Simplify the code and selftest. (Daniel, Alexei)

Song Liu (2):
  bpf: introduce BPF_F_PRESERVE_ELEMS for perf event array
  selftests/bpf: add tests for BPF_F_PRESERVE_ELEMS

 include/uapi/linux/bpf.h                      |  3 +
 kernel/bpf/arraymap.c                         | 19 +++++-
 tools/include/uapi/linux/bpf.h                |  3 +
 .../bpf/prog_tests/pe_preserve_elems.c        | 66 +++++++++++++++++++
 .../bpf/progs/test_pe_preserve_elems.c        | 42 ++++++++++++
 5 files changed, 131 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pe_preserve_el=
ems.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pe_preserve_el=
ems.c

--
2.24.1
