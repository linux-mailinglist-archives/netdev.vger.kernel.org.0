Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CA63A1753
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbhFIOf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:35:56 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:43822 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbhFIOfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:35:48 -0400
Received: by mail-lf1-f54.google.com with SMTP id n12so31373328lft.10
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 07:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8PDNC8Mo/P5rc+m2CaBOXRYUGdGE0Y+FOQz4Z9q23kE=;
        b=cmlainbjPOaGda6DkAkCK1nAK6ncxjkgH1uHbt1hsPu+LgRNS/WYVld7xPy8h1LWle
         QYlB06deJoPdtpQ/RtRlNCitiNzn4duDJwMN3fFwsOnyqsDjuGwgZGx1JLZqO8Kinj5I
         JF9oDx6mVHce5F7+ptbydorrhRSqTRfA84gv45D+B8HaKmi1gbHDh1W+xNFq+tJyKkte
         pNZaXKOiGX8nGNIBppaEfb44GCJ9arGsKNe/JmDcahjPfdO4C6hXJc9jPtYau8uVkuD4
         VvczvccSfS64Q9YlUFy4HwemoLNipcg9RSiIbGwSPVtGy9Uo7ir00H8fLbKA4o6GQagW
         16eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8PDNC8Mo/P5rc+m2CaBOXRYUGdGE0Y+FOQz4Z9q23kE=;
        b=Q4gN3scj3xEaAaVdPr+etMsrccpw4ag9zY+N9q7r0E5wbucb7QyAQp1PsBAedneGyL
         2E9pgAOMv/r29+k0tDJVInthbgjY65NJjPZV/mUaj0UNYBqdTiRRkfDj8ScwQ5kyFfGl
         qNz2ArCskDn1foC+ZjfsPjr6mtUq3ILIZSXpgTxjb71qxOETTffNeFFXCbJy51N4zHv7
         QODOMQDruiVfNkoY0ZBgzWHphqR8aH9pmAQ4BzRZZhoaYCJqvGBAnaD3/AvaB+cv0o7i
         sG5M49ORA+1YaZwJ+pndWofX3zNXWQZD1+IGPjCwMTvIdf03ZE/8iY4ql+lipcJBlTfZ
         q+UQ==
X-Gm-Message-State: AOAM532FPlkouz1V9t4NVIFyx3aogDoEZ4roXD4QGOSYmHZqvKG+R6AY
        Ngy0qmmYV6V9rhD3tZ3j+5EL5nSFlqI=
X-Google-Smtp-Source: ABdhPJwc4drnroaNNNb8ujwzT11JcIWTxZ5XbmGYtWHc7s7ZgIP+qWWmkbInpO0DwyVzaAP2TiVREw==
X-Received: by 2002:a05:6512:12c8:: with SMTP id p8mr12030185lfg.65.1623249171668;
        Wed, 09 Jun 2021 07:32:51 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan (2.149.207.108.tmi.telenormobil.no. [2.149.207.108])
        by smtp.gmail.com with ESMTPSA id u10sm353908lji.16.2021.06.09.07.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 07:32:51 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netdev@vger.kernel.org, sharathv@codeaurora.org,
        stranche@codeaurora.org, subashab@codeaurora.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] net: ethernet: rmnet: Always subtract MAP header
Date:   Wed,  9 Jun 2021 16:32:49 +0200
Message-Id: <20210609143249.2279285-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e1d9a90a9bfd ("net: ethernet: rmnet: Support for ingress MAPv5
checksum offload") broke ingress handling for devices where
RMNET_FLAGS_INGRESS_MAP_CKSUMV5 or RMNET_FLAGS_INGRESS_MAP_CKSUMV4 are
not set. Unless either of these flags are set, the MAP header is not
removed. This commit restores the original logic by ensuring that the
MAP header is removed for all MAP packets.

Fixes: e1d9a90a9bfd ("net: ethernet: rmnet: Support for ingress MAPv5 checksum offload")
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 2504d0363b6b..bfbd7847f946 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -88,11 +88,12 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 			goto free_skb;
 		skb_pull(skb, sizeof(*map_header));
 		rmnet_set_skb_proto(skb);
-	} else if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4) {
+	} else {
 		/* Subtract MAP header */
 		skb_pull(skb, sizeof(*map_header));
 		rmnet_set_skb_proto(skb);
-		if (!rmnet_map_checksum_downlink_packet(skb, len + pad))
+		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4 &&
+		    !rmnet_map_checksum_downlink_packet(skb, len + pad))
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
-- 
2.25.1

