Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6024D0E31
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 04:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiCHDEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 22:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCHDEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 22:04:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2DB3D1C3
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 19:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D1746150F
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 03:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD34C340E9;
        Tue,  8 Mar 2022 03:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646708630;
        bh=+Wg+GQ0YZXU6bAedvnfGwOsFxIfaG1caXtnjgIuSXjM=;
        h=From:To:Cc:Subject:Date:From;
        b=VYblVSTTUmJJ9u2Zr59ZOphKrLZNRpzZLFlUjDCstV0TZ+n1W+cYnfl6NDBuAyHh7
         0Zs8VaRVTncic7+axb51PkrDfAnUItFTN91+qTIeMUNA1wuK7QM8xHKKBV8eTT+Wtn
         BKieK4xsUQmpo2su70UI94eqBe30PXOI6QCl/KbAyJ2WLCRbCeVhrFJmqQdbSaN4f8
         FrdDdzUvRt5ul9TSC5PZIV8lFSObaHx5mJ+l+J8fghYqAIaEjS5NtGqxwbyr0koUa8
         3esNByfPTlVApSeNeJGr7/zfecHYLg6dT8j2SiHHBRdr81BGE2GNUdr/KOw9zxI68/
         x3dJ5brr6WhcA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, willemb@google.com, ncardwell@google.com,
        ycheng@google.com, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next] tcp: allow larger TSO to be built under overload
Date:   Mon,  7 Mar 2022 19:03:48 -0800
Message-Id: <20220308030348.258934-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We observed Tx-heavy workloads causing softirq overload because
with increased load and therefore latency the pacing rates fall,
pushing TCP to generate smaller and smaller TSO packets.

It seems reasonable to allow larger packets to be built when
system is under stress. TCP already uses the

  this_cpu_ksoftirqd() == current

condition as an indication of overload for TSQ scheduling.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Sending as an RFC because it seems reasonable, but really
I haven't run any large scale testing, yet. Bumping
tcp_min_tso_segs to prevent overloads is okay but it
seems like we can do better since we only need coarser
pacing once disaster strikes?

The downsides are that users may have already increased
the value to what's needed during overload, or applied
the same logic in out-of-tree CA algo implementations
(only BBR implements ca_ops->min_tso_segs() upstream).
---
 net/ipv4/tcp_output.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2319531267c6..815ef4ffc39d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1967,7 +1967,13 @@ static u32 tcp_tso_autosize(const struct sock *sk, unsigned int mss_now,
 	 * This preserves ACK clocking and is consistent
 	 * with tcp_tso_should_defer() heuristic.
 	 */
-	segs = max_t(u32, bytes / mss_now, min_tso_segs);
+	segs = bytes / mss_now;
+	if (segs < min_tso_segs) {
+		segs = min_tso_segs;
+		/* Allow larger packets under stress */
+		if (this_cpu_ksoftirqd() == current)
+			segs *= 2;
+	}
 
 	return segs;
 }
-- 
2.34.1

