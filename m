Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8E6592ED9
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 14:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241765AbiHOMYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 08:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiHOMYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 08:24:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC02C26560
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 05:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660566268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uQpVVBlfu8C4hEHqV5wDB9Y4RIj/DrlDPxyv9jq2Kvc=;
        b=QtmwwYKsH5w4k9Ikj1NSgWyyNcgoEakVYkLzUCqk2FhFzuB/YvjKqQM6W2KVZFxaikO1PK
        ZEtnsEp5Ws4+4oTDjR/wSEhZPoVaIYwD4yRBob5aFkXL26LP+zwwnQY7XLd5fyN+IvnXd7
        6EaFU2pwiUj/6X43ynGPUvzQE2U6dHU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-udLdasqIN7SvwqS6pAJ47w-1; Mon, 15 Aug 2022 08:24:25 -0400
X-MC-Unique: udLdasqIN7SvwqS6pAJ47w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 288D229AB449;
        Mon, 15 Aug 2022 12:24:25 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 05D95112131B;
        Mon, 15 Aug 2022 12:24:24 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id E451F1C02A5; Mon, 15 Aug 2022 14:24:23 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: fix attach point for non-x86 arches in test_progs/lsm
Date:   Mon, 15 Aug 2022 14:24:22 +0200
Message-Id: <20220815122422.687116-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use SYS_PREFIX macro from bpf_misc.h instead of hard-coded '__x64_'
prefix for sys_setdomainname attach point in lsm test.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 tools/testing/selftests/bpf/progs/lsm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index 33694ef8acfa..d8d8af623bc2 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -4,6 +4,7 @@
  * Copyright 2020 Google LLC.
  */
 
+#include "bpf_misc.h"
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
@@ -160,7 +161,7 @@ int BPF_PROG(test_task_free, struct task_struct *task)
 
 int copy_test = 0;
 
-SEC("fentry.s/__x64_sys_setdomainname")
+SEC("fentry.s/" SYS_PREFIX "sys_setdomainname")
 int BPF_PROG(test_sys_setdomainname, struct pt_regs *regs)
 {
 	void *ptr = (void *)PT_REGS_PARM1(regs);
-- 
2.37.1

