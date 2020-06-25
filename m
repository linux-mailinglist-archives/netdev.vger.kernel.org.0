Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB38209820
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 03:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389344AbgFYBPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 21:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389259AbgFYBPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 21:15:35 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F2C061573;
        Wed, 24 Jun 2020 18:15:34 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg28so2897117edb.3;
        Wed, 24 Jun 2020 18:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s+YDELLKqAQz5ufi65FON3o39vm62rLuw0cDlD7h5VM=;
        b=mk6XRGIMoffD7IgI/zGiVHpSmgbGXw8GfljrNIvQIs4Dio4Kz516oP3cC1/I+jIxOL
         SpXyOiTLOlj7muYMLHRxxqKGGhTLahHeyzVNY53Yrnnbp6q1zJFyjyyUy2UUe7iXyEgu
         NkcbkjePKlbLfD40eeZUt43VyAkk4+/73SuoJBUPIHO6FZEjluG7+lBzkF0/ptLI+Mpj
         Y8nqG1JEAZlw+HJufPY2Ly/dmmVRR2V90JVIDzIsOM38EtpRTG0MgYb4rmM6uYWWSRCD
         RVgr07sPT8+xrbEAjL4e5ROxbELn4H9alr7BRyiISaG6YhNiVfcuzahoWMSczvXWmbGb
         aGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s+YDELLKqAQz5ufi65FON3o39vm62rLuw0cDlD7h5VM=;
        b=JcpLeNpeccsXL3rGt5hK/+BvRPSMdbij2rPZVzNT3h6RIfAyMGmcyciokC1BWoCxQA
         ZKdEnI3ke7ZZoz2vVJN2wSw4Y1x5yv0RZZZhZau7QsedG/qQ0sWCF70KDlROVGzKiFfL
         +DQcNhFTc3H9OvbIE9MAWr9iWrsC75RDMWhjfGHMet17/RO/bUlYOq6J36yYPW52kd3E
         mqp7C/RDeCGw+XhVYh22Ung3CW3cE5PQ3/IR/p6oEVrZeTLanr7/XcVr8TjpYYiDiQ8b
         8xxnPoajlQFqUGgcJfZyfeRTbIvMBzdNK+GNOL2w3jzw2VbOlc7lauW26nbMSAkBGoT2
         /pPg==
X-Gm-Message-State: AOAM532QIRUQSbucwbW4wtaq0HF+xcphMM2WWnqp7tHMSarTLhb7GQN1
        a2/2TioidS0sgh3AJ4SKj53jAO+R
X-Google-Smtp-Source: ABdhPJz4c4o+k1ee50ZfXc4fFsFS3chTNWcMGx/nU5AtDwB07iDWO1DPoYprP205iHYEBhOJhS6F7A==
X-Received: by 2002:aa7:d14c:: with SMTP id r12mr6666025edo.58.1593047733059;
        Wed, 24 Jun 2020 18:15:33 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l24sm16080423ejb.5.2020.06.24.18.15.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 18:15:32 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 3/3] net: bcmgenet: use hardware padding of runt frames
Date:   Wed, 24 Jun 2020 18:14:55 -0700
Message-Id: <1593047695-45803-4-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
References: <1593047695-45803-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commit 474ea9cafc45 ("net: bcmgenet: correctly pad short
packets") added the call to skb_padto() it should have been
located before the nr_frags parameter was read since that value
could be changed when padding packets with lengths between 55
and 59 bytes (inclusive).

The use of a stale nr_frags value can cause corruption of the
pad data when tx-scatter-gather is enabled. This corruption of
the pad can cause invalid checksum computation when hardware
offload of tx-checksum is also enabled.

Since the original reason for the padding was corrected by
commit 7dd399130efb ("net: bcmgenet: fix skb_len in
bcmgenet_xmit_single()") we can remove the software padding all
together and make use of hardware padding of short frames as
long as the hardware also always appends the FCS value to the
frame.

Fixes: 474ea9cafc45 ("net: bcmgenet: correctly pad short packets")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c63f01e2bb03..af924a8b885f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2042,11 +2042,6 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto out;
 	}
 
-	if (skb_padto(skb, ETH_ZLEN)) {
-		ret = NETDEV_TX_OK;
-		goto out;
-	}
-
 	/* Retain how many bytes will be sent on the wire, without TSB inserted
 	 * by transmit checksum offload
 	 */
@@ -2093,6 +2088,9 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff *skb, struct net_device *dev)
 		len_stat = (size << DMA_BUFLENGTH_SHIFT) |
 			   (priv->hw_params->qtag_mask << DMA_TX_QTAG_SHIFT);
 
+		/* Note: if we ever change from DMA_TX_APPEND_CRC below we
+		 * will need to restore software padding of "runt" packets
+		 */
 		if (!i) {
 			len_stat |= DMA_TX_APPEND_CRC | DMA_SOP;
 			if (skb->ip_summed == CHECKSUM_PARTIAL)
-- 
2.7.4

