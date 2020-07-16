Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A49221BA4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGPE4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:56:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbgGPE4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:56:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06G4uEhx028217
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:56:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=FHWFuaPBteA35UD8sCOxFNtYkRUZqrWLLOVjbjd4xbY=;
 b=jXwPXmewJYudYbS0IPjhEFshk9yH8pCH3boDVByC77eEoZuacSdHozyN93S8rjBrA4G7
 ieXgHH0Sm6xOdQ6anWl+WCEDwqozJ7rkUI1Gy0E/k0cjKog4sVM/i8vNqGgtac8NfaeQ
 c34iKgsukxqkOzWk8xkTrz9ssqFCQqnp0GI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32a7df26gf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 21:56:14 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 15 Jul 2020 21:56:11 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EDEBE2EC422D; Wed, 15 Jul 2020 21:56:03 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <dsahern@gmail.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/9] BPF XDP link
Date:   Wed, 15 Jul 2020 21:55:52 -0700
Message-ID: <20200716045602.3896926-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-15_12:2020-07-15,2020-07-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=8 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007160037
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following cgroup and netns examples, implement bpf_link support for XDP.

The semantics is described in patch #2. Program and link attachments are
mutually exclusive, in the sense that neither link can replace attached
program nor program can replace attached link. Link can't replace attache=
d
link as well, as is the case for any other bpf_link implementation.

Patch #1 refactors existing BPF program-based attachment API and centrali=
zes
high-level query/attach decisions in generic kernel code, while drivers a=
re
kept simple and are instructed with low-level decisions about attaching a=
nd
detaching specific bpf_prog. This also makes QUERY command unnecessary, a=
nd
patch #8 removes support for it from all kernel drivers. If that's a bad =
idea,
we can drop that patch altogether.

With refactoring in patch #1, adding bpf_xdp_link is completely transpare=
nt to
drivers, they are still functioning at the level of "effective" bpf_prog,=
 that
should be called in XDP data path.

Corresponding libbpf support for BPF XDP link is added in patch #5.

v2->v3:
- fix build when CONFIG_BPF_SYSCALL=3Dn (kernel test robot);

v1->v2:
- fix prog refcounting bug (David);
- split dev_change_xdp_fd() changes into 2 patches (David);
- add extack messages to all user-induced errors (David).

Andrii Nakryiko (9):
  bpf: make bpf_link API available indepently of CONFIG_BPF_SYSCALL
  bpf, xdp: maintain info on attached XDP BPF programs in net_device
  bpf, xdp: extract commong XDP program attachment logic
  bpf, xdp: add bpf_link-based XDP attachment API
  bpf, xdp: implement LINK_UPDATE for BPF XDP link
  bpf: implement BPF XDP link-specific introspection APIs
  libbpf: add support for BPF XDP link
  selftests/bpf: add BPF XDP link selftests
  bpf, xdp: remove XDP_QUERY_PROG and XDP_QUERY_PROG_HW XDP commands

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   6 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   4 -
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   3 -
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   3 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   3 -
 drivers/net/ethernet/intel/ice/ice_main.c     |   3 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   4 -
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   6 -
 drivers/net/ethernet/marvell/mvneta.c         |   5 -
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   3 -
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  24 -
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  18 -
 .../ethernet/netronome/nfp/nfp_net_common.c   |   4 -
 .../net/ethernet/qlogic/qede/qede_filter.c    |   3 -
 drivers/net/ethernet/sfc/efx.c                |   5 -
 drivers/net/ethernet/socionext/netsec.c       |   3 -
 drivers/net/ethernet/ti/cpsw_priv.c           |   3 -
 drivers/net/hyperv/netvsc_bpf.c               |  21 +-
 drivers/net/netdevsim/bpf.c                   |   4 -
 drivers/net/netdevsim/netdevsim.h             |   2 +-
 drivers/net/tun.c                             |  15 -
 drivers/net/veth.c                            |  15 -
 drivers/net/virtio_net.c                      |  17 -
 drivers/net/xen-netfront.c                    |  21 -
 include/linux/bpf.h                           |  81 ++-
 include/linux/netdevice.h                     |  29 +-
 include/net/xdp.h                             |   2 -
 include/uapi/linux/bpf.h                      |  10 +-
 kernel/bpf/syscall.c                          |   5 +
 net/core/dev.c                                | 523 +++++++++++++-----
 net/core/rtnetlink.c                          |   5 +-
 net/core/xdp.c                                |   9 -
 tools/include/uapi/linux/bpf.h                |  10 +-
 tools/lib/bpf/libbpf.c                        |   9 +-
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/section_names.c  |   2 +-
 .../selftests/bpf/prog_tests/xdp_link.c       | 137 +++++
 .../selftests/bpf/progs/test_xdp_link.c       |  12 +
 39 files changed, 656 insertions(+), 376 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_link.c

--=20
2.24.1

