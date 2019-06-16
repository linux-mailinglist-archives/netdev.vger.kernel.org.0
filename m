Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3338475B1
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 17:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfFPPyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 11:54:41 -0400
Received: from kadath.azazel.net ([81.187.231.250]:55600 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbfFPPyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 11:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pLxt/PRVz7lVoKY2xWyunVRxavSMeR57R0akDQOSRKs=; b=EI3hw2rIl5T9ADaWw6Ej/iPXBA
        d6T9O0YF2QFKDYgKOZxx8+J3y/LjF1HAI1Ay0etWGLt8zVDNHJZEARr9uJxYfSsBUWzoNaFdx6IyW
        FzS7dROGuIY2ODgoZoVwPyUIeRey0yNNYARHkGVUphXpIOxeG45JC3V9WoOO++F4jd4E7F8+JhWWq
        xLi7+TTFWBIUjq6hqvC5mWSYy5q7T7541DdeuHVv3gg4nfaLVcV+wk9AGZUP85nRCqVvXV0DQ9Zwv
        jQoiwjr/+ITtuc6Ubfn/YeRv8Eu+L7UAc46OTIQxubcoiEBjcix6rdFDcVbMYSUCzsDQJs+EnCjb1
        bo99wARg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hcXUL-0004ow-M0; Sun, 16 Jun 2019 16:54:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+afb980676c836b4a0afa@syzkaller.appspotmail.com
Subject: [PATCH net] lapb: fixed leak of control-blocks.
Date:   Sun, 16 Jun 2019 16:54:37 +0100
Message-Id: <20190616155437.25299-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <0000000000005c5d1d0589660769@google.com>
References: <0000000000005c5d1d0589660769@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lapb_register calls lapb_create_cb, which initializes the control-
block's ref-count to one, and __lapb_insert_cb, which increments it when
adding the new block to the list of blocks.

lapb_unregister calls __lapb_remove_cb, which decrements the ref-count
when removing control-block from the list of blocks, and calls lapb_put
itself to decrement the ref-count before returning.

However, lapb_unregister also calls __lapb_devtostruct to look up the
right control-block for the given net_device, and __lapb_devtostruct
also bumps the ref-count, which means that when lapb_unregister returns
the ref-count is still 1 and the control-block is leaked.

Call lapb_put after __lapb_devtostruct to fix leak.

Reported-by: syzbot+afb980676c836b4a0afa@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/lapb/lapb_iface.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 600d754a1700..3c03f6512c5f 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -176,6 +176,7 @@ int lapb_unregister(struct net_device *dev)
 	lapb = __lapb_devtostruct(dev);
 	if (!lapb)
 		goto out;
+	lapb_put(lapb);
 
 	lapb_stop_t1timer(lapb);
 	lapb_stop_t2timer(lapb);
-- 
2.20.1

