Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63FD48360C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiACRbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:31:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38888 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiACRar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D87CB8107D;
        Mon,  3 Jan 2022 17:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13696C36AEF;
        Mon,  3 Jan 2022 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231045;
        bh=Y0CvrALrxPzMoSA3rAD+UGw88j6y6CGKYX7vtSYvKFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4+PKOmRZkSKJG1cPnACygEd3yn5PTm0fyNr9G+TJIrGI/dm72s36o9WFiQvXxWDa
         wkDx3pjG6wLk+kvs9WHzV14KaR17xJP2dtGJS4yGTQrNzJA6AWt0v5kmql7+6jtKcg
         ynYreBFXO8dJhkhGlZZT+jkHjMt/YPuaMa2w7knSlZXxeBssikAyZMGGKUTEzStG/E
         9koch8FUpSgelkXeaWqPHCjzqhnCSRTsP+Nz8JfNFiaOJHpYeG+Zx5oRfWvSW5Gsu4
         5+IK2RKCS/xCItnfECPpmic/PK0o6P8jw8c49MxqAi0Z1gh1GoQ+E+f/mJ1RhQXNCc
         /ZpFfMMiwwNlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangxingwu <xingwu.yang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/4] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon,  3 Jan 2022 12:30:38 -0500
Message-Id: <20220103173039.1613564-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173039.1613564-1-sashal@kernel.org>
References: <20220103173039.1613564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yangxingwu <xingwu.yang@gmail.com>

[ Upstream commit 6c25449e1a32c594d743df8e8258e8ef870b6a77 ]

$ cat /pro/net/udp

before:

  sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

after:

   sl  local_address rem_address   st tx_queue rx_queue tr tm->when
26050: 0100007F:0035 00000000:0000 07 00000000:00000000 00:00000000
26320: 0100007F:0143 00000000:0000 07 00000000:00000000 00:00000000
27135: 00000000:8472 00000000:0000 07 00000000:00000000 00:00000000

Signed-off-by: yangxingwu <xingwu.yang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4faeb698c33c9..fee1cdcc224e6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2777,7 +2777,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
 {
 	seq_setwidth(seq, 127);
 	if (v == SEQ_START_TOKEN)
-		seq_puts(seq, "  sl  local_address rem_address   st tx_queue "
+		seq_puts(seq, "   sl  local_address rem_address   st tx_queue "
 			   "rx_queue tr tm->when retrnsmt   uid  timeout "
 			   "inode ref pointer drops");
 	else {
-- 
2.34.1

