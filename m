Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE8F27DB38
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbgI2V5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:57:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728041AbgI2V5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 17:57:10 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TLucql014970
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:57:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=q8DOaP2zNVDpf7BaUv2l0Ns1Xl6nLR1DxSk9kMxN8hc=;
 b=GWrFkYxy5jUWZUtmh2mnvfvrwG42g4pOXbChj0eiFIfiM/utWto4AyDtd3OWBn+Mj3Pv
 SechmFxZzrLfrmlK2CpKoDqvF+PjbYEXe8DfNDQ5rsEFGQXaWW5mSXBUNg1XenbvysBm
 7Vi9MH1sIKIj/iKLNhjsJdt4vz9bEiI0zZs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33v3vtu8tn-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 14:57:10 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 14:57:05 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 4E0F062E55BF; Tue, 29 Sep 2020 14:57:01 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 0/2] introduce BPF_F_PRESERVE_ELEMS
Date:   Tue, 29 Sep 2020 14:56:57 -0700
Message-ID: <20200929215659.3938706-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxlogscore=905 clxscore=1015 bulkscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290188
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
Changes v1 =3D> v2:
1. Rename the flag as BPF_F_PRESERVE_ELEMS. (Alexei, Daniel)
2. Simplify the code and selftest. (Daniel, Alexei)

Song Liu (2):
  bpf: introduce BPF_F_PRESERVE_ELEMS for perf event array
  selftests/bpf: add tests for BPF_F_PRESERVE_ELEMS

 include/uapi/linux/bpf.h                      |  3 +
 kernel/bpf/arraymap.c                         | 21 +++++-
 tools/include/uapi/linux/bpf.h                |  3 +
 .../bpf/prog_tests/pe_preserve_elems.c        | 66 +++++++++++++++++++
 .../bpf/progs/test_pe_preserve_elems.c        | 44 +++++++++++++
 5 files changed, 135 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pe_preserve_el=
ems.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pe_preserve_el=
ems.c

--
2.24.1
