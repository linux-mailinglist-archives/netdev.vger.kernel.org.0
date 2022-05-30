Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE101537702
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiE3Ip5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiE3Ipz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:45:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED50DE9;
        Mon, 30 May 2022 01:45:54 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LBTS85LZsz684pj;
        Mon, 30 May 2022 16:42:32 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 10:45:51 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 0/2] bpf: Retry access to a map in read-only mode
Date:   Mon, 30 May 2022 10:45:12 +0200
Message-ID: <20220530084514.10170-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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

If a map is write-protected, for example by an eBPF program implementing
the bpf_map security hook, some read-like operations like show and dump
cannot be performed by bpftool even if bpftool has the right to do so.

The reason is that bpftool sets the open flags to zero, at the time it gets
a map file descriptor. The kernel interprets this as a request for full
access to the map (with read and write permissions).

The simple solution is to set only the necessary open flags for a requested
operation, so that only those operations requiring more privileges than the
ones granted by the enforcing eBPF programs are denied.

There are different ways to solve the problem. One would be to introduce a
new function to acquire a read-only file descriptor and use it from the
functions implementing read-like operations.

Or more simply, another is to attempt to get a read-only file descriptor in
the original function when the first request with full permissions failed.

This patch set implements the second solution in patch 1, and adds a
corresponding test in patch 2. Depending on the feedback, the first
solution can be implemented.

Roberto Sassu (2):
  libbpf: Retry map access with read-only permission
  selftests/bpf: Add test for retrying access to map with read-only perm

 tools/lib/bpf/bpf.c                           |  5 ++
 .../bpf/prog_tests/test_map_retry_access.c    | 54 +++++++++++++++++++
 .../selftests/bpf/progs/map_retry_access.c    | 36 +++++++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_retry_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_retry_access.c

-- 
2.25.1

