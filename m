Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D9753BAE7
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiFBOiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbiFBOiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:38:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E0513B8DC;
        Thu,  2 Jun 2022 07:38:06 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LDT9w158vz67tVr;
        Thu,  2 Jun 2022 22:37:08 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 2 Jun 2022 16:38:03 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 0/9] bpf: Per-operation map permissions
Date:   Thu, 2 Jun 2022 16:37:39 +0200
Message-ID: <20220602143748.673971-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the bpf_map security hook, an eBPF program is able to restrict access
to a map. For example, it might allow only read accesses and deny write
accesses.

Unfortunately, permissions are not accurately specified by libbpf and
bpftool. As a consequence, even if they are requested to perform a
read-like operation, such as a map lookup, that operation fails even if the
caller has the right to do so.

Even worse, the iteration over existing maps stops as soon as a
write-protected one is encountered. Maps after the write-protected one are
not accessible, even if the user has the right to perform operations on
them.

At low level, the problem is that open_flags and file_flags, respectively
in the bpf_map_get_fd_by_id() and bpf_obj_get(), are set to zero. The
kernel interprets this as a request to obtain a file descriptor with full
permissions.

For some operations, like show or dump, a read file descriptor is enough.
Those operations could be still performed even in a write-protected map.

Also for searching a map by name, which requires getting the map info, a
read file descriptor is enough. If an operation requires more permissions,
they could still be requested later, after the search.

First, solve both problems by extending libbpf with two new functions,
bpf_map_get_fd_by_id_flags() and bpf_obj_get_flags(), which unlike their
counterparts bpf_map_get_fd_by_id() and bpf_obj_get(), have the additional
parameter flags to specify the needed permissions for an operation.

Then, propagate the flags in bpftool from the functions implementing the
subcommands down to the functions calling bpf_map_get_fd_by_id() and
bpf_obj_get(), and replace the latter functions with their new variant.
Initially, set the flags to zero, so that the current behavior does not
change.

The only exception is for map search by name, where a read-only permission
is requested, regardless of the operation, to get the map info. In this
case, request a new file descriptor if a write-like operation needs to be
performed after the search.

Finally, identify other read-like operations in bpftool and for those
replace the zero value for flags with BPF_F_RDONLY.

The patch set is organized as follows.

Patches 1-2 introduce the two new variants of bpf_map_get_fd_by_id() and
bpf_obj_get() in libbpf, named respectively bpf_map_get_fd_by_id_flags()
and bpf_obj_get_flags().

Patches 3-7 propagate the flags in bpftool from the functions implementing
the subcommands to the two new libbpf functions, and always set flags to
BPF_F_RDONLY for the map search operation.

Patch 8 adjusts permissions depending on the map operation performed.

Patch 9 ensures that read-only accesses to a write-protected map succeed
and write accesses still fail. Also ensure that map search is always
successful even if there are write-protected maps.

Changelog

v1:
  - Define per-operation permissions rather than retrying access with
    read-only permission (suggested by Daniel)
    https://lore.kernel.org/bpf/20220530084514.10170-1-roberto.sassu@huawei.com/

Roberto Sassu (9):
  libbpf: Introduce bpf_map_get_fd_by_id_flags()
  libbpf: Introduce bpf_obj_get_flags()
  bpftool: Add flags parameter to open_obj_pinned_any() and
    open_obj_pinned()
  bpftool: Add flags parameter to *_parse_fd() functions
  bpftool: Add flags parameter to map_parse_fds()
  bpftool: Add flags parameter to map_parse_fd_and_info()
  bpftool: Add flags parameter in struct_ops functions
  bpftool: Adjust map permissions
  selftests/bpf: Add map access tests

 tools/bpf/bpftool/btf.c                       |  11 +-
 tools/bpf/bpftool/cgroup.c                    |   4 +-
 tools/bpf/bpftool/common.c                    |  52 ++--
 tools/bpf/bpftool/iter.c                      |   2 +-
 tools/bpf/bpftool/link.c                      |   9 +-
 tools/bpf/bpftool/main.h                      |  17 +-
 tools/bpf/bpftool/map.c                       |  24 +-
 tools/bpf/bpftool/map_perf_ring.c             |   3 +-
 tools/bpf/bpftool/net.c                       |   2 +-
 tools/bpf/bpftool/prog.c                      |  12 +-
 tools/bpf/bpftool/struct_ops.c                |  39 ++-
 tools/lib/bpf/bpf.c                           |  16 +-
 tools/lib/bpf/bpf.h                           |   2 +
 tools/lib/bpf/libbpf.map                      |   2 +
 .../bpf/prog_tests/test_map_check_access.c    | 264 ++++++++++++++++++
 .../selftests/bpf/progs/map_check_access.c    |  65 +++++
 16 files changed, 452 insertions(+), 72 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_check_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_check_access.c

-- 
2.25.1

