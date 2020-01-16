Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B4B13F968
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgAPQwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730170AbgAPQwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:52:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5959A21D56;
        Thu, 16 Jan 2020 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193559;
        bh=7X9djXMRPZ2MDbznjcbp/fyubI824GSoLXtTbSgovWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKOXLLo3/rHPeUtXP0BlNGXPvBTQbr5sMC2gpTjuvblBIojTgFHoCXFu1xr9NBwWq
         XA54ajZyB9Qpwh+j0/00vDtXG2Gl/BeOOVTLKzC6D/Xd4YdYq8Vun8XPFM2jNs6ZDE
         BKj72XBwgWCQ9n4FpxzXTcxkIqECyLQImQMvrGEk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>, wbob <wbob@jify.de>,
        Roman Yeryomin <roman@advem.lv>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 104/205] rt2800: remove errornous duplicate condition
Date:   Thu, 16 Jan 2020 11:41:19 -0500
Message-Id: <20200116164300.6705-104-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit a1f7c2cabf701a17b1a05d6526bbdadc3d05e05c ]

On 2019-10-28 06:07, wbob wrote:
> Hello Roman,
>
> while reading around drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> I stumbled on what I think is an edit of yours made in error in march
> 2017:
>
> https://github.com/torvalds/linux/commit/41977e86#diff-dae5dc10da180f3b055809a48118e18aR5281
>
> RT6352 in line 5281 should not have been introduced as the "else if"
> below line 5291 can then not take effect for a RT6352 device. Another
> possibility is for line 5291 to be not for RT6352, but this seems
> very unlikely. Are you able to clarify still after this substantial time?
>
> 5277: static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
> ...
> 5279:  } else if (rt2x00_rt(rt2x00dev, RT5390) ||
> 5280:         rt2x00_rt(rt2x00dev, RT5392) ||
> 5281:         rt2x00_rt(rt2x00dev, RT6352)) {
> ...
> 5291:  } else if (rt2x00_rt(rt2x00dev, RT6352)) {
> ...

Hence remove errornous line 5281 to make the driver actually
execute the correct initialization routine for MT7620 chips.

As it was requested by Stanislaw Gruszka remove setting values of
MIMO_PS_CFG and TX_PIN_CFG. MIMO_PS_CFG is responsible for MIMO
power-safe mode (which is disabled), hence we can drop setting it.
TX_PIN_CFG is set correctly in other functions, and as setting this
value breaks some devices, rather don't set it here during init, but
only modify it later on.

Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
Reported-by: wbob <wbob@jify.de>
Reported-by: Roman Yeryomin <roman@advem.lv>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index f1cdcd61c54a..c99f1912e266 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5839,8 +5839,7 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_0, 0x8000fc21);
 		rt2800_register_write(rt2x00dev, TX_TXBF_CFG_3, 0x00009c40);
 	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-		   rt2x00_rt(rt2x00dev, RT5392) ||
-		   rt2x00_rt(rt2x00dev, RT6352)) {
+		   rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
@@ -5854,8 +5853,6 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000401);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x000C0000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
-		rt2800_register_write(rt2x00dev, MIMO_PS_CFG, 0x00000002);
-		rt2800_register_write(rt2x00dev, TX_PIN_CFG, 0x00150F0F);
 		rt2800_register_write(rt2x00dev, TX_ALC_VGA3, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX0_BB_GAIN_ATTEN, 0x0);
 		rt2800_register_write(rt2x00dev, TX1_BB_GAIN_ATTEN, 0x0);
-- 
2.20.1

