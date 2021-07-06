Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1254D3BCFAD
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhGFLbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235097AbhGFL3h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 586AA61D81;
        Tue,  6 Jul 2021 11:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570439;
        bh=6mBsYhaKeX18KySfiOE6BvBBbZKWlt1Zm/r2GZXHrm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNMcE9k/wg0B7+VjmKnTi6kbOju7Rb8E1zT2AjijZqSh/m23T4hDM1D93sJryFHu2
         +dJoUV+3K/IoxkoZgLQmGCmbQTR41/CpsKUOoUEFv+y/eO95egYDyv800SZK+Ze279
         HksU1dqMmKpyxwmqv681UflDiYibEICuiOrg8LgRzscI5y0TWtyrVxOp2TtE7gU6Rk
         pADUa0zrcx6jjWVb1DxC6shU+wYdsOhewivVON0f/LGUgMJB4QTU6YqB0lAWVZlAzV
         Oq47Cp4MocI0JjviG6/GpztH+kr2sSh91YUBivkUTKu3+jEPfpj5AqGqs7d1w+Wfz1
         E+zz2bt8DTzBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 099/160] ice: fix incorrect payload indicator on PTYPE
Date:   Tue,  6 Jul 2021 07:17:25 -0400
Message-Id: <20210706111827.2060499-99-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 4ec24c3e813f..98a7f27c532b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -722,7 +722,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
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

