Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1584FEC73
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 03:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbiDMBq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 21:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiDMBqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 21:46:49 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CB352E40;
        Tue, 12 Apr 2022 18:44:30 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 17so483410lji.1;
        Tue, 12 Apr 2022 18:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5aNZYeUYDfIbOemrUHc4Mql5VkqNDGGwgnSk/laqkR8=;
        b=VzgWXGnNjnqKhQd5YAZ8hWVjbUagXCcZb1WhEAaG745M6nxWZybOVC6aWeLeP02rlG
         xCCXJZ1JOChfI9rlBIFXL9v5dWfFxzFXRi5MqKfcqCEWJvH80zHFcI1XghlYgdBP3c7B
         l+oqLiDKI1/lkNmoic28HPMyCX/kflxriWsX8p+4zoBUlQYZ7tshDEp9okY0gTw5YwGw
         MIQ8GNPfzt8kkElYSusRZt4ky67FiOg/3MGhIAeJCoq+of61j1Nz176OOhqYSUtawIgF
         AyffHQ//1iAjQjEbc9Iq5Amz169n4dMLfJyZLYp3ahYl0URTpMM86Tp/PMIBHQFVJwXl
         /lWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5aNZYeUYDfIbOemrUHc4Mql5VkqNDGGwgnSk/laqkR8=;
        b=UTMH6QPqtQqNdLPcI6lw0VD1vUwfWT6u9nh1Iw5gqzHjNFAc2Qys3gy0a1bL9CjiMs
         BVkjEjMu73l3bXSIIVDL9fX0qlQR8gGlTgljDKNSu/NtCPDywwykPTt5IDYkq+rcw6Mz
         ADrPu8MPjII4Gce4x5fHu51IgX8lMpoMarEVoW+ntU5/MV+U3CkdMC7Yk8R8sLGuKqR3
         9FWVXhWJayzli2dvbGB5wiQlA9N969XqmlBaIonvz2Ly+Az4xdd/zQ1bmbSwQ409XJFf
         Hd8eQO+WRps92sAHe5S2LfBLvpagF+2yMQDN1/97Xr3A+Yf45sA77yVKSfUMAuZLZ2Zm
         eGHw==
X-Gm-Message-State: AOAM53017K5DfuKOE4zVrxtfNyfZ7gcLdWRt+TtO4ffCJBw3IdHW/ODF
        tXH7nSkvG7o4uYhGbQtf0y46ukK6nSC2CA==
X-Google-Smtp-Source: ABdhPJzJNa1HQ6lfobavQaQ7VNNQ10OKCHmmnj1nm2HBxzA3IeI1Be5V/coATxAvyiNSQUQ4CX+bNQ==
X-Received: by 2002:a2e:934d:0:b0:24b:41cf:fb50 with SMTP id m13-20020a2e934d000000b0024b41cffb50mr19008281ljh.336.1649814268559;
        Tue, 12 Apr 2022 18:44:28 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id u3-20020a197903000000b00464f4c76ebbsm1915574lfc.94.2022.04.12.18.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 18:44:28 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v3 3/3] rndis_host: limit scope of bogus MAC address detection to ZTE devices
Date:   Wed, 13 Apr 2022 03:44:16 +0200
Message-Id: <20220413014416.2306843-4-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413014416.2306843-1-lech.perczak@gmail.com>
References: <20220413014416.2306843-1-lech.perczak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reporting of bogus MAC addresses and ignoring configuration of new
destination address wasn't observed outside of a range of ZTE devices,
among which this seems to be the common bug. Align rndis_host driver
with implementation found in cdc_ether, which also limits this workaround
to ZTE devices.

Suggested-by: Bjørn Mork <bjorn@mork.no>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---

v3: No changes to the patch.

v2:
- No logical changes, just rebased on top of previous patches.

 drivers/net/usb/rndis_host.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 7a9ece2de2c5..4e70dec30e5a 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -418,10 +418,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 		goto halt_fail_and_release;
 	}
 
-	if (bp[0] & 0x02)
-		eth_hw_addr_random(net);
-	else
-		eth_hw_addr_set(net, bp);
+	eth_hw_addr_set(net, bp);
 
 	/* set a nonzero filter to enable data transfers */
 	memset(u.set, 0, sizeof *u.set);
@@ -463,6 +460,16 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 	return generic_rndis_bind(dev, intf, FLAG_RNDIS_PHYM_NOT_WIRELESS);
 }
 
+static int zte_rndis_bind(struct usbnet *dev, struct usb_interface *intf)
+{
+	int status = rndis_bind(dev, intf);
+
+	if (!status && (dev->net->dev_addr[0] & 0x02))
+		eth_hw_addr_random(dev->net);
+
+	return status;
+}
+
 void rndis_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct rndis_halt	*halt;
@@ -615,7 +622,7 @@ static const struct driver_info	zte_rndis_info = {
 	.description =	"ZTE RNDIS device",
 	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
 	.data =		RNDIS_DRIVER_DATA_DST_MAC_FIXUP,
-	.bind =		rndis_bind,
+	.bind =		zte_rndis_bind,
 	.unbind =	rndis_unbind,
 	.status =	rndis_status,
 	.rx_fixup =	rndis_rx_fixup,
-- 
2.30.2

