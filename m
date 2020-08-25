Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A1825241E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgHYXUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:20:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48294 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726717AbgHYXUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:20:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PNIQXS016550
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=7vFPxfbUZkYxWAD0+nMscJ1pZa6+fxgsolX0ujeyhgk=;
 b=NHsqbFmKZntSF0WU0EKbv/Zb7124/L7ItbUD/UTTDypokd8KuFN491uW2VxLjuF7eJE/
 z7vzhdyh2C3xNhIqWNVMPHdIPNS3Mn2GT2WOAZEPA+1WuKCAwjfl+aKnZwBLyC8YIkCi
 OLWtNzHLXcFXlM0JsUHerrvTLFWZCu5QsfQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 333k6k63nf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:46 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 16:20:39 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id A08A4207586; Tue, 25 Aug 2020 16:20:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Udip Pant <udippant@fb.com>
Smtp-Origin-Hostname: devbig218.frc2.facebook.com
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Smtp-Origin-Cluster: frc2c02
Subject: [PATCH bpf-next v3 0/4] bpf: verifier: use target program's type for access verifications
Date:   Tue, 25 Aug 2020 16:19:59 -0700
Message-ID: <20200825232003.2877030-1-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0
 mlxlogscore=978 phishscore=0 adultscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds changes in verifier to make decisions such as gran=
ting
of read / write access or enforcement of return code status based on
the program type of the target program while using dynamic program
extension (of type BPF_PROG_TYPE_EXT).

The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
placeholder for those, we need this extended check for those extended
programs to actually work with proper access, while using this option.

Patch #1 includes changes in the verifier.
Patch #2 adds selftests to verify write access on a packet for a valid=20
extension program type
Patch #3 adds selftests to verify proper check for the return code
Patch #4 adds selftests to ensure access permissions and restrictions=20
for some map types such sockmap.

Changelogs:
  v2 -> v3:
    * more comprehensive resolution of the program type in the verifier
      based on the target program (and not just for the packet access)
    * selftests for checking return code and map access
    * Also moved this patch to 'bpf-next' from 'bpf' tree
  v1 -> v2:
    * extraction of the logic to resolve prog type into a separate method
    * selftests to check for packet access for a valid freplace prog

Udip Pant (4):
  bpf: verifier: use target program's type for access verifications
  selftests/bpf: add test for freplace program with write access
  selftests/bpf: test for checking return code for the extended prog
  selftests/bpf: test for map update access from within EXT programs

 kernel/bpf/verifier.c                         | 32 ++++++---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 68 +++++++++++++++++++
 .../selftests/bpf/progs/fexit_bpf2bpf.c       | 27 ++++++++
 .../bpf/progs/freplace_attach_probe.c         | 40 +++++++++++
 .../bpf/progs/freplace_cls_redirect.c         | 34 ++++++++++
 .../bpf/progs/freplace_connect_v4_prog.c      | 19 ++++++
 .../selftests/bpf/progs/test_pkt_access.c     | 20 ++++++
 7 files changed, 229 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_attach_pro=
be.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_cls_redire=
ct.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_connect_v4=
_prog.c

--=20
2.24.1

