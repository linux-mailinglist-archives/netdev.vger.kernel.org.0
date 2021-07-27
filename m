Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0ACE3D75F6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbhG0NUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236740AbhG0NTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E32B261A6E;
        Tue, 27 Jul 2021 13:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391958;
        bh=SGAxoX3bhykzeVNJBCU4wVtmlae3jXe/7YOcP5gwH3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxZHyz92LcgC3pdv07zsGZ90iPmpYGLmqIOHTPMgl/TG0JfvJyPlI27hTnNEXMqUh
         90gPTMAy+byERrGeNSY8XvWy9Az42q72Ndj7oUYQW0c7SCB1oXw7cK/l26Lz/sAkRw
         ZU5kq0vJ5vuQxYsx1Qo0w+1CV85MW6HFwyWy3qiHFxEXti2Vx9wfQZIMLr4Ir24gFw
         UkbmxGESDnxhjeXNDKkVsBeIkC9LqW16f/UUGEiiam/2q4XkGfjchT46yF6+a9YkVe
         IYK477garbu+w1OFvI/pmtdSBLbf+nfDE9vHw1xD4KTfoZm0id1+orMxH9dp7vut7c
         /4UcN3DQgq/+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 07/21] r8152: Fix potential PM refcount imbalance
Date:   Tue, 27 Jul 2021 09:18:54 -0400
Message-Id: <20210727131908.834086-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
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
index e25bfb7021ed..8dcc55e4a5bc 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6761,9 +6761,10 @@ static int rtl8152_close(struct net_device *netdev)
 		tp->rtl_ops.down(tp);
 
 		mutex_unlock(&tp->control);
+	}
 
+	if (!res)
 		usb_autopm_put_interface(tp->intf);
-	}
 
 	free_all_mem(tp);
 
-- 
2.30.2

