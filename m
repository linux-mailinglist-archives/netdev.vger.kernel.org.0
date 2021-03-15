Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B31733BD6D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhCOOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:35:21 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13616 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbhCOOe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:34:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dzf641P8kz17Lgh;
        Mon, 15 Mar 2021 22:33:00 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 15 Mar 2021 22:34:45 +0800
From:   'w00385741 <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Baowen Zheng <baowen.zheng@corigine.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: dsa: sja1105: fix error return code in sja1105_cls_flower_add()
Date:   Mon, 15 Mar 2021 14:43:23 +0000
Message-ID: <20210315144323.4110640-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

The return value 'rc' maybe overwrite to 0 in the flow_action_for_each
loop, the error code from the offload not support error handling will
not set. This commit fix it to return -EOPNOTSUPP.

Fixes: 6a56e19902af ("flow_offload: reject configuration of packet-per-second policing in offload drivers")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index f78b767f86ee..973761132fc3 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -317,14 +317,13 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	if (rc)
 		return rc;
 
-	rc = -EOPNOTSUPP;
-
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
 			if (act->police.rate_pkt_ps) {
 				NL_SET_ERR_MSG_MOD(extack,
 						   "QoS offload not support packets per second");
+				rc = -EOPNOTSUPP;
 				goto out;
 			}
 

