Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B5448361F
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiACRc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:32:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39572 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235867AbiACRbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:31:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 259C7B80E66;
        Mon,  3 Jan 2022 17:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E841EC36AEB;
        Mon,  3 Jan 2022 17:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641231081;
        bh=Jv+hN6Da6R9c2+cZQAepLYk2eyK4acPdpAFEYUqSosI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCyN4lGTQ5nVKTDaAJMf/sA3WfK7rNf8Lgn186RnDPCQMC4zZRToYrbu1b05NfqFF
         K8sJGa1dmOgc8kaHl6gvNPnkZ/dQPtEak6o1rZiBAz2NopYk5TM92eoQEscRTp55M1
         GTL0i1KPTBbFoWgMD2scltq7QEJcPc9CTJGxRzsDI/Y5IVsqEyrD5jL6d1R/nRzt1O
         8tEwonSZ0ASnJhCQN+yrWppxhKmGAk1cdC347z6dVikZXsXNKQIMdM3VaV1rCXpoPJ
         ysxuRyi12rmYeJZ6uKYuFwbpGQA+j1arWT9SySuedMXKpbWOB/a1IB0IVGZGDK03Dj
         IqXKNcdxDG6/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangxingwu <xingwu.yang@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/4] net: udp: fix alignment problem in udp4_seq_show()
Date:   Mon,  3 Jan 2022 12:31:04 -0500
Message-Id: <20220103173105.1613707-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103173105.1613707-1-sashal@kernel.org>
References: <20220103173105.1613707-1-sashal@kernel.org>
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
index 0d9f9d6251245..aba49b23e65f2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2463,7 +2463,7 @@ int udp4_seq_show(struct seq_file *seq, void *v)
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

