Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155D011BFFA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLKWh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:37:59 -0500
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:58663 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfLKWh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:37:59 -0500
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2019 17:37:58 EST
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id 79AD8C11F0;
        Wed, 11 Dec 2019 14:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1576103459;
        bh=IC4z90UdZ6JaiC0lf8P6At9+Go+I0xjjhAAz2W2FZ7Y=;
        h=From:To:Cc:Subject:Date;
        b=LCRSCwjawA+0zcWlWm2r2SLwa23X/G/KtiUJEkyzlWZdXdVyURQVjTcrZCaHCs0Aq
         OSgN2heABvFJUlppy5UFL5PEL7b09XmWb+aAVCbxcR6XkyN6Nsjo1/0KzS6BcaqWUK
         8RnoJRP7MpbTZLdvCDnr35p5k0QKLBK7CzCATysw=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, stephen@networkplumber.org
Subject: [PATCH net-next v2] bonding: move 802.3ad port state flags to uapi
Date:   Wed, 11 Dec 2019 14:30:58 -0800
Message-Id: <1576103458-22411-1-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bond slave actor/partner operating state is exported as
bitfield to userspace, which lacks a way to interpret it, e.g.,
iproute2 only prints the state as a number:

ad_actor_oper_port_state 15

For userspace to interpret the bitfield, the bitfield definitions
should be part of the uapi. The bitfield itself is defined in the
802.3ad standard.

This commit moves the 802.3ad bitfield definitions to uapi.

Related iproute2 patches, soon to be posted upstream, use the new uapi
headers to pretty-print bond slave state, e.g., with ip -d link show

ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>

Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/bonding/bond_3ad.c  | 10 ----------
 include/uapi/linux/if_bonding.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index e3b25f310936..34bfe99641a3 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -31,16 +31,6 @@
 #define AD_CHURN_DETECTION_TIME    60
 #define AD_AGGREGATE_WAIT_TIME     2
 
-/* Port state definitions (43.4.2.2 in the 802.3ad standard) */
-#define AD_STATE_LACP_ACTIVITY   0x1
-#define AD_STATE_LACP_TIMEOUT    0x2
-#define AD_STATE_AGGREGATION     0x4
-#define AD_STATE_SYNCHRONIZATION 0x8
-#define AD_STATE_COLLECTING      0x10
-#define AD_STATE_DISTRIBUTING    0x20
-#define AD_STATE_DEFAULTED       0x40
-#define AD_STATE_EXPIRED         0x80
-
 /* Port Variables definitions used by the State Machines (43.4.7 in the
  * 802.3ad standard)
  */
diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
index 790585f0e61b..6829213a54c5 100644
--- a/include/uapi/linux/if_bonding.h
+++ b/include/uapi/linux/if_bonding.h
@@ -95,6 +95,16 @@
 #define BOND_XMIT_POLICY_ENCAP23	3 /* encapsulated layer 2+3 */
 #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
 
+/* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
+#define AD_STATE_LACP_ACTIVITY   0x1
+#define AD_STATE_LACP_TIMEOUT    0x2
+#define AD_STATE_AGGREGATION     0x4
+#define AD_STATE_SYNCHRONIZATION 0x8
+#define AD_STATE_COLLECTING      0x10
+#define AD_STATE_DISTRIBUTING    0x20
+#define AD_STATE_DEFAULTED       0x40
+#define AD_STATE_EXPIRED         0x80
+
 typedef struct ifbond {
 	__s32 bond_mode;
 	__s32 num_slaves;
-- 
2.20.1

