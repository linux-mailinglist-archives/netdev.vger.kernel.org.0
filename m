Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E0527DCA2
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgI2X2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:28:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726637AbgI2X2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:28:48 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08TNPrHo025665
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=CbaM07ZK+GlVKTQxKPaMAAToEOEbD0ztrAeLlK5glk0=;
 b=SFxjzvw33+xBA+qiKigHlUAhpmOEw75Y4A+mnDnidoa8VSYMqGUUW98HvRsdIcT1t1+F
 mmoh7WWCcdNjg6lBdYKIEHZWCfO5HbAGyyav4R7JO33cTT8PnyaDN/OdN76WnUS6vw/o
 59YGi6kGgbiTzWYA0iss2XZhSfVP/Qagqmg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33t14ygd4q-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:28:46 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 16:28:45 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4374B2EC77D1; Tue, 29 Sep 2020 16:28:45 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
Date:   Tue, 29 Sep 2020 16:28:39 -0700
Message-ID: <20200929232843.1249318-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=850 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290198
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add btf_dump__dump_type_raw() API that emits human-readable low-level BTF=
 type
information, same as bpftool output. bpftool is not switched to this API
because bpftool still needs to perform all the same BTF type processing l=
ogic
to do JSON output, so benefits are pretty much zero.

Raw BTF type output is extremely useful when debugging issues with BTF. I=
t's
also handy to be able to do that in selftests. Raw BTF type output doesn'=
t
hide any information like BTF-to-C conversion might (e.g., not emitting
BTF_KIND_FUNC, BTF_KIND_VAR and BTF_KIND_DATASEC), so is the most robust =
way
to look at BTF data without going all the way to deciphering binary BTF i=
nfo.

Also, now that BTF can be extended with write APIs, teach btf_dump to wor=
k
with such modifiable BTFs, including the BTF-to-C convertion APIs. A self=
-test
to validate such incremental BTF-to-C conversion is added in patch #4.

Andrii Nakryiko (4):
  libbpf: make btf_dump work with modifiable BTF
  libbpf: add raw dumping of BTF types
  selftests/bpf: add checking of raw type dump in BTF writer APIs
    selftests
  selftests/bpf: test "incremental" btf_dump in C format

 tools/lib/bpf/btf.c                           |  17 ++
 tools/lib/bpf/btf.h                           |   1 +
 tools/lib/bpf/btf_dump.c                      | 243 ++++++++++++++++--
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/lib/bpf/libbpf_internal.h               |   1 +
 .../selftests/bpf/prog_tests/btf_dump.c       | 105 ++++++++
 .../selftests/bpf/prog_tests/btf_write.c      |  67 ++++-
 7 files changed, 410 insertions(+), 25 deletions(-)

--=20
2.24.1

