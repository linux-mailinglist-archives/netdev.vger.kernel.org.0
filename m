Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70964A5E57
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbiBAOca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:32:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:22637 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbiBAOc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643725949; x=1675261949;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cvx6rDpgo2S07AWukGYA/bvd35FN6fHtN9yNaCsXVc8=;
  b=w1Guz+k/IM8XWLOL6Z1QsilDovJIXZrwxH3vAdWSkdKl+lrH0VWeZS8x
   47wjs3NOgoWFtVlnEeMYTuSR4mZL45Bso7mtgpZ3VGbX2jIcQxGXpOPYT
   pSQ5JG73cC9FwC97Vc+NXFbbReTiQDsmJDedjHHDjoZhGL2wcTY4M8+9F
   dak1+KpeTfrzrQxrNVW4BqWvhu1LCYwRaRHaagMSQZQT+UJ8geeaGtlyF
   Ddvny7zxXfaae7IxzynutVxj8Ut+aNFji/r1nMDYztBTGy3SakryByF58
   W7Q0CEvki6hq1spPZD+GAE+XDkMAr7Y1YpT94NXsb3eV7px3uwORIOGwT
   A==;
IronPort-SDR: ssFcxKs/aaimKr6x/JkrDr27s2loVvXUIBxzJ23jxGWgIIDRR+wWus+W8sEMpOy9UMGhrqf4PH
 HbfxvALRKhmSDpWKKFG/KEAlWSIiGX78SimCUtAK9Zlq+FXVeOAgSGpM3kDUDLnPL9aTMi/Iht
 S5u8vh9GI1jr160eW1wngmqv4vjFwsGVlOW9nfmutOk6k/iMPWrXyXzB3q7a9CdFEIA8V/tg55
 qKZp6Op9MjNTNrZzuVKxJqaF2Imz05iItn289zCxBSsGFCVnikdKtUBvxIKspJvxj9VKMvUM7D
 OUncKledePvanQI/DloNdLA5
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="152105173"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 07:32:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 07:32:28 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 1 Feb 2022 07:32:26 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net] net: sparx5: do not refer to skb after passing it on
Date:   Tue, 1 Feb 2022 15:30:57 +0100
Message-ID: <20220201143057.3533830-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not try to use any SKB fields after the packet has been passed up in the
receive stack.

This error was reported as shown below:
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

Fixes: f3cad2611a77 (net: sparx5: add hostmode with phylink support)

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index dc7e5ea6ec15..ebdce4b35686 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -145,8 +145,8 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
 	skb->protocol = eth_type_trans(skb, netdev);
-	netif_rx(skb);
 	netdev->stats.rx_bytes += skb->len;
+	netif_rx(skb);
 	netdev->stats.rx_packets++;
 }

--
2.35.1

