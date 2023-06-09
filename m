Return-Path: <netdev+bounces-9563-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70684729C91
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AC37281861
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 683DC18007;
	Fri,  9 Jun 2023 14:18:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D96514293
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:18:18 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AAC30E8;
	Fri,  9 Jun 2023 07:18:15 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686320294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=D2uEsskSUg+j6aq0sQrlpHtD/hpOAW9BxWuP9HH1liI=;
	b=JCdwn7TD0a/t0fnixwNJTiDeBlVExLdg59tddQNqPTwfySgsv15q/koXTWwSuBzS8JfbF3
	VxmKMrn80h57xj4rDcVGehCOWE0rxxQElGoQPC1N2X1VUNSd4sTkba9u0gKPpy5HLkDDDi
	aio1fyeQEqEdsYI72ADPR4UvlWIMVtCjgMvsoFrYXR1eWwhvjvAgrQvPCHiC9yo9jd4lLL
	1pk63J9RJEegk4mBrgXTl9f4adzgcu8k890n3WZceVUn6vPX/mWSwKlqe/YWsyI+6adC6p
	BD++u4/f2c1JNDjnY4miy41ml/oeSGPOg2EHnTIrLMW+/1xzhGhTPWGEr/QL0g==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7819920013;
	Fri,  9 Jun 2023 14:18:12 +0000 (UTC)
From: alexis.lothore@bootlin.com
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com 
Subject: [PATCH net-next 0/2] add egress rate limit offload for Marvell 6393X family
Date: Fri,  9 Jun 2023 16:18:10 +0200
Message-ID: <20230609141812.297521-1-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.41.0
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

This series aims to give access to egress rate shaping offloading available
on Marvell 88E6393X family (88E6393X/88E6193X/88E6191X/88E6361)

The switch offers a very basic egress rate limiter: rate can be configured
from 64kbps up to 10gbps depending on the model, with some specific
increments depending on the targeted rate, and is "burstless".

Since available controls are quite limited, this series proposes to provide
controls to userspace through a TBF qdisc. Since hardware features do no
completely matches what TBF qidsc expects, some passed parameters (burst,
latency) are simply ignored

- 1st commit allows mv88e6xxx driver to attach the port_setup_tc callback
  in dsa_switch_opts and to dispatch it to any switch implementing it
- 2nd commit add tbf configuration for 88E6393X family

Alexis Lothoré (2):
  net: dsa: mv88e6xxx: allow driver to hook TC callback
  net: dsa: mv88e6xxx: implement egress tbf qdisc for 6393x family

 drivers/net/dsa/mv88e6xxx/chip.c |  18 ++++++
 drivers/net/dsa/mv88e6xxx/chip.h |   3 +-
 drivers/net/dsa/mv88e6xxx/port.c | 104 +++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h |  17 ++++-
 4 files changed, 139 insertions(+), 3 deletions(-)

-- 
2.41.0


