Return-Path: <netdev+bounces-3004-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FC6704FC8
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:50:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B01301C20DE8
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF3FF2772D;
	Tue, 16 May 2023 13:50:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9AE34CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:50:24 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B9B1721
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684245021; x=1715781021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gpfUFUucWBxadKGnBNsvGfbgUWvCCyHXrLjw0Qu0HQY=;
  b=MXiS0gGyg17pkvBmT62FQpbiGOCXIW5ds08pXnGRzCpGjDZLDkQa4Xso
   Yq6zhcQeVC9a0THLutheBstVt0OQQg/vY8ERWIsokpmWdD2XvaN/WKDOa
   ayInzZkrRNoqIVGNk6CG9dxbgCi62DVgn+aGIB0ZLMQZCsRzmHdpLEK+D
   bDDGk0R1mz7fFCGsj6eWcobT9+4gj5C7kqgO7rKVG5oRX1+rgFZN2AYnD
   OxKHRGneUSQqIxos03d9kv9y8dQ0kJ5nuiYa92z938eqKHI6UhSmvPAWu
   deBPgDClOe7fHytjIjD20EYtOT9SSguWYOyq2t5IqxyDjREKZQzVnQdA0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="350319872"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="350319872"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 06:50:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="651846458"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="651846458"
Received: from amlin-018-068.igk.intel.com ([10.102.18.68])
  by orsmga003.jf.intel.com with ESMTP; 16 May 2023 06:50:20 -0700
From: Mateusz Palczewski <mateusz.palczewski@intel.com>
To: j.vosburgh@gmail.com,
	andy@greyhouse.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dbanerje@akamai.com,
	netdev@vger.kernel.org
Cc: Sebastian Basierski <sebastianx.basierski@intel.com>,
	Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: [PATCH iwl-net  v1 1/2] drivers/net/bonding/bond_3ad: Use updated MAC address for lacpdu packets
Date: Tue, 16 May 2023 09:44:46 -0400
Message-Id: <20230516134447.193511-2-mateusz.palczewski@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230516134447.193511-1-mateusz.palczewski@intel.com>
References: <20230516134447.193511-1-mateusz.palczewski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Sebastian Basierski <sebastianx.basierski@intel.com>

After changing VFs MAC address, bonding driver shouldn't use
the old address. Otherwise lapcdu packets will have set wrong
source MAC address.

Fixes: ada0f8633c5b ("bonding: Convert memcpy(foo, bar, ETH_ALEN) to ether_addr_copy(foo, bar)")
Signed-off-by: Sebastian Basierski <sebastianx.basierski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
---
 drivers/net/bonding/bond_3ad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index c99ffe6c683a..b5202af79f20 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -869,10 +869,10 @@ static int ad_lacpdu_send(struct port *port)
 	lacpdu_header = skb_put(skb, length);
 
 	ether_addr_copy(lacpdu_header->hdr.h_dest, lacpdu_mcast_addr);
-	/* Note: source address is set to be the member's PERMANENT address,
+	/* Note: source address is set to be the member's CURRENT address,
 	 * because we use it to identify loopback lacpdus in receive.
 	 */
-	ether_addr_copy(lacpdu_header->hdr.h_source, slave->perm_hwaddr);
+	ether_addr_copy(lacpdu_header->hdr.h_source, slave->dev->dev_addr);
 	lacpdu_header->hdr.h_proto = PKT_TYPE_LACPDU;
 
 	lacpdu_header->lacpdu = port->lacpdu;
-- 
2.31.1


