Return-Path: <netdev+bounces-9624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDB072A0A3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 402B51C21176
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35FC19E7A;
	Fri,  9 Jun 2023 16:52:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3981171B4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:52:53 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D5C3A8D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329571; x=1717865571;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dk2sPCCfK6KqbxIJVhuD7uxcfQHn6gP9N0vrvuq8gGY=;
  b=MMUGqZXaFzvQDxGx0ROh02pmt5hJPVfI6Zwj0Kan6aOuAMS8eH6T9VAP
   6EeNPzvoPfzFvs2n1PWt0JnEh2S25R2LMI16GweBxyknJuo6zgDFYGt9w
   l6AQzFr7N+ux8Rq1TmbhwpAFJ3gDfPOoRSQqWtg5fla4uDOFGT6pDtNih
   aZSqR4uGr6FAFWZ40AevCg4v91QSLuT6JabRET0hQOqsaD4J+4PZKcTfn
   UGOrw2DbzDiK2+MHDdycpAS31Mh4WTPhQC2lWqILkP1xowYXLA6DsLasH
   8JFZkdJhZdSK91cOseb0TVp2mcibod8yFQbe78BZq+h8t3liEFtTwUP0n
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="338000131"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="338000131"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:52:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957215688"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957215688"
Received: from pgardocx-mobl1.igk.intel.com ([10.237.95.41])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:52:49 -0700
From: Piotr Gardocki <piotrx.gardocki@intel.com>
To: netdev@vger.kernel.org
Cc: piotrx.gardocki@intel.com,
	przemyslaw.kitszel@intel.com,
	michal.swiatkowski@linux.intel.com,
	pmenzel@molgen.mpg.de,
	kuba@kernel.org,
	maciej.fijalkowski@intel.com,
	anthony.l.nguyen@intel.com,
	simon.horman@corigine.com,
	aleksander.lobakin@intel.com
Subject: [PATCH net-next] net: add check for current MAC address in dev_set_mac_address
Date: Fri,  9 Jun 2023 18:52:41 +0200
Message-Id: <20230609165241.827338-1-piotrx.gardocki@intel.com>
X-Mailer: git-send-email 2.34.1
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

In some cases it is possible for kernel to come with request
to change primary MAC address to the address that is already
set on the given interface.

This patch adds proper check to return fast from the function
in these cases.

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
index 99d99b247bc9..c2c3ec61397b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8820,6 +8820,8 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
 		return -EINVAL;
 	if (!netif_device_present(dev))
 		return -ENODEV;
+	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
+		return 0;
 	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
 	if (err)
 		return err;
-- 
2.34.1


