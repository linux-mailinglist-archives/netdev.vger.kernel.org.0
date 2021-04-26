Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D158736AF89
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhDZIMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232295AbhDZIMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 04:12:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 807C261075;
        Mon, 26 Apr 2021 08:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619424712;
        bh=b73sWLTfZ3rVYbqm01S+4HlwmIhgl+rHnAudGrlqVOc=;
        h=From:To:Cc:Subject:Date:From;
        b=sAHUPcUaaz3BS2w4HEwuPa2mq1C0zMCXoo9bkDnrEZTqbpKptfGNnS7vKhyufmaJ2
         js6mtRYDJX2dQ+m+zzk4Op8xuOtoxNHMvk9l6c+o5+g+SLcwATOJ1hRHZUw8rP8FZG
         IsDIAYX5XWL+RAgz7btk5Ih+I3GgAN7SjBruykxN1w+zu9fpADrBahFGAKJP7tjqHE
         /V3WQamjw18E4HKmjq1cDTRO1oonK17VP62y8LjfxcXS+Y2VU+i4D3Dcf/H8fmR2Lu
         aEK3SXEl2NYQatlBP27uWbBGGaxSfydotdsRTpRkn3JDIhyeO/FYAz3nyF4nEURy1W
         0LmuJjOl5Aq+w==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lawLa-0002k5-5L; Mon, 26 Apr 2021 10:12:02 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        Leonardo Antoniazzi <leoanto@aruba.it>
Subject: [PATCH] net: hso: fix NULL-deref on disconnect regression
Date:   Mon, 26 Apr 2021 10:11:49 +0200
Message-Id: <20210426081149.10498-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device
unregistration") fixed the racy minor allocation reported by syzbot, but
introduced an unconditional NULL-pointer dereference on every disconnect
instead.

Specifically, the serial device table must no longer be accessed after
the minor has been released by hso_serial_tty_unregister().

Fixes: 8a12f8836145 ("net: hso: fix null-ptr-deref during tty device unregistration")
Cc: stable@vger.kernel.org
Cc: Anirudh Rayabharam <mail@anirudhrb.com>
Reported-by: Leonardo Antoniazzi <leoanto@aruba.it>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/hso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 9bc58e64b5b7..3ef4b2841402 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -3104,7 +3104,7 @@ static void hso_free_interface(struct usb_interface *interface)
 			cancel_work_sync(&serial_table[i]->async_put_intf);
 			cancel_work_sync(&serial_table[i]->async_get_intf);
 			hso_serial_tty_unregister(serial);
-			kref_put(&serial_table[i]->ref, hso_serial_ref_free);
+			kref_put(&serial->parent->ref, hso_serial_ref_free);
 		}
 	}
 
-- 
2.26.3

