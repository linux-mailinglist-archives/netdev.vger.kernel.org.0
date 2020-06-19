Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04A6200B54
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgFSOW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:22:26 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:33675 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726993AbgFSOWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:22:25 -0400
Received: from vishal.asicdesigners.com (chethan-pc.asicdesigners.com [10.193.177.170] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05JELtbg002529;
        Fri, 19 Jun 2020 07:22:19 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, rahul.lakkireddy@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 5/5] cxgb4: add action to steer flows to specific Rxq
Date:   Fri, 19 Jun 2020 19:51:39 +0530
Message-Id: <20200619142139.27982-6-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200619142139.27982-1-vishal@chelsio.com>
References: <20200619142139.27982-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for queue action to steer Rx traffic
hitting the flows to specified Rxq.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 53dbb3683653..8a176190586d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -425,6 +425,11 @@ void cxgb4_process_flow_actions(struct net_device *in,
 			process_pedit_field(fs, val, mask, offset, htype);
 			}
 			break;
+		case FLOW_ACTION_QUEUE:
+			fs->action = FILTER_PASS;
+			fs->dirsteer = 1;
+			fs->iq = act->queue.index;
+			break;
 		default:
 			break;
 		}
@@ -609,6 +614,9 @@ int cxgb4_validate_flow_actions(struct net_device *dev,
 			act_pedit = true;
 			}
 			break;
+		case FLOW_ACTION_QUEUE:
+			/* Do nothing. cxgb4_set_filter will validate */
+			break;
 		default:
 			netdev_err(dev, "%s: Unsupported action\n", __func__);
 			return -EOPNOTSUPP;
-- 
2.21.1

