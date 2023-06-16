Return-Path: <netdev+bounces-11365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D95BC732CE3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA9491C20F5E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B6C17AC6;
	Fri, 16 Jun 2023 10:05:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75DE33ED
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:05:33 +0000 (UTC)
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E01D194;
	Fri, 16 Jun 2023 03:05:31 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686909930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/bEp3l+mxj4OHOGsH5hIH6F032OIg4YoPj77OR1PVdg=;
	b=CN6oOlMdpm4WJSEG9Jbl2Wjd46tk4pOqx3PJpvQUFS28VyPKOhJIzXXMAmdKxbZoDJBCBF
	JoQnBH/1OwhyK5EYtNKFAuTuYLn+wKnQdm5d3148b84eqOEbb2GqpStIXBULMgr/GqI3PW
	inIn+uWZzm9eOjKfFpWdkhjEkTwz6RwRoz6xQwCI+wz5YYweGyHzlPMVg8oKmCdbp64wbg
	b6lrf5upm8vJsR1FMAU5BV7kmFasB9rdxsrghFRdpDIF6FqNJx8qqNSfDk32ehYr9aCG1L
	7aP1VRYxjRJChWBxI3Hw9YKDxnz9LKauQv0hEUHRIGdxJuC7TpCb6pEcFk/8iA==
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
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id ABFB320004;
	Fri, 16 Jun 2023 10:05:28 +0000 (UTC)
From: alexis.lothore@bootlin.com
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Nicolas Carrier <nicolas.carrier@nav-timing.safrangroup.com>
Subject: [PATCH net-next 0/8] net: stmmac: enable timestamp snapshots for DWMAC1000
Date: Fri, 16 Jun 2023 12:04:01 +0200
Message-ID: <20230616100409.164583-1-alexis.lothore@bootlin.com>
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

While trying to use the recently implemented auxiliary snapshot feature
([1]) on Cyclone V platform (embedding DWMAC1000 IP), I realized that some
parts are too tightly coupled to GMAC4 version of the IP. For example,
timestamp_interrupt function in stmmac_hwtstamp.c reads some timestamp
status (GMAC_TIMESTAMP_STATUS), which offset is relevant for GMAC4 (ptpaddr
+ 0x20), but not for GMAC3 (which should be ptpaddr + 0x28).
Another example is that auxiliary snapshot trigger configuration is done in
a dedicated register for GMAC4, while it is in the general Timestamp
control register for DWMAC1000.

This series proposes to split those too specific parts in each IP variant
file. DWMAC1000 mapping is based on Cyclone V HPS register map ([2]) while
GMAC4 mapping has been checked based on some Elkhart Lake range processors
mapping ([3])

One point I am not sure about is for all other variants: sun8i-dwmac,
dwxgmac2 and dwmac100. I have no clue about registers layout for those
platforms. I then had to possible approaches to enable feature on
DWMAC1000:
- ensure that current behaviour is preserved for dwxgmac2, sun8i-dwmac and
  dwmac100; keep auxiliary snapshot feature in stmmac_ptp.c and add
  dwmac1000 behaviour as an "exception"
- assume auxiliary snaspshots controls are different for each, then move the
  controls in each IP version file (XXXX_core.c)
I felt like stmmac_ptp.c should remain independant from the IP version, so
I chose the second option, but since I do not know about other versions
layout (and do not have the hardware), I did not wire "blindly" the
feature on those platform.
Please let me know if I am wrong and/or if I should come with a more
conservative approach (ie first version)

Tested on Cyclone V with testptp

[1] https://lore.kernel.org/netdev/20210414001617.3490-1-vee.khee.wong@linux.intel.com/
[2] https://cdrdv2.intel.com/v1/dl/getContent/666962?fileName=cv_5v4-683126-666962.pdf
[3] https://cdrdv2.intel.com/v1/dl/getContent/636722?fileName=636722_EHL+Datasheet+V2+Book+2_rev003.pdf

Alexis Lothoré (8):
  net: stmmac: add IP-specific callbacks for auxiliary snapshot
  net: stmmac: populate dwmac4 callbacks for auxiliary snapshots
  net: stmmac: move PTP interrupt handling to IP-specific DWMAC file
  net: stmmac: move common defines in stmmac_ptp.h
  net: stmmac: set number of snapshot external triggers for GMAC3
  net: stmmac: introduce setter/getter for timestamp configuration
  net: stmmac: do not overwrite other flags when writing timestamp
    control
  net: stmmac: enable timestamp external trigger for dwmac1000

 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  2 +
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   | 12 ++-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  | 83 ++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  | 29 +++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 85 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h    | 17 +++-
 .../ethernet/stmicro/stmmac/stmmac_hwtstamp.c | 62 ++------------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 +--
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 29 ++-----
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.h  | 26 +-----
 10 files changed, 246 insertions(+), 113 deletions(-)

-- 
2.41.0


