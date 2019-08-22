Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1869A1EC
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391371AbfHVVQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:16:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33605 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390414AbfHVVP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:15:56 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so6731589wrr.0;
        Thu, 22 Aug 2019 14:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W1FNCrNnXxN2/QCtRCe8rujqC6nAfE/fwtvSmwo86ho=;
        b=u9uG4WzXRi7xfjev4QAdR8xBQJZYDnOSV5fPq+Zc6cQ6e5CNNjHCOTFWAeqsXhGwQk
         kitD/MjaSnyLmuF+vG6X5hSBpoBqud6VpyOgceFQfqfb4c+YC83XgqqqU/Jb4G44PT3d
         xjnHF90r6dV0NF6oRIwzLa1IVH3VwXMw1pnHRZR/cwg9ve6coCbyqA+3wOsBouPSLxBw
         Z3YN1xGTujZSEmi+ywKoUh+3EmP9ZPumdmYnBiQ00ytatyLGd+JQqxMGmro/+RJSlI5c
         Fj70VZ1q2dTA+Qcc8kdn81beUXlg+44wu+0Ykntim7kurc6PNCowwgil9m6qops48WmX
         7TnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W1FNCrNnXxN2/QCtRCe8rujqC6nAfE/fwtvSmwo86ho=;
        b=cpSIWwoG3/agDcy1cbpj/AyCxMAqfyqxRKUFCQY0LZJvLbOUIZXgwpIUABmdajml2m
         0YN9V+7vKL6SkgBWa5uUQJv5JTHIKEPdyrbfBP5kIEGtGzA10CuSBFY5UtpEg3w+974/
         TdE02HmxE3f3q0dWOsoimc5sI5sPHKaEGz0c5ZQPhcbYeOFty0SXq0IFJIpzXogv9nBc
         91oRLh5qAgctEIhrm3UXvjX6YNNe2y1BgkGb4sUngMRupoT0krwjTdg23DCzSBeX0K7G
         NVh8/8iMXWS1bJTBmXR59NL2WW42IFJUq4DQC4X7nC00MM8/FFXMzNP9SYu4FWsTExxO
         FBJg==
X-Gm-Message-State: APjAAAVq7CCxZe9Z4RtTuOnE/duLF95Ni+DiWSyXKfMQxg4WAcvtVXQl
        UX2PJkY9qgHRHkIGycAkGI8=
X-Google-Smtp-Source: APXvYqxrNYl9VM7eGVqaMg5RDku84AwmuFLk1/8d2JGDiD9bPciaIQIeUKMpHERycQmQMNJb5IOwAQ==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr911812wrn.264.1566508553725;
        Thu, 22 Aug 2019 14:15:53 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id g197sm578488wme.30.2019.08.22.14.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 14:15:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh@kernel.org>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH v2 5/5] ARM: dts: ls1021a-tsn: Use the DSPI controller in poll mode
Date:   Fri, 23 Aug 2019 00:15:14 +0300
Message-Id: <20190822211514.19288-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822211514.19288-1-olteanv@gmail.com>
References: <20190822211514.19288-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connected to the LS1021A DSPI is the SJA1105 DSA switch. This
constitutes 4 of the 6 Ethernet ports on this board.

As the SJA1105 is a PTP switch, constant disciplining of its PTP clock
is necessary, and that translates into a lot of SPI I/O even when
otherwise idle.

Switching to using the DSPI in poll mode has several distinct
benefits:

- With interrupts, the DSPI driver in TCFQ mode raises an IRQ after each
  transmitted byte. There is more time wasted for the "waitq" event than
  for actual I/O. And the DSPI IRQ count is by far the largest in
  /proc/interrupts on this board (larger than Ethernet). I should
  mention that due to various LS1021A errata, other operating modes than
  TCFQ are not available.

- The SPI I/O time is both lower, and more consistently so. For a TSN
  switch it is important that all SPI transfers take a deterministic
  time to complete.
  Reading the PTP clock is an important example.
  Egressing through the switch requires some setup in advance (an SPI
  write command). Without this patch, that operation required a
  --tx_timestamp_timeout 50 (ms), now it can be done with
  --tx_timestamp_timeout 10.
  Yet another example is reconstructing timestamps, which has a hard
  deadline because the PTP timestamping counter wraps around in 0.135
  seconds. Combined with other I/O needed for that to happen, there is
  a real risk that the deadline is not always met.

See drivers/net/dsa/sja1105/ for more info about the above.

Cc: Rob Herring <robh@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 arch/arm/boot/dts/ls1021a-tsn.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/ls1021a-tsn.dts b/arch/arm/boot/dts/ls1021a-tsn.dts
index 5b7689094b70..1c09cfc766af 100644
--- a/arch/arm/boot/dts/ls1021a-tsn.dts
+++ b/arch/arm/boot/dts/ls1021a-tsn.dts
@@ -33,6 +33,7 @@
 };
 
 &dspi0 {
+	/delete-property/ interrupts;
 	bus-num = <0>;
 	status = "okay";
 
-- 
2.17.1

