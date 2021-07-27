Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA393D7661
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbhG0N2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236967AbhG0NUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0875661A3B;
        Tue, 27 Jul 2021 13:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392019;
        bh=oVrKdfA6ZQxpCEUMlh/V5PyuyRGyRC/s/8TGW3qsUYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9TVHvX5foMAnuruxjCVwQSaZyW3mPNkxS4GcRhjdGkbhpJHX0dBTH3kN4AY2Vw7z
         qRr/qG881V+KWL7/jUEFvR8A1AwiLduenoWBn5ppLn4zgIY8poYP7u0n4fCAAy339T
         2O/nRxioMdPcoqzOmJyIFyJZ/tCMeV2ekPLWz2VaBc+LS1jepPIkDwCHLH40pXQ1Hx
         ltshDod/kmVrx9LDW5pzmq0FWn+0KfHUBBwba+RfHmV0/f0g9E5NyiVcYxHhl4bpHb
         GH+Dg5/8ajFq+WwZkjkgl/zWr4DiipZFz6NSVD1yW9Bunr2x2HNiqPyUMb76TkVzB+
         ar0ljBRY0DXhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/6] r8152: Fix potential PM refcount imbalance
Date:   Tue, 27 Jul 2021 09:20:12 -0400
Message-Id: <20210727132015.835651-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132015.835651-1-sashal@kernel.org>
References: <20210727132015.835651-1-sashal@kernel.org>
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
index 726fb5561a0f..4764e4f54cef 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3960,9 +3960,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2

