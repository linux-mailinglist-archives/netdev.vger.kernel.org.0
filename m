Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360098F814
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 02:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfHPApQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 20:45:16 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54910 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfHPApO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 20:45:14 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so2700168wme.4;
        Thu, 15 Aug 2019 17:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SHwMVZf7nnhZ7srHZdoBKuigZ9THCKn0JvEgWlDyC5w=;
        b=gIXxVEB1SXZ42dG9/uCZEDsvm7VU5YyVftLmjsYuJVTtcs/ww5GTNNTrrkeDH5KHkp
         th4uXAVfEFDvDWhJ+Z28jRMengS8p6oxK62PHAovodql1w/5o0aajkt09FiwxalWXKb3
         mkKJxLrQBhFTfr+Gh0hM74iA0nM602qxbPsuorU7H1UpGJ2ICx9OhrY9VAAaXKJLEKCf
         6YaCqy5SOq3zCvFFmcbqIKD52QVHX4knZqJ8CFHQre4xyzsspJPOdGfzfm4CB7MFwGRw
         kq4Woey8lLdxoiTo6iU3eqYiZj02U7v/xepPvF5x3MZAl1fK63CJAwo7SQ9jBZVC69dh
         Medw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SHwMVZf7nnhZ7srHZdoBKuigZ9THCKn0JvEgWlDyC5w=;
        b=paqoo+e3LQZn2byGmsWsRt4ajQaOp//0FmKAdFxOh3GgvCcW0jP3hCxvcecahG0CeK
         akT9nHW/oFf66RpsrBzXha6QN50mhGzOejxDuQ3D+gAnExwe4kujNeOCrI6ERx1V511J
         MoMiNV7tTc1sOeD6UnsBnI9kiXRhQ8rwENBbxD4LlRh4T2GJKg0QeY/B180JCs+P6jLJ
         AgYbQESCggJz8/FpGCn5hPXs9EXslEMA8mlsHnDy1rOhIK/4FDMVEeHTjeHmDkU1HyUh
         xqI0uKOsoSsOrZNrPSOQiD7+E8si/McZvUCv885Dy/ZhkcakR973Vnv+aQdIIdxn/l/R
         wuPg==
X-Gm-Message-State: APjAAAUYUkRVyhX2DbGLM+DhsVqrwhUdcy3fya8qAKrwPakt1Tmly4kY
        ag3/mgpOsnvs/OFz8/XakTg=
X-Google-Smtp-Source: APXvYqwcQlBf96018l21ogc6HgqjWYc+Tj4Ut68GuDzrs5J/DF7aX5WDIEBaVUHh24ehNyM43iQ33A==
X-Received: by 2002:a1c:a481:: with SMTP id n123mr4348381wme.123.1565916312411;
        Thu, 15 Aug 2019 17:45:12 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id k124sm6451204wmk.47.2019.08.15.17.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 17:45:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next 10/11] ARM: dts: ls1021a-tsn: Use the DSPI controller in poll mode
Date:   Fri, 16 Aug 2019 03:44:48 +0300
Message-Id: <20190816004449.10100-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190816004449.10100-1-olteanv@gmail.com>
References: <20190816004449.10100-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connected to the LS1021A DSPI is the SJA1105 DSA switch. This
constitutes 4 of the 6 Ethernet ports on this board. When using the
board as a PTP switch and bridging all 6 ports under one single L2
entity, it is good to also have the PTP clocks of the switch and of the
standalone Ethernet ports in sync.

This cannot be done with hardware timestamping, and is where phc2sys
comes into play. Using poll mode for SPI access helps ensure that all
transfers take a deterministic time to complete, which is an important
requirement for a TSN switch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 6cec454c484c..3b35e6b5977f 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -37,6 +37,7 @@
 	bus-num = <0>;
 	/* EXP1_GPIO6 is GPIO4_18 */
 	debug-gpios = <&gpio3 18 GPIO_ACTIVE_HIGH>;
+	/delete-property/ interrupts;
 	status = "okay";
 
 	/* ADG704BRMZ 1:4 SPI mux/demux */
-- 
2.17.1

