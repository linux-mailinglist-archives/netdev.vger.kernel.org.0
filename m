Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EA96C74E3
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 02:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjCXBLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 21:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCXBLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 21:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B888C7DA0;
        Thu, 23 Mar 2023 18:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 710EBB822A6;
        Fri, 24 Mar 2023 01:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDA7C433EF;
        Fri, 24 Mar 2023 01:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679620275;
        bh=jChlmGcZ3FGfnBX7fNnv8wDApgWT3zXUZGzW9tEgLMk=;
        h=Date:From:To:Cc:Subject:From;
        b=svd0LywyWL2ynnX0mBXIZ+kWSUnvdX6jm7Ev/vgd3F/0X+iiWYpuSzOLnw/l67D39
         ONzuxTiQRAu087pglXu9ZvZT6AL4veh/hn5T3TG/3xbSWeqdZ0sdqEJpC18isQKAks
         PLd8jO0yTAm9VtkVelFWyXFL0z+3YVv5rjCjTdVHy0JJwdwUyo9YREvyl3k6fxxwGq
         z+mt71F9b1hkzSes4xs0YOu4qVoodWP+UrBLvQkOZmrL2o8yRvIShA1wkR+ri2T3kX
         /4Lddbz41FBbPIDwPxdRbO02aKv+8ZgXS1LXcKJTWd2m2hM8Pi1ZppufLJGgqeO0Zk
         Fn3cZz2iafeyg==
Date:   Thu, 23 Mar 2023 19:11:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] rtlwifi: Replace fake flex-array with flex-array member
Message-ID: <ZBz4x+MWoI/f65o1@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-length arrays as fake flexible arrays are deprecated and we are
moving towards adopting C99 flexible-array members instead.

Address the following warning found with GCC-13 and
-fstrict-flex-arrays=3 enabled:
In function ‘fortify_memset_chk’,
    inlined from ‘rtl_usb_probe’ at drivers/net/wireless/realtek/rtlwifi/usb.c:1044:2:
./include/linux/fortify-string.h:430:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
  430 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -fstrict-flex-arrays=3 [1].

Link: https://github.com/KSPP/linux/issues/21
Link: https://github.com/KSPP/linux/issues/277
Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 31f9e9e5c680..082af216760f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2831,7 +2831,7 @@ struct rtl_priv {
 	 * beyond  this structure like:
 	 * rtl_pci_priv or rtl_usb_priv
 	 */
-	u8 priv[0] __aligned(sizeof(void *));
+	u8 priv[] __aligned(sizeof(void *));
 };
 
 #define rtl_priv(hw)		(((struct rtl_priv *)(hw)->priv))
-- 
2.34.1

