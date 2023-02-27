Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FD36A4950
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjB0SMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjB0SMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:12:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C01233ED
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 10:12:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A314D60EF6
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 18:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B9DC433D2;
        Mon, 27 Feb 2023 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677521531;
        bh=e7/R7zLPLlFQ8xrBmBlCzms+6RLkNDDgg70ydQpuKdM=;
        h=From:To:Cc:Subject:Date:From;
        b=hk7uWEN2RTMYQJM+bQhb/GLUh/H5x7KdujP1RK/eDzRbhQh3sl04rcIPE9tTQhSe+
         +NiqksB4wk2cYJh+an+ftkvm5CPcufuFKYGL4Qhga5+9vKSQHWlHjF74T7+Ovn17CH
         pwuOavINyxRFha2H7alqCfiZ+IlU4S2RJUnNqRbJmoUvbom07LVI0YMgnDXAY5CGU0
         ytvrlb2O9xx409yw5MFtVd5JvFKNrFFSHBPFULw4nVfcIDVOpTdsG/8GSJLrr/oLrQ
         slU1AiVpDBaWz6kuA7SNdHhZAkGgtLpowdBja6uX/uZNCyf4IS7B8kyKWrGENsPnqu
         dw75rdgul+1qQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        gaurav.jain@nxp.com, Jakub Kicinski <kuba@kernel.org>,
        borisp@nvidia.com, john.fastabend@gmail.com
Subject: [PATCH net] tls: rx: fix return value for async crypto
Date:   Mon, 27 Feb 2023 10:12:01 -0800
Message-Id: <20230227181201.1793772-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gaurav reports that TLS Rx is broken with async crypto
accelerators. The commit under fixes missed updating
the retval byte counting logic when updating how records
are stored. Even tho both before and after the change
'decrypted' was updated inside the main loop, it was
completely overwritten when processing the async
completions. Now that the rx_list only holds
non-zero-copy records we need to add, not overwrite.

Reported-and-bisected-by: Gaurav Jain <gaurav.jain@nxp.com>
Fixes: cbbdee9918a2 ("tls: rx: async: don't put async zc on the list")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217064
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 782d3701b86f..021d760f9133 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2127,7 +2127,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted = max(err, 0);
+		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.39.2

