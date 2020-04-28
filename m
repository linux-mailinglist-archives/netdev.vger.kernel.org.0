Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5D1BB6EA
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 08:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgD1Glp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 02:41:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39166 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbgD1Glp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 02:41:45 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03S6dVht001477
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=stMB8MC5/GqzfqdlkDVB5yGnXDVhDyR2mYLaM73Phe8=;
 b=nMyXdkUXT2ulV1H6MYerI8Q04lvGDJoRLAr7svPfr2zX+9/F6rd4dRHP4gbBq+CriYt5
 vgJqEVo2Vb0ymM2npR3wZnE/TXu5RyDgn/nh9uZOqHkYemAqiQgSfwoJlF1mKVV0KS7/
 zQ8jklHFrMBTeGOFOXVQrkiegd2kQRuXk3M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30ntjvpww9-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 23:41:43 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 23:41:42 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 54B792EC2FA7; Mon, 27 Apr 2020 23:41:42 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <toke@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] Add BTF-defined map-in-map support to libbpf
Date:   Mon, 27 Apr 2020 23:41:36 -0700
Message-ID: <20200428064140.122796-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_03:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 suspectscore=8 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004280057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set teaches libbpf how to declare and initialize ARRAY_OF_MAPS=
 and
HASH_OF_MAPS maps. See patch #3 for all the details.

Patch #1 refactors parsing BTF definition of map to re-use it cleanly for
inner map definition parsing.

Patch #2 refactors map creation and destruction logic for reuse. It also =
fixes
existing bug with not closing successfully created maps when bpf_object m=
ap
creation overall fails.

Patch #3 adds support for an extension of BTF-defined map syntax, as well=
 as
parsing, recording, and use of relocations to allow declaratively initial=
ize
outer maps with references to inner maps.

Andrii Nakryiko (3):
  libbpf: refactor BTF-defined map definition parsing logic
  libbpf: refactor map creation logic and fix cleanup leak
  libbpf: add BTF-defined map-in-map support

 tools/lib/bpf/bpf_helpers.h                   |   1 +
 tools/lib/bpf/libbpf.c                        | 698 ++++++++++++------
 .../selftests/bpf/prog_tests/btf_map_in_map.c |  49 ++
 .../selftests/bpf/progs/test_btf_map_in_map.c |  76 ++
 4 files changed, 606 insertions(+), 218 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_map_in_map=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_map_in_map=
.c

--=20
2.24.1

