Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D55630945
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiKSCMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiKSCMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:12:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70D96A6A7;
        Fri, 18 Nov 2022 18:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B17162835;
        Sat, 19 Nov 2022 02:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89221C43470;
        Sat, 19 Nov 2022 02:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823906;
        bh=X9pQl7qPJKt05DQwZOx/8QIpcMaJKUUJ9Xb+hErQcoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hj7LLNpcKJ8an7aEVDJciMQGbX3G9DWGeHiXmWlI0DXhXrx0Zq8BgZnMzWZMrNL/E
         c0/P9E4m24l3gvB5Fmu0UL3+2tyJRLpcWJbBPLwotRcVHI7DjzrUWZkVOYkibuL0vn
         0hqkrjoVNsBb4W2xCr/lr7huvzszcdOmM+TDJIHGzVyRz4IEYu9JW2BKeXz/h7wfYG
         LNOsQ3xtN+3BqCX3nwF21ghRypMWbFOxdQnhherXcGeBvb07JUskf4r7ZqRnKQFaK4
         sAGYy0Ihq8kwBljpXLESbNRE+Vt0G4tsAYtAhFvV8Mtd1nfaai/YyyBgfzgHxcpPXd
         bTR+XJYOcIR9Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 09/44] selftests/net: don't tests batched TCP io_uring zc
Date:   Fri, 18 Nov 2022 21:10:49 -0500
Message-Id: <20221119021124.1773699-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 9921d5013a6e51892623bf2f1c5b49eaecda55ac ]

It doesn't make sense batch submitting io_uring requests to a single TCP
socket without linking or some other kind of ordering. Moreover, it
causes spurious -EINTR fails due to interaction with task_work. Disable
it for now and keep queue depth=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b547698d5938b1b1a898af1c260188d8546ded9a.1666700897.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/io_uring_zerocopy_tx.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
index 32aa6e9dacc2..9ac4456d48fc 100755
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -29,7 +29,7 @@ if [[ "$#" -eq "0" ]]; then
 	for IP in "${IPs[@]}"; do
 		for mode in $(seq 1 3); do
 			$0 "$IP" udp -m "$mode" -t 1 -n 32
-			$0 "$IP" tcp -m "$mode" -t 1 -n 32
+			$0 "$IP" tcp -m "$mode" -t 1 -n 1
 		done
 	done
 
-- 
2.35.1

