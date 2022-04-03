Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE01A4F0A14
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 16:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343717AbiDCOEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 10:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237059AbiDCOEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 10:04:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74D7162DF
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 07:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648994536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IgMX2nj2cNExGiU4IHmGwPOWMy+mYsJ+4MxIjrhMhLQ=;
        b=P1f1Kd7XQs7zWhu3JWMRznh1l5pPzxdaiGB4B9XP7MMQbeAQZCHe0FoX+lLO9upUGB/RH2
        Z7JKg04Ws+pz5YtZZOJkwUZXNgV2eBUWR3jU/p9A17NVkmcPyTPJ6WK253MNj16H8npXsA
        fv/Mdbpb2LD7+l4g2FA6hqLScrwocLQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-q8jz7_0UNFu0UAhSNU5MOw-1; Sun, 03 Apr 2022 10:02:15 -0400
X-MC-Unique: q8jz7_0UNFu0UAhSNU5MOw-1
Received: by mail-wr1-f72.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so1195905wri.2
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 07:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IgMX2nj2cNExGiU4IHmGwPOWMy+mYsJ+4MxIjrhMhLQ=;
        b=hDaZJw/d8ZEo7P3cfpcJ/kx9VR0LiHVmY8Tm3L2aijDVOxkbgI1CGu60TYQ4R3Hkwe
         btoj/xitKrXRBxOQiWy4N40AYknjGlt/Fb+R9xBTmsK7CnVECrfTa6PTtgsgcfBzMESQ
         6dzmQt5K1unhyRnwcMWPdZ1sCjYmu9sc7qSuA0RkQfY3QtgXNeP3pB5SCY1qdThLqHS3
         NV3v+l5EVv4h2RILJjSQI6IbkV74lwFj36EDLzanUhW3dbdMEwN30OPliNIrw55G8h+p
         7Qa0jVTqAnkxeLt2VEvqPTBXG7Widwpyx7aForGQB1KupTVUh1ocqOhECx7sJK5OIqh3
         RNIA==
X-Gm-Message-State: AOAM5317fs3kiUCZIKY6tgG0o2q/iipl63CxGngCRaFEl75twbKjP23P
        CUyzLpdUxET+Dl8LRBq2DVgVCIYjrMTODEQP2usTfbUaTaC/TJ+p0EyNmn5vzzzm94yTarZXQF7
        7i+wNxscJxFks6aU7
X-Received: by 2002:a5d:40c8:0:b0:205:2a3b:c2c with SMTP id b8-20020a5d40c8000000b002052a3b0c2cmr14072349wrq.13.1648994534346;
        Sun, 03 Apr 2022 07:02:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwz8TWqYImcP6rcwIhAkGMXujAFPtHd1mtW4Epczq6oGwMPXw022V6Oc/3xXzJvj9XSl1FGwA==
X-Received: by 2002:a5d:40c8:0:b0:205:2a3b:c2c with SMTP id b8-20020a5d40c8000000b002052a3b0c2cmr14072332wrq.13.1648994534137;
        Sun, 03 Apr 2022 07:02:14 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k9-20020adfb349000000b00206101fc58fsm914374wrd.110.2022.04.03.07.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 07:02:13 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] stmmac: dwmac-loongson: change loongson_dwmac_driver from global to static
Date:   Sun,  3 Apr 2022 10:02:02 -0400
Message-Id: <20220403140202.2191516-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch reports this issue
dwmac-loongson.c:208:19: warning: symbol
  'loongson_dwmac_driver' was not declared.
  Should it be static?

loongson_dwmac_driver is only used in dwmac-loongson.c.
File scope variables used only in one file should
be static. Change loongson_dwmac_driver's
storage-class-specifier from global to static.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index ecf759ee1c9f..017dbbda0c1c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -205,7 +205,7 @@ static const struct pci_device_id loongson_dwmac_id_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, loongson_dwmac_id_table);
 
-struct pci_driver loongson_dwmac_driver = {
+static struct pci_driver loongson_dwmac_driver = {
 	.name = "dwmac-loongson-pci",
 	.id_table = loongson_dwmac_id_table,
 	.probe = loongson_dwmac_probe,
-- 
2.27.0

