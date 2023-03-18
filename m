Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F355C6BFA2C
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 14:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCRNOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 09:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCRNOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 09:14:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A5818AB7
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 06:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679145230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jgoarmppOveCAhzhSS+yukRVNHlYy4ELLTt4seUigM0=;
        b=M+B80kD7s2yHbrf1k6sdg5t8L3+aEr0dTAHtVhaXfl+KjQOL7KcbbQpBNedlWFT46rHVe9
        ebq3OQSw6EkpaU72yrovow6BxJ74DdYPEemu0C5Jcy13BK6wMdJ4ioo2TV0WrTVCfvvSje
        8jmNNYaNMu7NwvsyA4iecN6IbbCgYa8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-PtyRKgWaMnq12IXMG-lveg-1; Sat, 18 Mar 2023 09:13:47 -0400
X-MC-Unique: PtyRKgWaMnq12IXMG-lveg-1
Received: by mail-qv1-f71.google.com with SMTP id g6-20020ad45426000000b005a33510e95aso4171750qvt.16
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 06:13:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679145227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgoarmppOveCAhzhSS+yukRVNHlYy4ELLTt4seUigM0=;
        b=48WHkDcgsnXCi6gtIgLoMijO1e9fx6fPaNW/KYUVJOHoEu0yEbekblYtmY5SAoSfSZ
         q5F8PPz5svAo5nHdN2D9SdTOErCg5MVmosO9GLERt/jE2hWz7u1BjeR5mRFYpObobwo+
         SEGtSU7FOkibdrnBYCzxsyxTx2kbNnZtrDhokyrmu6en2mjKivRqhUeNjhSpGTO0BxVA
         G1gC0XiM40ysATYGl/klJJK5DvMkaJ5TQkCNZwQLpk/SSaCVwGuIBv7+kzL0fVzGytsj
         sLacxojI6pguKdiHXcpm7zzyB2gjEtE1BIAZ9yl/2g9MbXoJwG8e+o7v48BMnl2se9WN
         cZFQ==
X-Gm-Message-State: AO0yUKVawX6XhLZyqaC0YBzc3CZs06FoEOJoJ5ybWBgtL2VTSK5Qofcy
        NL7WHA6nNrJXE1ymWYSf6uhCe8UrwuQ/VBSxBI92oCGM2eKzbLhcaxMdktoF4U0eUn8OWuwT62w
        xRQJzCz2vRSnS13qh
X-Received: by 2002:a05:622a:1116:b0:3d3:6285:a63 with SMTP id e22-20020a05622a111600b003d362850a63mr10899540qty.10.1679145227299;
        Sat, 18 Mar 2023 06:13:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Sm2ecyLp2qn8isjtzfX8KwHzTIP8qxzV+utPo3ZIhQHxrfPrkzvAXLPrT24ch0L/LOoDWJQ==
X-Received: by 2002:a05:622a:1116:b0:3d3:6285:a63 with SMTP id e22-20020a05622a111600b003d362850a63mr10899504qty.10.1679145226993;
        Sat, 18 Mar 2023 06:13:46 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bl28-20020a05620a1a9c00b007339c5114a9sm3575523qkb.103.2023.03.18.06.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 06:13:46 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        stern@rowland.harvard.edu, studentxswpy@163.com,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] usb: plusb: remove unused pl_clear_QuickLink_features function
Date:   Sat, 18 Mar 2023 09:13:42 -0400
Message-Id: <20230318131342.1684103-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/usb/plusb.c:65:1: error:
  unused function 'pl_clear_QuickLink_features' [-Werror,-Wunused-function]
pl_clear_QuickLink_features(struct usbnet *dev, int val)
^
This static function is not used, so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/usb/plusb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
index 7a2b0094de51..2894114858a2 100644
--- a/drivers/net/usb/plusb.c
+++ b/drivers/net/usb/plusb.c
@@ -61,12 +61,6 @@ pl_vendor_req(struct usbnet *dev, u8 req, u8 val, u8 index)
 				val, index, NULL, 0);
 }
 
-static inline int
-pl_clear_QuickLink_features(struct usbnet *dev, int val)
-{
-	return pl_vendor_req(dev, 1, (u8) val, 0);
-}
-
 static inline int
 pl_set_QuickLink_features(struct usbnet *dev, int val)
 {
-- 
2.27.0

