Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B36699D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 11:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfGLJHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 05:07:19 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56347 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfGLJHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 05:07:18 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MeC5x-1iN7Ph3SwZ-00bI7H; Fri, 12 Jul 2019 11:07:06 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Arjun Vynipadath <arjun@chelsio.com>,
        Surendra Mobiya <surendra@chelsio.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] [net-next] cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()
Date:   Fri, 12 Jul 2019 11:06:33 +0200
Message-Id: <20190712090700.317887-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:rxFNf2Aki8qaWD5BAHF9dJ6RZq9YGgkpHy8CO9HIEVlm7go4NVx
 kHFABxf69KKsV1nhzdGT3E9nhL8b1dNpvlMeZZl2UMJi8iAayuR+sj7oa0MEnBelfmAdzn5
 GmHu8AwVCwbo0qLCZAdAoclelQrmU9yj0DnBAzqUoCo/zn600t8P2zAcHHKnKHoneepLFiT
 ZS5YgzKSe3u0GNUA3I0FA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:O+AX6q867+c=:MXtjbU0XZTwkG7PWMjzQ0V
 v5o84QhB/JLoRjYCRSyrVPpQt+fH7M0kpZkVaBCVVUDGAjEiOpR7zF32Qu8hpWd9fjVvUf+3U
 KM3P5kDvJKPYVl3RNOaGzcaB+KUav3WF3hQGBcRQ5oavMoyr1ROzkS4UD91aZIX2VOC3hywPN
 LYXBXODKbJrhtm+gVfyHZhr/oM6QSpKV/T5aq/hwkkYKNdUKbAZJjTKKOFSMqbZU3W5wl4l5K
 ZJxws379F6lkAaRSSwgkC5q6yPaDxukpzkb9aX+7ySDAfmcwkFaSsdzP1N5SybF+TievuvcO/
 xAc46xFlboH0LUsMWBjvT+8Tz1tvqK6rWkdCl5ZyP2V1wbYA449wJ76Y3yBQ0oGcl8oHUNR0D
 Kop6dogBbjIbIZi5nMcsuNvvy7tMBy+Netj1OMEEVl6wb4nBNmFVdgApLQJTZvL46Zz8H0xof
 qE1VEvSdhbZrWfi05TsMs99NoV7+Qy+L6/1lNyUu76iUnhD5uIwFA7A+n+Xhek2p5XjU0BGkI
 tF4JPjQp/fIRI8zPkQVqPvfyzoJEDDwO9YAjwz3be7/QnXITG8dOE0e4oVwWEoMqAT8kgruzR
 MSEhW1VvhgmwaDaQTK+1rSNFglRTIvh2/oPX9zMp5nrcR5Cy0QuxN6c5EYSv314nMM002t7JP
 6gxHomwy6vEHdQnQ/6HHOVawvNPEXHrEQQhC7lP46W6BLahCkwhrAMjYv+Qknyg2uvGCER0Qw
 vIforeros4ovfVwG0LyxQ5Y7toEmy3zMX/nf4g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cudbg_collect_mem_region() and cudbg_read_fw_mem() both use several
hundred kilobytes of kernel stack space. One gets inlined into the other,
which causes the stack usage to be combined beyond the warning limit
when building with clang:

drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:1057:12: error: stack frame size of 1244 bytes in function 'cudbg_collect_mem_region' [-Werror,-Wframe-larger-than=]

Restructuring cudbg_collect_mem_region() lets clang do the same
optimization that gcc does and reuse the stack slots as it can
see that the large variables are never used together.

A better fix might be to avoid using cudbg_meminfo on the stack
altogether, but that requires a larger rewrite.

Fixes: a1c69520f785 ("cxgb4: collect MC memory dump")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index a76529a7662d..c2e92786608b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1054,14 +1054,12 @@ static void cudbg_t4_fwcache(struct cudbg_init *pdbg_init,
 	}
 }
 
-static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
-				    struct cudbg_buffer *dbg_buff,
-				    struct cudbg_error *cudbg_err,
-				    u8 mem_type)
+static unsigned long cudbg_mem_region_size(struct cudbg_init *pdbg_init,
+					   struct cudbg_error *cudbg_err,
+					   u8 mem_type)
 {
 	struct adapter *padap = pdbg_init->adap;
 	struct cudbg_meminfo mem_info;
-	unsigned long size;
 	u8 mc_idx;
 	int rc;
 
@@ -1075,7 +1073,16 @@ static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
 	if (rc)
 		return rc;
 
-	size = mem_info.avail[mc_idx].limit - mem_info.avail[mc_idx].base;
+	return mem_info.avail[mc_idx].limit - mem_info.avail[mc_idx].base;
+}
+
+static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
+				    struct cudbg_buffer *dbg_buff,
+				    struct cudbg_error *cudbg_err,
+				    u8 mem_type)
+{
+	unsigned long size = cudbg_mem_region_size(pdbg_init, cudbg_err, mem_type);
+
 	return cudbg_read_fw_mem(pdbg_init, dbg_buff, mem_type, size,
 				 cudbg_err);
 }
-- 
2.20.0

