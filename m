Return-Path: <netdev+bounces-10758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04BD1730262
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E87DD1C20D78
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716428BFB;
	Wed, 14 Jun 2023 14:53:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657F1C2C3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:53:19 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DC62681
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 07:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686754393; x=1718290393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ffOlKDdwHfZdnNsFKPvOtlXnT9PQ9YUdotU+ROTB8Yw=;
  b=fiXfX3j1g51OQ74AgI0SveykynaIzKJeXgHAYcwTNSH8bWxpQJ+vpdZC
   OOim9QSq6hHX+GYY4EFwDeFCsvy1PTmRVKpxyI7M1iPauhV4xyeT0zdBY
   KHhijLni3FDKzcsOdBgMdv3UdOhlzQLtZLMu/fjp/jZ7o2lU+2XxHfsiR
   eIeC4rlrMRMbhEQPwcxlngF5EqXSxCXQp5sB/r7yMXF4Z8PB18dMXvcfJ
   WJ8EA8QyJbIYpK/vP7VVDH7aOiAgWINYfuLeyQw2MSLEaA/GUWuwM7nVp
   D3fi59bw4tR9gYX8rlARK1p/Q9CJcHPT3+ndDeO+3m3ac6Pj7bBqgK7vj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387040557"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="387040557"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782114859"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="782114859"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 07:53:11 -0700
From: Piotr Gardocki <piotrx.gardocki@intel.com>
To: netdev@vger.kernel.org
Cc: piotrx.gardocki@intel.com,
	intel-wired-lan@lists.osuosl.org,
	przemyslaw.kitszel@intel.com,
	michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de,
	kuba@kernel.org,
	maciej.fijalkowski@intel.com,
	anthony.l.nguyen@intel.com,
	simon.horman@corigine.com,
	aleksander.lobakin@intel.com
Subject: [PATCH net-next v3 1/3] net: add check for current MAC address in dev_set_mac_address
Date: Wed, 14 Jun 2023 16:53:00 +0200
Message-Id: <20230614145302.902301-2-piotrx.gardocki@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230614145302.902301-1-piotrx.gardocki@intel.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In some cases it is possible for kernel to come with request
to change primary MAC address to the address that is already
set on the given interface.

Add proper check to return fast from the function in these cases.

An example of such case is adding an interface to bonding
channel in balance-alb mode:
modprobe bonding mode=balance-alb miimon=100 max_bonds=1
ip link set bond0 up
ifenslave bond0 <eth>

Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index c2456b3667fe..8f1c49ab17df 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8754,6 +8754,8 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 		return -EINVAL;
 	if (!netif_device_present(dev))
 		return -ENODEV;
+	if (!memcmp(dev->dev_addr, sa->sa_data, dev->addr_len))
+		return 0;
 	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
 	if (err)
 		return err;
-- 
2.34.1


