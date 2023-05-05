Return-Path: <netdev+bounces-597-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6B56F8606
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68C371C21948
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:42:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAA4CC12D;
	Fri,  5 May 2023 15:42:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757BF8BE0
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 15:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7384C433EF;
	Fri,  5 May 2023 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683301349;
	bh=ndKw3M3u+9Ev/+6Q02FJjDEkuTYXoWl+xEOrU4Avl9o=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=PAl/o3OLb105NkwdVpYZpx+yKgouWOl8pBLFBXuOIZqKvnXgw2RhYlYcyVH7cQ/4t
	 a/OQBK/hfdk97Mn91lurJYxd6qG1JT0t+XxEy5M4MClJ9LSsEPc3yOdlHKuqxILC0v
	 bIGb7sbYaIeN5wKluAJBt1YSRKiVqJmINkuv0jq5lFYGCBs+Lan4QWSA3Kbngy5Ubv
	 qDZCNeJyAQXahQWf3ztodRAyRllKumQE1PlmIuDysQqYKZ6PcKnKfBmdnTV32IxkfM
	 eXqMH54SAcX7pwdesJYmHaIk4uyRJi8gHNgTiC+KmK6k92/ieOi62henoJhq3zgjtX
	 omU/g5wJgFl0Q==
Subject: [PATCH RFC 1/3] net/tun: Ensure tun devices have a MAC address
From: Chuck Lever <cel@kernel.org>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: BMT@zurich.ibm.com, tom@talpey.com
Date: Fri, 05 May 2023 11:42:17 -0400
Message-ID: 
 <168330132769.5953.7109360341846745035.stgit@oracle-102.nfsv4bat.org>
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

A non-zero MAC address enables a network device to be assigned as
the underlying device for a virtual RDMA device. Without a non-
zero MAC address, cma_acquire_dev_by_src_ip() is unable to find the
underlying egress device that corresponds to a source IP address,
and rdma_resolve_address() fails.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 drivers/net/tun.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d4d0a41a905a..da85abfcd254 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1384,7 +1384,7 @@ static void tun_net_initialize(struct net_device *dev)
 
 		/* Point-to-Point TUN Device */
 		dev->hard_header_len = 0;
-		dev->addr_len = 0;
+		dev->addr_len = ETH_ALEN;
 		dev->mtu = 1500;
 
 		/* Zero header length */
@@ -1399,8 +1399,6 @@ static void tun_net_initialize(struct net_device *dev)
 		dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 		dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-		eth_hw_addr_random(dev);
-
 		/* Currently tun does not support XDP, only tap does. */
 		dev->xdp_features = NETDEV_XDP_ACT_BASIC |
 				    NETDEV_XDP_ACT_REDIRECT |
@@ -1409,6 +1407,8 @@ static void tun_net_initialize(struct net_device *dev)
 		break;
 	}
 
+	eth_hw_addr_random(dev);
+
 	dev->min_mtu = MIN_MTU;
 	dev->max_mtu = MAX_MTU - dev->hard_header_len;
 }



