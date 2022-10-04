Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391A25F3D7E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 09:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJDHwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 03:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJDHwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 03:52:47 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED412B629;
        Tue,  4 Oct 2022 00:52:46 -0700 (PDT)
Received: from [192.168.10.9] (unknown [39.45.148.204])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 01F2D6602294;
        Tue,  4 Oct 2022 08:52:42 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1664869964;
        bh=R6l9T5BM52dcR1rvtAnSOR0sTeiXruJN2cxHdJAe5ZY=;
        h=Date:Cc:To:From:Subject:From;
        b=CkBj9peD5/eQeSHFXfLAg/YLU/jvMp4CukTv+9PnxQpjqFUwXRkWWUMmXzvVma8cb
         Oa9tRZOjBQGdgRkIkDekKrU4ttcqMxz+C3oInmjV49bq+OJPZht98sLxBFfdi7j+uZ
         tcizwg1nkwuLyUEd1mzlCAI8LvWZH9Gmq8xZD0Oay/4GPNwcvBY2kMbjyD+uZwRUI3
         l9oVdntpezgHbu0iWtGr++TJoY5R7PmjoI0RCR/9ASfOB8PVWkW43des2E+Z9F1w0P
         k61e+iUcci6hhEo8kLXZg3gfhrLZJd/6iVVgbk6CpRaB9L9gdfS3QOYym/KjlA9Vhd
         5iENahn47BRHg==
Message-ID: <28270724-1c20-5b28-e5cf-ffe29a85ce4c@collabora.com>
Date:   Tue, 4 Oct 2022 12:52:38 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Cc:     usama.anjum@collabora.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Collabora Kernel ML <kernel@collabora.com>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Language: en-US
To:     =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Kalle Valo <kvalo@kernel.org>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
Subject: [Bug report] Probably variable is being overwritten
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A bit in rfb0r1 is being cleared and result is stored in rfval. Then the
first bit is being set without reusing the rfval. It is probably bug or
dead code? The same pattern can be seen repeated below as well.


diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index cbbb1a4849cf..4857e3818418 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8844,7 +8844,7 @@ static void rt2800_rxiq_calibration(struct
rt2x00_dev *rt2x00dev)
        for (ch_idx = 0; ch_idx < 2; ch_idx = ch_idx + 1) {
                if (ch_idx == 0) {
                        rfval = rfb0r1 & (~0x3);
-                       rfval = rfb0r1 | 0x1;
+                       rfval = rfval | 0x1;
                        rt2800_rfcsr_write_bank(rt2x00dev, 0, 1, rfval);
                        rfval = rfb0r2 & (~0x33);
                        rfval = rfb0r2 | 0x11;


-- 
Muhammad Usama Anjum
