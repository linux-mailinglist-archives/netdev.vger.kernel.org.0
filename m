Return-Path: <netdev+bounces-5018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C40270F722
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C47D281406
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD44E60878;
	Wed, 24 May 2023 13:01:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25181775C
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:01:20 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E5D9B;
	Wed, 24 May 2023 06:01:18 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 593FA60005;
	Wed, 24 May 2023 13:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DcILLvgxyjEn2ektgWeiBusqzZCd79fPMyPnGYS4Xow=;
	b=LY6Vzk7vedJ9MOH4asouFhcZ1lLiaeFwD9Z51o6qVcdxev6NXRNHaonfUiNCwbN4UEVzdU
	ofcQ3PK7Eyh79bNSNDCZUignY0ZNTOLR4TjPh3PI56mXt1G8T7OR0uoh1OZ6fyEeGVJSMY
	K+JdNR/fsVVtXUCuQDifHuREIF4f/Ah308gSpxdPY8uQ8G8qPWA+ANolDaWZWOkn4UXxKQ
	dXMX/ksHFAsuL2fUtVIdOdDEklpi52HZ5YV9pZrjYnvglHrTRfFJgwbJXO13+uzCkXPl0Z
	b82aWLaZzwr0A0q74eUr4DQ9Z4h0Ht2KVGFEFYoUtNBAtsEicW7G+kFkMXnNNw==
From: =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
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
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	devicetree@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com ,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v3 3/7] net: dsa: mv88e6xxx: use mv88e6xxx_phy_is_internal in mv88e6xxx_port_ppu_updates
Date: Wed, 24 May 2023 15:01:23 +0200
Message-Id: <20230524130127.268201-4-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230524130127.268201-1-alexis.lothore@bootlin.com>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Make sure to use existing helper to get internal PHYs count instead of
redoing it manually

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---
Changes since v2
- add reviewed-by tags

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


