Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094EA38EC54
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhEXPOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234565AbhEXPIK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 11:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA886190A;
        Mon, 24 May 2021 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867893;
        bh=L48UWyvFxi6jji9zke4DDDKrz3Dztp562eUL8ZzzxpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSaiAo4moTLMBcs1jhyyiWdFS5NjBsAB3jMi7rcbWW24ioaAH6G7RzFyYCXOES3yC
         qqKd/gu2Adyz2t7KSpi67u67RoYvia5BhV7Or7G+Gvphg9NUiAlKHxP/NzTYWXMcpq
         TB6zac+sW49ziUbXgQukCYSwo/ZMnOoOYFPVf/HZ1BuIGaUTiIob9DFYco4H/rO2CK
         xD3UoVgbjrGzWXdOwvDBtCaQLKEXnlkFJB87taaBtwylCt2S6rkRVhQYp6Ahm/UVWD
         /Yr/und6nNTY/6dd+gxhqORewvr6D8HMdYrrXQ2ZQymSClS/Lk0hT742xE8KMI+dKC
         z43Jl0rgsi4XA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/16] net: fujitsu: fix potential null-ptr-deref
Date:   Mon, 24 May 2021 10:51:16 -0400
Message-Id: <20210524145130.2499829-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145130.2499829-1-sashal@kernel.org>
References: <20210524145130.2499829-1-sashal@kernel.org>
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
index a7139f588ad2..fb1a9bd24660 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -548,6 +548,11 @@ static int fmvj18x_get_hwinfo(struct pcmcia_device *link, u_char *node_id)
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

