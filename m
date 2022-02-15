Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3224B6A70
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236991AbiBOLNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:13:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbiBOLNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:13:20 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3F8108184;
        Tue, 15 Feb 2022 03:13:09 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q17so3524837edd.4;
        Tue, 15 Feb 2022 03:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=V5jTjWeCJaxu6W4LGsy8GkMNItmN4npHxe5fYjW27qo=;
        b=qXMApXvPrUftbgjj4i+KZTcyMR3a0m7RvmRf0MzyAEp+F/ZjjfBXYfS7Z8NUCsACE1
         e1Av4qpgy+oaHpvrWESUTE1Tbij/7XiMdFItMZqq9l2CtNWjXI7HqwiB18xm51hlu1Kr
         nivqwV+Fzstm9AiW9llxsZh1i8Ag7Lhdtn6hn9tPUjdiKlQt6EoIrQbE4huwFrzHIFsC
         qgBJ5VS69tNCTFsPrC2a7xHcRLKsvgoT2yir9Jx5FqWTbP5/dLEtyi+k0EHDH9qpsQ/9
         gTWBtpE6aAK5ExXipsYT03zI6lefmxcyJtX6exakDzN+wF+j4S/QG3xnCXRM4bRPjYk8
         YjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V5jTjWeCJaxu6W4LGsy8GkMNItmN4npHxe5fYjW27qo=;
        b=GDevnAVyT/17JjuW6nHHHabVnVTKvXIXDM6vOWEjt9MEprdgy9o0D8yufGyIrrMtv0
         F3Q/CSwcUc0xClVLHvajKIFK9CMFkLUTrfmWsMvptTMl1yOM9xoLhswC1mg2+ULuenKp
         yHbC1apOWATmHMDIyuLeUcBQ8KPjd9Zp+joiPzxKbyY+3H0RekiRgIHwJi5+3JHz78rN
         1E/3BctNgRTsRDrVNb87IZHx7sMx6Z8ZN/ZpyeaO6GIz0ykM6N/pcJIDgGuTguOZmovu
         g3acvgwK05nScE+bQXL8s2Zf3JbLsIS3ImB9D+MU+s6xh9z+136aQnCSXY4tlcSXuFP+
         ZQ3A==
X-Gm-Message-State: AOAM533OM9QDqyfzhSszDy7duWtdro2btV1qvwFAZ3C4sgCHyxg/eHt4
        S6qZkalD3b/CSUbbSwErmTw=
X-Google-Smtp-Source: ABdhPJxMWRj3Sb4y9ose/89urYNhOuZr5l9B+7gKYNWjwGGlftZIIqb6F8Zo94V/MGkaW+JXqH8tcQ==
X-Received: by 2002:a05:6402:2947:: with SMTP id ed7mr3439241edb.141.1644923588223;
        Tue, 15 Feb 2022 03:13:08 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id 5sm3541007ejl.32.2022.02.15.03.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:13:07 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     Oliver Neukum <oliver@neukum.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990
Date:   Tue, 15 Feb 2022 12:13:35 +0100
Message-Id: <20220215111335.26703-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FN990
0x1071 composition in order to avoid bind error.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/usb/cdc_mbim.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 82bb5ed94c48..c0b8b4aa78f3 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -659,6 +659,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FN990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1071, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
-- 
2.32.0

