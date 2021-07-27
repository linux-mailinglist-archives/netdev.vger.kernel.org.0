Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370293D762A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhG0NYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236862AbhG0NUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A1661AAD;
        Tue, 27 Jul 2021 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391986;
        bh=TDI08tLR/NnGq08rpgOJHeEMoqEPTSQ5y6xMVG/q2c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dgvin16CDifLFf1ORhcCi3A4Z0sa4qkwXxAJnpgYGsy7QeYNX1LU/zk5DdHkZv/Qp
         FSudjV9B8aoqkUk19Gex0jzk3uqTyG3oid/EXjzdViWVP+AJElsgXrtsk+Z0k3Bdmr
         OHScCstO0AKgHd8lIKBNkDHkhc8kFOxNqAaDpU1Q1TmwyLbU7oYgYRVfAnh4Dx7q5p
         JdJ3mg+t3VzowrYr91Haz1k8MT0cWbTw/i6PFFtFC6CYjq4Qfz1DwIjchyenfZrMtv
         CJoMw3mNWicyuNI3vYsgUSitkf7FJIEJhEoZCrwBIw+4MygsbcHgeQsShivGB8OLcU
         +AXB1g0hCzrBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/17] r8152: Fix potential PM refcount imbalance
Date:   Tue, 27 Jul 2021 09:19:27 -0400
Message-Id: <20210727131938.834920-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131938.834920-1-sashal@kernel.org>
References: <20210727131938.834920-1-sashal@kernel.org>
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
index 95e27fb7d2c1..105622e1defa 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5282,9 +5282,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2

