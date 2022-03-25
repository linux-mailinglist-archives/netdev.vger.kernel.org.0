Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED094E7CF3
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiCYX2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiCYX2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:28:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301FD5BE48;
        Fri, 25 Mar 2022 16:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B515A61766;
        Fri, 25 Mar 2022 23:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC647C2BBE4;
        Fri, 25 Mar 2022 23:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648250833;
        bh=4ft5GjKOjv9kZGAeVQsrpTPr9lF5wIbiYZa/m8JLetc=;
        h=From:To:Cc:Subject:Date:From;
        b=h30HZwZ4d5GNDL7PX0e4TkktbrZgXpEfV/2+a6bmyG5Oijzept3Qgqh6imeqZOfZE
         P+5SPC3jbQgnY2pGWIQ5zCOBC3TmXHLEBxhH6GOzoUuL89GTS4MTK4/vD/BNr2va9o
         11QsOCLntExH2+0ePSp0iF6YOOfP7OkttcfGSGiyR8xWGKEgdxZXu84zWs66gaX4N2
         IoHUi0vWho7VQpQyxwca+cHlxNSapK7aFaTthzhs6xt9qOTB51jwNDDBpsOf8GrtGA
         BRgZzsn1he+z/RPXdg9erfFYOkV3hM7ZX1Z3Rs7/wO2zNJX5l5Tkx2fQ4UAwPapHk+
         8Bsc3ESmgI/DQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     pabeni@redhat.com, netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH net] selftests: tls: skip cmsg_to_pipe tests with TLS=n
Date:   Fri, 25 Mar 2022 16:27:09 -0700
Message-Id: <20220325232709.2358965-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are negative tests, testing TLS code rejects certain
operations. They won't pass without TLS enabled, pure TCP
accepts those operations.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Fixes: d87d67fd61ef ("selftests: tls: test splicing cmsgs")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 6e468e0f42f7..5d70b04c482c 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -683,6 +683,9 @@ TEST_F(tls, splice_cmsg_to_pipe)
 	char buf[10];
 	int p[2];
 
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), -1);
@@ -703,6 +706,9 @@ TEST_F(tls, splice_dec_cmsg_to_pipe)
 	char buf[10];
 	int p[2];
 
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
 	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
-- 
2.34.1

