Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0315C519AB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732524AbfFXRgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:36:18 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:20082 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732521AbfFXRgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:36:18 -0400
Received: from localhost (junagarh.blr.asicdesigners.com [10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5OHaEOR014333;
        Mon, 24 Jun 2019 10:36:15 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH v3 net-next 2/4] cxgb4: Add MPS TCAM refcounting for raw mac filters
Date:   Mon, 24 Jun 2019 23:05:33 +0530
Message-Id: <20190624173535.12572-3-rajur@chelsio.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190624173535.12572-1-rajur@chelsio.com>
References: <20190624173535.12572-1-rajur@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds TCAM reference counting
support for raw mac filters.

Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h     | 16 +++++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c | 46 ++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 39ccd4c64d48..c7ab57fd03be 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -1919,5 +1919,21 @@ int cxgb4_alloc_encap_mac_filt(struct adapter *adap, unsigned int viid,
 			       u8 dip_hit, u8 lookup_type, bool sleep_ok);
 int cxgb4_free_encap_mac_filt(struct adapter *adap, unsigned int viid,
 			      int idx, bool sleep_ok);
+int cxgb4_free_raw_mac_filt(struct adapter *adap,
+			    unsigned int viid,
+			    const u8 *addr,
+			    const u8 *mask,
+			    unsigned int idx,
+			    u8 lookup_type,
+			    u8 port_id,
+			    bool sleep_ok);
+int cxgb4_alloc_raw_mac_filt(struct adapter *adap,
+			     unsigned int viid,
+			     const u8 *addr,
+			     const u8 *mask,
+			     unsigned int idx,
+			     u8 lookup_type,
+			     u8 port_id,
+			     bool sleep_ok);
 
 #endif /* __CXGB4_H__ */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
index b8a5375bf64d..b942748c7dfa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c
@@ -54,6 +54,52 @@ static int cxgb4_mps_ref_inc(struct adapter *adap, const u8 *mac_addr,
 	return ret;
 }
 
+int cxgb4_free_raw_mac_filt(struct adapter *adap,
+			    unsigned int viid,
+			    const u8 *addr,
+			    const u8 *mask,
+			    unsigned int idx,
+			    u8 lookup_type,
+			    u8 port_id,
+			    bool sleep_ok)
+{
+	int ret = 0;
+
+	if (!cxgb4_mps_ref_dec(adap, idx))
+		ret = t4_free_raw_mac_filt(adap, viid, addr,
+					   mask, idx, lookup_type,
+					   port_id, sleep_ok);
+
+	return ret;
+}
+
+int cxgb4_alloc_raw_mac_filt(struct adapter *adap,
+			     unsigned int viid,
+			     const u8 *addr,
+			     const u8 *mask,
+			     unsigned int idx,
+			     u8 lookup_type,
+			     u8 port_id,
+			     bool sleep_ok)
+{
+	int ret;
+
+	ret = t4_alloc_raw_mac_filt(adap, viid, addr,
+				    mask, idx, lookup_type,
+				    port_id, sleep_ok);
+	if (ret < 0)
+		return ret;
+
+	if (cxgb4_mps_ref_inc(adap, addr, ret, mask)) {
+		ret = -ENOMEM;
+		t4_free_raw_mac_filt(adap, viid, addr,
+				     mask, idx, lookup_type,
+				     port_id, sleep_ok);
+	}
+
+	return ret;
+}
+
 int cxgb4_free_encap_mac_filt(struct adapter *adap, unsigned int viid,
 			      int idx, bool sleep_ok)
 {
-- 
2.12.0

