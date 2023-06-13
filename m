Return-Path: <netdev+bounces-10322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0446172DE0E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FED41C20C17
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8722773C;
	Tue, 13 Jun 2023 09:45:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320302915
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:45:38 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2BCE3;
	Tue, 13 Jun 2023 02:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686649537; x=1718185537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m0hOFgJwzlbpeuCAknODemWN+7nfVAdt6X0ewFU8eLQ=;
  b=WtD/giN+hbGj2zyhETOWBF8Q6DlAVO8l8ndiPxhbhovptnwWzm99krfO
   b/zoMDG0Jb/fAdQl0EdzeT+OjmwwzXJl3x16pkZVxdUMSiCTEr0T80gEd
   rakWgZBmHNY8kvfeC81SySZgkoPKNrcmjnT72KgxpDcHcGI8BbUiN5qES
   ANgDWrJ0NLP8QWWFewl82YWO+rVWZEgba6Y5s+nWTB5Cu/1KRazJmjTtF
   W3CjOebdwco/ATPXQsPg6QyvCQLshBvWeIJ6gX2m3jmA0LjNrR9IezLn4
   kjdHA/1b3ue8o6odxREUBM8OnxsDpViTlIZLCIblNgHkMLDn3yRbyINer
   A==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="218210662"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jun 2023 02:45:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 13 Jun 2023 02:45:36 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Tue, 13 Jun 2023 02:45:34 -0700
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 0/2] net: micrel: Change how to read TX timestamp
Date: Tue, 13 Jun 2023 11:45:24 +0200
Message-ID: <20230613094526.69532-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Change how to read the timestamp of the received frames. Currently it is
required to read over the MDIO bus each of the timestamps but it is
possible to change to receive the timestamp (the nanosecond part and the
least significant two bits of the second) in the frame.
The first patch makes this change, while the second patch optimized the
read of second part. Because it is not required to read the second part
of the timestmap for each received frame but it is OK to read the second
part twice per second and then cache it.

v1->v2:
- create a patch series instead of single patch
- add optimization for reading the second part of the received timestamp,
  read the second twice per second instead of for each frame

Horatiu Vultur (2):
  net: micrel: Change to receive timestamp in the frame for lan8841
  net: micrel: Schedule work to read seconds for lan8841

 drivers/net/phy/micrel.c | 272 ++++++++++++++++++++++++++-------------
 1 file changed, 180 insertions(+), 92 deletions(-)

-- 
2.38.0


