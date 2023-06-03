Return-Path: <netdev+bounces-7679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 824A77210BD
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 17:14:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3BD528194A
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:14:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4D59D539;
	Sat,  3 Jun 2023 15:14:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659E120EB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 15:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDC0C433D2;
	Sat,  3 Jun 2023 15:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685805264;
	bh=ScfCpeueTKwIGM7OyFbKO5lv13xBUuDYOH1xc/AuVB0=;
	h=Subject:From:To:Cc:Date:From;
	b=FHOD3LN9n/3vjWi6poVszen3yA5WgsdOf9H5byhinDAT0kAbCF9QmxZ4c3R/Mh6aa
	 LaE4TEV6FtgfS1uJi0cMqWvtZ7jW2BUTJdeT+WojAehapsRbX/8wTnA5siYo0cVuwi
	 2eqKGrk587kvl6XqsyQoc0CZlydW1bEzhBLFe2pTboVCdITcN6sdD9pvPdTl/xxHnU
	 bvRXURDeQhA+0GoRxHJ9i5Chua4CT5YBr4IffLAn+0Rjyz4SckRSHIg1AQkVuvhu81
	 R6z2kzsT97HYVsmNi4e2i9Bfj+vAyid/QMuv9+gYci1vzxkBpwc2ZjkY80miANNsH7
	 2Sz7RR6xBLZQA==
Subject: [PATCH RFC] RDMA/siw: Fabricate a GID on tun and loopback devices
From: Chuck Lever <cel@kernel.org>
To: BMT@zurich.ibm.com
Cc: Tom Talpey <tom@talpey.com>, Chuck Lever <chuck.lever@oracle.com>,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org, tom@talpey.com
Date: Sat, 03 Jun 2023 11:14:13 -0400
Message-ID: 
 <168580524310.5238.13720896895363588620.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

LOOPBACK and NONE (tunnel) devices have all-zero MAC addresses.
Currently, siw_device_create() falls back to copying the IB device's
name in those cases, because an all-zero MAC address breaks the RDMA
core address resolution mechanism.

However, at the point when siw_device_create() constructs a GID, the
ib_device::name field is uninitialized, leaving the MAC address to
remain in an all-zero state.

Fabricate a random artificial GID for such devices, and ensure that
artificial GID is returned for all device query operations.

Reported-by: Tom Talpey <tom@talpey.com>
Link: https://lore.kernel.org/linux-rdma/SA0PR15MB391986C07C4D41E107E79659994FA@SA0PR15MB3919.namprd15.prod.outlook.com/T/#t
Fixes: a2d36b02c15d ("RDMA/siw: Enable siw on tunnel devices")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 drivers/infiniband/sw/siw/siw.h       |    1 +
 drivers/infiniband/sw/siw/siw_main.c  |   22 ++++++++--------------
 drivers/infiniband/sw/siw/siw_verbs.c |    4 ++--
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index d7f5b2a8669d..41fb8976abc6 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -74,6 +74,7 @@ struct siw_device {
 
 	u32 vendor_part_id;
 	int numa_node;
+	char raw_gid[ETH_ALEN];
 
 	/* physical port state (only one port per device) */
 	enum ib_port_state state;
diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 1225ca613f50..57896fafa6c0 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -75,8 +75,7 @@ static int siw_device_register(struct siw_device *sdev, const char *name)
 		return rv;
 	}
 
-	siw_dbg(base_dev, "HWaddr=%pM\n", sdev->netdev->dev_addr);
-
+	siw_dbg(base_dev, "HWaddr=%pM\n", sdev->raw_gid);
 	return 0;
 }
 
@@ -314,24 +313,19 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 		return NULL;
 
 	base_dev = &sdev->base_dev;
-
 	sdev->netdev = netdev;
 
-	if (netdev->type != ARPHRD_LOOPBACK && netdev->type != ARPHRD_NONE) {
-		addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
-				    netdev->dev_addr);
+	if (netdev->addr_len) {
+		memcpy(sdev->raw_gid, netdev->dev_addr,
+		       min_t(unsigned int, netdev->addr_len, ETH_ALEN));
 	} else {
 		/*
-		 * This device does not have a HW address,
-		 * but connection mangagement lib expects gid != 0
+		 * This device does not have a HW address, but
+		 * connection mangagement requires a unique gid.
 		 */
-		size_t len = min_t(size_t, strlen(base_dev->name), 6);
-		char addr[6] = { };
-
-		memcpy(addr, base_dev->name, len);
-		addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
-				    addr);
+		eth_random_addr(sdev->raw_gid);
 	}
+	addrconf_addr_eui48((u8 *)&base_dev->node_guid, sdev->raw_gid);
 
 	base_dev->uverbs_cmd_mask |= BIT_ULL(IB_USER_VERBS_CMD_POST_SEND);
 
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index 398ec13db624..32b0befd25e2 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -157,7 +157,7 @@ int siw_query_device(struct ib_device *base_dev, struct ib_device_attr *attr,
 	attr->vendor_part_id = sdev->vendor_part_id;
 
 	addrconf_addr_eui48((u8 *)&attr->sys_image_guid,
-			    sdev->netdev->dev_addr);
+			    sdev->raw_gid);
 
 	return 0;
 }
@@ -218,7 +218,7 @@ int siw_query_gid(struct ib_device *base_dev, u32 port, int idx,
 
 	/* subnet_prefix == interface_id == 0; */
 	memset(gid, 0, sizeof(*gid));
-	memcpy(&gid->raw[0], sdev->netdev->dev_addr, 6);
+	memcpy(gid->raw, sdev->raw_gid, ETH_ALEN);
 
 	return 0;
 }



