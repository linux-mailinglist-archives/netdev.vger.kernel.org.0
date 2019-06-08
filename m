Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281C139F81
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfFHMFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37862 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfFHMFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id 22so4195301wmg.2;
        Sat, 08 Jun 2019 05:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ghj88Jml2RkS+TOts6KbJxsxq/8ghqRmCDtRbCASJII=;
        b=SP5g5bl7alfZMDNcE0kJepasS4H2BceNSnLXvZBJoUMZRMz2tzlYfcL+7WmRVcPW+3
         ZiiCSUhFKgAwiowDfeXUH06b9UA92Cudbl7reNwVj1prfbvOzQsUsogG3497qgrSwGug
         kbOibjeJNNiWW6wTgaafm/5Qt7HZCV8pSVf0xODXHJb9sTVfwblphuea4J2S2YEWQOUP
         SQ6p/XwYg82qCESdXgKEvbOXSe3Q/x4VWrdhuHsQgD/FvaheDbusU10ME9UnvMMkEQ7m
         rbv9TIkxxDVa/k84N/LWGdLauoaxxVFOekU4OuJCsEQ/zdEPGhFCuXOFHyAlrAxDn2qD
         ZMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ghj88Jml2RkS+TOts6KbJxsxq/8ghqRmCDtRbCASJII=;
        b=s8t7TFTIwa4IcnJQuN81r9VkThFDpxd6BAO+wYN32Kvuy04UfWl/Y04Ev6C9E8mldv
         6B0rf7Uhdq+QbBrW0Pk6QtNq06IJuP8GoqtjD6hu/Asb843IyTNFxyyN4yxL2Vf0eK2m
         xJXfSKjXsyf7LHTxcqf3qWAWtEdnr+fJoeFbmO949m2QlzhrW9sfSwY3cun8YiysyKDR
         TrVIGnh9TdvsyxG9c+tI+MOjyPH4oZPdotopz1UmnpGcJ17jM/Zthej3z5k8rsjYWxfr
         1ykU9a92kr4L8ND9QukGtAgTZp9duq0uvey01iTD7vLid8Ou6EQF/5O8FDiMkz+LKD8H
         bdgw==
X-Gm-Message-State: APjAAAVMx/3QBbpjDevT/lZlw16LzQE9khYUdLGoU57OShjnGL161U6z
        FamIh3ZO8eS3Y4d2WQ7xQYU=
X-Google-Smtp-Source: APXvYqw6+9bpf9P5k4+7vPUm6oTQt4Uq5HS1I8ANNpYvdSk6bZ7pCseTwzii/LveIeRfpYqqpqEv5g==
X-Received: by 2002:a1c:c305:: with SMTP id t5mr6810425wmf.163.1559995548451;
        Sat, 08 Jun 2019 05:05:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 12/17] net: dsa: sja1105: Make sja1105_is_link_local not match meta frames
Date:   Sat,  8 Jun 2019 15:04:38 +0300
Message-Id: <20190608120443.21889-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although meta frames are configured to be sent at SJA1105_META_DMAC
(01-80-C2-00-00-0E) which is a multicast MAC address that would also be
trapped by the switch to the CPU, were it to receive it on a front-panel
port, meta frames are conceptually not link-local frames, they only
carry their RX timestamps.

The choice of sending meta frames at a multicast DMAC is a pragmatic
one, to avoid installing an extra entry to the DSA master port's
multicast MAC filter.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v4:

Since dropping the patch that moves sja1105_is_link_local to
include/linux from the previous series, this now applies over
net/dsa/tag_sja1105.c.

Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 net/dsa/tag_sja1105.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 0beb52518d56..094711ced5c0 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -13,6 +13,8 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 	const struct ethhdr *hdr = eth_hdr(skb);
 	u64 dmac = ether_addr_to_u64(hdr->h_dest);
 
+	if (ntohs(hdr->h_proto) == ETH_P_SJA1105_META)
+		return false;
 	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
 		    SJA1105_LINKLOCAL_FILTER_A)
 		return true;
-- 
2.17.1

