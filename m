Return-Path: <netdev+bounces-2410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A573701C3B
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 09:48:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8610E1C20AA9
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 07:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1591C37;
	Sun, 14 May 2023 07:48:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733D41C30
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 07:48:28 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5F52D47
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 00:48:13 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ab1ce53ca6so82551245ad.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 00:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1684050493; x=1686642493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXMOTCbN4pJHC2KQ8XGHSVJ9bZ+JD3sMLsrY84T9zCg=;
        b=azGjwxqhbzeX67GBbt3bcHqoIgoCGl5i80BhgsZq2X3loYVux9ag97RU0oJ8Za63hk
         fxKzsd2u9AlRhI445awheLBaJXtU+lmgGbRU3PqLSQb/xr2c7khgj9GZwe6v3MZ8JvYB
         8cSJhjqywpqVBdsYF/G3JQVrzM/vUYWjns6Rw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684050493; x=1686642493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXMOTCbN4pJHC2KQ8XGHSVJ9bZ+JD3sMLsrY84T9zCg=;
        b=Vhmz0mO3NP913HxEJpF5kZa75h/cTSGRmXOWJHNebNiPd6IXqkkL2E2u8riSGmLQiE
         KsL6Hl+B3/sknVeXJZTHFjzBNf0jWpTu3ugzAh8vscKvPqjLsnRo0TZ/h1Hy2sCHpi69
         y7cHdGZzj4FxbgMemb241szqEhwEC0EjjULv8DujaZGhSWmEDk/J+TfyHGvpnM7xfj6p
         PIodRJAiZK7zwEvIpbe0NJse8TUnOeE6ljPsGaZ8lof0iF5HEyzug4H2iEbfBsAc939Z
         cmqyGShUBNMCokXGFBEO0HTdcco9ffzCq5t9V6TGMyXU6bhu/gfGdj7WP6506I2N3ncw
         ZA4A==
X-Gm-Message-State: AC+VfDzMgn2ZtvBGq/XPhMq3q9+KEKb4vHBW6ZjyO33Qtvvi0qgv4ofG
	6r9Ukd7acgMWGm3AVzlwjllSdQ==
X-Google-Smtp-Source: ACHHUZ7nuNI32aku8He5WevcEmfdir2RB6FIdCP/I07cZYqXxRCmHW80kT4iPbcyjRSz4TjOHJo6Tw==
X-Received: by 2002:a17:902:d2c7:b0:1a9:90bc:c3c6 with SMTP id n7-20020a170902d2c700b001a990bcc3c6mr39582395plc.16.1684050492641;
        Sun, 14 May 2023 00:48:12 -0700 (PDT)
Received: from 8add390ca20e.heitbaum.com ([122.199.31.3])
        by smtp.googlemail.com with ESMTPSA id j4-20020a17090276c400b00194caf3e975sm10903363plt.208.2023.05.14.00.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 00:48:12 -0700 (PDT)
From: Rudi Heitbaum <rudi@heitbaum.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	anarsoul@gmail.com,
	alistair@alistair23.me
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-bluetooth@vger.kernel.org,
	Rudi Heitbaum <rudi@heitbaum.com>
Subject: [PATCH 3/3] arm64: dts: allwinner: h6: tanix-tx6: Add compatible bluetooth
Date: Sun, 14 May 2023 07:47:31 +0000
Message-Id: <20230514074731.70614-4-rudi@heitbaum.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230514074731.70614-1-rudi@heitbaum.com>
References: <20230514074731.70614-1-rudi@heitbaum.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tanix TX6 comes either with RTL8822BS or RTL8822CS wifi+bt combo module.
Add compatible for RTL8822BS as it uses different firmware.

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
index 9a38ff9b3fc7..9460ccbc247d 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
@@ -21,7 +21,7 @@ &uart1 {
 	status = "okay";
 
 	bluetooth {
-		compatible = "realtek,rtl8822cs-bt";
+		compatible = "realtek,rtl8822bs-bt", "realtek,rtl8822cs-bt";
 		device-wake-gpios = <&r_pio 1 2 GPIO_ACTIVE_HIGH>; /* PM2 */
 		host-wake-gpios = <&r_pio 1 1 GPIO_ACTIVE_HIGH>; /* PM1 */
 		enable-gpios = <&r_pio 1 4 GPIO_ACTIVE_HIGH>; /* PM4 */
-- 
2.25.1


