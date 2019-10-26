Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0667CE5D2B
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfJZNRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:17:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbfJZNRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3CB2222BE;
        Sat, 26 Oct 2019 13:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095822;
        bh=VzRzt+ya9hGFOk9QNHrPmzOE1KFCO7G1Hf7shEKQJBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AWrhtS0Lxjix7Hpx/pVAvH7oXR4grXHaBZbh5jMoefMNM5ROEolxm+mIVZQsSkQML
         EHo6UDCcW5oDMS+0tyrSdtOZW5shzRYH8bNAgToiVIKuJrXiOwd2aJTLjE0SKbN9J7
         +YQh4PED0a9evK7YmfvoURssqi0W5VEG574GGWnM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        William Tu <u9012063@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 34/99] ip6erspan: remove the incorrect mtu limit for ip6erspan
Date:   Sat, 26 Oct 2019 09:14:55 -0400
Message-Id: <20191026131600.2507-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

[ Upstream commit 4123f637a5129470ff9d3cb00a5a4e213f2e15cc ]

ip6erspan driver calls ether_setup(), after commit 61e84623ace3
("net: centralize net_device min/max MTU checking"), the range
of mtu is [min_mtu, max_mtu], which is [68, 1500] by default.

It causes the dev mtu of the erspan device to not be greater
than 1500, this limit value is not correct for ip6erspan tap
device.

Fixes: 61e84623ace3 ("net: centralize net_device min/max MTU checking")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Acked-by: William Tu <u9012063@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index d5779d6a60650..787d9f2a6e990 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2192,6 +2192,7 @@ static void ip6erspan_tap_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
+	dev->max_mtu = 0;
 	dev->netdev_ops = &ip6erspan_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
-- 
2.20.1

