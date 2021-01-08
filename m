Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4112EF179
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbhAHLjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 06:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHLjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:39:51 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD4AC0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 03:39:11 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id f14so3492922pju.4
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 03:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOwfxvIp0i1YM0z8ARW+SrOzdf+vjxzyD4lS8VNBwig=;
        b=pe88pzxC5GmP+TDsM9vkIU9gTLdSn8t9Fh01lUowsaWXRx7ntc0kyJgrvWxWnAeKqF
         uz5zZAd6IWNASLH84RZh0PHrBhxFnv4FEMJZTHaiwYf7/OLNhJkis/vq1DRn4zgYpOZe
         puJIBRuZ/Wt0Dos3fo5yLqKsFumnIr1FrnaAzcsiyFvu4CdsM472++3zH2ScascM8haZ
         H5zvPmcdKNKGtQDMMrfft1fOLZt7X7HvhCoFmZQRzHCCBqELhgH2NXcqLlZTduS5Pc0O
         UHQuOZXBGxawgFE18Wv9H7NLREcyVEewFGtAoM5k0D4kDK9bXvVRVWm/EWCI+R8bNFcj
         +uew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOwfxvIp0i1YM0z8ARW+SrOzdf+vjxzyD4lS8VNBwig=;
        b=kNbeUPUhBIN6v/uObFc4GOtqN5IuStbCcpK9iJCpR/MCo1o6kJQnF+5pJU66Zqj/0r
         rt4buFEIuVcEcxAbOoVHDYniX3O5ghsIjPZp3HZBm9cXOWxX5sM3BgheHEe3CBEQqd1G
         5tsXucLbHeFNzWaHjPXvK6Tud2fxNEPf1dZkEaTCTec/sOJdCSvxQk2UuqIzge7bWgjd
         ARoSvcqaN+ooKfrnQRPfyS84YKsIikOc1XPKuPsq4TXE0mCkht9ZK4FyCD8Q3unnhYvE
         ZJkCBRSMQn5CLo2vlpDj/mZA8xlFYBdnGp8+g4m9P5SCgj3zPG27265pvwVbPOxmsyrQ
         S0HQ==
X-Gm-Message-State: AOAM5319QO/kbOhCTnf+hNjsfD/ex1FnX+v/HKtU8AkR1XCNzcimqmPD
        UO0CRiuGeIBrFEyeRhnCbv4=
X-Google-Smtp-Source: ABdhPJyl/efvcXTywiEfyrshraDqpAuH195JK5FckE8+pOkjzzZdOReJqum0qBx1SdeUNYPwS00osw==
X-Received: by 2002:a17:90a:df12:: with SMTP id gp18mr3273062pjb.43.1610105950896;
        Fri, 08 Jan 2021 03:39:10 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id r20sm9939971pgb.3.2021.01.08.03.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 03:39:10 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next 1/2] ice: drop dead code in ice_receive_skb()
Date:   Fri,  8 Jan 2021 03:39:02 -0800
Message-Id: <20210108113903.3779510-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20210108113903.3779510-1-eric.dumazet@gmail.com>
References: <20210108113903.3779510-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

napi_gro_receive() can never return GRO_DROP

GRO_DROP can only be returned from napi_gro_frags()
which is the other NAPI GRO entry point.

Followup patch will remove GRO_DROP, because drivers
are not supposed to call napi_gro_frags() if prior
napi_get_frags() has failed.

Note that I have left the gro_dropped variable. I leave to ice
maintainers the decision to further remove it from ethtool -S results.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index bc2f4390b51dc67b2ef8cf929a6451a0259e3d51..02b12736ea80d4551d3d3460339eb0706941d22f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -191,12 +191,7 @@ ice_receive_skb(struct ice_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 	if ((rx_ring->netdev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    (vlan_tag & VLAN_VID_MASK))
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
-	if (napi_gro_receive(&rx_ring->q_vector->napi, skb) == GRO_DROP) {
-		/* this is tracked separately to help us debug stack drops */
-		rx_ring->rx_stats.gro_dropped++;
-		netdev_dbg(rx_ring->netdev, "Receive Queue %d: Dropped packet from GRO\n",
-			   rx_ring->q_index);
-	}
+	napi_gro_receive(&rx_ring->q_vector->napi, skb);
 }
 
 /**
-- 
2.29.2.729.g45daf8777d-goog

