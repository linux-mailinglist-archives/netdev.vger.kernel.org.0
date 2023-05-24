Return-Path: <netdev+bounces-5020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E91270F725
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 550A71C20CD1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1301A17AD5;
	Wed, 24 May 2023 13:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A2182C6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:01:26 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA3AA9;
	Wed, 24 May 2023 06:01:22 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 93A266000B;
	Wed, 24 May 2023 13:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/KpBTQNbYUCVWHc93n6KUkrBnNtHu99ffD+p+bkadsI=;
	b=fICbrXZxJSkEBR/BqqIYnRWp5wmyh7dwiZCl9GqGl9jIHlply+CKU0xtcee/x/JJpuznt7
	kWnv3ygmyQMuN8CUh6KJ1E6skyM+bn+RzT857MUWLM4G15lPNkrDpT7JryXFEsonoi/W2u
	WfXMgNG8DBqtRdbMVd8yJiYQ0J+jczohKhPiwhus4khHJyqgn57EXpnlxsqBCw8bHvTMF8
	L+JdL7urAkMYA7j6kI6EiWN2eDEsLCdhrkNNdKfQrh6AJlOCbJWpRZ5rYbMuS4nlNd4Txy
	/C3qOdZP5lXJy9Vvza+2bD4tgx3BqIs/D7jfkk7B/RDDyJNyFOr4AqaY+eLP5A==
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
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v3 5/7] net: dsa: mv88e6xxx: fix 88E6393X family internal phys layout
Date: Wed, 24 May 2023 15:01:25 +0200
Message-Id: <20230524130127.268201-6-alexis.lothore@bootlin.com>
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

88E6393X/88E6193X/88E6191X swicthes have in fact 8 internal PHYs, but those
are not present starting at port 0: supported ports go from 1 to 8

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---
Changes since v2:
- add reviewed-by tags

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2716d17c5c49..f15ca17bf9e2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6024,7 +6024,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.name = "Marvell 88E6191X",
 		.num_databases = 4096,
 		.num_ports = 11,	/* 10 + Z80 */
-		.num_internal_phys = 9,
+		.num_internal_phys = 8,
+		.internal_phys_offset = 1,
 		.max_vid = 8191,
 		.max_sid = 63,
 		.port_base_addr = 0x0,
@@ -6047,7 +6048,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.name = "Marvell 88E6193X",
 		.num_databases = 4096,
 		.num_ports = 11,	/* 10 + Z80 */
-		.num_internal_phys = 9,
+		.num_internal_phys = 8,
+		.internal_phys_offset = 1,
 		.max_vid = 8191,
 		.max_sid = 63,
 		.port_base_addr = 0x0,
@@ -6366,7 +6368,8 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.name = "Marvell 88E6393X",
 		.num_databases = 4096,
 		.num_ports = 11,	/* 10 + Z80 */
-		.num_internal_phys = 9,
+		.num_internal_phys = 8,
+		.internal_phys_offset = 1,
 		.max_vid = 8191,
 		.max_sid = 63,
 		.port_base_addr = 0x0,
-- 
2.40.1


