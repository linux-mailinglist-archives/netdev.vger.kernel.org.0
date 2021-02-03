Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA330D8C6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 12:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhBCLgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 06:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhBCLgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 06:36:22 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFA1C0613D6;
        Wed,  3 Feb 2021 03:35:41 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m13so23839851wro.12;
        Wed, 03 Feb 2021 03:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sr/viP2SKaJXfKIJbBo8hjY70U9kkVhClzZkvhF0wpU=;
        b=oOPQLQHa9bNCGD+j9QPELyM1JyDeEF4CuGM54Vl+KBjJzjkw5qxhSQzd8DNeaKjchS
         UN7I/FjKU7t+6WfIKwRp+vdK7ajFWjeO3xnUPQDaANPOhVKYZnbn36knN7+rVrNifwf8
         q4TOzrbAHtlF1pUL3mUiOEk71Y3Meev0/11dg1eMUyZ4w1Aa1sJVHt4XVGcDEVcQmglG
         Aas1xZig0CNaC+cGTXNJTOPKC/PCmumsdKB5Tk0mlhjcv4a64wTlPwoWoFAfv5s13w1U
         uJyaakQ9wWdG6/jGOUHVasfEPgt63Xrjk5GWo8TKX2xh36xwnhdIb02PO1+uIXp/+NDV
         kNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sr/viP2SKaJXfKIJbBo8hjY70U9kkVhClzZkvhF0wpU=;
        b=rKbxSQB9OWSLLmmZ+IdKYYW6e7DswnDZyD6JXQUDh8kIHOHH2JKcyBtQeukhxFY7CQ
         iD9vQqn/94SS2fH/VyC33CCM1M4TdV1H7qQ79i955pLwKsVjY9QdX3mKjEVaua3nm3q2
         YaI1p/e9Tk3s8Ir8BKVKLasCYlnMOttIG7XhR47amTPtrYMsgLH8IA7XcmRmnk6QeN+r
         0W98MqvmpV1GkBGBtRexaWkW7BgVsi6QSKtua5vNcegqioaj3Wb0jnINtqH103ZTHiwG
         JiNg7iDhFDk78lj5F69MJIPf+qw6h0GCKhc0ZLFVukTtlh12DQ77IshiizN2yzdDYESA
         ZgMA==
X-Gm-Message-State: AOAM533NlRUTI9F/vJ0rd5aUPutuqMAr0KmFRHyHm6NyAbyegwd0WHKD
        bKfkLsSFT3gCr0YnUAQChZb7c1D1OP3icGKx
X-Google-Smtp-Source: ABdhPJyBD0j/RTnAZ15LcHMy6kS6dv3r58hCPPQ3CSNGHFZDYdc6c1K+4wQNu8BreYOnZL/F26/TZw==
X-Received: by 2002:adf:e404:: with SMTP id g4mr2951461wrm.416.1612352140217;
        Wed, 03 Feb 2021 03:35:40 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id t18sm3295088wrr.56.2021.02.03.03.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 03:35:39 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] hv_netvsc: Allocate the recv_buf buffers after NVSP_MSG1_TYPE_SEND_RECV_BUF
Date:   Wed,  3 Feb 2021 12:35:12 +0100
Message-Id: <20210203113513.558864-2-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203113513.558864-1-parri.andrea@gmail.com>
References: <20210203113513.558864-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recv_buf buffers are allocated in netvsc_device_add().  Later in
netvsc_init_buf() the response to NVSP_MSG1_TYPE_SEND_RECV_BUF allows
the host to set up a recv_section_size that could be bigger than the
(default) value used for that allocation.  The host-controlled value
could be used by a malicious host to bypass the check on the packet's
length in netvsc_receive() and hence to overflow the recv_buf buffer.

Move the allocation of the recv_buf buffers into netvsc_init_but().

Reported-by: Juan Vazquez <juvazq@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Fixes: 0ba35fe91ce34f ("hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer")
---
 drivers/net/hyperv/netvsc.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 0fba8257fc119..9db1ea3affbb3 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -311,7 +311,7 @@ static int netvsc_init_buf(struct hv_device *device,
 	struct nvsp_message *init_packet;
 	unsigned int buf_size;
 	size_t map_words;
-	int ret = 0;
+	int i, ret = 0;
 
 	/* Get receive buffer area. */
 	buf_size = device_info->recv_sections * device_info->recv_section_size;
@@ -405,6 +405,16 @@ static int netvsc_init_buf(struct hv_device *device,
 		goto cleanup;
 	}
 
+	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
+		struct netvsc_channel *nvchan = &net_device->chan_table[i];
+
+		nvchan->recv_buf = kzalloc(net_device->recv_section_size, GFP_KERNEL);
+		if (nvchan->recv_buf == NULL) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
+	}
+
 	/* Setup receive completion ring.
 	 * Add 1 to the recv_section_cnt because at least one entry in a
 	 * ring buffer has to be empty.
@@ -1549,12 +1559,6 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	for (i = 0; i < VRSS_CHANNEL_MAX; i++) {
 		struct netvsc_channel *nvchan = &net_device->chan_table[i];
 
-		nvchan->recv_buf = kzalloc(device_info->recv_section_size, GFP_KERNEL);
-		if (nvchan->recv_buf == NULL) {
-			ret = -ENOMEM;
-			goto cleanup2;
-		}
-
 		nvchan->channel = device->channel;
 		nvchan->net_device = net_device;
 		u64_stats_init(&nvchan->tx_stats.syncp);
-- 
2.25.1

