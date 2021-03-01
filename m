Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3237327D02
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 12:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhCALUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 06:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhCALTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 06:19:24 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4C6C06121D
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 03:18:42 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id l12so20132363edt.3
        for <netdev@vger.kernel.org>; Mon, 01 Mar 2021 03:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=68Pi3ZfOgUhzARIUi2t3kfkoKLegX+yuIQD0xCOE/lo=;
        b=NwWOzYOJFr+FpwevzAvEVYW3heEligYM3Vzp9sL0X8Wkio5ReToFf1VdcvWnGzks5O
         gXUzi/MchT1/hlVUgDHT2EYUCzXaHhUWHPJIi2mOz6r11hRx8Ka9hrxi3fg3UbNeA41b
         GEQCbFkQdyBEFju5z1Yxc3WvUgiZR5e5uiHeNH3W7saBgaGGodFlq+n/nM7OXoQ9Quym
         JO7mPDCb+naN9UBrGO+JcdvZJ2bphvjW6Bd2kFOZ0fs4rAra+fOGb261gS/9H7fkm0/X
         d454Istnryq8oBXfMo3wPsG7Yp4E+nGoeMr6wxo3FGYW8bVmQuF61mZRc4SnOZ/iW8kU
         oN0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=68Pi3ZfOgUhzARIUi2t3kfkoKLegX+yuIQD0xCOE/lo=;
        b=eSJZpLGEnTuo0l/SHsOWSA2owYERH1i7KNBDvnKlFkzNgCfdLInewT1q3ZwXrrRgfx
         BdLpdKOGB23hNpJJNye9s3IKKE/DZynmxqwLgp214dPF6zExABtnuaNvXuf80tS4+ak3
         i/P5K8cGLGv5sK/KNu7CFJkmWVh6vZ3zoveyU7ldLbMsbH6A+bNAPSGnmqkzlooGS3Z4
         h0lq5T7VeBrL/2/OcjFTesmQM1UCjjmCT73MjLQuLvpVwGZISQlR5S3bp1JftWGWt88O
         kBK7OwAPGHPgE0lzNkA2CQlstMAQnNgjEG3FiaykbjoGPLYRwo+4eKiwixdWOer2qKhm
         3vbQ==
X-Gm-Message-State: AOAM533ayxVIHY3B13IMxDP+mH6d25oPSV+KVT6YEpjOXvAXdFk76O02
        PzjTaMzCg/PF6MrfjAzPvGk=
X-Google-Smtp-Source: ABdhPJx+PcUtc8Y5FBw2hdAhHJDM/n5f7hddXhbOiPglQyluKhLWOuYhSU1D03GuDgVEpxFhyjgCNQ==
X-Received: by 2002:a50:e0c3:: with SMTP id j3mr16401349edl.32.1614597520784;
        Mon, 01 Mar 2021 03:18:40 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id i13sm13586491ejj.2.2021.03.01.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 03:18:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net 7/8] net: enetc: remove bogus write to SIRXIDR from enetc_setup_rxbdr
Date:   Mon,  1 Mar 2021 13:18:17 +0200
Message-Id: <20210301111818.2081582-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210301111818.2081582-1-olteanv@gmail.com>
References: <20210301111818.2081582-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Station Interface Receive Interrupt Detect Register (SIRXIDR)
contains a 16-bit wide mask of 'interrupt detected' events for each ring
associated with a port. Bit i is write-1-to-clean for RX ring i.

I have no explanation whatsoever how this line of code came to be
inserted in the blamed commit. I checked the downstream versions of that
patch and none of them have it.

The somewhat comical aspect of it is that we're writing a binary number
to the SIRXIDR register, which is derived from enetc_bd_unused(rx_ring).
Since the RX rings have 512 buffer descriptors, we end up writing 511 to
this register, which is 0x1ff, so we are effectively clearing the
'interrupt detected' event for rings 0-8.

This register is not what is used for interrupt handling though - it
only provides a summary for the entire SI. The hardware provides one
separate Interrupt Detect Register per RX ring, which auto-clears upon
read. So there doesn't seem to be any adverse effect caused by this
bogus write.

There is, however, one reason why this should be handled as a bugfix:
next_to_clean _should_ be committed to hardware, just not to that
register, and this was obscuring the fact that it wasn't. This is fixed
in the next patch, and removing the bogus line now allows the fix patch
to be backported beyond that point.

Fixes: fd5736bf9f23 ("enetc: Workaround for MDIO register access issue")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new.

 drivers/net/ethernet/freescale/enetc/enetc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 8ddf0cdc37a5..abb29ee81463 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1212,7 +1212,6 @@ static void enetc_setup_rxbdr(struct enetc_hw *hw, struct enetc_bdr *rx_ring)
 	rx_ring->idr = hw->reg + ENETC_SIRXIDR;
 
 	enetc_refill_rx_ring(rx_ring, enetc_bd_unused(rx_ring));
-	enetc_wr(hw, ENETC_SIRXIDR, rx_ring->next_to_use);
 
 	/* enable ring */
 	enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
-- 
2.25.1

