Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB534B6C42
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237762AbiBOMly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:41:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237763AbiBOMlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:41:51 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FB213FA5;
        Tue, 15 Feb 2022 04:41:40 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JygZx5Kb4z6809v;
        Tue, 15 Feb 2022 20:37:13 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 13:41:37 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 0/6] bpf-lsm: Extend interoperability with IMA
Date:   Tue, 15 Feb 2022 13:40:36 +0100
Message-ID: <20220215124042.186506-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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

Patches 2-4 gives the ability to eBPF-based LSMs to take advantage of the
measurement capability of IMA without needing to setup a policy in IMA
(those LSMs might implement the policy capability themselves).

Patches 5-6 allows eBPF-based LSMs to evaluate files read by the kernel.

Changelog

v1:
- Modify ima_file_hash() only and allow the usage of the function with the
  modified behavior by eBPF-based LSMs through the new function
  bpf_ima_file_hash() (suggested by Mimi)
- Make bpf_lsm_kernel_read_file() sleepable so that bpf_ima_inode_hash()
  and bpf_ima_file_hash() can be called inside the implementation of
  eBPF-based LSMs for this hook

Roberto Sassu (6):
  ima: Fix documentation-related warnings in ima_main.c
  ima: Always return a file measurement in ima_file_hash()
  bpf-lsm: Introduce new helper bpf_ima_file_hash()
  selftests/bpf: Add test for bpf_ima_file_hash()
  bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
  selftests/bpf: Add test for bpf_lsm_kernel_read_file()

 include/uapi/linux/bpf.h                      | 11 +++++
 kernel/bpf/bpf_lsm.c                          | 21 +++++++++
 security/integrity/ima/ima_main.c             | 47 ++++++++++++-------
 tools/include/uapi/linux/bpf.h                | 11 +++++
 tools/testing/selftests/bpf/ima_setup.sh      |  2 +
 .../selftests/bpf/prog_tests/test_ima.c       | 30 ++++++++++--
 tools/testing/selftests/bpf/progs/ima.c       | 34 ++++++++++++--
 7 files changed, 132 insertions(+), 24 deletions(-)

-- 
2.32.0

