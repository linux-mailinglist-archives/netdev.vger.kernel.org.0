Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162C13AF2A4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhFUR4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232035AbhFURzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 706066128A;
        Mon, 21 Jun 2021 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297959;
        bh=HXZWMFTM4rc1VvbXjfrhFeBANb2/h4lWBdB8XBCt/d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXQuR0qvmvqSqE9OlD7UeeENfJnKWaxWJqoitjL4jBQu3yK2f3z+s/VsOtgexbAd3
         y7Z9uFTn3iVQFfx7g2xdE8l7JpqdaQ0QIIDl4zAxshjuZ13u6WHaRq7dq9OZuA8a9W
         PPMeuqW7yD7azj0GLBhSzvIS0vx9KtcYdAbmo/YwODwu8DqMVARs+haKJAq0Wrcl6W
         EjykRLV/FtqlbKfTl0RqhQ2X8CeqNVsAOdzMih/0ZoRrzUCK2Z4braPSkAOEmM/vSx
         w+LoA5E2xKR4X9WEdvFkAbs/xgenxekBrJGy9mmyfwTqz9XCvFSgFfv2W48lvma1i4
         dkTRDhz3px1Nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 25/39] qmi_wwan: Do not call netif_rx from rx_fixup
Date:   Mon, 21 Jun 2021 13:51:41 -0400
Message-Id: <20210621175156.735062-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

[ Upstream commit 057d49334c02a79af81c30a8d240e641bd6f1741 ]

When the QMI_WWAN_FLAG_PASS_THROUGH is set, netif_rx() is called from
qmi_wwan_rx_fixup(). When the call to netif_rx() is successful (which is
most of the time), usbnet_skb_return() is called (from rx_process()).
usbnet_skb_return() will then call netif_rx() a second time for the same
skb.

Simplify the code and avoid the redundant netif_rx() call by changing
qmi_wwan_rx_fixup() to always return 1 when QMI_WWAN_FLAG_PASS_THROUGH
is set. We then leave it up to the existing infrastructure to call
netif_rx().

Suggested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 6700f1970b24..bc55ec739af9 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -575,7 +575,7 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 
 	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
 		skb->protocol = htons(ETH_P_MAP);
-		return (netif_rx(skb) == NET_RX_SUCCESS);
+		return 1;
 	}
 
 	switch (skb->data[0] & 0xf0) {
-- 
2.30.2

