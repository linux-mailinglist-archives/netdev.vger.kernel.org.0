Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82E204EA5
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbgFWKAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:00:02 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:42093 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731947AbgFWKAC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:00:02 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f5c9a53e;
        Tue, 23 Jun 2020 09:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=4dopyPj/KdCR6a3iZO+zjrh02
        zQ=; b=qAZRlfUU8zV1RAgK6sDqnfnOgoVmFFjMVA4I/hM3GNWp2OtnnwBhSAfhc
        hrSMUFCYwA+SxiG65aG2oG+1m5Zoa9yISFPD8c64rFn5CF0PwqxAJuxNGwQlWehr
        UgXtj9L4KkEMBFJcSaZWAUj5UJH2uiCmlxQVc2I2Ibh2EDJFuNUrYaGghzVmrdxD
        H28eFnoEEqwOOr7r49txR8a73xeh3oYNaqMsl42q4lG3MzViMnxeNWM4zB2p0LKd
        fNFMmypOvGRdOxQaCZSSJlHSdc+CY8yMtdLlPVvD8TU6SSFYHhAFQAGCLnw5ulll
        /y6eOzq6o/e6GS0lUvwVppElZV/CA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b3d3d1f2 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 23 Jun 2020 09:41:08 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Frank Werner-Krippendorf <mail@hb9fxq.ch>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/2] wireguard: noise: do not assign initiation time in if condition
Date:   Tue, 23 Jun 2020 03:59:44 -0600
Message-Id: <20200623095945.1402468-2-Jason@zx2c4.com>
In-Reply-To: <20200623095945.1402468-1-Jason@zx2c4.com>
References: <20200623095945.1402468-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Werner-Krippendorf <mail@hb9fxq.ch>

Fixes an error condition reported by checkpatch.pl which caused by
assigning a variable in an if condition in wg_noise_handshake_consume_
initiation().

Signed-off-by: Frank Werner-Krippendorf <mail@hb9fxq.ch>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/noise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 626433690abb..201a22681945 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -617,8 +617,8 @@ wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
 	memcpy(handshake->hash, hash, NOISE_HASH_LEN);
 	memcpy(handshake->chaining_key, chaining_key, NOISE_HASH_LEN);
 	handshake->remote_index = src->sender_index;
-	if ((s64)(handshake->last_initiation_consumption -
-	    (initiation_consumption = ktime_get_coarse_boottime_ns())) < 0)
+	initiation_consumption = ktime_get_coarse_boottime_ns();
+	if ((s64)(handshake->last_initiation_consumption - initiation_consumption) < 0)
 		handshake->last_initiation_consumption = initiation_consumption;
 	handshake->state = HANDSHAKE_CONSUMED_INITIATION;
 	up_write(&handshake->lock);
-- 
2.27.0

