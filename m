Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3679738E962
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233299AbhEXOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233260AbhEXOsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:48:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31438613B0;
        Mon, 24 May 2021 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867612;
        bh=v6OOnt1SXHiN/AItB/mVsWX4OlFRu1mfmCztys9CYok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaCG0fTIBOgnWEA0QCnPVUOs1OhPOiuGf11rnHnADSHLFEBr8lLnJFyTacQZyu6d6
         vTOmEkHIfeL2/s5/oYlXV8gn9jZm8V5UIPAH7xOj2VyF4pZKLe0ean9CjAiUoWKZno
         b5pcbQujx+jMhTba77PjwTze5QhRfluYmVKDVVug8F/YaUJRQGhM7+ijDYUtUVvwvm
         SwVu//EZdVPg+jQZ+n9dlKzmf1X8GWhDB/Ro+Y0HnrH2y/x5+PrCGE/be4E7pW+GPr
         LdKd/+9N60AXAcWmRHpiJKUdqa588kq/M1cKYThk8yjd7FyGfR38NOUq10E+YdFPhB
         Ebf/Z92r5fs6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 24/63] isdn: mISDN: correctly handle ph_info allocation failure in hfcsusb_ph_info
Date:   Mon, 24 May 2021 10:45:41 -0400
Message-Id: <20210524144620.2497249-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit 5265db2ccc735e2783b790d6c19fb5cee8c025ed ]

Modify return type of hfcusb_ph_info to int, so that we can pass error
value up the call stack when allocation of ph_info fails. Also change
three of four call sites to actually account for the memory failure.
The fourth, in ph_state_nt, is infeasible to change as it is in turn
called by ph_state which is used as a function pointer argument to
mISDN_initdchannel, which would necessitate changing its signature
and updating all the places where it is used (too many).

Fixes original flawed commit (38d22659803a) from the University of
Minnesota.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-48-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 4bb470d3963d..cd5642cef01f 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -46,7 +46,7 @@ static void hfcsusb_start_endpoint(struct hfcsusb *hw, int channel);
 static void hfcsusb_stop_endpoint(struct hfcsusb *hw, int channel);
 static int  hfcsusb_setup_bch(struct bchannel *bch, int protocol);
 static void deactivate_bchannel(struct bchannel *bch);
-static void hfcsusb_ph_info(struct hfcsusb *hw);
+static int  hfcsusb_ph_info(struct hfcsusb *hw);
 
 /* start next background transfer for control channel */
 static void
@@ -241,7 +241,7 @@ hfcusb_l2l1B(struct mISDNchannel *ch, struct sk_buff *skb)
  * send full D/B channel status information
  * as MPH_INFORMATION_IND
  */
-static void
+static int
 hfcsusb_ph_info(struct hfcsusb *hw)
 {
 	struct ph_info *phi;
@@ -249,6 +249,9 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 	int i;
 
 	phi = kzalloc(struct_size(phi, bch, dch->dev.nrbchan), GFP_ATOMIC);
+	if (!phi)
+		return -ENOMEM;
+
 	phi->dch.ch.protocol = hw->protocol;
 	phi->dch.ch.Flags = dch->Flags;
 	phi->dch.state = dch->state;
@@ -260,6 +263,8 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 	_queue_data(&dch->dev.D, MPH_INFORMATION_IND, MISDN_ID_ANY,
 		    struct_size(phi, bch, dch->dev.nrbchan), phi, GFP_ATOMIC);
 	kfree(phi);
+
+	return 0;
 }
 
 /*
@@ -344,8 +349,7 @@ hfcusb_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 			ret = l1_event(dch->l1, hh->prim);
 		break;
 	case MPH_INFORMATION_REQ:
-		hfcsusb_ph_info(hw);
-		ret = 0;
+		ret = hfcsusb_ph_info(hw);
 		break;
 	}
 
@@ -400,8 +404,7 @@ hfc_l1callback(struct dchannel *dch, u_int cmd)
 			       hw->name, __func__, cmd);
 		return -1;
 	}
-	hfcsusb_ph_info(hw);
-	return 0;
+	return hfcsusb_ph_info(hw);
 }
 
 static int
@@ -743,8 +746,7 @@ hfcsusb_setup_bch(struct bchannel *bch, int protocol)
 			handle_led(hw, (bch->nr == 1) ? LED_B1_OFF :
 				   LED_B2_OFF);
 	}
-	hfcsusb_ph_info(hw);
-	return 0;
+	return hfcsusb_ph_info(hw);
 }
 
 static void
-- 
2.30.2

