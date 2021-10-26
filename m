Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CF43AF7F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhJZJzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231963AbhJZJzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 607CD60EC0;
        Tue, 26 Oct 2021 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635241996;
        bh=1yK8f767hVuBik3p0ImJWK6GMwCNwKjgGrhZGPbIhvk=;
        h=From:To:Cc:Subject:Date:From;
        b=Pjglhxfc5H6vO20QAUfypy+FInj0glzGnkrkJqXV2BjfkBAMCUZA8yjBa8vf6yfKO
         3jfc4Nwag9tZeozftfoDHG4bewdFS9eKLlyyegceBvNkaGE9lpGGyExZVBS8CPdgXB
         HmQeT/p29PTW4musYIzrgAfm/i082uGMpDHzsei46t63tscqy3mrZqp88uBFqIEgSH
         lORjD14XWlIQHOYLlvhyBd+vLOHGvKZxxBqJuytSY1qLNucWPWjaSaFQ/0xBmTrvD/
         x465ARVNWUMGkTZxMFoFAX7ZAb7poApbrUBxvBnmFHSiMGxqSVIIwDfhDJ+1OpJ6V/
         TnuF24UaK9J9A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfJ8d-0006sS-82; Tue, 26 Oct 2021 11:52:59 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 1/3] ath10k: fix division by zero in send path
Date:   Tue, 26 Oct 2021 11:52:12 +0200
Message-Id: <20211026095214.26375-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
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

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Cc: stable@vger.kernel.org      # 4.14
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/ath/ath10k/usb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 6d831b098cbb..3d98f19c6ec8 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -853,6 +853,11 @@ static int ath10k_usb_setup_pipe_resources(struct ath10k *ar,
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

