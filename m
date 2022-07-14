Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD7574F0E
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239246AbiGNNXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238494AbiGNNWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:22:45 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0BC5D5A4;
        Thu, 14 Jul 2022 06:22:09 -0700 (PDT)
Received: from quatroqueijos.. (unknown [177.9.88.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9761D3F3A9;
        Thu, 14 Jul 2022 13:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657804927;
        bh=36Vgpi0nCGl0u3pmcD8xjyNPutMygLK4GXtVa3Et0BU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=i2J362YfjhMBlccJitl6AaA2T+I1hQ9PYpLi8quPGbMXmZUC5VEMnKjcsCIPQTZV9
         1uv0K1S6rDV28z1R+Oz1o1woJTpEEPQrkwIp/mGPGeggd86Wc9LcIcuxdpOSuih3kO
         CJHJ9mvsn/BsmFIKL0hOKC+aPuouVajYzfcDBLMAc5dNCSegQeH+q54kQglhkFkGH1
         Pfyk4NOBOmlsDfXMEwTZhta/e+ajfENPcZbaofONW/DBHHViufQ3GYyhmymaUyrjBd
         3EqFcqYElkfdRuV0mRYv0jX+qKwoDKepvCXYUK79vdUkBv+vbzp25zL3fzUj4aSyNi
         Fiy7eApVrd8ew==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oneukum@suse.com, grundler@chromium.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH] sr9700: improve packet length sanity check
Date:   Thu, 14 Jul 2022 10:21:34 -0300
Message-Id: <20220714132134.426621-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet format includes a 3 byte headers and a 4 byte CRC. Account for
that when checking the given length is not larger than the skb length.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Fixes: e9da0b56fe27 ("sr9700: sanity check for packet length")
---
 drivers/net/usb/sr9700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 5a53e63d33a6..09bb40ac6e09 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -413,7 +413,7 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len)
+		if (len > ETH_FRAME_LEN || len + SR_RX_OVERHEAD > skb->len)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.34.1

