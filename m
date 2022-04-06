Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BA44F5DC6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiDFMXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiDFMWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:22:51 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720E055374C
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 01:05:47 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i27so2549320ejd.9
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 01:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ti/npGoPTFibH+xB4eUUf9YNEZYTNBWMKZyz6wFUfVA=;
        b=JV1kyQ9gJoaGXgB5X0xYBM+ICIjOae23OUNruli8xsLcm6yf6HWGHI90Zefe5lGBtN
         Atcj3DfcVbKsW42IgA7PInZ3b2GyTf90pE/8T5ht6/SSSHXfoGQMjjPzs1am5s0lka0t
         EwJKE7zEqKNotRvbgpAW0d6u32d5jbPDKnKk3REwjW8K3DO0XMr461ldz8n+xtNIk5kR
         qMfnXixuZu63vgbNaQGBsRoIiLIQQyO+gdH7/RqDaW4S7/CEau7yKA25+KG393nz/w5Y
         B6Hbr+SNpewqic//y0aeZK+b/QgzOy+wSN1bBeStL8Tey7q+xttP6VYLXDN5DtL4tzuy
         HeLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ti/npGoPTFibH+xB4eUUf9YNEZYTNBWMKZyz6wFUfVA=;
        b=1vCmPZo2Q4upwC4/nsDAKKvQtnF+cSeC50Pss+9MFnuR23mD5IfFhsb46ZyJzeJDix
         w18CuYBKsstFMJAz365CR7ro5U9gSF04Fuoj/lda0vfPeHF1g5CiycgXLvEmciiCWOlf
         4/Pvqt3sZEKR4jdaUsB6X0SP68JDnjgZDMd1QbOJ/WyVvk4nUQqMKfXAq9f70YyUaiF6
         UCHUZkw5XdQ9eWwzB5hJETaX+SXHbY0GYxWZMXC54YoMpapGWt+huY0zPWwHSBmSrsN2
         gmUzD4hTtLvCwtKDmkroWFhXWDvSTaDE89nquvyv104sgQenr+Dnwa+ClGTN8a708lc3
         LfEA==
X-Gm-Message-State: AOAM531r1fxq4QCswJmb+VYxi6oyl5GEEpd7p4QRyjkALpf8P82rP+hh
        kY9HYKVQYab6qxyQwrSzqvfRBgwuokM=
X-Google-Smtp-Source: ABdhPJxOujxeVo/3JLmDpAK0es0OcVlDPm1fm/Qbg7FGWbzGKzNHxlu2JuTIAevlUC65cAi4PsUDFQ==
X-Received: by 2002:a17:906:99c5:b0:6df:8215:4ccd with SMTP id s5-20020a17090699c500b006df82154ccdmr7210760ejn.684.1649232345807;
        Wed, 06 Apr 2022 01:05:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8109:8680:1d54:740d:6e9f:d774:8de2])
        by smtp.googlemail.com with ESMTPSA id l14-20020a170906644e00b006e4dae79576sm5944074ejn.14.2022.04.06.01.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 01:05:45 -0700 (PDT)
From:   Marcin Kozlowski <marcinguy@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marcinguy@gmail.com
Subject: [PATCH] net: usb: aqc111: Fix out-of-bounds accesses in RX fixup
Date:   Wed,  6 Apr 2022 10:05:37 +0200
Message-Id: <20220406080537.22026-1-marcinguy@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

aqc111_rx_fixup() contains several out-of-bounds accesses that can be
triggered by a malicious (or defective) USB device, in particular:

 - The metadata array (desc_offset..desc_offset+2*pkt_count) can be out of bounds,
   causing OOB reads and (on big-endian systems) OOB endianness flips.
 - A packet can overlap the metadata array, causing a later OOB
   endianness flip to corrupt data used by a cloned SKB that has already
   been handed off into the network stack.
 - A packet SKB can be constructed whose tail is far beyond its end,
   causing out-of-bounds heap data to be considered part of the SKB's
   data.

Found doing variant analysis. Tested it with another driver (ax88179_178a), since
I don't have a aqc111 device to test it, but the code looks very similar.

Signed-off-by: Marcin Kozlowski <marcinguy@gmail.com>
---
 drivers/net/usb/aqc111.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index ea06d10e1c21..ca409d450a29 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1102,10 +1102,15 @@ static int aqc111_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	if (start_of_descs != desc_offset)
 		goto err;
 
-	/* self check desc_offset from header*/
-	if (desc_offset >= skb_len)
+	/* self check desc_offset from header and make sure that the
+	 * bounds of the metadata array are inside the SKB
+	 */
+	if (pkt_count * 2 + desc_offset >= skb_len)
 		goto err;
 
+	/* Packets must not overlap the metadata array */
+	skb_trim(skb, desc_offset);
+
 	if (pkt_count == 0)
 		goto err;
 
-- 
2.17.1

