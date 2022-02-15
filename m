Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9082E4B6A28
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbiBOLC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:02:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbiBOLC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:02:57 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53221074F0;
        Tue, 15 Feb 2022 03:02:47 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 647241F382;
        Tue, 15 Feb 2022 11:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644922966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rPolAolb2PgOG+R2zG2Qjmk5p7rupUy2s7DLLjc/lak=;
        b=FR0JMPn+H9SSk2tufXAmRIXecTquuuhO45nsTpe8057awYWBPCFcs5HGEFh0gYCF4ATSIo
        /rU4OOetHZzsuPnFYjTcnhVUicl38CqSn6D24V9mBMZ7RRx1YwD0ccvNBaFJCsleX52DlY
        /SjLgIoZx38sj2yBhjCMKh9ZMQBgIrk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 25A7313C55;
        Tue, 15 Feb 2022 11:02:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NTaLB1aIC2L2MAAAMHmgww
        (envelope-from <oneukum@suse.com>); Tue, 15 Feb 2022 11:02:46 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     dmitry.bezrukov@aquantia.com, igor.russkikh@aquantia.com,
        meissner@suse.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [RFC] aqc111: check for valid header length before parsing
Date:   Tue, 15 Feb 2022 12:02:43 +0100
Message-Id: <20220215110243.30468-1-oneukum@suse.com>
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

The received package must be checked for being long
enough to contain the header to be parsed, or garbage
may be parsed during fixup.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/aqc111.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index ea06d10e1c21..7848fe941a36 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1084,10 +1084,10 @@ static int aqc111_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	if (!skb)
 		goto err;
 
-	if (skb->len == 0)
+	skb_len = skb->len;
+	if (skb_len < sizeof(desc_hdr))
 		goto err;
 
-	skb_len = skb->len;
 	/* RX Descriptor Header */
 	skb_trim(skb, skb->len - sizeof(desc_hdr));
 	desc_hdr = le64_to_cpup((u64 *)skb_tail_pointer(skb));
-- 
2.34.1

