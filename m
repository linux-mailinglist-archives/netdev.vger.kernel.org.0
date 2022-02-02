Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39274A6CF0
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 09:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244936AbiBBIbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 03:31:33 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:37981 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbiBBIbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 03:31:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643790692; x=1675326692;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=u+DzTfKMjcecMARYYAmOWUUJ2SW4bIwLVPvUzcWVG28=;
  b=CTZkczvN5tjQIKL0xBYgmKX1XQSlO4DtElcdKjD16Fdj4fCMDhaWsoGj
   kGblzgZM9z4t3qRBpwizC5lRjLBx4SsS5UFhwVXlJFtNMwZH7d7xb5fnX
   yY1g6pbV+Ff8mNqrqdkhiaaXM+rmNtJjzQmgtY2a3mHdqLltSS3rJbjyR
   S9O/1vXb1uSlq35CxJRMKwpVC5VQb9FezfYcLF/Wo3bNuKB2TugLmQfBR
   RMHjc9j2vtcZ6og84uDYQFdHycEbMx/WdeW14W2gkQJQqHEcBatGJGwCU
   zabTwsQMcE4K46DoN8pIrjhUJVH2kT3c+T66yNdj5hIs8UZ1+nX01eYhA
   g==;
IronPort-SDR: HrLsfAkEaxHvnyiqLFs4XJ7ooFesl42N5wt1tF6vC/8NT++lDk5ThMENLLj6tzh3Krhlf6E5QY
 7Iht3eBe/C8hhI08nt2Mxaj8mpF6UJxE1dcBh/ljtEUrNHTDmkoDKBmGqgG8nRL45x7Ud4FdC/
 Ry8S7bRHE0UqrenG0XodLT5DOkeUJdmFR0v0CtVc6Y3TyqUA2g+SIpzQA1EGVmzgfWz3fNcXQs
 4JQyRSPp4KlSA30fWKc97Eg1UGfPeocs+Mzz6sBPBnWsunlbxC6JmwsBBBOlngffzHWmHdIDBa
 OWFVdfXglwmojel2EnKFTTfQ
X-IronPort-AV: E=Sophos;i="5.88,336,1635231600"; 
   d="scan'208";a="84413464"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2022 01:31:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 2 Feb 2022 01:31:31 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 2 Feb 2022 01:31:30 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net v2] net: sparx5: do not refer to skb after passing it on
Date:   Wed, 2 Feb 2022 09:30:39 +0100
Message-ID: <20220202083039.3774851-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not try to use any SKB fields after the packet has been passed up in the
receive stack.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index dc7e5ea6ec15..148d431fcde4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -145,9 +145,9 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
 	skb->protocol = eth_type_trans(skb, netdev);
-	netif_rx(skb);
 	netdev->stats.rx_bytes += skb->len;
 	netdev->stats.rx_packets++;
+	netif_rx(skb);
 }

 static int sparx5_inject(struct sparx5 *sparx5,
--
2.35.1

