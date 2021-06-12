Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463DC3A4F51
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhFLOlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:41:00 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:33339 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhFLOk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:40:58 -0400
Received: by mail-io1-f50.google.com with SMTP id a6so34777966ioe.0
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zm655iiQBvNsM1zGTE3Z5YIWcNDBpgG+PR5dwnxy8PY=;
        b=znbHIRfQQsxi7yyp1vZex0OL8FYa7DTX2/4Ukwx5Qk4nUcoP0/3iEfVYw4koyVI23I
         1/aLvM4kisHWHNzGsUkn3GIuKV9rEOQd1F+YP8+jQjZnu69WDmR+m9YWh61NalMWA3sn
         Huk9FCnB8BHM2dhR3IuUDsBP14YuGCGYb9Yf6LNbDAiUEFIPvHAJPNtmeK2nFGA+IH04
         yE2GpEVX8V/me/ZLURyguAZYOgvnwQyAcQJ1SfDFlpsc2n2Ce2WPSD30ZDcNlRLtmjEZ
         dfaJaujqMlV1PrmUnQrzh+F2aKt1/fEgbJBYAN+Jp3mBNGBsOnkxoF74IFIkiCwngV3B
         L2Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zm655iiQBvNsM1zGTE3Z5YIWcNDBpgG+PR5dwnxy8PY=;
        b=mcheCuFBWn6ELUdTMX8xT3wRxxA+uctJ++gyDxZ4CP8r2UyH2Ji5O1BGHvv+OFys0M
         Gfuu+HEqvQP3B36ZpYeOTt+K0qOif/u2iK9H30XxXnTa1Ru7M7DEJFogdFzgU0kyQNbE
         VMxqyFfTmDBvQCKjIA5VsY7dE3KonLOJ9gqkqxwL7cMGCuzwjvDDzGBVwiiCXcemtYZu
         qtSYDmUrQHea1A9SABPmFQCjVlYa1Yi2YSber/PkGABn35uEaF4gAH1tOtexZ7AT0MjF
         R6JfdJl+CKpE7aZZA6NVwHKBsvgIEs9/cxOQj8YpjZCzb/ESYq9Aco51IaKnFAFxn6r2
         uTBw==
X-Gm-Message-State: AOAM533kW/lTpIy13QUz5mBC89MohyWiw+TefLxxakp0qjv4Xj5SGMhZ
        a1+rQXWbF7ITdoNNuYBFO8BpsA==
X-Google-Smtp-Source: ABdhPJwLMvXqqkYmksjDRRGQuJHfz+h2zudIKmnedTpsfXCIwTy/hfXfukAjVFFURNz+GyXt5AsZ8A==
X-Received: by 2002:a05:6602:114:: with SMTP id s20mr7562158iot.98.1623508662310;
        Sat, 12 Jun 2021 07:37:42 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k4sm5126559ior.55.2021.06.12.07.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:37:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: qualcomm: rmnet: show that an intermediate sum is zero
Date:   Sat, 12 Jun 2021 09:37:31 -0500
Message-Id: <20210612143736.3498712-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210612143736.3498712-1-elder@linaro.org>
References: <20210612143736.3498712-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch simply demonstrates that a checksum value computed when
verifying an offloaded transport checksum value for both IPv4 and
IPv6 is (normally) 0.  It can be squashed into the next patch.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 1b170e9189d8a..51909b8fa8a80 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -84,6 +84,11 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 					 ip4h->protocol, 0);
 	pseudo_csum = csum16_add(ip_payload_csum, (__force __be16)pseudo_csum);
 
+	/* The trailer checksum *includes* the checksum in the transport
+	 * header.  Adding that to the pseudo checksum will yield 0xffff
+	 * ("negative 0") if the message arrived intact.
+	 */
+	WARN_ON((__sum16)~pseudo_csum);
 	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
 	if (unlikely(!csum_value_final)) {
@@ -150,6 +155,10 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 				       length, ip6h->nexthdr, 0);
 	pseudo_csum = csum16_add(ip6_payload_csum, (__force __be16)pseudo_csum);
 
+	/* Adding the payload checksum to the pseudo checksum yields 0xffff
+	 * ("negative 0") if the message arrived intact.
+	 */
+	WARN_ON((__sum16)~pseudo_csum);
 	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
 	if (unlikely(csum_value_final == 0)) {
-- 
2.27.0

