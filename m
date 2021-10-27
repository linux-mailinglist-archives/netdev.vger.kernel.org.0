Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF6543C4C1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240828AbhJ0IOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:14:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239185AbhJ0IOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79E26601FF;
        Wed, 27 Oct 2021 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635322338;
        bh=1yK8f767hVuBik3p0ImJWK6GMwCNwKjgGrhZGPbIhvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrO5XD2YIP373HIfFqyTW5p9wJlTqcnDT+cpbR0WBEom7XMLhRnu7COwQgBYkysjK
         7hkHhO2v37+Ija7po5YchG8eHKsjZZV/g8HbyPKZlXUn5auD8v76nK/0nGQeEkEZbs
         v4dwBRwqwXeFCDqNc9tUVUY8/iArvt9u8dXFEI4yVKpbJ823r97mI/lgqamwdWx0dj
         JKHOnImv33EWEVT4yfZ64qCp9c7lmkLgVH7EGYvOL8oPY4DmxdDApXhk/cW8AfvjPa
         AG9/IctAFN3pPZI6RBUFAQWhHl6sTc9xk/YMfOXvX6B/cdBOXxfr88lf0msM2+ms8x
         rLcnMOsARrslg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfe2S-0001lg-Ps; Wed, 27 Oct 2021 10:12:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 1/3] ath10k: fix division by zero in send path
Date:   Wed, 27 Oct 2021 10:08:17 +0200
Message-Id: <20211027080819.6675-2-johan@kernel.org>
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

