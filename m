Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3878483627
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbiACRcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235965AbiACRbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:31:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30479C0698C8;
        Mon,  3 Jan 2022 09:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1317C61194;
        Mon,  3 Jan 2022 17:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A4BC36AEF;
        Mon,  3 Jan 2022 17:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231063;
        bh=bgVpJrrY7RWgXM+ZQVkHINVlds67un5ThG9L/+XlI6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1Gtk3l28RRG+katH79JAcF6zyNNhAbx743O4Vh2EjmNKeJOBAoeLyiHWvKgtjH3N
         8OZ16U8lrazIVPtGw5ya/yZxy33aiOft7/AkbvpqOGBjFNpWBXmA12GM7K//r8FSW/
         3p/z0OD7y42+mc5eQt8shQgiQvDgp6v9DHTS5mE5pny89XW6mSwpFZ3Kw2PiklZlIs
         FHSw4PpWMVDNwEzv1d4Q7oWPzRc5BoLmrMntPVavw3gEf/F8ozanrSx3NDHFQuAEFZ
         EDZXsxgqPFfuY6xki9mlZgvf6Ozo8RsaIrgBthh88u27hG0bn3pbKSOUMKqV1AG/b2
         11SR3kk+IR9JQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangxingwu <xingwu.yang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 3/4] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon,  3 Jan 2022 12:30:45 -0500
Message-Id: <20220103173047.1613630-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173047.1613630-1-sashal@kernel.org>
References: <20220103173047.1613630-1-sashal@kernel.org>
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
index 860ab2e6544cc..8770966a564b5 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2435,7 +2435,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
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

