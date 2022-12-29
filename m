Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3765898F
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 06:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbiL2Fli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 00:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiL2Flh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 00:41:37 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7D310B72;
        Wed, 28 Dec 2022 21:41:36 -0800 (PST)
Received: from localhost.localdomain (1.general.phlin.uk.vpn [10.172.194.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id BFC2043519;
        Thu, 29 Dec 2022 05:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1672292494;
        bh=K8ugYDZRkBzYLfNsSqHX8RJMnPEEi0o0mHYPYxH+SLI=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=XqOBpPvoVd0ncnFiqoSkWtdU86ck2Ge69FXp082fJRaJKMDTXKxobVdLMN/wYwMu5
         MrAGtz6/Kj/kuGz7flskJMeeqcaF7rI5B+18E9d/VfBi7cAUfAwWcbo9yU4355snis
         DQtQM1qnAeyeUDsa+hxhan+S8lk81wA0dzbZTj3jQv2TPT9SxroeeLWzWnt5FFLO6D
         F/42SMmS+dP+3GI9/o+nSGUjKsdsbthETzAafrN5xmaFz2Ys4NGUgenwzCJqydWNfm
         /cvnGgZpe9ZMZOexPv1egNvFpr7Pnm5IHDNx2VfDOZ91bH2YLn7IAfo7sSBVZFykzO
         WJ+rTZHFbYGFw==
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, naresh.kamboju@linaro.org,
        po-hsu.lin@canonical.com
Subject: [PATCH] selftests: net: fix cmsg_so_mark.sh test hang
Date:   Thu, 29 Dec 2022 13:41:06 +0800
Message-Id: <20221229054106.96682-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This cmsg_so_mark.sh test will hang on non-amd64 systems because of the
infinity loop for argument parsing in cmsg_sender.

Variable "o" in cs_parse_args() for taking getopt() should be an int,
otherwise it will be 255 when getopt() returns -1 on non-amd64 system
and thus causing infinity loop.

Link: https://lore.kernel.org/lkml/CA+G9fYsM2k7mrF7W4V_TrZ-qDauWM394=8yEJ=-t1oUg8_40YA@mail.gmail.com/t/
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 tools/testing/selftests/net/cmsg_sender.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/cmsg_sender.c b/tools/testing/selftests/net/cmsg_sender.c
index 75dd83e..24b21b1 100644
--- a/tools/testing/selftests/net/cmsg_sender.c
+++ b/tools/testing/selftests/net/cmsg_sender.c
@@ -110,7 +110,7 @@ static void __attribute__((noreturn)) cs_usage(const char *bin)
 
 static void cs_parse_args(int argc, char *argv[])
 {
-	char o;
+	int o;
 
 	while ((o = getopt(argc, argv, "46sS:p:m:M:d:tf:F:c:C:l:L:H:")) != -1) {
 		switch (o) {
-- 
2.7.4

