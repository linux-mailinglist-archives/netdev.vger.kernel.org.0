Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0133E318A4D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 13:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhBKMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 07:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhBKMPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 07:15:54 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C45DC0617A7;
        Thu, 11 Feb 2021 04:13:26 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id a22so7041636ljp.10;
        Thu, 11 Feb 2021 04:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJPoGrTKInAL8lHXhueEWmoIyBBxrbtsidr003g0JVQ=;
        b=h1S9L/MuiipWGDZk0QdAJ1vxuwelYSDaRBxXL3pl6CAN+SFT1MtEfVK6e/btoiTk31
         GMoJNQrugZmMkU1zE8A5H9hMrDnCwNngqWKylXHkkCkbdi3nSURxYZIFvDbdWbtUq4eF
         iWQ9OG1aE0TKTPLnhpl3fFdSWh1EhiD2mAxZ4NURAmvYHZI9o2dqf7/dfPYNzsHn8qN0
         yDOYopSBM3pV+eMLcIujCB7hodz1oBDMy+0pnhz7PeQJ1iypor5aamhJIuDl5p3zHP1a
         8Jmlq81J3pTgM5EPtcZB7Kwc/lYmoIvuOXzJeGQPbe7SSDtS39UfVEBrtRdvaLRf9lNF
         rOuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJPoGrTKInAL8lHXhueEWmoIyBBxrbtsidr003g0JVQ=;
        b=lXLXLryD0n+PBkUTmHzszL7+TwSp+KstC6Qu9ft77zTCly6K0ey6D575DjXgmW3GLp
         eZkUSVjBoGGTWTl1Iw+FB6F3FfdqoeOyLnxYrPtuwL849Noiv44KIYuCUvfNmdLe6x0X
         NQsg9kH1lk/eAde2UNfE5TauIjHnV2G55vTHVejd4K5PC8XY1lnwvK7lR1VWogsTEAWL
         nsxwvsjJN+ciPZV7EmlLHzhLawgRt4vc9mUjl6Rc78crurRfckPUEbiFocbJ1KIaeYM2
         Xabq/bp3r7jBqtB7SI7h6kzseDrghLpWeWqQIjeh+65EFEcSFLxCDpMvCW2RnewCbjW1
         QM0A==
X-Gm-Message-State: AOAM532zYPoy8BFbV0jXvUK3fsXBTwuvgU+SGyI9xDeGp9UCbJPNL/cn
        idsG3STp7dpngy1JyBBQ1eU=
X-Google-Smtp-Source: ABdhPJzOWCeQE/xVojne9iRVhq0uq/euljiV13i1vMRK8IOzZ0xMScWhj2h1gBBN4qc11DbGdoz3EQ==
X-Received: by 2002:a2e:9b0b:: with SMTP id u11mr4879282lji.415.1613045605509;
        Thu, 11 Feb 2021 04:13:25 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f23sm834783ljn.131.2021.02.11.04.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 04:13:25 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 5.12 8/8] net: broadcom: bcm4908_enet: fix endianness in xmit code
Date:   Thu, 11 Feb 2021 13:12:39 +0100
Message-Id: <20210211121239.728-9-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211121239.728-1-zajec5@gmail.com>
References: <20210209230130.4690-2-zajec5@gmail.com>
 <20210211121239.728-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Use le32_to_cpu() for reading __le32 struct field filled by hw.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 2e825db3b2f1..0da8c8c73ba7 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -476,7 +476,7 @@ static int bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_device *netde
 	/* Free transmitted skbs */
 	while (ring->read_idx != ring->write_idx) {
 		buf_desc = &ring->buf_desc[ring->read_idx];
-		if (buf_desc->ctl & DMA_CTL_STATUS_OWN)
+		if (le32_to_cpu(buf_desc->ctl) & DMA_CTL_STATUS_OWN)
 			break;
 		slot = &ring->slots[ring->read_idx];
 
-- 
2.26.2

