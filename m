Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D332E150A
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgLWCqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729648AbgLWCWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5CDA23333;
        Wed, 23 Dec 2020 02:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690123;
        bh=JP2cc1mevuJN2u/L90j9fjZKBXCwLkJWQ6uizVILycE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0C0jq/LNsLEiVwjy3fOnM+AcwY4k/uERzdt+1XYwyjTLRf9Iox0jC67l5+HoTAuo
         TDMNJwvIzH5YqQwwwJjd2ATE1Symkuw1+S8jwyZiAucTIxG+Dy2nz520FREEJJz4BF
         zVmXDg/mGrfft2pI3gRDYxrpUE3hVOEGr2AgGwcuWopznD/rIFiwvYHmMC0MvG6l4N
         By6yyGD7QaZr8g4p4UHm9cOXPyGQRBa19qAaixogTYuBDlGlpb9KybtwXbsy6iHMoW
         waQ/IwwFNW+l4y4yoWy3kXsQBp/Mfotj3X1r1IlFP0yong4hsT1AGlF/aNdWU9ZsPa
         QiCSPWmgpJdpg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 48/87] hv_netvsc: Validate number of allocated sub-channels
Date:   Tue, 22 Dec 2020 21:20:24 -0500
Message-Id: <20201223022103.2792705-48-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>

[ Upstream commit 206ad34d52a2f1205c84d08c12fc116aad0eb407 ]

Lack of validation could lead to out-of-bound reads and information
leaks (cf. usage of nvdev->chan_table[]).  Check that the number of
allocated sub-channels fits into the expected range.

Suggested-by: Saruhan Karademir <skarade@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/20201118153310.112404-1-parri.andrea@gmail.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/rndis_filter.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index dd91834f841d5..1554d4fa0bb08 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1111,6 +1111,11 @@ int rndis_set_subchannel(struct net_device *ndev,
 		return -EIO;
 	}
 
+	/* Check that number of allocated sub channel is within the expected range */
+	if (init_packet->msg.v5_msg.subchn_comp.num_subchannels > nvdev->num_chn - 1) {
+		netdev_err(ndev, "invalid number of allocated sub channel\n");
+		return -EINVAL;
+	}
 	nvdev->num_chn = 1 +
 		init_packet->msg.v5_msg.subchn_comp.num_subchannels;
 
-- 
2.27.0

