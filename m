Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE5635E9F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiKWMvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbiKWMv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:51:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CA46B39D;
        Wed, 23 Nov 2022 04:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B6261C5E;
        Wed, 23 Nov 2022 12:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBD0C43147;
        Wed, 23 Nov 2022 12:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207455;
        bh=VsE/HWjQxRSXID5Fj3p9heuzQWh+w9K33zN3bgvPy6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWjR5aUuecZQTd0PK0udhhGgETWEjlmdH2wsn03Zrl92k7uwzVxjk/jMKpFBVNlWd
         AEtoN0uvvLgqAcfurmvMC8X//g6vdbqMSWsHbNpN8TshlqCWw/dE9seEbCcVGgOW5k
         9kfSUrv7CK6frAC43B/L0EvAClkx6nznT01NDnsI2eHdk/a4MEiFZKMQFoXXOLA0Iq
         TXKLc2hVIZkGO771BGRCZYg38m+OOq8IyWxr6Cdr1t5NUg+Y1hR0vrCyqBjtjVwBUc
         oSToONcGylwBtcE7V8T3+1Pax/f/1Yr/UbZsfT70BuYfrlhhk9tdigbPAOay514PCK
         fNhgrDWCD91Ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gleb Mazovetskiy <glex.spb@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/22] tcp: configurable source port perturb table size
Date:   Wed, 23 Nov 2022 07:43:30 -0500
Message-Id: <20221123124339.265912-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124339.265912-1-sashal@kernel.org>
References: <20221123124339.265912-1-sashal@kernel.org>
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

From: Gleb Mazovetskiy <glex.spb@gmail.com>

[ Upstream commit aeac4ec8f46d610a10adbaeff5e2edf6a88ffc62 ]

On embedded systems with little memory and no relevant
security concerns, it is beneficial to reduce the size
of the table.

Reducing the size from 2^16 to 2^8 saves 255 KiB
of kernel RAM.

Makes the table size configurable as an expert option.

The size was previously increased from 2^8 to 2^16
in commit 4c2c8f03a5ab ("tcp: increase source port perturb table to
2^16").

Signed-off-by: Gleb Mazovetskiy <glex.spb@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/Kconfig           | 10 ++++++++++
 net/ipv4/inet_hashtables.c | 10 +++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 87983e70f03f..23b06063e1a5 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -403,6 +403,16 @@ config INET_IPCOMP
 
 	  If unsure, say Y.
 
+config INET_TABLE_PERTURB_ORDER
+	int "INET: Source port perturbation table size (as power of 2)" if EXPERT
+	default 16
+	help
+	  Source port perturbation table size (as power of 2) for
+	  RFC 6056 3.3.4.  Algorithm 4: Double-Hash Port Selection Algorithm.
+
+	  The default is almost always what you want.
+	  Only change this if you know what you are doing.
+
 config INET_XFRM_TUNNEL
 	tristate
 	select INET_TUNNEL
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c0de655fffd7..c68a1dae25ca 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -721,13 +721,13 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
+ *
  * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
- * attacks were since demonstrated, thus we use 65536 instead to really
- * give more isolation and privacy, at the expense of 256kB of kernel
- * memory.
+ * attacks were since demonstrated, thus we use 65536 by default instead
+ * to really give more isolation and privacy, at the expense of 256kB
+ * of kernel memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 16
-#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+#define INET_TABLE_PERTURB_SIZE (1 << CONFIG_INET_TABLE_PERTURB_ORDER)
 static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-- 
2.35.1

