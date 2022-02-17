Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668404B9D23
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiBQK33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:29:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiBQK3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:29:25 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A9991356;
        Thu, 17 Feb 2022 02:29:09 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 767E32198B;
        Thu, 17 Feb 2022 10:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645093748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=oe4+isgvvxx9QbIn+cKcFDXBth0DabkkXTbAF0d4F9U=;
        b=UDe+90c5osVd82PQcCkKYFk+uPECnw4gsXyqkk6GUdOa65yqqBhQ0DUbFqZEpDMlBbNlHB
        8NuAWyQ7AVwwjypDY4J50wdKv9R3tnAjzHiz7ZdpSmSrf1JsZD5JSsyelBGkXVTp5xEvTy
        5gfuqgDkKitR7moGmw4PKXL3gyNSg8E=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4688113DD8;
        Thu, 17 Feb 2022 10:29:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R6B1D3QjDmJHQAAAMHmgww
        (envelope-from <oneukum@suse.com>); Thu, 17 Feb 2022 10:29:08 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     steve.glendinning@shawell.ne, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [RFC] sierra: avoid trailing bytes leading to garbage parsing
Date:   Thu, 17 Feb 2022 11:29:00 +0100
Message-Id: <20220217102900.10102-1-oneukum@suse.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver's main loop isn't ready for a device sending
some trailing bytes as it tests for an exact match between
package and accumulated frames.
We would parse some garbage from the heap and follow its
pointers.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/smsc75xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 95de452ff4da..649e43b4df4f 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2183,7 +2183,8 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	if (skb->len < dev->net->hard_header_len)
 		return 0;
 
-	while (skb->len > 0) {
+	/* at least two u32 must be left to go on */
+	while (skb->len > 4 + 4) {
 		u32 rx_cmd_a, rx_cmd_b, align_count, size;
 		struct sk_buff *ax_skb;
 		unsigned char *packet;
-- 
2.34.1

