Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C8F30ADF6
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhBARdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhBARaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:30:21 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC10C061793
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:29:01 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d6so16367633ilo.6
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AD7sJiqeRNIVKYtmxnmsyabUetsvJJmTXIczDFUxnes=;
        b=j0ZNpjxFBP2YppUXpqlylkEtM0G6AwPuOwVc962pTU0wtZ0pfH+rl/2UiD5RinVsk2
         9BKOVNgo3UoAEy2lKvayX3xIsUDH5n2AFvTXoEUd8RhvHK1w2K8mNp0CN1kUFx70feSP
         9BTvoZpyU95S99+jEEuOarwPkJGC78QnCaoDFtIXMiRKfdylC9e39ICQBh/yNusj3beq
         FtnNFtqMnyiquX7EKXfXBDX0rHiwEBynmzuXGTDCeeVC02XCHbsoJGZQujh2wvL9sfOq
         3mwRhjrGJCN2uSJ3fvA1peL0QkScFRrBBS8sVEsADr9C2LNkR7TpGpkAK4nA66/dM2xT
         89Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AD7sJiqeRNIVKYtmxnmsyabUetsvJJmTXIczDFUxnes=;
        b=OteNUV1J9VHW2wDcKnD21Fbxcb20Kp9EBlM1SCvF/ozJM38ndnOD3I5uxEOkqPvr9I
         P1k+ltgREPgtwh+v8LDyPTNg9kviQwsPOHxYiATntgt4VIHHmTHZn99TNRvnm4ToBJop
         bkvltc62I2uWWRRzCNVds4PZwY+d6gdpVwKh5By97xZDw+1z+TmohORx8AELwv72m2+H
         xxZpwnCCONp8RsLhNwO30PwI3usasm5Ly9iSf3IyXHX9TMqBq1Yc6WBXnh76QlpGf3tH
         kgWyKVq3zkoTrAGYqt7oEplzqS3zuTSZP35t7PPREdHPxJBpfEauJHv2x2qja2t1Ge84
         R/hw==
X-Gm-Message-State: AOAM5327GJWDkOzNL+Qz9BNZW+aSSeIRn85Khg13yegW40ygNLfU2mwN
        nUysdJubOk6/5IKMphD//EM0OHXxRkrksw==
X-Google-Smtp-Source: ABdhPJz4NDQOsBIkEDNxq29t5pxY6NvHO74UsGOfqY6G+o86HbVtQQfgm2h2tr+Vo0gGHer3NOsz7w==
X-Received: by 2002:a05:6e02:1b84:: with SMTP id h4mr5304965ili.196.1612200541274;
        Mon, 01 Feb 2021 09:29:01 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v2sm9529856ilj.19.2021.02.01.09.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:29:00 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: ipa: disable interrupt and NAPI after channel stop
Date:   Mon,  1 Feb 2021 11:28:48 -0600
Message-Id: <20210201172850.2221624-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201172850.2221624-1-elder@linaro.org>
References: <20210201172850.2221624-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable both the I/O completion interrupt and NAPI polling on a
channel *after* we successfully stop it rather than before.  This
ensures a completion occurring just before the channel is stopped
gets processed.

Enable NAPI polling and the interrupt *before* starting a channel
rather than after, to be symmetric.  A stopped channel won't
generate any completion interrupts anyway.

Enable NAPI before the interrupt and disable it afterward.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Update code for *both* NAPI and the completion interrupt.

 drivers/net/ipa/gsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 565c785e33a25..93e1d29b28385 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -860,15 +860,18 @@ static int __gsi_channel_start(struct gsi_channel *channel, bool start)
 	struct gsi *gsi = channel->gsi;
 	int ret;
 
+	napi_enable(&channel->napi);
+	gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
+
 	mutex_lock(&gsi->mutex);
 
 	ret = start ? gsi_channel_start_command(channel) : 0;
 
 	mutex_unlock(&gsi->mutex);
 
-	if (!ret) {
-		gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
-		napi_enable(&channel->napi);
+	if (ret) {
+		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
+		napi_disable(&channel->napi);
 	}
 
 	return ret;
@@ -908,14 +911,11 @@ static int __gsi_channel_stop(struct gsi_channel *channel, bool stop)
 	int ret;
 
 	gsi_channel_trans_quiesce(channel);
-	napi_disable(&channel->napi);
-	gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
 
 	ret = stop ? gsi_channel_stop_retry(channel) : 0;
-
-	if (ret) {
-		gsi_irq_ieob_enable_one(gsi, channel->evt_ring_id);
-		napi_enable(&channel->napi);
+	if (!ret) {
+		gsi_irq_ieob_disable_one(gsi, channel->evt_ring_id);
+		napi_disable(&channel->napi);
 	}
 
 	return ret;
-- 
2.27.0

