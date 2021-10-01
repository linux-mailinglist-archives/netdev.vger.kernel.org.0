Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B179A41F6FE
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355653AbhJAVec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355637AbhJAVeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8772619EC;
        Fri,  1 Oct 2021 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123956;
        bh=50dvr8r9bcS5YPr7sboPY0P1w5AguWHvwIvvzZfzdWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2pC3q1uX3cxlWvn1QdYwzKUjq4qj88QJZTm4CNNMGvx5dg3QorTCN46ATpnHl2vj
         udglErVa2uQlwsUbuBiK0TY7tJaIR6jFgDVKLo/X+jXIZCq7fs1l/ZJcEwsEOdfHyQ
         9iPNu2iFV+/9FBrkl0mbYZ6c/m7TS7be9Ok3PK3i08mTJVfoa/fylt12Duadyg5eZ8
         /+oEXou4fEwEYI9z8x41tw65LPhThnSIZLPDnEUgz4gI/XiU9xnSs9UloaUAuAHI8/
         I9QcHjDzjwlyoBVJ5H/VK5Ucm1RGqgAD1j8omP51BO0K0bCbI+wwTQne1B092lENAf
         x0Vh1vjxHSAbA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <rajur@chelsio.com>
Subject: [PATCH net-next 08/11] ethernet: chelsio: use eth_hw_addr_set()
Date:   Fri,  1 Oct 2021 14:32:25 -0700
Message-Id: <20211001213228.1735079-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert chelsio drivers from memcpy() and ether_addr_copy()
to eth_hw_addr_set(). They lack includes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb/subr.c       | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c     | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h     | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c     | 2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h | 3 ++-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/subr.c b/drivers/net/ethernet/chelsio/cxgb/subr.c
index 310add28fcf5..007c591b8bf5 100644
--- a/drivers/net/ethernet/chelsio/cxgb/subr.c
+++ b/drivers/net/ethernet/chelsio/cxgb/subr.c
@@ -1140,7 +1140,7 @@ int t1_init_sw_modules(adapter_t *adapter, const struct board_info *bi)
 			       adapter->port[i].dev->name);
 			goto error;
 		}
-		memcpy(adapter->port[i].dev->dev_addr, hw_addr, ETH_ALEN);
+		eth_hw_addr_set(adapter->port[i].dev, hw_addr);
 		init_link_config(&adapter->port[i].link_config, bi);
 	}
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
index 7ff31d1026fb..53feac8da503 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/t3_hw.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/etherdevice.h>
 #include "common.h"
 #include "regs.h"
 #include "sge_defs.h"
@@ -3758,8 +3759,7 @@ int t3_prep_adapter(struct adapter *adapter, const struct adapter_info *ai,
 		memcpy(hw_addr, adapter->params.vpd.eth_base, 5);
 		hw_addr[5] = adapter->params.vpd.eth_base[5] + i;
 
-		memcpy(adapter->port[i]->dev_addr, hw_addr,
-		       ETH_ALEN);
+		eth_hw_addr_set(adapter->port[i], hw_addr);
 		init_link_config(&p->link_config, p->phy.caps);
 		p->phy.ops->power_down(&p->phy, 1);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index ecea3cdd30b3..5657ac8cfca0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1545,7 +1545,7 @@ static inline void t4_write_reg64(struct adapter *adap, u32 reg_addr, u64 val)
 static inline void t4_set_hw_addr(struct adapter *adapter, int port_idx,
 				  u8 hw_addr[])
 {
-	ether_addr_copy(adapter->port[port_idx]->dev_addr, hw_addr);
+	eth_hw_addr_set(adapter->port[port_idx], hw_addr);
 	ether_addr_copy(adapter->port[port_idx]->perm_addr, hw_addr);
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 64144b6171d7..e7b4e3ed056c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -9706,7 +9706,7 @@ int t4_port_init(struct adapter *adap, int mbox, int pf, int vf)
 		if (ret)
 			return ret;
 
-		memcpy(adap->port[i]->dev_addr, addr, ETH_ALEN);
+		eth_hw_addr_set(adap->port[i], addr);
 		j++;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h b/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h
index f55105a4112f..03cb1410d6fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/adapter.h
@@ -40,6 +40,7 @@
 #ifndef __CXGB4VF_ADAPTER_H__
 #define __CXGB4VF_ADAPTER_H__
 
+#include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
@@ -507,7 +508,7 @@ static inline const char *port_name(struct adapter *adapter, int pidx)
 static inline void t4_os_set_hw_addr(struct adapter *adapter, int pidx,
 				     u8 hw_addr[])
 {
-	memcpy(adapter->port[pidx]->dev_addr, hw_addr, ETH_ALEN);
+	eth_hw_addr_set(adapter->port[pidx], hw_addr);
 }
 
 /**
-- 
2.31.1

