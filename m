Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69384835AE
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbiACR3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiACR3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:29:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E4C061761;
        Mon,  3 Jan 2022 09:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56507B80B4C;
        Mon,  3 Jan 2022 17:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9A7C36AF0;
        Mon,  3 Jan 2022 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641230960;
        bh=0FT26Cem4e3d3QKDR7k5iIQTmQdC4qIdU6Kx73jhFK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQ61MSk0AGLYvuRirH2YE/t9fOFxNNCW8ka6awOD5peAAc63c11rmgJ/pbLRuK6XR
         nwTynqFanbfj5hSKFAP+Hk2dt6zpaJ+CAaMboLIMqLeNV15PKZFOrksjo6Dib2q+cl
         jIcks7ljUskypAnI+nmjliCpYGe2ngQU6ktbyUYKy5OoWEluppztwBRwNul9CYAkln
         d1vpwrcgAxdG+PkjZltapveKL9DRx4ZLczGJF1P97Eol9uBiSZGQJhh28u8esTy1xK
         5FwIYAhVCotxmUIdLYpe03IxAqauujfW/2oeKSb9r81vvf5dFpNp0cwQ8AQ8nLbpVy
         cAzV5TIrpySJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangxingwu <xingwu.yang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/16] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon,  3 Jan 2022 12:28:40 -0500
Message-Id: <20220103172849.1612731-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103172849.1612731-1-sashal@kernel.org>
References: <20220103172849.1612731-1-sashal@kernel.org>
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
index be07e3d2b77bc..835b9d6e4e686 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3076,7 +3076,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
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

