Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6954835D3
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbiACRaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:30:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60250 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbiACRaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:30:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B416F6119F;
        Mon,  3 Jan 2022 17:30:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4720BC36AF1;
        Mon,  3 Jan 2022 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231009;
        bh=JnLfpKarmaeJnfgtZqGxuI+wJOGE1vIwrpQ8HcTQ8Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XGbYoeb2Mq8b7Q/7sbPz03ZXDzSL3KKeZaGAIm4HFR1Mt/h+GSB/BIWCxrle2wzAr
         et3G8qWa3nBAeOHirgXEOTZMr7RwcL7nvD4HIreU9awCOCjU1DFml5Rzz8Ct0dO/Rq
         J//c9XqFIjSXBldQdTyHPjb1ibeZbNU7cKd80DmNDo4o/lOymUOB8uEvlRN04l41RA
         ig8K+d9JTFRYIf7dBt7QT/mrrOnkVLby7doReUnIPbCQD2abfUI7ANDunVszwSrkes
         uAYp7jhe/WWV/5EhB7oAdWpWFwqMIGJicJ96Vkcivtdg/UgWRp1JQsScHcjhs64zRA
         4nWo8ssFfVvyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangxingwu <xingwu.yang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/8] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon,  3 Jan 2022 12:29:57 -0500
Message-Id: <20220103173001.1613277-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173001.1613277-1-sashal@kernel.org>
References: <20220103173001.1613277-1-sashal@kernel.org>
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
index 86ed2afbee302..ef2068a60d4ad 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3006,7 +3006,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
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

