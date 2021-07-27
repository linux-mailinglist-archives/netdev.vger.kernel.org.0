Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314383D763E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhG0NY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237055AbhG0NWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF2AE61ABC;
        Tue, 27 Jul 2021 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392039;
        bh=oPvlV2NsK4f1ssaKBVn25F6huJX4K96v8zrnFjhoR1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCi+bFpNfx4uvNHO5zUG7UW9JL3cl7L2YMQhXyvMeN809R1GFeZim9pDFz/i3/fBU
         utfDK5ygkH6Uf14nfUlohGDZCEsmvvWUOlt+an+pbMpVS5DJH9ptb+6PBveXqRVS31
         KVPPiiWqAe2SEFGN77PvQdfnk0Nx6+jyksOamv7VF8rZ0XlpZhf8Pnxw0KDdVUpde5
         DJOaD3OK/SHFEy8PsSj44k1oQUOwUlzYNWV/+FlrKYAYmyjsEIKweM8u20rkr75nIZ
         2ov29gAPU2hBMYYh+7fLoj0wcxkyBAqOwE9mQ98dq62Z9+T6XYd6xGXOqK2XEPxjIf
         20qQJyYl5XsGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 2/3] r8152: Fix potential PM refcount imbalance
Date:   Tue, 27 Jul 2021 09:20:35 -0400
Message-Id: <20210727132036.835981-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132036.835981-1-sashal@kernel.org>
References: <20210727132036.835981-1-sashal@kernel.org>
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
index 5baaa8291624..ebf6d4cf09ea 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3159,9 +3159,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2

