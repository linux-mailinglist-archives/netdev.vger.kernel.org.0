Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4527C61
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 14:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbfEWMCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 08:02:41 -0400
Received: from first.geanix.com ([116.203.34.67]:60966 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbfEWMCk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 08:02:40 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 0AC531175;
        Thu, 23 May 2019 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1558612908; bh=LfwnnfieQzBuyg6h9W7Y1rNS6lVNSdfd8KNtUtWZaJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kJ9FPLj5cx2w28szRXrBMPa80YBVClPnPnf8PgMldxwNQNVQjcQVsb9GXwrNpHk8N
         tJw+foiDGU3AlHxlwy1KxgylPLUXJ8l0/4v7k97mTXKebpU6xDh/tqDNzdbCpthRYC
         lVoruh+96ZhSW95HeTTMGmNngDsvtq/IfG93U7ZyOzze5deytBIZ2xSUsxE+36Y9hD
         0joBBVPV4ZE+gs8wNK4t2ySBpADW9+OAeZtB6SDZg1HKniPNL6FtMqKOlMSxUSEMsJ
         mETqg/v7SetcrogeS3zMkJOkKZKLGfwYAiCP/uPwj35XXH4APyC7zG6CIG1mm7UuHp
         7kmjkQI1dM+KQ==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] net: ll_temac: Cleanup multicast filter on change
Date:   Thu, 23 May 2019 14:02:21 +0200
Message-Id: <20190523120222.3807-4-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523120222.3807-1-esben@geanix.com>
References: <20190523120222.3807-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 796779db2bec
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid leaving old address table entries when using multicast.  If more than
one multicast address were removed, only the first removed address would
actually be cleared.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9d43be3..75da604 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -484,10 +484,13 @@ static void temac_set_multicast_list(struct net_device *ndev)
 						    multi_addr_lsw);
 			i++;
 		}
-	} else {
+	}
+
+	/* Clear all or remaining/unused address table entries */
+	while (i < MULTICAST_CAM_TABLE_NUM) {
 		temac_indirect_out32_locked(lp, XTE_MAW0_OFFSET, 0);
 		temac_indirect_out32_locked(lp, XTE_MAW1_OFFSET, i << 16);
-		}
+		i++;
 	}
 
 	/* Enable address filter block if currently disabled */
-- 
2.4.11

