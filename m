Return-Path: <netdev+bounces-3926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D101709933
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:14:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 317CC280F5A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E64110975;
	Fri, 19 May 2023 14:13:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047C610955
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:13:08 +0000 (UTC)
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675DF1A8;
	Fri, 19 May 2023 07:13:06 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id A885FE0010;
	Fri, 19 May 2023 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684505585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/PdR+46jyf8bKiK0AiqIRHB98lWg+txwfuVwXSZEZOI=;
	b=OrZjSUTtbd3MYNoQhzPqmL+Bt6G6R77yrFw7tD2/YyxBo+hNhCGJzyHYsfdMHw+3iwgPcz
	n8QTKAER1dQOZIY2BF2fxptOIOoZFj1ASvgGO8UAVuRZMxBReYxt1NUAYYHI2Funj7vlB5
	9zVHXA+GF2knPytanEyeqc4hZgAviLHaDlPPMflvtS/k8n9pU87RdHh/mlTUwZrDPN+Vfw
	PXBNAZSE0d08wEfI/6p21zTlycAGyFJBcKyUKkseEHpKvVzTZw7WEyJp6swgkOLuPE1OrM
	GMykI+EFwl7JGGy2nLvTO28rgFwizsQw6cXKfTrvNy83YEw1eos74CVondSWtA==
From: alexis.lothore@bootlin.com
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	paul.arola@telus.com,
	scott.roberts@telus.com,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v2 3/7] net: dsa: mv88e6xxx: use mv88e6xxx_phy_is_internal in mv88e6xxx_port_ppu_updates
Date: Fri, 19 May 2023 16:12:59 +0200
Message-Id: <20230519141303.245235-4-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519141303.245235-1-alexis.lothore@bootlin.com>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

Make sure to use existing helper to get internal PHYs count instead of
redoing it manually

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 93bcfa5c80e1..c812e52bb5b7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -477,7 +477,7 @@ static int mv88e6xxx_port_ppu_updates(struct mv88e6xxx_chip *chip, int port)
 	 * report whether the port is internal.
 	 */
 	if (chip->info->family == MV88E6XXX_FAMILY_6250)
-		return port < chip->info->num_internal_phys;
+		return mv88e6xxx_phy_is_internal(chip, port);
 
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
 	if (err) {
-- 
2.40.1


