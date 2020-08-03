Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9423A05C
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgHCHdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:33:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7440 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726062AbgHCHdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 03:33:37 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0737SaUH022741
        for <netdev@vger.kernel.org>; Mon, 3 Aug 2020 00:33:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3Ng3kZKATwRh8dvqA29ijn4MFgFGeQvUxcoBNJhH2Cs=;
 b=aTvlSlHF2YpJBLsvVtwzlmTq61ri2Qs+KFoDcemBjYA+NnfC7bw1lAz9jbMIdo3y6Ade
 evJlxyIQyLMeLu6mRpYnxC38FZ7b21PNwn/N/ggouPktnKZf3v5W4RaDhdnyB5e4ovyU
 jdlK5CyeVzbb71TwB14H1THCDQB3yEJJdTw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 32n80t5pms-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 00:33:35 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 00:33:34 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 01E2D37052EA; Mon,  3 Aug 2020 00:33:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 0/2] bpf: change uapi for bpf iterator map elements
Date:   Mon, 3 Aug 2020 00:33:26 -0700
Message-ID: <20200803073326.3745149-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_07:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 suspectscore=8 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxscore=0 mlxlogscore=965 phishscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii raised a concern that current uapi for bpf iterator map
element is a little restrictive and not suitable for future potential
complex customization. This is a valid suggestion, considering people
may indeed add more complex custimization to the iterator, e.g.,
cgroup_id + user_id, etc. for task or task_file. Another example might
be map_id plus additional control so that the bpf iterator may bail
out a bucket earlier if a bucket has too many elements which may hold
lock too long and impact other parts of systems.

Patch #1 modified uapi with kernel changes. Patch #2
adjusted libbpf api accordingly.

Changelogs:
  v1 -> v2:
    . ensure link_create target_fd/flags =3D=3D 0 since they are not used=
. (Andrii)
    . if either of iter_info ptr =3D=3D 0 or iter_info_len =3D=3D 0, but =
not both,
      return error to user space. (Andrii)
    . do not reject iter_info.map.map_fd =3D=3D 0, go ahead to use it try=
ing to
      get a map reference since the map_fd is required for map_elem itera=
tor.
    . use bpf_iter_link_info in bpf_iter_attach_opts instead of map_fd.
      this way, user space is responsible to set up bpf_iter_link_info an=
d
      libbpf just passes the data to the kernel, simplifying libbpf desig=
n.
      (Andrii)

Yonghong Song (2):
  bpf: change uapi for bpf iterator map elements
  tools/bpf: support new uapi for map element bpf iterator

 include/linux/bpf.h                           | 10 ++--
 include/uapi/linux/bpf.h                      | 15 ++---
 kernel/bpf/bpf_iter.c                         | 58 +++++++++----------
 kernel/bpf/map_iter.c                         | 34 ++++++++---
 kernel/bpf/syscall.c                          |  2 +-
 net/core/bpf_sk_storage.c                     | 34 ++++++++---
 tools/bpf/bpftool/iter.c                      |  8 ++-
 tools/include/uapi/linux/bpf.h                | 15 ++---
 tools/lib/bpf/bpf.c                           |  3 +
 tools/lib/bpf/bpf.h                           |  4 +-
 tools/lib/bpf/libbpf.c                        |  6 +-
 tools/lib/bpf/libbpf.h                        |  4 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 34 ++++++++---
 13 files changed, 146 insertions(+), 81 deletions(-)

--=20
2.24.1

