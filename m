Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CC5218FC9
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGHSha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:37:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34633 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGHSha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 14:37:30 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jtEwe-0000Nd-5u; Wed, 08 Jul 2020 18:37:24 +0000
From:   Colin King <colin.king@canonical.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: systemport: fix double shift of a vlan_tci by VLAN_PRIO_SHIFT
Date:   Wed,  8 Jul 2020 19:37:23 +0100
Message-Id: <20200708183723.1212652-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the u16 skb->vlan_tci is being right  shifted twice by
VLAN_PRIO_SHIFT, once in the macro skb_vlan_tag_get_pri and explicitly
by VLAN_PRIO_SHIFT afterwards. The combined shift amount is larger than
the u16 so the end result is always zero.  Remove the second explicit
shift as this is extraneous.

Fixes: 6e9fdb60d362 ("net: systemport: Add support for VLAN transmit acceleration")
Addresses-Coverity: ("Operands don't affect result")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b470551bae4f..dfed9ade6950 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1250,8 +1250,7 @@ static struct sk_buff *bcm_sysport_insert_tsb(struct sk_buff *skb,
 	memset(tsb, 0, sizeof(*tsb));
 
 	if (skb_vlan_tag_present(skb)) {
-		tsb->pcp_dei_vid = (skb_vlan_tag_get_prio(skb) >>
-				    VLAN_PRIO_SHIFT & PCP_DEI_MASK);
+		tsb->pcp_dei_vid = skb_vlan_tag_get_prio(skb) & PCP_DEI_MASK;
 		tsb->pcp_dei_vid |= (u32)skb_vlan_tag_get_id(skb) << VID_SHIFT;
 	}
 
-- 
2.27.0

