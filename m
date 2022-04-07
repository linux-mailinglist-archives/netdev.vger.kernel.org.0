Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D124F6F12
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiDGAWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 20:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiDGAWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 20:22:44 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0427310FDC0;
        Wed,  6 Apr 2022 17:20:47 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id m12so5421163ljp.8;
        Wed, 06 Apr 2022 17:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWtJUufTgUTljvZ4DozO/AYXP9ooRGM/t22SC5y7uYA=;
        b=bLQrgQZODjMU1wcMWA5gBZOJuqUE9bcHLDl/d/BAt0fQ94wmNB9i743jzJXSE+ITsd
         Ee8BwbyGo46OtYPTZksNesNtCBpuA2em1uujIYf5jD/AddIkxSkPqlVQYr0PSYsHwjDB
         bSG3n+3/96s3Bf+5iCNNRK7AmHivyyJ3azBcg/vr9FvUXVWXLjuzjngvqYJH9ZHu4xOu
         +oOy3n9oMju699yuttQuk6hfXZtcaBUZQuDhacSp2IVk6PUyUSvkz7Dbss052b3Lc3Oz
         KxFhINxQVmt7opgfGvGY7hKcs4QZiPS4zJbxrxZmKj8d0gZzutGU6FMIU/jMLlGxxeN6
         oWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWtJUufTgUTljvZ4DozO/AYXP9ooRGM/t22SC5y7uYA=;
        b=VZRM406GiSjlUNUt3tK4T7Egg0pgUd3okuhYs64Hkpesy3ShrGRBc98BKk6/JSJKiT
         g5hWSn4Fo4kvm5YP50kZseAEYNtDyzzGppzikL3NZSlPiOlZytn43LyBBWXXIEBq9O5n
         CT8r3NxXTfAK6AkFJD0YXRdogWcrfp6sts43BHgXR4fNi2haad+UCBjfUTAx8Js8NbUt
         DTmrbbUvcT99J1TkRlfqJnV0lHroOyZy37L+i/Kxrooy26bDquz0B51dW/6BYMzSq2df
         TDNIyfYRK9+fdToVoQptj0p+RDd/3wkuE1sVq8i6blCvud7eaxWNIUZImH0oJ3mfpjEs
         ZBPg==
X-Gm-Message-State: AOAM531D2LIwxSPkoTIdLvNgbtZ+NcFmmILSRZB+VtdGk9Z7KdQYtz9t
        7P2kO32GicGywIVqfqqdc5iZgrcNBD8=
X-Google-Smtp-Source: ABdhPJy5yX1EG2vjtAEvuN/327uGdZseybjoWauMDvgf211zsKE6iR2ite/LlZiapQ6bE4QTYRFGMw==
X-Received: by 2002:a2e:b94b:0:b0:249:6181:468a with SMTP id 11-20020a2eb94b000000b002496181468amr7023837ljs.113.1649290845324;
        Wed, 06 Apr 2022 17:20:45 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id n12-20020a2e86cc000000b0024b121fbb2csm1413879ljj.46.2022.04.06.17.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:20:45 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 3/3] rndis_host: limit scope of bogus MAC address detection to ZTE devices
Date:   Thu,  7 Apr 2022 02:19:26 +0200
Message-Id: <20220407001926.11252-4-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407001926.11252-1-lech.perczak@gmail.com>
References: <20220407001926.11252-1-lech.perczak@gmail.com>
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

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Suggested-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---
 drivers/net/usb/rndis_host.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index a7eb032115e8..55ff0461d39b 100644
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
@@ -607,7 +614,7 @@ static const struct driver_info	rndis_poll_status_info = {
 static const struct driver_info	zte_rndis_info = {
 	.description =	"ZTE RNDIS device",
 	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
-	.bind =		rndis_bind,
+	.bind =		zte_rndis_bind,
 	.unbind =	rndis_unbind,
 	.status =	rndis_status,
 	.rx_fixup =	zte_rndis_rx_fixup,
-- 
2.30.2

