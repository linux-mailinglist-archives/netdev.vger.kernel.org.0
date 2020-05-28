Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6031E5F5D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 14:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389156AbgE1MBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 08:01:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389131AbgE1L54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 07:57:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A481C21655;
        Thu, 28 May 2020 11:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590667076;
        bh=Ofyy/pFlu4cgxy1yF12JiX34gIAbjw97Qwq6M95okwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHaPjhfxEbGzAhvkUxb8ismdT1w08z4B9E1kUKvbKKAKoqbqaGacJIJb9qUQit7zz
         mUm5MZli0h7BJHqdSvL10j8RqVSWLpBvxCUvJWUmpW2p2kPzj4yAj8S97QPz3HH/Er
         R3K6a8URaqnpOkGInvMTKuI0LJQYLGXYqOLKxfwo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/13] net: sun: fix missing release regions in cas_init_one().
Date:   Thu, 28 May 2020 07:57:41 -0400
Message-Id: <20200528115744.1406533-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200528115744.1406533-1-sashal@kernel.org>
References: <20200528115744.1406533-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 5a730153984dd13f82ffae93d7170d76eba204e9 ]

In cas_init_one(), "pdev" is requested by "pci_request_regions", but it
was not released after a call of the function “pci_write_config_byte”
failed. Thus replace the jump target “err_write_cacheline” by
"err_out_free_res".

Fixes: 1f26dac32057 ("[NET]: Add Sun Cassini driver.")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/cassini.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 382993c1561c..7e5c0f182770 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -4983,7 +4983,7 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					  cas_cacheline_size)) {
 			dev_err(&pdev->dev, "Could not set PCI cache "
 			       "line size\n");
-			goto err_write_cacheline;
+			goto err_out_free_res;
 		}
 	}
 #endif
@@ -5158,7 +5158,6 @@ err_out_iounmap:
 err_out_free_res:
 	pci_release_regions(pdev);
 
-err_write_cacheline:
 	/* Try to restore it in case the error occurred after we
 	 * set it.
 	 */
-- 
2.25.1

