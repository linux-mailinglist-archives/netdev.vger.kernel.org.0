Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCD2159275
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgBKPBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:01:04 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:34135 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728073AbgBKPBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 10:01:04 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id fd2ff95a;
        Tue, 11 Feb 2020 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=NgYNluWNYqWNVHMj35wM6xWxZ
        C8=; b=v8KFWqsG11SdrabGPR4/nCpLE+sunMJ+WWqTY7MuLRQARDkGNdaBVpP89
        2aABUldklrgfWICX1HZwygd2/bp/eFoWy8XC33Zcat3WwyEJbOl77g2e9ODjUHQn
        P/S3w4DB5N7ldLFDeKCgljfKMJ0TCyfZHXsrzdwTkFoX0G/7QWZjhfBSavFXXBUU
        NLs1xMTUfnuBdxAlP/0k+zhtMG00FgRJvkLhBrKZeRAJ4OVXp7zBXT19FvWKAqSK
        sQrVPyKUvN3TVnZlO+HseKULGosU15VMkjpbD5TNRSi3jVyROb466NoYiHh/zbMH
        yOIzOEE7+FquKnBu7wIIT5JUmC81w==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a45e62b6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 11 Feb 2020 14:59:18 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>
Subject: [PATCH v3 net 9/9] benet: remove skb_share_check from xmit path
Date:   Tue, 11 Feb 2020 16:00:28 +0100
Message-Id: <20200211150028.688073-10-Jason@zx2c4.com>
In-Reply-To: <20200211150028.688073-1-Jason@zx2c4.com>
References: <20200210141423.173790-2-Jason@zx2c4.com>
 <20200211150028.688073-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an impossible condition to reach; an skb in ndo_start_xmit won't
be shared by definition.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Sathya Perla <sathya.perla@broadcom.com>
Cc: Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: Somnath Kotur <somnath.kotur@broadcom.com>
Link: https://lore.kernel.org/netdev/CAHmME9pk8HEFRq_mBeatNbwXTx7UEfiQ_HG_+Lyz7E+80GmbSA@mail.gmail.com/
---
 drivers/net/ethernet/emulex/benet/be_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 56f59db6ebf2..8b797adb3065 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1048,10 +1048,6 @@ static struct sk_buff *be_insert_vlan_in_pkt(struct be_adapter *adapter,
 	bool insert_vlan = false;
 	u16 vlan_tag = 0;
 
-	skb = skb_share_check(skb, GFP_ATOMIC);
-	if (unlikely(!skb))
-		return skb;
-
 	if (skb_vlan_tag_present(skb)) {
 		vlan_tag = be_get_tx_vlan_tag(adapter, skb);
 		insert_vlan = true;
-- 
2.25.0

