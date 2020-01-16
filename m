Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CEF13E51C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390542AbgAPRMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:12:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730222AbgAPRMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34ED724696;
        Thu, 16 Jan 2020 17:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194759;
        bh=bKmCCL+nFaZVoUvGVtR+CZXLw04c6sx0it0xFjT08fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaJ3Woqd/tCNQKZsd5ARJHG6MQa6WPz9i+9Yw3yLEpjyFgPQnHohYOf3/NGywTRRL
         pu4yP0eukfYX/wOTqEMPgTk2ezF+qCNWehkQyQ/B4IQZXh2cPwo5L0s//nCSuj3HMT
         CHZPIUND9FLjrmmiONo4ohaTtoxvlR1mIalvqeGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        William Tu <u9012063@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 581/671] ip6erspan: remove the incorrect mtu limit for ip6erspan
Date:   Thu, 16 Jan 2020 12:03:39 -0500
Message-Id: <20200116170509.12787-318-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
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
index b3515a4f1303..1f2d0022ba6f 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2218,6 +2218,7 @@ static void ip6erspan_tap_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
+	dev->max_mtu = 0;
 	dev->netdev_ops = &ip6erspan_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = ip6gre_dev_free;
-- 
2.20.1

