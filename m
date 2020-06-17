Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F2F1FD95B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 01:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgFQXKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 19:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgFQXKg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 19:10:36 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81F920734;
        Wed, 17 Jun 2020 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592435436;
        bh=iTeb2kX7xW5oxSvw8/1TZw92wiNZyuS3Q+0H+TGM910=;
        h=Date:From:To:Cc:Subject:From;
        b=l6RrJcxukVy+IEcXGhwAhUOUvaBegt20gGWOi5dMiBQiFybwYJDjSjY2b9Ia31kBG
         trEeegmcSRzMNG4hUL7ZtPmevX7JB/D1t9I+23sRtYZTnZvPo9OGQXGb886Py5S9s2
         PcHb2JDprgx3zpoAILbgq8tvv0uRsuN22gYG4/P0=
Date:   Wed, 17 Jun 2020 18:15:57 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Karsten Keil <isdn@linux-pingi.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] mISDN: hfcsusb: Use struct_size() helper
Message-ID: <20200617231557.GA1539@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 621364bb6b12..4274906f8654 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -261,8 +261,7 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 		phi->bch[i].Flags = hw->bch[i].Flags;
 	}
 	_queue_data(&dch->dev.D, MPH_INFORMATION_IND, MISDN_ID_ANY,
-		    sizeof(struct ph_info_dch) + dch->dev.nrbchan *
-		    sizeof(struct ph_info_ch), phi, GFP_ATOMIC);
+		    struct_size(phi, bch, dch->dev.nrbchan), phi, GFP_ATOMIC);
 	kfree(phi);
 }
 
-- 
2.27.0

