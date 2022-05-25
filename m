Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF7533DCB
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbiEYNVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiEYNVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:21:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2982427FF8;
        Wed, 25 May 2022 06:21:38 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L7Wsr5bJbz67Q1X;
        Wed, 25 May 2022 21:21:04 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 25 May 2022 15:21:35 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 0/3] bpf: Add support for maps with authenticated values
Date:   Wed, 25 May 2022 15:21:12 +0200
Message-ID: <20220525132115.896698-1-roberto.sassu@huawei.com>
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

One of the desirable features in security is the ability to restrict import
of data to a given system based on data authenticity. If data import can be
restricted, it would be possible to enforce a system-wide policy based on
the signing keys the system owner trusts.

This feature is widely used in the kernel. For example, if the restriction
is enabled, kernel modules can be plugged in only if they are signed with a
key whose public part is in the primary or secondary keyring.

For eBPF, it can be useful as well. For example, it might be useful to
authenticate data an eBPF program makes security decisions on.

The initial idea for this feature was to provide an helper that eBPF
programs might call to authenticate data whenever necessary. However, this
restricts the ability to use that helper only in sleepable programs (due to
crypto operations). Furthermore, data authentication would have been
responsibility of eBPF programs.

The proposed implementation instead shifts the responsibility of data
authentication to the eBPF subsystem, upon request by the users. Whenever
the users desire such feature, they just have to set a new map flag called
BPF_F_VERIFY_ELEM. The eBPF subsystem ensures that only authenticated data
can be added to the map. The check is performed during the execution of the
bpf() system call when the commands are BPF_MAP_UPDATE_ELEM or
BPF_MAP_UPDATE_BATCH. Since memory regions are not verified, usage of the
BPF_F_MMAPABLE map flag is forbidden when BPF_F_VERIFY_ELEM is set.

An advantage of shifting the responsibility of data authentication to the
eBPF subsystem is that it can be offered to any kind of eBPF programs, not
only the sleepable ones.

When the new map flag BPF_F_VERIFY_ELEM is set, users have to provide a map
value in the following format:

+-------------------------------+---------------+-----+-----------------+
| verified data+sig size (be32) | verified data | sig | unverified data |
+-------------------------------+---------------+-----+-----------------+

This is mostly the same format adopted for kernel modules, with the
exception of the first field, as the size cannot be determined otherwise
due to the fixed map value size. More details can be found in patch 1.

Since the kernel already parses the format above, it was convenient to
introduce also a new helper, called bpf_map_verified_data_size(), to
return the size of verified data to the caller. This is done in patch 2.

Finally, the added functionality is tested in patch 3.

Roberto Sassu (3):
  bpf: Add BPF_F_VERIFY_ELEM to require signature verification on map
    values
  bpf: Introduce bpf_map_verified_data_size() helper
  bpf: Add tests for signed map values

 include/linux/bpf.h                           |   7 +
 include/uapi/linux/bpf.h                      |  11 +
 kernel/bpf/arraymap.c                         |   2 +-
 kernel/bpf/helpers.c                          |  15 ++
 kernel/bpf/syscall.c                          |  70 ++++++
 tools/include/uapi/linux/bpf.h                |  11 +
 .../bpf/prog_tests/test_map_value_sig.c       | 212 ++++++++++++++++++
 .../selftests/bpf/progs/map_value_sig.c       |  50 +++++
 8 files changed, 377 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_value_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_value_sig.c

-- 
2.25.1

