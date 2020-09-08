Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E07261891
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731805AbgIHR5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:57:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50570 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728184AbgIHR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:57:22 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 088HvH2E007609
        for <netdev@vger.kernel.org>; Tue, 8 Sep 2020 10:57:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=kM8n0ZP0Aws+jsdQw0Zf7gHq68l6vzED6c5DDHwLnZo=;
 b=bbqDHaAY1eKGxknTWr/u2qp4kjdD2NZjvYvuR5w4G7Wo9Zh1CsXHIIjxRQxi8ASO3btL
 sJcqgWRZk8ShNtJQnQRg0bmFXnbR1dgYs2zqqjVFT7SElO+Hp0zz2ZpJ9Vk4RZDdkMwp
 R+xNAAO9B1I6xOXA1waKxtj/qDfHcL6OhIg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33c91hdmte-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:57:20 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 10:57:11 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 702673704B12; Tue,  8 Sep 2020 10:57:02 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next v3 0/2] bpf: permit map_ptr arithmetic with opcode add and offset 0
Date:   Tue, 8 Sep 2020 10:57:02 -0700
Message-ID: <20200908175702.2463416-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 suspectscore=8 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=954 impostorscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CORE, it is possible that the compiler may produce code like
  r1 =3D 0  // relocation instruction
  map_ptr +=3D r1
  ...
Currently verifier does not allow map_ptr arithmetic, even for adding wit=
h 0.
This patch set relaxed the condition so the above code can be accepted.
Patch #1 is the kernel implementation and Patch #2 added selftest tests t=
o
cover the new functionality.

Changelog:
  v2 -> v3:
    . only change hashmap subtest to use non-inline version of check_defa=
ult(),
      other subtests still used inline version. This will provide coverag=
e for
      both inline and non-inline check_default(). (Andrey)
  v1 -> v2:
    . add comment to clarify smin_val represents the const. (Andrii)

Yonghong Song (2):
  bpf: permit map_ptr arithmetic with opcode add and offset 0
  selftests/bpf: add test for map_ptr arithmetic

 kernel/bpf/verifier.c                         |  4 +++
 .../selftests/bpf/progs/map_ptr_kern.c        | 10 +++++-
 .../testing/selftests/bpf/verifier/map_ptr.c  | 32 +++++++++++++++++++
 3 files changed, 45 insertions(+), 1 deletion(-)

--=20
2.24.1

