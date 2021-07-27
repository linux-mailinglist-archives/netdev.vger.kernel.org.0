Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C843D7635
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhG0NZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237047AbhG0NWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05F7A61AAB;
        Tue, 27 Jul 2021 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392034;
        bh=RYv/LVHPl7XhcSxojrBThWSp24asBCQfMCmUPKws9QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uRGs7g3VHISVY/vCJEgqXaJsTIYUlQagmT7FCbCj2I+b4Bx28/E1D8CM2iYNRSPaX
         WQONIj0sqyvFI0FNtgGMwon0blmDva9OTvA9JQAX5/K1mWLnsybzaExl6d5nsgt9DY
         zatfXwqVzwi9KrvTn0DwWiXXlZOZYirXfLwpMgRyWEewPsnAjcpVAF8VJ27EKjD34Q
         vG6BzrbWq7T7pB/V3Nl2Eoai6OukKbrSAiBPzn4Un3vGRjgDuUTKxiN7rMrHCiPRTU
         UIzShEAhbmtKsRsZGhy6XdnT2xQ/fKwNZr7CWDVXBxgVyORdA05C06bo3CsEu4RooV
         KJq+BbAzTEX2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/3] r8152: Fix potential PM refcount imbalance
Date:   Tue, 27 Jul 2021 09:20:30 -0400
Message-Id: <20210727132031.835904-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132031.835904-1-sashal@kernel.org>
References: <20210727132031.835904-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9c23aa51477a37f8b56c3c40192248db0663c196 ]

rtl8152_close() takes the refcount via usb_autopm_get_interface() but
it doesn't release when RTL8152_UNPLUG test hits.  This may lead to
the imbalance of PM refcount.  This patch addresses it.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1186194
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 64fdea332886..96f6edcb0062 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3347,9 +3347,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2

