Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBF61F2B45
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgFIANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgFHXTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C9ED20814;
        Mon,  8 Jun 2020 23:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658361;
        bh=Ie2mvIvkGQbdrF3H2i6PnpLXDR6Dmda2raGGfUvNt4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gpdsd84WAkctOlcNkZ4HyjuQKc19aPqKhDgktnld/SRfLuimP8rP6ghA/KZbSi2IE
         UwMphn9BmKhq8kk6VcQFwZRcSyO8coEOw3U2lqA4f4gOIoVGPohBBK/1OFKzy8rTk1
         B+q9eFRtycm3RRwjbeXngfgoDmie6b8Tcp4JlH1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 026/175] rtw88: fix an issue about leak system resources
Date:   Mon,  8 Jun 2020 19:16:19 -0400
Message-Id: <20200608231848.3366970-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit 191f6b08bfef24e1a9641eaac96ed030a7be4599 ]

the related system resources were not released when pci_iomap() return
error in the rtw_pci_io_mapping() function. add pci_release_regions() to
fix it.

Fixes: e3037485c68ec1a ("rtw88: new Realtek 802.11ac driver")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200504083442.3033-1-zhengdejin5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 77a2bdee50fa..4a43c4fa716d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -974,6 +974,7 @@ static int rtw_pci_io_mapping(struct rtw_dev *rtwdev,
 	len = pci_resource_len(pdev, bar_id);
 	rtwpci->mmap = pci_iomap(pdev, bar_id, len);
 	if (!rtwpci->mmap) {
+		pci_release_regions(pdev);
 		rtw_err(rtwdev, "failed to map pci memory\n");
 		return -ENOMEM;
 	}
-- 
2.25.1

