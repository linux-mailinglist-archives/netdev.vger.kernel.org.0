Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9F3BCD03
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhGFLUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhGFLT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43B2361C43;
        Tue,  6 Jul 2021 11:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570211;
        bh=jm0JWmxGcpKQuILz7gY4zT/faOtsrR7J5SxL68SHXzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tl3ItFtqmu5JIzHcu8JBzWg5GgUfFtaxCFZ94J9oRLOMGJoaSs4PVfcedQbNfa5Gy
         8JZRxi5VLiWi9Y5+J9EfnoM5ysGbzeNjwD7ovQolLdZSsh/GZ33GtEkVxSHoTMSbiS
         FtHovrjaVyRvYIf3u9Si72hyOe+WWNo2N8jxqyexkJMy3kCQ1iolLa5gdtFBoYX2E9
         EwHkqTc3SUqB9+7KCrjFBiAUEfJj87nJxCpIhxUQ5fCTRuJ6O35zcX02vW4b+NbYbe
         3Z0gdTxpf/DR1OJ3gScxCzf9/DJ8Szw3iDI4lRV422uCq9nDBATOelIClFE+X2TxXB
         U0odh7LMGVF2Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 120/189] ice: fix incorrect payload indicator on PTYPE
Date:   Tue,  6 Jul 2021 07:13:00 -0400
Message-Id: <20210706111409.2058071-120-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 638a0c8c8861cb8a3b54203e632ea5dcc23d8ca5 ]

The entry for PTYPE 90 indicates that the payload is layer 3. This does
not match the specification in the datasheet which indicates the packet
is a MAC, IPv6, UDP packet, with a payload in layer 4.

Fix the lookup table to match the data sheet.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 21329ed3087e..fc3b56c13786 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -744,7 +744,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
 	/* Non Tunneled IPv6 */
 	ICE_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
 	ICE_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
 	ICE_PTT_UNUSED_ENTRY(91),
 	ICE_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
 	ICE_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
-- 
2.30.2

