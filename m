Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6D74835EE
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbiACRbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiACRac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA46C061397;
        Mon,  3 Jan 2022 09:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D6AE611A3;
        Mon,  3 Jan 2022 17:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2609C36AEF;
        Mon,  3 Jan 2022 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231025;
        bh=ODd+ifXtdV+GQOH+5z2G3OxUzcUuORCnGgD5ZCmaYb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfGcXyBIe/W5JhMf8v6ZqZYNfVcyS3i6baIrN84F5UIAG9h2iIluwfrNZ1DsAm8ML
         c4rr7oymDJQ4HuPX347dqKwIrMBLmaSgDbuyVLrpU7EU/OBTzTdmykV8hsJP+XPj/V
         lC1fAl1+PY/l4ACJSXfnRPST9r6zaOWavx9/eB9Zid9bAqiLUgWI9EBjpPvqQMccmy
         pNXMxuGngdsRbBcmEFC2D155C4MmxzFQNpRsgcEeY/QYdYztp/KDccPax/riwhEDhe
         1WSCDPTjdxZWuunuJ3yiZqytifwHyuoucaO6grPaLYzO+DleffangfhePA3bkgg9xW
         k57Goe/HzS25g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangxingwu <xingwu.yang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/6] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon,  3 Jan 2022 12:30:16 -0500
Message-Id: <20220103173018.1613394-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173018.1613394-1-sashal@kernel.org>
References: <20220103173018.1613394-1-sashal@kernel.org>
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
index a0016f05c4f86..3cdf011a8dd8d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2943,7 +2943,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
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

