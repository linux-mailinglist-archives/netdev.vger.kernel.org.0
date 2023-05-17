Return-Path: <netdev+bounces-3324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E407066EA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95AB01C20DE9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BDA2C739;
	Wed, 17 May 2023 11:39:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4F1211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:39:32 +0000 (UTC)
X-Greylist: delayed 1148 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 May 2023 04:39:29 PDT
Received: from ida.iewc.co.za (ida.iewc.co.za [154.73.34.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A037F35AB
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:39:29 -0700 (PDT)
Received: from [165.16.201.30] (helo=plastiekpoot)
	by ida.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <jaco@uls.co.za>)
	id 1pzFCW-0002le-TV; Wed, 17 May 2023 13:20:13 +0200
Received: from jkroon by plastiekpoot with local (Exim 4.94.2)
	(envelope-from <jaco@uls.co.za>)
	id 1pzFCV-0005Ly-U7; Wed, 17 May 2023 13:20:11 +0200
From: Jaco Kroon <jaco@uls.co.za>
Date: Wed, 17 May 2023 10:00:03 +0200
Subject: [PATCH] net/pppoe: make number of hash bits configurable
To: netdev@vger.kernel.org
Message-Id: <E1pzFCV-0005Ly-U7@plastiekpoot>
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

When running large numbers of pppoe connections, a bucket size of 16 may
be too small and 256 may be more appropriate.  This sacrifices some RAM
but should result in faster processing of incoming PPPoE frames.

On our systems we run upwards of 150 PPPoE connections at any point in
time, and we suspect we're starting to see the effects of this small
number of buckets.

The legal values according to pppoe.c is anything that when 8 is divided
by that results in a modulo of 0, ie, 1, 2, 4 and 8.

The size of the per-underlying-interface structure is:

sizeof(rwlock_t) + sizeof(pppox_sock*) * PPPOE_HASH_SIZE.

Assuming a 64-bit pointer this will result in just over a 2KiB structure
for PPPOE_HASH_BITS=8, which will likely result in a 4KiB allocation,
which for us at least is acceptable.

Not sure what the minimum allocation size is, and thus if values of 1
and 2 truly make sense.  Default results in historic sizing and
behaviour.

Signed-off-by: Jaco Kroon <jaco@uls.co.za>
---
 drivers/net/ppp/Kconfig | 34 ++++++++++++++++++++++++++++++++++
 drivers/net/ppp/pppoe.c |  2 +-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/Kconfig b/drivers/net/ppp/Kconfig
index ac4d162d9455..2fbcae31fc02 100644
--- a/drivers/net/ppp/Kconfig
+++ b/drivers/net/ppp/Kconfig
@@ -129,6 +129,40 @@ config PPPOE
 	  which contains instruction on how to use this driver (under
 	  the heading "Kernel mode PPPoE").
 
+choice
+	prompt "Number of PPPoE hash bits"
+	default PPPOE_HASH_BITS_4
+	depends on PPPOE
+	help
+		Select the number of bits used for hashing PPPoE interfaces.
+
+		Larger sizes reduces the risk of hash collisions at the cost
+		of slightly increased memory usage.
+
+		This hash table is on a per outer ethernet interface.
+
+config PPPOE_HASH_BITS_2
+	bool "1 bit (2 buckets)"
+
+config PPPOE_HASH_BITS_2
+	bool "2 bits (4 buckets)"
+
+config PPPOE_HASH_BITS_4
+	bool "4 bits (16 buckets)"
+
+config PPPOE_HASH_BITS_8
+	bool "8 bits (256 buckets)"
+
+endchoice
+
+config PPPOE_HASH_BITS
+	int
+	default 1 if PPPOE_HASH_BITS_1
+	default 2 if PPPOE_HASH_BITS_2
+	default 4 if PPPOE_HASH_BITS_4
+	default 8 if PPPOE_HASH_BITS_8
+	default 4
+
 config PPTP
 	tristate "PPP over IPv4 (PPTP)"
 	depends on PPP && NET_IPGRE_DEMUX
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index ce2cbb5903d7..3b79c603b936 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -80,7 +80,7 @@
 
 #include <linux/uaccess.h>
 
-#define PPPOE_HASH_BITS 4
+#define PPPOE_HASH_BITS CONFIG_PPPOE_HASH_BITS
 #define PPPOE_HASH_SIZE (1 << PPPOE_HASH_BITS)
 #define PPPOE_HASH_MASK	(PPPOE_HASH_SIZE - 1)
 
-- 
2.39.3


