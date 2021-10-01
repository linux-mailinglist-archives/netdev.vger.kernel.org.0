Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B37F41F73B
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355842AbhJAWFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:05:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4814 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355799AbhJAWFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:05:12 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 191LtcuJ021393
        for <netdev@vger.kernel.org>; Fri, 1 Oct 2021 15:03:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=H5ZHUYFEhbidodW/G8tkR5W9D7fiUi+8DDuSlnbpc0o=;
 b=ZOFvMHbm+5pfZRyUVkSZ9u5ErBcoK8yOgAx80VeLoISLgHb9e0r8Zp+4Yr4y6hlYqPpL
 7wLQIlMQt0WT79vLeyT1szs4EyIvBVOS22Ocjsp/uTVg+qc/xmhtf41bj8QfT/HNx77w
 nx4WRZtwY3f70cUJSkfRATpRm3ZVwYtNIuE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3be9abrjt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 15:03:27 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 1 Oct 2021 15:03:26 -0700
Received: by devbig612.frc2.facebook.com (Postfix, from userid 115148)
        id 4280F312DE4A; Fri,  1 Oct 2021 15:03:17 -0700 (PDT)
From:   Joanne Koong <joannekoong@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kafai@fb.com>, <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Joanne Koong <joannekoong@fb.com>
Subject: [PATCH bpf-next v1 0/3] Add XDP support for bpf_load_hdr_opt
Date:   Fri, 1 Oct 2021 14:58:55 -0700
Message-ID: <20211001215858.1132715-1-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: NOo0obyGNiVpbTwQe0JfURPAv1Fmc8d1
X-Proofpoint-GUID: NOo0obyGNiVpbTwQe0JfURPAv1Fmc8d1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-01_05,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 clxscore=1015 mlxlogscore=266 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110010153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpf_sockops programs have been using bpf_load_hdr_opt() to
parse the tcp header option. It will be useful to allow other bpf prog
types to have a similar way of handling tcp hdr options.

This series adds XDP support for bpf_load_hdr_opt(). At a high level,
these patches are:

1/3 patch - Add functionality for xdp bpf_load_hdr_opt in net/core.

2/3 patch - Rename existing test_tcp_hdr_options to test_sockops_tcp_hdr_=
options.

3/3 patch - Add tests for xdp bpf_load_hdr_opt (test_xdp_tcp_hdr_options)=
.

Joanne Koong (3):
  bpf/xdp: Add bpf_load_hdr_opt support for xdp
  bpf/selftests: Rename test_tcp_hdr_options to
    test_sockops_tcp_hdr_options
  bpf/selftests: Add xdp bpf_load_tcp_hdr_options tests

 include/uapi/linux/bpf.h                      |  26 ++-
 net/core/filter.c                             |  88 ++++++--
 tools/include/uapi/linux/bpf.h                |  26 ++-
 ...dr_options.c =3D> sockops_tcp_hdr_options.c} |  18 +-
 .../bpf/prog_tests/xdp_tcp_hdr_options.c      | 158 ++++++++++++++
 ....c =3D> test_sockops_misc_tcp_hdr_options.c} |   0
 ...tions.c =3D> test_sockops_tcp_hdr_options.c} |   0
 .../bpf/progs/test_xdp_tcp_hdr_options.c      | 198 ++++++++++++++++++
 8 files changed, 468 insertions(+), 46 deletions(-)
 rename tools/testing/selftests/bpf/prog_tests/{tcp_hdr_options.c =3D> so=
ckops_tcp_hdr_options.c} (96%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_tcp_hdr_op=
tions.c
 rename tools/testing/selftests/bpf/progs/{test_misc_tcp_hdr_options.c =3D=
> test_sockops_misc_tcp_hdr_options.c} (100%)
 rename tools/testing/selftests/bpf/progs/{test_tcp_hdr_options.c =3D> te=
st_sockops_tcp_hdr_options.c} (100%)
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_tcp_hdr_op=
tions.c

--=20
2.30.2

