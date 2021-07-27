Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5100F3D7638
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhG0NZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237019AbhG0NWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 935CD61AA3;
        Tue, 27 Jul 2021 13:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392027;
        bh=nkadAqFC6N6e3FztxYq8/NmSdB2on2QZ953tiE7PvUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=peYFhBA4YR0bjbrVNx+DJAm/wiS0rsGmeGxU5nND4X9EGLgyfr+1R4M6pytg58hZR
         WgZAKsmVtH9J6nKmorZP6nq5HKKc+8JWxoqickYn7HmRGcBOcN/+JPtmgx4FizRVAP
         LGZKFfx48Vvqzo/B7oBK+6YHna7A6HS4Wbka9/pcSBNP7R2+3pIzt/iv06lninF328
         mWvv6sLcN9um1atld2DVDdHTP8Zt/HbclNo2iCmrwxaDgtftnPwbuFM8saEdoFvpnG
         kE+o6bBcaCLTGVxiRjCTilqOcSR31OLsHN9+0h+XUyX014FcbNzel4eBlA/sC7CSKo
         V+mtR7paYjpOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 2/5] r8152: Fix potential PM refcount imbalance
Date:   Tue, 27 Jul 2021 09:20:21 -0400
Message-Id: <20210727132024.835810-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132024.835810-1-sashal@kernel.org>
References: <20210727132024.835810-1-sashal@kernel.org>
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
index 8da3c891c9e8..a5a4fef09b93 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3953,9 +3953,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2

