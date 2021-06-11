Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519003A4945
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhFKTIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:08:53 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:43830 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhFKTIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:08:47 -0400
Received: by mail-io1-f52.google.com with SMTP id k16so32221277ios.10
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUpvk546xJbxccrzYy1DJAE11qaWwvxoi2eLnJNWB58=;
        b=apDBUttal8iaipbAO980nf/x8zRkf3UuOXodhRiWve6B/zDaSBOQcforlzF8s3aTyP
         kJghjhImXbxvX3Ua1WhXJeSPy+WD6MQVfRhn8oLo5xwvWk6HsW8ePBBjzMvrKKIEygr4
         9PswGSNFdgp6iBWWyJU0NdKjoAD/4wlcySZ7rGKmY8zXhcVSDAU/Gt2ayZ23tQm7Lq2Q
         RJi04+snWlHihb6gQfXHLWnUN2o5288in0DW5h6O2f9ZSfsIhPeRJfAR/7M3D5WN+4DL
         P5i1B8b2E7z9c7aBhDr3w9TwW2Byx6BNvrC+JAeVyPvGvhqUjJcNl3Odc38AdVn1PVms
         3BvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUpvk546xJbxccrzYy1DJAE11qaWwvxoi2eLnJNWB58=;
        b=S88tp6MpPPJ6t2QQC/NC03pge8L3494YwMB1xRZyiTnU2DF02qit35uosd2COPndFf
         UwZbEr/hK++rkHh5qjLrTINWXkSV96n8UHUmr3VOdaFnfaklij7yydoHoBl9PBmSIHiq
         bc444dgXyHN7jsJ3+uJoukay1kCOspoxhkfwsSx5GkLpK6dXsJoX292vk8Qdk7t1BoxC
         TaQanrL/cdeoxUNVhczvdBgUNH2kLV9KNaPsv+UwqLz1Ztqosv5u/MDIdO5+RrmzEj/f
         pShHayQOFqBx+76FE0RK5KQLNXz3rEA0xToMwkFYZWcQd7Yy+NIHurIHSzoKZV++un/e
         BmPg==
X-Gm-Message-State: AOAM532Gd0KxnDJXLVMoER54g+jW3bTbVSrMWrNOgo11+HIaiv2eN2Gg
        pUCS54SxoKnO95zLx+LGS3oazA==
X-Google-Smtp-Source: ABdhPJyQvSliUi32RR8b6i+pzFCO7ZkiFTgHuMIlmebLf2nnm4j2Bnc6AmiIPpz3FjnTDiyTC2UJrw==
X-Received: by 2002:a05:6602:22ca:: with SMTP id e10mr4202393ioe.57.1623438338290;
        Fri, 11 Jun 2021 12:05:38 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p9sm3936566ilc.63.2021.06.11.12.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:05:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/8] net: qualcomm: rmnet: simplify rmnet_map_get_csum_field()
Date:   Fri, 11 Jun 2021 14:05:25 -0500
Message-Id: <20210611190529.3085813-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210611190529.3085813-1-elder@linaro.org>
References: <20210611190529.3085813-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The checksum fields of the TCP and UDP header structures already
have type __sum16.  We don't support any other protocol headers, so
we can simplify rmnet_map_get_csum_field(), getting rid of the local
variable entirely and just returning the appropriate address.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 20 +++++--------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index ca07b87d7ed71..79f1d516b5cca 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -19,23 +19,13 @@
 static __sum16 *rmnet_map_get_csum_field(unsigned char protocol,
 					 const void *txporthdr)
 {
-	__sum16 *check = NULL;
+	if (protocol == IPPROTO_TCP)
+		return &((struct tcphdr *)txporthdr)->check;
 
-	switch (protocol) {
-	case IPPROTO_TCP:
-		check = &(((struct tcphdr *)txporthdr)->check);
-		break;
+	if (protocol == IPPROTO_UDP)
+		return &((struct udphdr *)txporthdr)->check;
 
-	case IPPROTO_UDP:
-		check = &(((struct udphdr *)txporthdr)->check);
-		break;
-
-	default:
-		check = NULL;
-		break;
-	}
-
-	return check;
+	return NULL;
 }
 
 static int
-- 
2.27.0

