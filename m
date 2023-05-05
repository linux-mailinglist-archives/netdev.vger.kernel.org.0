Return-Path: <netdev+bounces-600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 294286F860E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:43:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7268E1C21968
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56FE4C2E2;
	Fri,  5 May 2023 15:43:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D96BE62
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF9DC433EF;
	Fri,  5 May 2023 15:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683301402;
	bh=I+4Dxsbv/cMRqHUJKBGJuQZex4wx3fvqMLJdFCovs68=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=ghN1e2tQr1X4fgQCWvzLhbRco4DHi82qv9U960Nk9jj4nAx3mwkua3OgW9LZ00TRp
	 sPivH//k+3V0ENsUxc2Fh6q2L6les8qSlqkV6c+1faWqAYv9woxJfnJdMGWdIJBV0g
	 VDXmuqWuZvU6HTatU+2gAfwYnRO61bdt1BRZ9JgWITvTEcqyTVB5HtmiDAmjq0yxIt
	 +sB+k2GdXXAlGta6L3cfIwNv7r3TsQQPH1m6X4xwnZpGU9as5SxvqXiiOf37RbJyWb
	 yW+PCRfH/6+Pe+MURjaa7adgcBX/ufD8xd4cQ9TExSn0Wd16jYpb58YgePRHy7OdqT
	 6plxOFxBqk4ZA==
Subject: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft iWARP
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: BMT@zurich.ibm.com, tom@talpey.com
Date: Fri, 05 May 2023 11:43:11 -0400
Message-ID: 
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
In-Reply-To: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
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

In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
addresses. siw_device_create() would fall back to copying the
device's name in those cases, because an all-zero MAC address breaks
the RDMA core IP-to-device lookup mechanism.

However, in some cases, the net_device::name field is also empty.
So we're back at square one.

Rather than checking the device type, look at the
net_device::addr_len field. If it's got the right number of octets
and it is not all zeroes, use that.

Then, to enable siw support for that device/address type, change
the device driver to ensure such devices have a valid 6-octet MAC
address. For virtual devices, using eth_hw_addr_random() is
sufficient.

Fixes: a2d36b02c15d ("RDMA/siw: Enable siw on tunnel devices")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 drivers/infiniband/sw/siw/siw_main.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 65b5cda5457b..2c31bf397993 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -304,10 +304,15 @@ static const struct ib_device_ops siw_device_ops = {
 
 static struct siw_device *siw_device_create(struct net_device *netdev)
 {
+	static const u8 zeromac[ETH_ALEN] = { 0 };
 	struct siw_device *sdev = NULL;
 	struct ib_device *base_dev;
 	int rv;
 
+	if ((netdev->addr_len != ETH_ALEN) ||
+	    (memcmp(netdev->dev_addr, zeromac, ETH_ALEN) == 0))
+		return NULL;
+
 	sdev = ib_alloc_device(siw_device, base_dev);
 	if (!sdev)
 		return NULL;
@@ -316,21 +321,8 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 
 	sdev->netdev = netdev;
 
-	if (netdev->type != ARPHRD_LOOPBACK && netdev->type != ARPHRD_NONE) {
-		addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
-				    netdev->dev_addr);
-	} else {
-		/*
-		 * This device does not have a HW address,
-		 * but connection mangagement lib expects gid != 0
-		 */
-		size_t len = min_t(size_t, strlen(base_dev->name), 6);
-		char addr[6] = { };
-
-		memcpy(addr, base_dev->name, len);
-		addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
-				    addr);
-	}
+	addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
+			    netdev->dev_addr);
 
 	base_dev->uverbs_cmd_mask |= BIT_ULL(IB_USER_VERBS_CMD_POST_SEND);
 



