Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8272256199A
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 13:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiF3LvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 07:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiF3LvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 07:51:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E8233E9A;
        Thu, 30 Jun 2022 04:51:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CACD21FB06;
        Thu, 30 Jun 2022 11:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656589871; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=1THAt4Br27hQvRoXxZwOtw6kFXgYBQXcKi9yQoW6FNE=;
        b=R2sqIPVDx+juv/vDOJmrb7O/eQiaLAvDSfkxSEV8D7AjtEfMoPEGKO2rFpMZ37ZD8UQE8Z
        xQaOiERDWao4syg4ppDRu8pP+1W8eQntY8bfgFgMMCIqwbd+pkwWwhGg3h9xEQ8MvBtgQ8
        avcJk79qoH5rOz5dUp3XypiI6oJMWNg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B8B013A5C;
        Thu, 30 Jun 2022 11:51:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +cBsIC+OvWKOIwAAMHmgww
        (envelope-from <oneukum@suse.com>); Thu, 30 Jun 2022 11:51:11 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] cdc-eem: always use BIT
Date:   Thu, 30 Jun 2022 13:51:09 +0200
Message-Id: <20220630115109.7522-1-oneukum@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Either you use BIT(x) or 1 << x in the same expression.
Mixing them is ridiculous. Go to BIT()

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/cdc_eem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_eem.c b/drivers/net/usb/cdc_eem.c
index 359ea0d10e59..baa9b14b1644 100644
--- a/drivers/net/usb/cdc_eem.c
+++ b/drivers/net/usb/cdc_eem.c
@@ -218,7 +218,7 @@ static int eem_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 				if (unlikely(!skb2))
 					goto next;
 				skb_trim(skb2, len);
-				put_unaligned_le16(BIT(15) | (1 << 11) | len,
+				put_unaligned_le16(BIT(15) | BIT(11) | len,
 						skb_push(skb2, 2));
 				eem_linkcmd(dev, skb2);
 				break;
-- 
2.35.3

