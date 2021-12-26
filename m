Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E900347F7BE
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhLZPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbhLZPii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 10:38:38 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B695C061761;
        Sun, 26 Dec 2021 07:38:38 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id B84C944B0B;
        Sun, 26 Dec 2021 15:38:29 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 15/34] ACPI / property: Support strings in Apple _DSM props
Date:   Mon, 27 Dec 2021 00:36:05 +0900
Message-Id: <20211226153624.162281-16-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Wi-Fi module in Apple machines has a "module-instance" device
property that specifies the platform type and is used for firmware
selection. Its value is a string, so add support for string values in
acpi_extract_apple_properties().

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/acpi/x86/apple.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/apple.c b/drivers/acpi/x86/apple.c
index c285c91a5e9c..71b8f103ab0f 100644
--- a/drivers/acpi/x86/apple.c
+++ b/drivers/acpi/x86/apple.c
@@ -70,13 +70,16 @@ void acpi_extract_apple_properties(struct acpi_device *adev)
 
 		if ( key->type != ACPI_TYPE_STRING ||
 		    (val->type != ACPI_TYPE_INTEGER &&
-		     val->type != ACPI_TYPE_BUFFER))
+		     val->type != ACPI_TYPE_BUFFER &&
+		     val->type != ACPI_TYPE_STRING))
 			continue; /* skip invalid properties */
 
 		__set_bit(i, valid);
 		newsize += key->string.length + 1;
 		if ( val->type == ACPI_TYPE_BUFFER)
 			newsize += val->buffer.length;
+		else if (val->type == ACPI_TYPE_STRING)
+			newsize += val->string.length + 1;
 	}
 
 	numvalid = bitmap_weight(valid, numprops);
@@ -118,6 +121,12 @@ void acpi_extract_apple_properties(struct acpi_device *adev)
 		newprops[v].type = val->type;
 		if (val->type == ACPI_TYPE_INTEGER) {
 			newprops[v].integer.value = val->integer.value;
+		} else if (val->type == ACPI_TYPE_STRING) {
+			newprops[v].string.length = val->string.length;
+			newprops[v].string.pointer = free_space;
+			memcpy(free_space, val->string.pointer,
+			       val->string.length);
+			free_space += val->string.length + 1;
 		} else {
 			newprops[v].buffer.length = val->buffer.length;
 			newprops[v].buffer.pointer = free_space;
-- 
2.33.0

