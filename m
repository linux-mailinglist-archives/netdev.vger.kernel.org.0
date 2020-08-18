Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091ED248E4A
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 20:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgHRSzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 14:55:45 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:39610 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgHRSzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 14:55:45 -0400
Received: from vishal.asicdesigners.com (venkat-suman.asicdesigners.com [10.193.177.205] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07IItVln024504;
        Tue, 18 Aug 2020 11:55:33 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     rahul.lakkireddy@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next] ethtool: allow flow-type ether without IP protocol field
Date:   Wed, 19 Aug 2020 00:25:03 +0530
Message-Id: <20200818185503.664-1-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set IP protocol mask only when IP protocol field is set.
This will allow flow-type ether with vlan rule which don't have
protocol field to apply.

ethtool -N ens5f4 flow-type ether proto 0x8100 vlan 0x600\
m 0x1FFF action 3 loc 16

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 net/ethtool/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 441794e0034f..e6f5cf52023c 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -3025,13 +3025,14 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
 	case TCP_V4_FLOW:
 	case TCP_V6_FLOW:
 		match->key.basic.ip_proto = IPPROTO_TCP;
+		match->mask.basic.ip_proto = 0xff;
 		break;
 	case UDP_V4_FLOW:
 	case UDP_V6_FLOW:
 		match->key.basic.ip_proto = IPPROTO_UDP;
+		match->mask.basic.ip_proto = 0xff;
 		break;
 	}
-	match->mask.basic.ip_proto = 0xff;
 
 	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_BASIC);
 	match->dissector.offset[FLOW_DISSECTOR_KEY_BASIC] =
-- 
2.21.1

