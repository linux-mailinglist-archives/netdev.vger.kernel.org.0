Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46153E4E67
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505057AbfJYNz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505010AbfJYNzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C33921D82;
        Fri, 25 Oct 2019 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011724;
        bh=YMIA8rjAV5K28qn2+cRhD8XtwVSArNt+QfSzG8Gnd1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oV24+2v/mbfLG5HUUUMNOENigDqHHy9Dll/0ue1Lpf/sdd73pFgKZQnzMMApvqmhJ
         2BPq1Xy1nAJMS1Wg4nE/AEiwQLqwxXKaKvLldTVJxmljx5qHeGaAhE1YENBG5vZil8
         VDMYbHiS2cwGLYUfmAMnvIL+mG7KJhyrXn0h1wjE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 09/33] NFC: pn533: fix use-after-free and memleaks
Date:   Fri, 25 Oct 2019 09:54:41 -0400
Message-Id: <20191025135505.24762-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6af3aa57a0984e061f61308fe181a9a12359fecc ]

The driver would fail to deregister and its class device and free
related resources on late probe errors.

Reported-by: syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com
Fixes: 32ecc75ded72 ("NFC: pn533: change order operations in dev registation")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index c5289eaf17eef..e897e4d768ef7 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -547,18 +547,25 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
 	rc = pn533_finalize_setup(priv);
 	if (rc)
-		goto error;
+		goto err_deregister;
 
 	usb_set_intfdata(interface, phy);
 
 	return 0;
 
+err_deregister:
+	pn533_unregister_device(phy->priv);
 error:
+	usb_kill_urb(phy->in_urb);
+	usb_kill_urb(phy->out_urb);
+	usb_kill_urb(phy->ack_urb);
+
 	usb_free_urb(phy->in_urb);
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	usb_put_dev(phy->udev);
 	kfree(in_buf);
+	kfree(phy->ack_buffer);
 
 	return rc;
 }
-- 
2.20.1

