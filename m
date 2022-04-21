Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402E750A039
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbiDUNEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiDUNEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:04:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE86813DD6
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650546070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6B8uAfM2zYdOBiNWDA6MHvnN4shneSOBk1++/81VmlE=;
        b=ADG+gDBDMRjErh0VPQGQZ/xYOuQIni4T5bymWZGrfHYqPoBcQvJDKe6LXj5eGt7v/98hYd
        PBpWYn6s27+xsxVysEQYwTxpyaBTvupv8bphsBZoEZd6LESdmVYEsbUjaML6qC1DDSNJaN
        IdYbaqYc99mkaQY6l8BjPC0mnbA0xCc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-jqNO56VnP7ySBIqMALhPAQ-1; Thu, 21 Apr 2022 09:01:07 -0400
X-MC-Unique: jqNO56VnP7ySBIqMALhPAQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D84E51014A69;
        Thu, 21 Apr 2022 13:01:06 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97C1D400E86E;
        Thu, 21 Apr 2022 13:01:06 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 7F8861C016C; Thu, 21 Apr 2022 15:01:05 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: fix attach tests retcode checks
Date:   Thu, 21 Apr 2022 15:01:04 +0200
Message-Id: <20220421130104.1582053-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switching to libbpf 1.0 API broke test_sock and test_sysctl as they
check for return of bpf_prog_attach to be exactly -1. Switch the check
to '< 0' instead.

Fixes: b858ba8c52b6 ("selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 tools/testing/selftests/bpf/test_sock.c   | 2 +-
 tools/testing/selftests/bpf/test_sysctl.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sock.c b/tools/testing/selftests/bpf/test_sock.c
index 6c4494076bbf..810c3740b2cc 100644
--- a/tools/testing/selftests/bpf/test_sock.c
+++ b/tools/testing/selftests/bpf/test_sock.c
@@ -492,7 +492,7 @@ static int run_test_case(int cgfd, const struct sock_test *test)
 			goto err;
 	}
 
-	if (attach_sock_prog(cgfd, progfd, test->attach_type) == -1) {
+	if (attach_sock_prog(cgfd, progfd, test->attach_type) < 0) {
 		if (test->result == ATTACH_REJECT)
 			goto out;
 		else
diff --git a/tools/testing/selftests/bpf/test_sysctl.c b/tools/testing/selftests/bpf/test_sysctl.c
index 5bae25ca19fb..57620e7c9048 100644
--- a/tools/testing/selftests/bpf/test_sysctl.c
+++ b/tools/testing/selftests/bpf/test_sysctl.c
@@ -1560,7 +1560,7 @@ static int run_test_case(int cgfd, struct sysctl_test *test)
 			goto err;
 	}
 
-	if (bpf_prog_attach(progfd, cgfd, atype, BPF_F_ALLOW_OVERRIDE) == -1) {
+	if (bpf_prog_attach(progfd, cgfd, atype, BPF_F_ALLOW_OVERRIDE) < 0) {
 		if (test->result == ATTACH_REJECT)
 			goto out;
 		else
-- 
2.35.1

