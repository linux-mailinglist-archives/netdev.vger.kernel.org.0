Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3374A23C540
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 07:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgHEFvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 01:51:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725920AbgHEFvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 01:51:01 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0755p1s4001336
        for <netdev@vger.kernel.org>; Tue, 4 Aug 2020 22:51:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=CRvJorEC17eX27jrDmKqcWJ299NGOzwHbVEH856ABfA=;
 b=GFea2HL/MfvCUqninT5SAwt+YOfECusv3kUo/Mm+W1o0Ky0/mWlbl08lv0oSfGDF6C8H
 yO6fsocrnOrtMFjFO4bviL4wI+Rw6FgnsSZJbVT0umSXCaB/8TCs2hLyDPt5w9iXDq3D
 /FTLYopY4LGxSWijxRM+mw8c1yHfbpw4mxc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32qefa208s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 22:51:01 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 22:51:00 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6839F3705133; Tue,  4 Aug 2020 22:50:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf v4 0/2] bpf: change uapi for bpf iterator map elements
Date:   Tue, 4 Aug 2020 22:50:56 -0700
Message-ID: <20200805055056.1457388-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_04:2020-08-03,2020-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 spamscore=0 phishscore=0 priorityscore=1501 mlxscore=0 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008050052
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
  v3 -> v4:
    . add a forward declaration of bpf_iter_link_info in
      tools/lib/bpf/bpf.h in case that libbpf is built against
      not-latest uapi bpf.h.
    . target the patch set to "bpf" instead of "bpf-next"
  v2 -> v3:
    . undo "not reject iter_info.map.map_fd =3D=3D 0" from v1.
      In the future map_fd may become optional, so let us use map_fd =3D=3D=
 0
      indicating the map_fd is not set by user space.
    . add link_info_len to bpf_iter_attach_opts to ensure always correct
      link_info_len from user. Otherwise, libbpf may deduce incorrect
      link_info_len if it uses different uapi header than the user app.
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
 kernel/bpf/map_iter.c                         | 37 +++++++++---
 kernel/bpf/syscall.c                          |  2 +-
 net/core/bpf_sk_storage.c                     | 37 +++++++++---
 tools/bpf/bpftool/iter.c                      |  9 ++-
 tools/include/uapi/linux/bpf.h                | 15 ++---
 tools/lib/bpf/bpf.c                           |  3 +
 tools/lib/bpf/bpf.h                           |  5 +-
 tools/lib/bpf/libbpf.c                        |  6 +-
 tools/lib/bpf/libbpf.h                        |  5 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       | 40 ++++++++++---
 13 files changed, 160 insertions(+), 82 deletions(-)

--=20
2.24.1

