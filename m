Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BBA6C4A7D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCVM3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjCVM3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:29:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E517EAF0B
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679488140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/RmaCdFiflknr5F/EzALZWl8EQAEMlohlo+Bq/6n784=;
        b=IGRiaXY47/CqfQ0HhrV9YXycAt4KYHUdiaYitJlJoN7/+XZUvAlCO1iMkYBinss56kGpGa
        I4VfKnY1V4KbvSmUIJIRMYVBqB1s6p2S0mASlZ/PXfsonM0pQGzWH+3UHIak4lL0kzT2Ui
        AQa5juRrC8KEnTtunlpOkaxNBguWy6c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-kh-epCaHPEe8Iw-kBu4cgA-1; Wed, 22 Mar 2023 08:28:59 -0400
X-MC-Unique: kh-epCaHPEe8Iw-kBu4cgA-1
Received: by mail-qk1-f198.google.com with SMTP id 198-20020a370bcf000000b007468cffa4e2so3956669qkl.10
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679488138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/RmaCdFiflknr5F/EzALZWl8EQAEMlohlo+Bq/6n784=;
        b=GMFRUn9AkFkYJo6Wq8cMu1ToZUPM4t8Sjbe3OSg9vie/H/2h3NRc4i/hl15QL1dTAb
         uFLXNXZaFbiDhCQ07kQSOv0gGN7F4ZPBvGspZcvEEaA9qoTqsTDJ04mnQDqVdpPbi5uN
         T+fDvteYTdTuFWFIiQVCrKBnQl0uZHY/56d+tMr9Kl2zXfaikY6QZakVNXWr2fvDfk8C
         WTDR0EaIKHicTvj3ucTGAPw3rXO1LaGNyuAqg6Z9fijn4nX6ZgdlTgvAmkPEjMj3cQbR
         9Knu5cRFbUxSxo8/ITApg5dX5+xNzF8kNJn6w1rnzmrXO1wvweieaGR9E3X7Edjm4WGo
         3Yeg==
X-Gm-Message-State: AO0yUKXumxAuBtYYRm3vVYzVQcL4xtFLTeGSrU+kZtp2uAQ0q1oZOAyB
        EDxKbfjrh44HyeHQ4h6beKYDlAbIxoEexygIyP82MCZgY/aTBMiqSQEpgJYbF9fBkyInH3U3c/R
        XIOrxgxy7f0hmsKKOm31N75WiUyc=
X-Received: by 2002:ac8:7f8e:0:b0:3bf:d9d2:484f with SMTP id z14-20020ac87f8e000000b003bfd9d2484fmr5698838qtj.11.1679488138427;
        Wed, 22 Mar 2023 05:28:58 -0700 (PDT)
X-Google-Smtp-Source: AK7set8Gcxx8GdV/OeVtTOhHQR7MlyYiQ1UjJcEDEFgxn3029wWSBoOMbr8ofWD/oxpFcUXsweisow==
X-Received: by 2002:ac8:7f8e:0:b0:3bf:d9d2:484f with SMTP id z14-20020ac87f8e000000b003bfd9d2484fmr5698812qtj.11.1679488138211;
        Wed, 22 Mar 2023 05:28:58 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j13-20020a37ef0d000000b00729b7d71ac7sm11174245qkk.33.2023.03.22.05.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 05:28:57 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] ath10k: remove unused ath10k_get_ring_byte function
Date:   Wed, 22 Mar 2023 08:28:55 -0400
Message-Id: <20230322122855.2570417-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang with W=1 reports
drivers/net/wireless/ath/ath10k/ce.c:88:1: error:
  unused function 'ath10k_get_ring_byte' [-Werror,-Wunused-function]
ath10k_get_ring_byte(unsigned int offset,
^
This function is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index b656cfc03648..c27b8204718a 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -84,13 +84,6 @@ ath10k_set_ring_byte(unsigned int offset,
 	return ((offset << addr_map->lsb) & addr_map->mask);
 }
 
-static inline unsigned int
-ath10k_get_ring_byte(unsigned int offset,
-		     struct ath10k_hw_ce_regs_addr_map *addr_map)
-{
-	return ((offset & addr_map->mask) >> (addr_map->lsb));
-}
-
 static inline u32 ath10k_ce_read32(struct ath10k *ar, u32 offset)
 {
 	struct ath10k_ce *ce = ath10k_ce_priv(ar);
-- 
2.27.0

