Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3734CA337
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241397AbiCBLQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbiCBLPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:15:52 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47304A252A;
        Wed,  2 Mar 2022 03:14:33 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s1H10R8z67bhp;
        Wed,  2 Mar 2022 19:13:23 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:14:30 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <revest@chromium.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 0/9] bpf-lsm: Extend interoperability with IMA
Date:   Wed, 2 Mar 2022 12:13:55 +0100
Message-ID: <20220302111404.193900-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the interoperability with IMA, to give wider flexibility for the
implementation of integrity-focused LSMs based on eBPF.

Patch 1 fixes some style issues.

Patches 2-6 give the ability to eBPF-based LSMs to take advantage of the
measurement capability of IMA without needing to setup a policy in IMA
(those LSMs might implement the policy capability themselves).

Patches 7-9 allow eBPF-based LSMs to evaluate files read by the kernel.

Changelog

v2:
- Add better description to patch 1 (suggested by Shuah)
- Recalculate digest if it is not fresh (when IMA_COLLECTED flag not set)
- Move declaration of bpf_ima_file_hash() at the end (suggested by
  Yonghong)
- Add tests to check if the digest has been recalculated
- Add deny test for bpf_kernel_read_file()
- Add description to tests

v1:
- Modify ima_file_hash() only and allow the usage of the function with the
  modified behavior by eBPF-based LSMs through the new function
  bpf_ima_file_hash() (suggested by Mimi)
- Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
  and bpf_ima_file_hash() can be called inside the implementation of
  eBPF-based LSMs for this hook

Roberto Sassu (9):
  ima: Fix documentation-related warnings in ima_main.c
  ima: Always return a file measurement in ima_file_hash()
  bpf-lsm: Introduce new helper bpf_ima_file_hash()
  selftests/bpf: Move sample generation code to ima_test_common()
  selftests/bpf: Add test for bpf_ima_file_hash()
  selftests/bpf: Check if the digest is refreshed after a file write
  bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
  selftests/bpf: Add test for bpf_lsm_kernel_read_file()
  selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA
    policy

 include/uapi/linux/bpf.h                      |  11 ++
 kernel/bpf/bpf_lsm.c                          |  21 +++
 security/integrity/ima/ima_main.c             |  57 ++++---
 tools/include/uapi/linux/bpf.h                |  11 ++
 tools/testing/selftests/bpf/ima_setup.sh      |  35 +++-
 .../selftests/bpf/prog_tests/test_ima.c       | 149 +++++++++++++++++-
 tools/testing/selftests/bpf/progs/ima.c       |  66 +++++++-
 7 files changed, 321 insertions(+), 29 deletions(-)

-- 
2.32.0

