Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A7D43C4BD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhJ0IOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240785AbhJ0IOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D00460F6F;
        Wed, 27 Oct 2021 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635322338;
        bh=OgMrTYLYFTRq1xURZC/7AxyMSuua7/BgrWAb5qpfMkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijLYPecgsamDQTyxBtxqxH85QnhztnkIywWYpFqbyhXWF5Po1XNCMAd/XjnjDo2h4
         Tv6wm/p1HabaQ6jCks/VjVHbwE7Ig3WhqwhHaQZPMPI7o43oDFPEGXvOeWtwc6D4dq
         js+nUhJOcxed14IO0RzP07OjBhwIOsKe/YBvJp/j6nZe7nCq2NKry5WTPCLgzkvwrm
         pqyrCA/z0ZfpOG4BnlId3tEEauk3/CtQDhcZhAurZLh9RFPnwYqVCJZt+rrsw1OJss
         oxQO1kTcvz7flPqDc57Q2JfMKPvJYxysdbQaFt+uIhMm7oj78fm9gAksw/AoQDeaSL
         nAj3VHNmTU54A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfe2S-0001li-Sx; Wed, 27 Oct 2021 10:12:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/3] ath6kl: fix division by zero in send path
Date:   Wed, 27 Oct 2021 10:08:18 +0200
Message-Id: <20211027080819.6675-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211027080819.6675-1-johan@kernel.org>
References: <20211027080819.6675-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in ath10k_usb_hif_tx_sg() in case a malicious device
has broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 9cbee358687e ("ath6kl: add full USB support")
Cc: stable@vger.kernel.org      # 3.5
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index bd367b79a4d3..aba70f35e574 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -340,6 +340,11 @@ static int ath6kl_usb_setup_pipe_resources(struct ath6kl_usb *ar_usb)
 				   le16_to_cpu(endpoint->wMaxPacketSize),
 				   endpoint->bInterval);
 		}
+
+		/* Ignore broken descriptors. */
+		if (usb_endpoint_maxp(endpoint) == 0)
+			continue;
+
 		urbcount = 0;
 
 		pipe_num =
-- 
2.32.0

