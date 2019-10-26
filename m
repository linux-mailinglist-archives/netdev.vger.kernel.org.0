Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A695CE6003
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 01:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbfJZXim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 19:38:42 -0400
Received: from internalmail.cumulusnetworks.com ([45.55.219.144]:59081 "EHLO
        internalmail.cumulusnetworks.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbfJZXil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 19:38:41 -0400
Received: from localhost (fw.cumulusnetworks.com [216.129.126.126])
        by internalmail.cumulusnetworks.com (Postfix) with ESMTPSA id CA594C11F1;
        Sat, 26 Oct 2019 16:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cumulusnetworks.com;
        s=mail; t=1572132598;
        bh=1oteWXTv2++w91YOsXyAgD/F+Byne90gp0zyHmBkEB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=nqZfQbm23lxT1TlmaGdI9prdWakfBoGYKfqPe7sqGrx2TPCvhz0xJ87yl9+Wsunky
         POe7dELlbCja6g9Lk5nn1H4JSiKxVntZbHioH4T3CggisueoCIlOQ74VyIj0BUnmjG
         NUsIEwmN5+bdIoNkk05G4/aZyjzrYBg08c5fLaxI=
From:   Andy Roulin <aroulin@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net
Subject: [PATCH net-next 1/3] bonding: move 3ad port state defs to include/uapi
Date:   Sat, 26 Oct 2019 16:29:52 -0700
Message-Id: <1572132594-2006-2-git-send-email-aroulin@cumulusnetworks.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actor and partner 802.3ad operating states are exported to userspace
in bond_netlink.c, see bond_slave_fill_info with the following
attributes:

- IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE; and
- IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE.

The operating states are exported as bitfields and userspace lacks a way
to interpret them, e.g., iproute2 only prints the states as numbers.

For userspace to interpret kernel bitfields, the bitfield definitions
should be part of the uapi. The bitfield itself is defined in the 802.3ad
standard.

This commit moves the 802.3ad bitfield definitions to
uapi/linux/if_bonding.h

Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/bonding/bond_3ad.c  | 10 ----------
 include/uapi/linux/if_bonding.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 9274dcc6e9b0..503af517bc64 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -48,16 +48,6 @@
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

