Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0516A423A
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjB0NGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjB0NGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:06:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5481E5E0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 05:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677503150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q92sQcBkpoH/Y89DMN/b2PnZ1a4R3LQUabxaooE41f4=;
        b=dPoZyTVM6Jy5fR+/OKKbRI7hnWkv7rjyFHQfdEajhpNs1lGbkFyqHssyzSiAN1Lx2adLxU
        kJiwq8OBbTN8rzmtNqBzDoP8lemKy6+J3x013jfG5AeFMOmV5OGl5Ker1K5n2GqkQHLl/e
        7lm73CgmQwEQX6FXTLruUhQSXjmiU7k=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-111-TB2gaHvBOrCm3kJUA3qUSw-1; Mon, 27 Feb 2023 08:05:48 -0500
X-MC-Unique: TB2gaHvBOrCm3kJUA3qUSw-1
Received: by mail-qt1-f198.google.com with SMTP id n22-20020ac86756000000b003be57054a3bso2762817qtp.1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 05:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q92sQcBkpoH/Y89DMN/b2PnZ1a4R3LQUabxaooE41f4=;
        b=O7EpA7oNNEialx8ru8LV4aqAWOyLbuAh0SvmDdB+aF+4LvYJmEn9PHvzk4b0IMc5PE
         ZckDg6r4chBLrXdDDsgI3BN7hK/do1BzlZhOLvpY9RmkBLsyQBOOOb3CewXi2+Xwd79b
         phtVK+cqjDEZWNZU4cvfBQbSh30czs3rF6HDx/nk6NBwaUw6YpoFOFXyPCmpNWN/IFi0
         k+glks/qImF26z3pdRHuwz//0NH3PAef7Ys++zTXbxdWzJUtgtzzh2hy/sIRKaqUCYJv
         qNgSKB0DmAcf1BTs49Xd7O/JOMNpaoiuK2FAWY3bxYsCBhUuWyCxeLtlcvyHMeDVnNLJ
         uY/w==
X-Gm-Message-State: AO0yUKVl0Iu5VZE3BYIK44x5SODUR3iFxRsaS9cEaFhAPGrD5KDUv9u/
        +hHxR3//uXfyai2XL2W8PAxY7CobXRohchWWOBfQbwc7iH19hc+IL3JJ0c2+6bL+iM0gVkBvzu6
        mEqKc1DCJRCAStcTj
X-Received: by 2002:a05:622a:198d:b0:3ba:1c07:e472 with SMTP id u13-20020a05622a198d00b003ba1c07e472mr31833344qtc.51.1677503148165;
        Mon, 27 Feb 2023 05:05:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/Q83c86U2flHpqHGPKAg/isPSifHH7doggpAJ/IZmXIvW61I9KlhY599MXX2oNeKrX9jDULg==
X-Received: by 2002:a05:622a:198d:b0:3ba:1c07:e472 with SMTP id u13-20020a05622a198d00b003ba1c07e472mr31833272qtc.51.1677503147482;
        Mon, 27 Feb 2023 05:05:47 -0800 (PST)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id t136-20020a37aa8e000000b0073b967b9b35sm4830749qke.106.2023.02.27.05.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 05:05:46 -0800 (PST)
From:   Tom Rix <trix@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steen.hegelund@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH v2] net: lan743x: LAN743X selects FIXED_PHY to resolve a link error
Date:   Mon, 27 Feb 2023 08:05:35 -0500
Message-Id: <20230227130535.2828181-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A rand config causes this link error
drivers/net/ethernet/microchip/lan743x_main.o: In function `lan743x_netdev_open':
drivers/net/ethernet/microchip/lan743x_main.c:1512: undefined reference to `fixed_phy_register'

lan743x_netdev_open is controlled by LAN743X
fixed_phy_register is controlled by FIXED_PHY

and the error happens when
CONFIG_LAN743X=y
CONFIG_FIXED_PHY=m

So LAN743X should also select FIXED_PHY

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: Add config setting that trigger the error to commit log
---
 drivers/net/ethernet/microchip/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/microchip/Kconfig b/drivers/net/ethernet/microchip/Kconfig
index 24c994baad13..43ba71e82260 100644
--- a/drivers/net/ethernet/microchip/Kconfig
+++ b/drivers/net/ethernet/microchip/Kconfig
@@ -47,6 +47,7 @@ config LAN743X
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLIB
+	select FIXED_PHY
 	select CRC16
 	select CRC32
 	help
-- 
2.27.0

