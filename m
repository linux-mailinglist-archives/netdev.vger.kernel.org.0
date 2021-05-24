Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BB538EC35
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhEXPMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:12:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhEXPGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 11:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39E416162C;
        Mon, 24 May 2021 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867871;
        bh=V0QDUYX5OnRqA3JrdUeP+0VbvLODVnGZUntGH/PKvOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCqZ18rf4vCy4P28++JLKL8sczOC+3NaBBgeqCrGLhgPqXumrKFcw77bWcqRw/QsG
         bi0ucumQTSXJW1b72exaz2WMVjkBuFcNsJYZZX9fgbMdvMyrXx3p6aOGLlrr1zTyJl
         9NAmG3CBqQ5qmDxJ8KS5/LVz2w+HcSnxNNz+oTxgeMejo+83QcUWrMXkhaCeB6F9zQ
         sQhb+aj00oO+ynSDh1xnt3cyQQmplCf1AX/MhjZ9AIzBBj5C887ukYBPhMAwwC5/1j
         OUff3iHxCfFCnCBBRotkcfVk0nIcGefzCqQDi5FjTH8VvwtoRdi30iVnnvCF+7lIrk
         M21b99ZaWYLnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/19] net: fujitsu: fix potential null-ptr-deref
Date:   Mon, 24 May 2021 10:50:50 -0400
Message-Id: <20210524145106.2499571-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145106.2499571-1-sashal@kernel.org>
References: <20210524145106.2499571-1-sashal@kernel.org>
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
index 399cfd217288..cfda55bfa811 100644
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

