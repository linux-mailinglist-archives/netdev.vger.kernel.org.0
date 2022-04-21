Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013D250A0BC
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350360AbiDUN0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377865AbiDUN02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8097C37019
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 06:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650547404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cbmH4M7d4GLcYeIEHq42CQGiQzmje9WO0ROuhEyNljM=;
        b=GUe6LtTagkIuhfCb5JXIgwk2dUU8wWh7Q9ezBtgrGHhcdhtKw4x/nmu6C1mMo+vLnap57c
        qm25NO9/8gd8xu2mTGpyW99traqcyPE76q9wJ3J7AEVo9fvJozyczpIyfBm1Sfa0VlKf2Z
        8i3x8nZDXe4/UAcKJGYVnEdSql3DM3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-4GoSzyGXNYWGSMbuc4VzIA-1; Thu, 21 Apr 2022 09:23:20 -0400
X-MC-Unique: 4GoSzyGXNYWGSMbuc4VzIA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C7F61014A68;
        Thu, 21 Apr 2022 13:23:20 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA385572344;
        Thu, 21 Apr 2022 13:23:19 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id C35B01C016C; Thu, 21 Apr 2022 15:23:18 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next] selftests/bpf: fix prog_tests/uprobe_autoattach compilation error
Date:   Thu, 21 Apr 2022 15:23:17 +0200
Message-Id: <20220421132317.1583867-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am getting the following compilation error for prog_tests/uprobe_autoattach.c

tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c: In function ‘test_uprobe_autoattach’:
./test_progs.h:209:26: error: pointer ‘mem’ may be used after ‘free’ [-Werror=use-after-free]

mem variable is now used in one of the asserts so it shouldn't be freed right
away. Move free(mem) after the assert block.

Fixes: 1717e248014c ("selftests/bpf: Uprobe tests should verify param/return values")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
index d6003dc8cc99..35b87c7ba5be 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
@@ -34,7 +34,6 @@ void test_uprobe_autoattach(void)
 
 	/* trigger & validate shared library u[ret]probes attached by name */
 	mem = malloc(malloc_sz);
-	free(mem);
 
 	ASSERT_EQ(skel->bss->uprobe_byname_parm1, trigger_val, "check_uprobe_byname_parm1");
 	ASSERT_EQ(skel->bss->uprobe_byname_ran, 1, "check_uprobe_byname_ran");
@@ -44,6 +43,8 @@ void test_uprobe_autoattach(void)
 	ASSERT_EQ(skel->bss->uprobe_byname2_ran, 3, "check_uprobe_byname2_ran");
 	ASSERT_EQ(skel->bss->uretprobe_byname2_rc, mem, "check_uretprobe_byname2_rc");
 	ASSERT_EQ(skel->bss->uretprobe_byname2_ran, 4, "check_uretprobe_byname2_ran");
+
+	free(mem);
 cleanup:
 	test_uprobe_autoattach__destroy(skel);
 }
-- 
2.35.1

