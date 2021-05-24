Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3585138EA3C
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhEXOxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233397AbhEXOvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB0D26140F;
        Mon, 24 May 2021 14:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867675;
        bh=3Dbt6QMFQJ+5uUFwcM6yTQ8Yvxyht9pncCIVnfvtdLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayFm5Jut8NYrUYWUg9BMib5GVrBp0/IJAbceGG1OzEfgWZVOcExR1+LT9SdA6kVAv
         bUm6OOuVOXgubCXMDk2Y+ZKJuZ83qFqcfJDm5UdhIZjS3LnPFlFbEQINajPeIvdEe8
         DKX1ZM1AyYJiQ1YIr3K0p26afJbGaU0JK7lqTC27PXIdeG3zTAhwXq1cx1OpGCHtkr
         /IDr2kHmrRNqgNLowXS4EpyVpy4TVHcjbBCyv4V6GVLR7g5bEwDKs5JHLgE3uRDc0k
         XE8Uqb36MGs5e8DZJKNLjGWggIk8kN06p+1Ab+bhfn2TFxWCJY0CjtwwPgQ8+xdP8M
         J12SB2d+tXFuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/62] net: fujitsu: fix potential null-ptr-deref
Date:   Mon, 24 May 2021 10:46:50 -0400
Message-Id: <20210524144744.2497894-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

[ Upstream commit 52202be1cd996cde6e8969a128dc27ee45a7cb5e ]

In fmvj18x_get_hwinfo(), if ioremap fails there will be NULL pointer
deref. To fix this, check the return value of ioremap and return -1
to the caller in case of failure.

Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-16-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index dc90c61fc827..b0c0504950d8 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -547,6 +547,11 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link, u_char *node_id)
 	return -1;
 
     base = ioremap(link->resource[2]->start, resource_size(link->resource[2]));
+    if (!base) {
+	pcmcia_release_window(link, link->resource[2]);
+	return -1;
+    }
+
     pcmcia_map_mem_page(link, link->resource[2], 0);
 
     /*
-- 
2.30.2

