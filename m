Return-Path: <netdev+bounces-9660-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 80EEB72A231
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFFFF1C20AA7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B11EF2107D;
	Fri,  9 Jun 2023 18:29:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63591993B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:29:26 +0000 (UTC)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7787F1730;
	Fri,  9 Jun 2023 11:29:25 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-777a8f11e14so117469739f.1;
        Fri, 09 Jun 2023 11:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686335365; x=1688927365;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VipHoxiMfD3uzdBLsogIXHpx7+dU5e/bPAzRQZ/HDOI=;
        b=MPZlzeF/N0wjk3pdORpbF2+ax4kio6+5W7oVmUmPze5X456SAwxYrefgDZjRrDLm2B
         m0IZo87177UwFN8aSgT7XoCgE/LEGmvL/HLOb4I0hcRbKHmnVD9bFwsmAssPpc6qDhbo
         hVMTKpwah9GOoDKrM9QRXDxsR0WnurfyJauzYc366demiMnUlQzgtmc1BSQ18yDcXWct
         CWLgZm1FRTtPMaRQfsQexZ8Iuo0pj+LAWJwzVM9RzTDpKBDUV+QRWdpvTTnhff24uP5v
         8TBpmvXR73DhZ4DiQGw1z/ljhV1d7YUX0CLnXiQszPJp36wHxWN/zuv3ALP5JErVgMM2
         oq0A==
X-Gm-Message-State: AC+VfDx3/rlfNpNjhPd0KH/7g5jjE3I21tfcxK2madYc2Ms4QGL2AB0v
	ZVC/lhelnLlN2lpcfYd/hQ==
X-Google-Smtp-Source: ACHHUZ6KuLzZy2zhPGS2/wrxoVdTEET1g+fOAumHxv3bxoy5nqKOSecTSc+3ozcHEEmmQeESTno8WQ==
X-Received: by 2002:a05:6e02:68e:b0:331:107d:e96e with SMTP id o14-20020a056e02068e00b00331107de96emr1699736ils.16.1686335364663;
        Fri, 09 Jun 2023 11:29:24 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id r13-20020a92d44d000000b0032ca1426ddesm1219216ilm.55.2023.06.09.11.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:29:24 -0700 (PDT)
Received: (nullmailer pid 1763526 invoked by uid 1000);
	Fri, 09 Jun 2023 18:29:22 -0000
From: Rob Herring <robh@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] mdio: mdio-mux-mmioreg: Use of_property_read_reg() to parse "reg"
Date: Fri,  9 Jun 2023 12:26:16 -0600
Message-Id: <20230609182615.1760266-1-robh@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the recently added of_property_read_reg() helper to get the
untranslated "reg" address value.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/net/mdio/mdio-mux-mmioreg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux-mmioreg.c b/drivers/net/mdio/mdio-mux-mmioreg.c
index c02c9c660016..09af150ed774 100644
--- a/drivers/net/mdio/mdio-mux-mmioreg.c
+++ b/drivers/net/mdio/mdio-mux-mmioreg.c
@@ -140,14 +140,15 @@ static int mdio_mux_mmioreg_probe(struct platform_device *pdev)
 	 * set any bits outside of the 'mask'.
 	 */
 	for_each_available_child_of_node(np, np2) {
-		iprop = of_get_property(np2, "reg", &len);
-		if (!iprop || len != sizeof(uint32_t)) {
+		u64 reg;
+
+		if (of_property_read_reg(np2, 0, &reg, NULL)) {
 			dev_err(&pdev->dev, "mdio-mux child node %pOF is "
 				"missing a 'reg' property\n", np2);
 			of_node_put(np2);
 			return -ENODEV;
 		}
-		if (be32_to_cpup(iprop) & ~s->mask) {
+		if ((u32)reg & ~s->mask) {
 			dev_err(&pdev->dev, "mdio-mux child node %pOF has "
 				"a 'reg' value with unmasked bits\n",
 				np2);
-- 
2.39.2


