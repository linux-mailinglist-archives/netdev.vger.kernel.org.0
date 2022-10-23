Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9513609472
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 17:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJWPhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 11:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbiJWPhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 11:37:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C764A773BE
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666539450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eptQAIgt+rtRNa4cgmHEpSMk9rF/5xnBW0YpjfCrXP4=;
        b=Tlm8ZpxKczOBd4IT/+fH8WdpPtvYLG/W0L92kjUCpnS8o0YHDfmS348z7ubT9bvWxTt+0t
        9ZRx0E4OL33fnQ842s9vsO4WJoB3GaxN5w+79flXipDxNUS/dCBrlKxZosmp8tBOStT5Cz
        1wwLQo0Tsv1Oeraary/bCB7jU+TAnDg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-0l8JeLocPYSycl-L1xZZgA-1; Sun, 23 Oct 2022 11:37:29 -0400
X-MC-Unique: 0l8JeLocPYSycl-L1xZZgA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A73D93C025B0;
        Sun, 23 Oct 2022 15:37:28 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A5E71121315;
        Sun, 23 Oct 2022 15:37:26 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, liuhangbin@gmail.com
Subject: [PATCH iproute2] testsuite: fix build failure
Date:   Sun, 23 Oct 2022 17:37:11 +0200
Message-Id: <ae381380067a2db4079bd8880093d8fdb5d9f446.1666539148.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 6c09257f1bf6 ("rtnetlink: add new function
rtnl_echo_talk()") "make check" results in:

$ make check

make -C testsuite
make -C iproute2 configure
make -C testsuite alltests
make -C tools
    CC       generate_nlmsg
/usr/bin/ld: /tmp/cc6YaGBM.o: in function `rtnl_echo_talk':
libnetlink.c:(.text+0x25bd): undefined reference to `new_json_obj'
/usr/bin/ld: libnetlink.c:(.text+0x25c7): undefined reference to `open_json_object'
/usr/bin/ld: libnetlink.c:(.text+0x25e3): undefined reference to `close_json_object'
/usr/bin/ld: libnetlink.c:(.text+0x25e8): undefined reference to `delete_json_obj'
collect2: error: ld returned 1 exit status
make[2]: *** [Makefile:6: generate_nlmsg] Error 1
make[1]: *** [Makefile:40: generate_nlmsg] Error 2
make: *** [Makefile:130: check] Error 2

This is due to json function calls included in libutil and not in
libnetlink. Fix this adding libutil.a to the tools Makefile, and linking
against libcap as required by libutil itself.

Fixes: 6c09257f1bf6 ("rtnetlink: add new function rtnl_echo_talk()")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 testsuite/tools/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/testsuite/tools/Makefile b/testsuite/tools/Makefile
index e3e771d7..e0162ccc 100644
--- a/testsuite/tools/Makefile
+++ b/testsuite/tools/Makefile
@@ -2,8 +2,8 @@
 CFLAGS=
 include ../../config.mk
 
-generate_nlmsg: generate_nlmsg.c ../../lib/libnetlink.c
-	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRA_CFLAGS) -I../../include -I../../include/uapi -include../../include/uapi/linux/netlink.h -o $@ $^ -lmnl
+generate_nlmsg: generate_nlmsg.c ../../lib/libnetlink.a ../../lib/libutil.a
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRA_CFLAGS) -I../../include -I../../include/uapi -include../../include/uapi/linux/netlink.h -o $@ $^ -lmnl -lcap
 
 clean:
 	rm -f generate_nlmsg
-- 
2.37.3

