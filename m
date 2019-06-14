Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1A46351
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfFNPtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:49:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfFNPsn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 11:48:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B356EC057E65;
        Fri, 14 Jun 2019 15:48:40 +0000 (UTC)
Received: from ceranb.redhat.com (ovpn-204-86.brq.redhat.com [10.40.204.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BC7054696;
        Fri, 14 Jun 2019 15:48:37 +0000 (UTC)
From:   Ivan Vecera <ivecera@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Tianhao <tizhao@redhat.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] be2net: Fix number of Rx queues used for flow hashing
Date:   Fri, 14 Jun 2019 17:48:36 +0200
Message-Id: <20190614154836.22172-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 14 Jun 2019 15:48:42 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Number of Rx queues used for flow hashing returned by the driver is
incorrect and this bug prevents user to use the last Rx queue in
indirection table.

Let's say we have a NIC with 6 combined queues:

[root@sm-03 ~]# ethtool -l enp4s0f0
Channel parameters for enp4s0f0:
Pre-set maximums:
RX:             5
TX:             5
Other:          0
Combined:       6
Current hardware settings:
RX:             0
TX:             0
Other:          0
Combined:       6

Default indirection table maps all (6) queues equally but the driver
reports only 5 rings available.

[root@sm-03 ~]# ethtool -x enp4s0f0
RX flow hash indirection table for enp4s0f0 with 5 RX ring(s):
    0:      0     1     2     3     4     5     0     1
    8:      2     3     4     5     0     1     2     3
   16:      4     5     0     1     2     3     4     5
   24:      0     1     2     3     4     5     0     1
...

Now change indirection table somehow:

[root@sm-03 ~]# ethtool -X enp4s0f0 weight 1 1
[root@sm-03 ~]# ethtool -x enp4s0f0
RX flow hash indirection table for enp4s0f0 with 6 RX ring(s):
    0:      0     0     0     0     0     0     0     0
...
   64:      1     1     1     1     1     1     1     1
...

Now it is not possible to change mapping back to equal (default) state:

[root@sm-03 ~]# ethtool -X enp4s0f0 equal 6
Cannot set RX flow hash configuration: Invalid argument

Fixes: 594ad54a2c3b ("be2net: Add support for setting and getting rx flow hash options")
Reported-by: Tianhao <tizhao@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 4c218341c51b..6e635debc7fd 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1105,7 +1105,7 @@ static int be_get_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd,
 		cmd->data = be_get_rss_hash_opts(adapter, cmd->flow_type);
 		break;
 	case ETHTOOL_GRXRINGS:
-		cmd->data = adapter->num_rx_qs - 1;
+		cmd->data = adapter->num_rx_qs;
 		break;
 	default:
 		return -EINVAL;
-- 
2.21.0

