Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1296F62CB1E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234588AbiKPUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbiKPUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:36:16 -0500
X-Greylist: delayed 396 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Nov 2022 12:36:04 PST
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FD867108
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:36:04 -0800 (PST)
Received: (wp-smtpd smtp.tlen.pl 10810 invoked from network); 16 Nov 2022 21:29:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1668630561; bh=wIPDLnO3IoAeI00Smq/ujtO4jdLyKZdBbvJO81An0Us=;
          h=From:To:Cc:Subject;
          b=ahtEv54oe3So5cDD0xuRqhdgCPnPfel5z6Z6Z7TSlT3OpWgOs5pZnaP0cwmLk+IpW
           v8rF7ca+UmzuCnqMDd/b5sfRS1oZPN4igsdS2juPNG2O3dTRvt76AcqMAxtX+TaXj0
           i0VZOc1q14HNBx4pVgvtqeAiiXUrZ/eJIEVwP2tk=
Received: from aafn183.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.4.143.183])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-bluetooth@vger.kernel.org>; 16 Nov 2022 21:29:21 +0100
From:   =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Brian Gix <brian.gix@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Subject: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
Date:   Wed, 16 Nov 2022 21:28:56 +0100
Message-Id: <20221116202856.55847-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: cf8b44b908658acece8b81a6ab35ced6
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 000000B [0XNk]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On kernel 6.1-rcX, I have been getting the following dmesg error message
on every boot, resume from suspend and rfkill unblock of the Bluetooth
device:

	Bluetooth: hci0: HCI_REQ-0xfcf0

After some investigation, it turned out to be caused by
commit dd50a864ffae ("Bluetooth: Delete unreferenced hci_request code")
which modified hci_req_add() in net/bluetooth/hci_request.c to always
print an error message when it is executed. In my case, the function was
executed by msft_set_filter_enable() in net/bluetooth/msft.c, which
provides support for Microsoft vendor opcodes.

As explained by Brian Gix, "the error gets logged because it is using a
deprecated (but still working) mechanism to issue HCI opcodes" [1]. So
this is just a debugging tool to show that a deprecated function is
executed. As such, it should not be included in the mainline kernel.
See for example
commit 771c035372a0 ("deprecate the '__deprecated' attribute warnings entirely and for good")
Additionally, this error message is cryptic and the user is not able to
do anything about it.

[1]
Link: https://lore.kernel.org/lkml/beb8dcdc3aee4c5c833aa382f35995f17e7961a1.camel@intel.com/

Fixes: dd50a864ffae ("Bluetooth: Delete unreferenced hci_request code")
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Brian Gix <brian.gix@intel.com>
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
---
 net/bluetooth/hci_request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 5a0296a4352e..f7e006a36382 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -269,7 +269,7 @@ void hci_req_add_ev(struct hci_request *req, u16 opcode, u32 plen,
 void hci_req_add(struct hci_request *req, u16 opcode, u32 plen,
 		 const void *param)
 {
-	bt_dev_err(req->hdev, "HCI_REQ-0x%4.4x", opcode);
+	bt_dev_dbg(req->hdev, "HCI_REQ-0x%4.4x", opcode);
 	hci_req_add_ev(req, opcode, plen, param, 0);
 }
 

base-commit: 094226ad94f471a9f19e8f8e7140a09c2625abaa
-- 
2.25.1

