Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B4340D96C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbhIPMFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238813AbhIPMF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:05:29 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB402C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:08 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id m3so15727717lfu.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H0bHfm2OHc/+R26LWx41QW/EjW8T978QdQn3bUA25nM=;
        b=CDPdy1jDmdSzJdQCO5FmKXuWbeM/VbdrSDcV1detcw+a0KqARZKtTem77oSY1w50Fu
         /LV/dyPcxCMa1K14jRhBwsrEuK6+7I8mJwe6SCRZ2d+jUJUQR3FYvPVUOme39boemzDo
         xP793KzxjyWChTI25QVzIvttSIdt3GaHIE08mTToqL5Swi4qreOBS4pg6Pb96CZzpWMq
         usUOSmdAFhDM+N61IQHxLmRwpj+2KYq1WshX+pzhsiwbT5+95+9L5D+q1W19QOySJ2rt
         jJLMNj72gsVwhRm/UhsA/9Ba/40nhX1ppOx1ObTAqE5ls0W6ML8/nz1WCgqTnpObswo7
         lLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H0bHfm2OHc/+R26LWx41QW/EjW8T978QdQn3bUA25nM=;
        b=HssCo8kEko9jcbypbRJZz0G9uWBrlRCI1D1PkmpFaluqbUnr/dWuzUjZ/pF0e8c6Ju
         llh3HH2lKaey92t4mIpP5sNaEaSIeLOUy33UPN/vA4Ku4bcS5j9H25SQQqi+1Ykl8m2D
         7rvfv5iJhndgzKlYvqdVada57n1gE9D7sKUHdaOQLv0LzLH19QRDWcsHqmc0lrpcgWRM
         2FMqbfHo4530L2blOh55U/Q0tjK3Ywn3ptWT5m5VgqkxgjSZofVnqYFK7ZTy1wZ1TQMw
         xI06NKf0JRDkEer3SrcSRKJ9PP3f6wcwbUMX25tuFKP//3PL+F9utdaP+FooL4Eta/AM
         hSKA==
X-Gm-Message-State: AOAM533pEBkMlTq50r6qWOCn6ZrFeN/4VGuI8/5TfiFBX00FO43w6+7Q
        pj3+uaStITsSPbKXohR8wBA=
X-Google-Smtp-Source: ABdhPJzZDhE7Aahu3ziMYV875Hv9JwSJhpXDe1LUjzRsfoohFLldhmuteIYlUVaI4kvxKhaQGuO/KA==
X-Received: by 2002:a2e:a782:: with SMTP id c2mr4532555ljf.381.1631793847055;
        Thu, 16 Sep 2021 05:04:07 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h8sm243010lfk.227.2021.09.16.05.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 05:04:06 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 1/4] net: dsa: b53: Include all ports in "enabled_ports"
Date:   Thu, 16 Sep 2021 14:03:51 +0200
Message-Id: <20210916120354.20338-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210916120354.20338-1-zajec5@gmail.com>
References: <20210916120354.20338-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Make "enabled_ports" bitfield contain all available switch ports
including a CPU port. This way there is no need for fixup during
initialization.

For BCM53010, BCM53018 and BCM53019 include also other available ports.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 604f54112665..47a00c5364c7 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2302,7 +2302,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM5325_DEVICE_ID,
 		.dev_name = "BCM5325",
 		.vlans = 16,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x3f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
 		.imp_port = 5,
@@ -2313,7 +2313,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM5365_DEVICE_ID,
 		.dev_name = "BCM5365",
 		.vlans = 256,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x3f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
 		.imp_port = 5,
@@ -2324,7 +2324,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM5389_DEVICE_ID,
 		.dev_name = "BCM5389",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x11f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2338,7 +2338,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM5395_DEVICE_ID,
 		.dev_name = "BCM5395",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x11f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2352,7 +2352,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM5397_DEVICE_ID,
 		.dev_name = "BCM5397",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x11f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2366,7 +2366,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM5398_DEVICE_ID,
 		.dev_name = "BCM5398",
 		.vlans = 4096,
-		.enabled_ports = 0x7f,
+		.enabled_ports = 0x17f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2380,7 +2380,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM53115_DEVICE_ID,
 		.dev_name = "BCM53115",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x11f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.vta_regs = B53_VTA_REGS,
@@ -2394,7 +2394,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM53125_DEVICE_ID,
 		.dev_name = "BCM53125",
 		.vlans = 4096,
-		.enabled_ports = 0xff,
+		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2436,7 +2436,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM53010_DEVICE_ID,
 		.dev_name = "BCM53010",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2478,7 +2478,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM53018_DEVICE_ID,
 		.dev_name = "BCM53018",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2492,7 +2492,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.chip_id = BCM53019_DEVICE_ID,
 		.dev_name = "BCM53019",
 		.vlans = 4096,
-		.enabled_ports = 0x1f,
+		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
@@ -2634,7 +2634,6 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->cpu_port = 5;
 	}
 
-	dev->enabled_ports |= BIT(dev->cpu_port);
 	dev->num_ports = fls(dev->enabled_ports);
 
 	dev->ds->num_ports = min_t(unsigned int, dev->num_ports, DSA_MAX_PORTS);
-- 
2.26.2

