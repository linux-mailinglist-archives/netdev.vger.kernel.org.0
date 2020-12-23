Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5322E12C1
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgLWCY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730193AbgLWCYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84E66229C5;
        Wed, 23 Dec 2020 02:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690223;
        bh=Df0DxbSAYSyYMU6NKNk1/U88ie/hjegk9tYCULiAtNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0aKETvTlnWOjI7jAKw+T/7olhy6+jWSpTK9C5InuSCzbhhtCgtXNG9mF2aABv2qd
         5EKgMcgWeRtJLOMyPTaoQSl/FqptRaUcpeYM4ZH6NoS1jsULNBYA7+XcFTOQwD60rO
         UmTjtEdtt1ejY60siZaXAcEmDvxIOmTkfw2FlWNZijhk1XgrdvnIqaf7UE6t8f6aqb
         kSRgb9M7VHubQNVoOMcO8Oc7o23dMyK43xFC9xKCgqFSaLguEtLfur4yt0krYTM2mq
         fS5i0qhloe0d+FiN6K6fmjGkcIj/knkkZWWyYu2lMLiwuaLB3mCa98hTdJIh9an2Vd
         ByMnlJnW9++WQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 40/66] hv_netvsc: Validate number of allocated sub-channels
Date:   Tue, 22 Dec 2020 21:22:26 -0500
Message-Id: <20201223022253.2793452-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index aa0bbffe49005..1db34b7a423ef 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1100,6 +1100,11 @@ int rndis_set_subchannel(struct net_device *ndev, struct netvsc_device *nvdev)
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

