Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63484635D74
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 13:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237755AbiKWMpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 07:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237667AbiKWMoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 07:44:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AF66B3AC;
        Wed, 23 Nov 2022 04:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD5E861C41;
        Wed, 23 Nov 2022 12:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF08C433D7;
        Wed, 23 Nov 2022 12:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207338;
        bh=BinOJNivN5SwYSDGbsBMM1OMdyiz7O09D9xZ1yr0N9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QE+irGG7QGIGFyRTXOzvTaPyDVsYNeuDPfMflKZkBO81DQ2wjcCWXpfOpYg2G0OUh
         AKHQExa0kEqGb7WSwZvcVg7aPVS3MoZcV+mTjF/rSO+KBUgeCDw+3IptKiCgBF1naz
         Wmey5QeTIGSJiiQLIkZvx7ljJU0IGsqS/R1Hvry9K3dUNK2jiAHYdfiFkB1pLo99pE
         JTeGdRNGSSrcFTSmG/uvhTmuqBBnpEdqBkxCJgAJ9P08Paui4+e55OZYsEeIc3TnZg
         CBt0Ys02+ZBmJUdULTyClMYqjQmosgxfQ9vPLuWoysZsuSOEyMPz3TxbzFLYjIrnNZ
         sNXiCPkP/F+6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gleb Mazovetskiy <glex.spb@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 34/44] tcp: configurable source port perturb table size
Date:   Wed, 23 Nov 2022 07:40:43 -0500
Message-Id: <20221123124057.264822-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
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
index e983bb0c5012..2dfb12230f08 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -402,6 +402,16 @@ config INET_IPCOMP
 
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
index f5950a7172d6..1e45fe6276f7 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -679,13 +679,13 @@ EXPORT_SYMBOL_GPL(inet_unhash);
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

