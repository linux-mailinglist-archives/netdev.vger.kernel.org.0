Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DDB24DFDB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgHUSoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:44:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13686 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgHUSoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:44:23 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LIbtl7019354
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:44:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KHOEnIhDGb3YcMOfP80cPan6bG+mM/wIU3Ifi6h+bzM=;
 b=D5D8EfvVA0dxRzH4mB7k8fcU2jzEEMfo2itc04oO6gXg5q7ies/VBhyPklCyp8/WG0aP
 AX0sSiMbq4A3wsEh8zGDM6fUNorONbi9J+TbbmBmS9axURkbma7UsaQhyvYATQynrQnO
 OC/HWXkZ5L9PtYG/Vbxd1aMsijWsn8r+odI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 332gp815k9-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:44:22 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 11:44:21 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 5BF883702096; Fri, 21 Aug 2020 11:44:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 0/3] bpf: implement link_query for bpf iterators
Date:   Fri, 21 Aug 2020 11:44:18 -0700
Message-ID: <20200821184418.574065-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=755
 priorityscore=1501 mlxscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=9 spamscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210176
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"link" has been an important concept for bpf ecosystem to connect
bpf program with other properties. Currently, the information related
information can be queried from userspace through bpf command
BPF_LINK_GET_NEXT_ID, BPF_LINK_GET_FD_BY_ID and BPF_OBJ_GET_INFO_BY_FD.
The information is also available by "cating" /proc/<pid>/fdinfo/<link_fd=
>.
Raw_tracepoint, tracing, cgroup, netns and xdp links are already
supported in the kernel and bpftool.

This patch added support for bpf iterator. Patch #1 added generic support
for link querying interface. Patch #2 implemented callback functions
for map element bpf iterators. Patch #3 added bpftool support.

Changelogs:
  v3 -> v4:
    . return target specific link_info even if target_name buffer
      is empty. (Andrii)
  v2 -> v3:
    . remove extra '\t' when fdinfo prints map_id to make parsing
      consistent. (Andrii)
  v1 -> v2:
    . fix checkpatch.pl warnings. (Jakub)

Yonghong Song (3):
  bpf: implement link_query for bpf iterators
  bpf: implement link_query callbacks in map element iterators
  bpftool: implement link_query for bpf iterators

 include/linux/bpf.h            | 10 ++++++
 include/uapi/linux/bpf.h       |  7 ++++
 kernel/bpf/bpf_iter.c          | 58 ++++++++++++++++++++++++++++++++++
 kernel/bpf/map_iter.c          | 15 +++++++++
 net/core/bpf_sk_storage.c      |  2 ++
 tools/bpf/bpftool/link.c       | 44 ++++++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h |  7 ++++
 7 files changed, 140 insertions(+), 3 deletions(-)

--=20
2.24.1

