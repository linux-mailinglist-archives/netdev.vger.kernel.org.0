Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86458439C47
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234117AbhJYRCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234118AbhJYRCY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 13:02:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 126AB60F22;
        Mon, 25 Oct 2021 17:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635181202;
        bh=4zrUyzXuxJ9pkKXnnxIBGpTCdtmBMLCyzj2zXTJPccc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbuFw/87KJw+MZ4EHi079AwPZAETZ/QmNySmLTik+V9J1c3kxNjrmA3e0jJj4Wczn
         TmcqHXVMdMq6aEw1cJKu4UmmttoFks3QXsAS29G+3ycDu2Q6NKCQ9r025IX2fJOeIP
         UnZJQKvHlmiwdQ2gxtNaiGMR8tjqxlgbD+SlyoQaok8HT5GUoyyjklCO4gpZ7lZttN
         UbVdfzsIcYuZ26tClwUAQE4LSPX7wL7ej5Jl4NdUvQKuBgul8sf5AWi3XqCdnM1Yze
         GrSj2/DnjXW794sVS9+G9lvuDYagEvgGqnjEdoD45m8jAKu0tp7mR+/iUDWp8bULS7
         6hr2wLYm5KYvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, bjarni.jonasson@microchip.com,
        yangyingliang@huawei.com, nathan@kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 07/18] net: sparx5: Add of_node_put() before goto
Date:   Mon, 25 Oct 2021 12:59:20 -0400
Message-Id: <20211025165939.1393655-7-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211025165939.1393655-1-sashal@kernel.org>
References: <20211025165939.1393655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

[ Upstream commit d9fd7e9fccfac466fb528a783f2fc76f2982604c ]

Fix following coccicheck warning:
./drivers/net/ethernet/microchip/sparx5/s4parx5_main.c:723:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before goto

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index f666133a15de..6e9058265d43 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -743,6 +743,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 			err = dev_err_probe(sparx5->dev, PTR_ERR(serdes),
 					    "port %u: missing serdes\n",
 					    portno);
+			of_node_put(portnp);
 			goto cleanup_config;
 		}
 		config->portno = portno;
-- 
2.33.0

