Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E215BF9
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfEGFgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbfEGFgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:36:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8534720989;
        Tue,  7 May 2019 05:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207404;
        bh=OqokL3GaFvL/RYQ0/pqR9m4PkWqMIWIuV1si0M+F5Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hg12NFCTxMnGw8M7H46nebXR062ZWawCAspZquVZEDegqtfGnK1ed+kFE68X4zygr
         7t9AUWmHKOxYsqG1sfRb7qAQwHaRwF2EtfL/5kQ5A76yPRpdvaZr29hKdkoaqnE6E6
         sD5wzPMTni3OZp7l9jKaz1WxQMoaNsqdPXd03SWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 25/81] vxge: fix return of a free'd memblock on a failed dma mapping
Date:   Tue,  7 May 2019 01:34:56 -0400
Message-Id: <20190507053554.30848-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0a2c34f18c94b596562bf3d019fceab998b8b584 ]

Currently if a pci dma mapping failure is detected a free'd
memblock address is returned rather than a NULL (that indicates
an error). Fix this by ensuring NULL is returned on this error case.

Addresses-Coverity: ("Use after free")
Fixes: 528f727279ae ("vxge: code cleanup and reorganization")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.c b/drivers/net/ethernet/neterion/vxge/vxge-config.c
index bf4302e45dcd..28f765664702 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.c
@@ -2365,6 +2365,7 @@ static void *__vxge_hw_blockpool_malloc(struct __vxge_hw_device *devh, u32 size,
 				dma_object->addr))) {
 			vxge_os_dma_free(devh->pdev, memblock,
 				&dma_object->acc_handle);
+			memblock = NULL;
 			goto exit;
 		}
 
-- 
2.20.1

