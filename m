Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C886335EBE5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 06:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhDNEdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 00:33:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229450AbhDNEd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 00:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618374787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K2vkXpJZHgj/JTUPOc0jXKmP+vtPwy7VdCirNmhf2mk=;
        b=EiOzUqwrLf8vDPDjkeJBIDR5OZGFLZ33IBWh/4c5GqjlgGj/gfdmBdcX+3Ta2Z6XD91ozc
        5vckvuMlQwslHGLCsTPjcFXjGiDQ+SRqzJhw0kPnZNkO2O92MySZ04c/hcVgvcpCX4PgO3
        ZJHu/gVsMXhhrEHGZqzP96+tVMnAZeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-8c5gkQ6vOl67ZYVo7IGDkA-1; Wed, 14 Apr 2021 00:33:06 -0400
X-MC-Unique: 8c5gkQ6vOl67ZYVo7IGDkA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B47D81006C80;
        Wed, 14 Apr 2021 04:33:04 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-67.rdu2.redhat.com [10.10.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E47710016F4;
        Wed, 14 Apr 2021 04:33:03 +0000 (UTC)
From:   Nico Pache <npache@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     brendanhiggins@google.com, gregkh@linuxfoundation.org,
        linux-ext4@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, npache@redhat.com,
        linux-m68k@lists.linux-m68k.org, geert@linux-m68k.org
Subject: [PATCH 1/2] kunit: Fix formatting of KUNIT tests to meet the standard
Date:   Wed, 14 Apr 2021 00:33:02 -0400
Message-Id: <20210414043303.1072552-1-npache@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are few instances of KUNIT tests that are not properly defined.
This commit focuses on correcting these issues to match the standard
defined in the Documentation.

    Issues Fixed:
 - Tests should default to KUNIT_ALL_TESTS
 - Tests configs tristate should have `if !KUNIT_ALL_TESTS`
 - Tests should end in KUNIT_TEST, some fixes have been applied to
    correct issues were KUNIT_TESTS is used or KUNIT is not mentioned.

No functional changes other than CONFIG name changes
Signed-off-by: Nico Pache <npache@redhat.com>
---
 drivers/base/test/Kconfig  |  2 +-
 drivers/base/test/Makefile |  2 +-
 fs/ext4/.kunitconfig       |  2 +-
 fs/ext4/Kconfig            |  2 +-
 fs/ext4/Makefile           |  2 +-
 lib/Kconfig.debug          | 21 +++++++++++++--------
 lib/Makefile               |  6 +++---
 net/mptcp/Kconfig          |  2 +-
 net/mptcp/Makefile         |  2 +-
 net/mptcp/crypto.c         |  2 +-
 net/mptcp/token.c          |  2 +-
 sound/soc/Kconfig          |  2 +-
 sound/soc/Makefile         |  4 ++--
 13 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/base/test/Kconfig b/drivers/base/test/Kconfig
index ba225eb1b761..2f3fa31a948e 100644
--- a/drivers/base/test/Kconfig
+++ b/drivers/base/test/Kconfig
@@ -8,7 +8,7 @@ config TEST_ASYNC_DRIVER_PROBE
 	  The module name will be test_async_driver_probe.ko
 
 	  If unsure say N.
-config KUNIT_DRIVER_PE_TEST
+config DRIVER_PE_KUNIT_TEST
 	bool "KUnit Tests for property entry API" if !KUNIT_ALL_TESTS
 	depends on KUNIT=y
 	default KUNIT_ALL_TESTS
diff --git a/drivers/base/test/Makefile b/drivers/base/test/Makefile
index 2f15fae8625f..64b2f3d744d5 100644
--- a/drivers/base/test/Makefile
+++ b/drivers/base/test/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_TEST_ASYNC_DRIVER_PROBE)	+= test_async_driver_probe.o
 
-obj-$(CONFIG_KUNIT_DRIVER_PE_TEST) += property-entry-test.o
+obj-$(CONFIG_DRIVER_PE_KUNIT_TEST) += property-entry-test.o
 CFLAGS_REMOVE_property-entry-test.o += -fplugin-arg-structleak_plugin-byref -fplugin-arg-structleak_plugin-byref-all
diff --git a/fs/ext4/.kunitconfig b/fs/ext4/.kunitconfig
index bf51da7cd9fc..81d4da667740 100644
--- a/fs/ext4/.kunitconfig
+++ b/fs/ext4/.kunitconfig
@@ -1,3 +1,3 @@
 CONFIG_KUNIT=y
 CONFIG_EXT4_FS=y
-CONFIG_EXT4_KUNIT_TESTS=y
+CONFIG_EXT4_KUNIT_TEST=y
diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 86699c8cab28..1569d3872136 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -101,7 +101,7 @@ config EXT4_DEBUG
 	  If you select Y here, then you will be able to turn on debugging
 	  using dynamic debug control for mb_debug() / ext_debug() msgs.
 
-config EXT4_KUNIT_TESTS
+config EXT4_KUNIT_TEST
 	tristate "KUnit tests for ext4" if !KUNIT_ALL_TESTS
 	depends on EXT4_FS && KUNIT
 	default KUNIT_ALL_TESTS
diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 49e7af6cc93f..4e28e380d51b 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -15,5 +15,5 @@ ext4-y	:= balloc.o bitmap.o block_validity.o dir.o ext4_jbd2.o extents.o \
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-inode-test-objs			+= inode-test.o
-obj-$(CONFIG_EXT4_KUNIT_TESTS)		+= ext4-inode-test.o
+obj-$(CONFIG_EXT4_KUNIT_TEST)		+= ext4-inode-test.o
 ext4-$(CONFIG_FS_VERITY)		+= verity.o
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 417c3d3e521b..7ade91511da6 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2279,9 +2279,10 @@ config TEST_SYSCTL
 
 	  If unsure, say N.
 
-config BITFIELD_KUNIT
-	tristate "KUnit test bitfield functions at runtime"
+config BITFIELD_KUNIT_TEST_TEST
+	tristate "KUnit test bitfield functions at runtime" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  Enable this option to test the bitfield functions at boot.
 
@@ -2296,8 +2297,9 @@ config BITFIELD_KUNIT
 	  If unsure, say N.
 
 config RESOURCE_KUNIT_TEST
-	tristate "KUnit test for resource API"
+	tristate "KUnit test for resource API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This builds the resource API unit test.
 	  Tests the logic of API provided by resource.c and ioport.h.
@@ -2337,9 +2339,10 @@ config LIST_KUNIT_TEST
 
 	  If unsure, say N.
 
-config LINEAR_RANGES_TEST
-	tristate "KUnit test for linear_ranges"
+config LINEAR_RANGES_KUNIT_TEST
+	tristate "KUnit test for linear_ranges" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	select LINEAR_RANGES
 	help
 	  This builds the linear_ranges unit test, which runs on boot.
@@ -2350,8 +2353,9 @@ config LINEAR_RANGES_TEST
 	  If unsure, say N.
 
 config CMDLINE_KUNIT_TEST
-	tristate "KUnit test for cmdline API"
+	tristate "KUnit test for cmdline API" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This builds the cmdline API unit test.
 	  Tests the logic of API provided by cmdline.c.
@@ -2360,9 +2364,10 @@ config CMDLINE_KUNIT_TEST
 
 	  If unsure, say N.
 
-config BITS_TEST
-	tristate "KUnit test for bits.h"
+config BITS_KUNIT_TEST
+	tristate "KUnit test for bits.h" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	default KUNIT_ALL_TESTS
 	help
 	  This builds the bits unit test.
 	  Tests the logic of macros defined in bits.h.
diff --git a/lib/Makefile b/lib/Makefile
index b5307d3eec1a..c482327acdfb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -347,10 +347,10 @@ obj-$(CONFIG_OBJAGG) += objagg.o
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
-obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
+obj-$(CONFIG_BITFIELD_KUNIT_TEST_TEST) += bitfield_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
-obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
-obj-$(CONFIG_BITS_TEST) += test_bits.o
+obj-$(CONFIG_LINEAR_RANGES_KUNIT_TEST) += test_linear_ranges.o
+obj-$(CONFIG_BITS_KUNIT_TEST) += test_bits.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index a014149aa323..20328920f6ed 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -22,7 +22,7 @@ config MPTCP_IPV6
 	depends on IPV6=y
 	default y
 
-config MPTCP_KUNIT_TESTS
+config MPTCP_KUNIT_TEST
 	tristate "This builds the MPTCP KUnit tests" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index a611968be4d7..dcce3cbd1f19 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -9,4 +9,4 @@ obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
 
 mptcp_crypto_test-objs := crypto_test.o
 mptcp_token_test-objs := token_test.o
-obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o mptcp_token_test.o
+obj-$(CONFIG_MPTCP_KUNIT_TEST) += mptcp_crypto_test.o mptcp_token_test.o
diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index b472dc149856..a8931349933c 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -78,6 +78,6 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 	sha256(input, SHA256_BLOCK_SIZE + SHA256_DIGEST_SIZE, hmac);
 }
 
-#if IS_MODULE(CONFIG_MPTCP_KUNIT_TESTS)
+#if IS_MODULE(CONFIG_MPTCP_KUNIT_TEST)
 EXPORT_SYMBOL_GPL(mptcp_crypto_hmac_sha);
 #endif
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index feb4b9ffd462..8f0270a780ce 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -402,7 +402,7 @@ void __init mptcp_token_init(void)
 	}
 }
 
-#if IS_MODULE(CONFIG_MPTCP_KUNIT_TESTS)
+#if IS_MODULE(CONFIG_MPTCP_KUNIT_TEST)
 EXPORT_SYMBOL_GPL(mptcp_token_new_request);
 EXPORT_SYMBOL_GPL(mptcp_token_new_connect);
 EXPORT_SYMBOL_GPL(mptcp_token_accept);
diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index 640494f76cbd..8a13462e1a63 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -37,7 +37,7 @@ config SND_SOC_COMPRESS
 config SND_SOC_TOPOLOGY
 	bool
 
-config SND_SOC_TOPOLOGY_KUNIT_TESTS
+config SND_SOC_TOPOLOGY_KUNIT_TEST
 	tristate "KUnit tests for SoC topology"
 	depends on KUNIT
 	depends on SND_SOC_TOPOLOGY
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index f56ad996eae8..a7b37c06dc43 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -7,9 +7,9 @@ ifneq ($(CONFIG_SND_SOC_TOPOLOGY),)
 snd-soc-core-objs += soc-topology.o
 endif
 
-ifneq ($(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TESTS),)
+ifneq ($(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TEST),)
 # snd-soc-test-objs := soc-topology-test.o
-obj-$(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TESTS) := soc-topology-test.o
+obj-$(CONFIG_SND_SOC_TOPOLOGY_KUNIT_TEST) := soc-topology-test.o
 endif
 
 ifneq ($(CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM),)
-- 
2.30.2

