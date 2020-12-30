Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0712E7D09
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 23:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgL3WzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 17:55:11 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:61540 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgL3WzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 17:55:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1609368911; x=1640904911;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=fkonjLjYRFDw/u76n7t+moOaX+PjH/39tyxGd/FyqBA=;
  b=VXhD8BCrC+tGlmzzURCVOQZvTYKz5PToh4UgYZdzAqldhf2VluPz6O3r
   ThmUcLXNqNwRAbVAO6+IAqV6mZ+4LWJjoZR1pAJPWdHYO+aQPas2EfRuX
   ydgTMAFcsfATisQDodX+OXXmuA0m6065SYCLQyjJSU/UXYWNr89acUWkG
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,462,1599523200"; 
   d="scan'208";a="107163853"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-22cc717f.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 30 Dec 2020 22:54:30 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-22cc717f.us-west-2.amazon.com (Postfix) with ESMTPS id 5FF5FA06FD;
        Wed, 30 Dec 2020 22:54:29 +0000 (UTC)
Received: from EX13D06UEA002.ant.amazon.com (10.43.61.198) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 30 Dec 2020 22:54:28 +0000
Received: from ucf43ac461c9a53.ant.amazon.com (10.43.160.48) by
 EX13D06UEA002.ant.amazon.com (10.43.61.198) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 30 Dec 2020 22:54:27 +0000
Date:   Wed, 30 Dec 2020 17:54:23 -0500
From:   Tong Zhu <zhutong@amazon.com>
To:     <davem@davemloft.net>, <sashal@kernel.org>, <edumazet@google.com>,
        <zhutong@amazon.com>, <vvs@virtuozzo.com>
CC:     <netdev@vger.kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] neighbour: Disregard DEAD dst in neigh_update
Message-ID: <20201230225415.GA490@ucf43ac461c9a53.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.48]
X-ClientProxiedBy: EX13D46UWC001.ant.amazon.com (10.43.162.126) To
 EX13D06UEA002.ant.amazon.com (10.43.61.198)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 4.x kernel a dst in DST_OBSOLETE_DEAD state is associated
with loopback net_device and leads to loopback neighbour. It
leads to an ethernet header with all zero addresses.

A very troubling case is working with mac80211 and ath9k.
A packet with all zero source MAC address to mac80211 will
eventually fail ieee80211_find_sta_by_ifaddr in ath9k (xmit.c).
As result, ath9k flushes tx queue (ath_tx_complete_aggr) without
updating baw (block ack window), damages baw logic and disables
transmission.

Signed-off-by: Tong Zhu <zhutong@amazon.com>
---
 net/core/neighbour.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 6e890f51b7d8..e471c32e448f 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1271,7 +1271,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
 			 * we can reinject the packet there.
 			 */
 			n2 = NULL;
-			if (dst) {
+			if (dst && dst->obsolete != DST_OBSOLETE_DEAD) {
 				n2 = dst_neigh_lookup_skb(dst, skb);
 				if (n2)
 					n1 = n2;
-- 
2.17.1

